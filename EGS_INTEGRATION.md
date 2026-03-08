# EGS Integration Plan

Replace the current OpenZeppelin + nft_combo ERC721 token with the Provable Games
Embeddable Game Standard (EGS). The game contract becomes a pure game logic contract
using `MinigameComponent`; the ERC721 token is handled by the PG-hosted `MinigameToken`.

## References

- EGS docs: https://docs.provable.games/embeddable-game-standard
- game example: https://github.com/Provable-Games/number-guess/blob/main/contracts/packages/number_guess/src/number_guess.cairo
- test example: https://github.com/Provable-Games/number-guess/blob/main/contracts/packages/number_guess/src/tests/test_number_guess.cairo

## Phase 1 — Toolchain & Dependency Upgrade (`Scarb.toml`) ✅ Done

> **Completed:** Dojo upgraded to `1.8.0`, all tests migrated from `cairo-test` to `snforge`.

EGS requires Cairo `2.15.1` and OZ `v3.0.0`.

**Decisions baked in:**
- MinigameToken is **PG-hosted** (Denshokan) — no self-deployed token contract.
- Use **EGS default renderer** — pass `Option::None` for `renderer_address`.
- **Remove `GameScoredEvent`** — score is exposed via `IMinigameTokenData` interface reads.
- **Drop** transfer-on-top-score mechanic — top scorer recorded in `GameInfo` only.

### Remove
```toml
openzeppelin_token = { git = "...", tag = "v1.0.0" }
nft_combo = { git = "...", branch = "scarb_2.12.2" }
```

### Add / Update
```toml
[package]
cairo-version = ">=2.15.1"

[dependencies]
starknet = "2.15.1"
dojo = "=1.8.0"
game_components_embeddable_game_standard = { git = "https://github.com/Provable-Games/game-components.git", tag = "v1.1.0" }
game_components_utilities = { git = "https://github.com/Provable-Games/game-components.git", tag = "v1.1.0" }
openzeppelin_introspection = { git = "https://github.com/OpenZeppelin/cairo-contracts.git", tag = "v3.0.0" }
openzeppelin_token = { git = "https://github.com/OpenZeppelin/cairo-contracts.git", tag = "v3.0.0" }
openzeppelin_interfaces = { git = "https://github.com/OpenZeppelin/cairo-contracts.git", tag = "v3.0.0" }

[dev-dependencies]
snforge_std = { git = "https://github.com/foundry-rs/starknet-foundry", tag = "v0.55.0" }
denshokan_testing = { git = "https://github.com/Provable-Games/denshokan.git", tag = "v1.1.0" }
denshokan_token   = { git = "https://github.com/Provable-Games/denshokan.git", tag = "v1.1.0" }
denshokan_registry = { git = "https://github.com/Provable-Games/denshokan.git", tag = "v1.1.0" }
denshokan_renderer = { git = "https://github.com/Provable-Games/denshokan.git", tag = "v1.1.0" }

[[target.starknet-contract]]
sierra = true
casm = true
build-external-contracts = [
    "denshokan_token::denshokan::Denshokan",
    "denshokan_registry::minigame_registry::MinigameRegistry",
    "denshokan_renderer::default_renderer::DefaultRenderer",
]
```

> **Note:** `game_components_interfaces` is replaced by `game_components_utilities`
> (provides `u128_to_ascii_felt` and other helpers). OZ v3.0.0 packages (`openzeppelin_token`,
> `openzeppelin_interfaces`) are still required as EGS imports them internally.

---

## Phase 2 — Game Contract Rewrite (`systems/game_token.cairo`)

The contract keeps the `#[dojo::contract]` macro (for `WorldStorage` / model access)
but replaces all ERC721 components with EGS components.

### Remove entirely
- `openzeppelin_token::erc721::ERC721Component` — all uses, storage, events
- `nft_combo::erc721::erc721_combo::ERC721ComboComponent` — all uses, storage, events
- `ERC721ComboHooksTrait` impl block (`before_update`, `render_contract_uri`, `render_token_uri`)
- `#[storage]` entries for `erc721`, `erc721_combo`
- `#[event]` variants `ERC721Event`, `ERC721ComboEvent`

> **Keep** `SRC5Component` — EGS requires it. Keep its storage and event entries.

### Add — Components

```cairo
use game_components_embeddable_game_standard::minigame::minigame_component::MinigameComponent;
use game_components_embeddable_game_standard::minigame::extensions::settings::settings::SettingsComponent;
use game_components_embeddable_game_standard::minigame::extensions::objectives::objectives::ObjectivesComponent;
use openzeppelin_introspection::src5::SRC5Component;

component!(path: MinigameComponent, storage: minigame, event: MinigameEvent);
component!(path: SettingsComponent,  storage: settings,  event: SettingsEvent);
component!(path: ObjectivesComponent, storage: objectives, event: ObjectivesEvent);
component!(path: SRC5Component,      storage: src5,      event: SRC5Event);

#[abi(embed_v0)]
impl MinigameImpl = MinigameComponent::MinigameImpl<ContractState>;
impl MinigameInternalImpl = MinigameComponent::InternalImpl<ContractState>;
impl SettingsInternalImpl  = SettingsComponent::InternalImpl<ContractState>;
impl ObjectivesInternalImpl = ObjectivesComponent::InternalImpl<ContractState>;
#[abi(embed_v0)]
impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;
```

Storage:
```cairo
#[substorage(v0)] minigame:   MinigameComponent::Storage,
#[substorage(v0)] settings:   SettingsComponent::Storage,
#[substorage(v0)] objectives: ObjectivesComponent::Storage,
#[substorage(v0)] src5:       SRC5Component::Storage,
```

Events:
```cairo
#[flat] MinigameEvent:   MinigameComponent::Event,
#[flat] SettingsEvent:   SettingsComponent::Event,
#[flat] ObjectivesEvent: ObjectivesComponent::Event,
#[flat] SRC5Event:       SRC5Component::Event,
```

### Add — Required EGS interface implementations

EGS reads score and game-over state through two mandatory interfaces that the game
contract must implement. Score is stored as a field in `GameInfo` (Dojo model) and
returned by the interface — there is no `minigame.update_score()` call.

```cairo
use game_components_embeddable_game_standard::minigame::interface::{
    IMinigameDetails, IMinigameTokenData,
};
use game_components_embeddable_game_standard::minigame::structs::GameDetail;
use game_components_utilities::utils::encoding::u128_to_ascii_felt;

#[abi(embed_v0)]
impl TokenDataImpl of IMinigameTokenData<ContractState> {
    fn score(self: @ContractState, token_id: felt252) -> u64 {
        let world = self.world_default();
        let info: GameInfo = world.read_model(token_id);
        info.top_score.into()
    }
    fn game_over(self: @ContractState, token_id: felt252) -> bool {
        // true once a game has been submitted (finished field on GameInfo)
        let world = self.world_default();
        let info: GameInfo = world.read_model(token_id);
        info.finished
    }
    fn score_batch(self: @ContractState, token_ids: Span<felt252>) -> Array<u64> {
        let mut out = array![];
        let mut i = 0;
        loop { if i >= token_ids.len() { break; } out.append(self.score(*token_ids.at(i))); i += 1; }
        out
    }
    fn game_over_batch(self: @ContractState, token_ids: Span<felt252>) -> Array<bool> {
        let mut out = array![];
        let mut i = 0;
        loop { if i >= token_ids.len() { break; } out.append(self.game_over(*token_ids.at(i))); i += 1; }
        out
    }
}

#[abi(embed_v0)]
impl DetailsImpl of IMinigameDetails<ContractState> {
    fn token_name(self: @ContractState, _token_id: felt252) -> ByteArray { metadata::TOKEN_NAME() }
    fn token_description(self: @ContractState, token_id: felt252) -> ByteArray {
        let world = self.world_default();
        let info: GameInfo = world.read_model(token_id);
        format!("Feral Forge. Top score: {} in {} moves.", info.top_score, info.top_score_move_count)
    }
    fn game_details(self: @ContractState, token_id: felt252) -> Span<GameDetail> {
        let world = self.world_default();
        let info: GameInfo = world.read_model(token_id);
        array![
            GameDetail { name: 'Top Score', value: u128_to_ascii_felt(info.top_score.into()) },
            GameDetail { name: 'Best Move Count', value: u128_to_ascii_felt(info.top_score_move_count.into()) },
        ].span()
    }
    // batch variants follow same loop pattern as TokenDataImpl above
    fn token_name_batch(self: @ContractState, token_ids: Span<felt252>) -> Array<ByteArray> { ... }
    fn token_description_batch(self: @ContractState, token_ids: Span<felt252>) -> Array<ByteArray> { ... }
    fn game_details_batch(self: @ContractState, token_ids: Span<felt252>) -> Array<Span<GameDetail>> { ... }
}
```

### Update `dojo_init`

Add `minigame_token_address: ContractAddress` as a constructor parameter. The
`settings_address` and `objectives_address` default to `get_contract_address()`
(self-hosted — the game contract manages its own settings/objectives).

```cairo
fn dojo_init(ref self: ContractState, minigame_token_address: ContractAddress) {
    // Init sub-components first (they register SRC5 interfaces)
    self.settings.initializer();
    self.objectives.initializer();

    self.minigame.initializer(
        starknet::get_caller_address(),          // game_creator
        metadata::TOKEN_NAME(),                  // game_name
        metadata::DESCRIPTION(),                 // game_description
        "Underware",                             // developer
        "Underware",                             // publisher
        "Puzzle",                                // genre
        metadata::CONTRACT_IMAGE(),              // game_image
        Option::None,                            // color
        Option::Some(metadata::EXTERNAL_LINK()), // client_url
        Option::None,                            // renderer_address (EGS default)
        Option::Some(starknet::get_contract_address()), // settings_address (self)
        Option::Some(starknet::get_contract_address()), // objectives_address (self)
        minigame_token_address,
        Option::None,                            // royalty_fraction
        Option::None,                            // skills_address
        1_u64,                                   // version
    );
}
```

---

## Phase 3 — Interface Changes

Rename `IGameTokenPublic` → `IFeralGame`. Remove all ERC721/minter/metadata methods.
Token ID type changes from `u128` / `u256` to `felt252` throughout.

### Remove from interface
- All ERC721 methods: `balance_of`, `owner_of`, `name`, `symbol`, `token_uri`, `tokenURI`
- All minter methods: `max_supply`, `reserved_supply`, `available_supply`, `minted_supply`,
  `total_supply`, `last_token_id`, `is_minting_paused`, `is_minted_out`, `is_owner_of`, `token_exists`
- `contract_uri`, `contractURI`
- `royalty_info`, `default_royalty`, `token_royalty`
- `mint(recipient)` — minting is now via `IMinigameDispatcher::mint_game()` (see below)
- `set_minting_paused`, `update_token_metadata`, `update_tokens_metadata`, `update_contract_metadata`
- `world_dispatcher`
- The combined `IGameToken` trait (was only used for `IWorldProvider`)

### Game-specific interface
```cairo
#[starknet::interface]
pub trait IFeralGame<TState> {
    fn new_game(ref self: TState, token_id: felt252);
    fn start_game(self: @TState, token_id: felt252) -> GameState;
    fn move(self: @TState, game_state: GameState, direction: Direction) -> GameState;
    fn submit_game(ref self: TState, token_id: felt252, moves: Array<Direction>) -> GameState;
    fn get_game_info(self: @TState, token_id: felt252) -> GameInfo;
    fn get_games_info(self: @TState, token_id: felt252, count: usize) -> Array<GameInfo>;
}
```

### Required EGS interfaces (exposed via embed_v0)

These are implemented in Phase 2 and automatically satisfy the EGS standard:
- `IMinigameTokenData` — `score()`, `game_over()`, batch variants
- `IMinigameDetails` — `token_name()`, `token_description()`, `game_details()`, batch variants
- `IMinigame` (from `MinigameComponent::MinigameImpl`) — includes `mint_game()` for token minting

### Token minting flow

Players mint tokens by calling **`mint_game()`** on the **game contract** (exposed via
`MinigameComponent::MinigameImpl`). This packs a `settings_id` into the token_id at
mint time. The player then calls `new_game(token_id)` to start playing.

```cairo
// From tests — player mints via IMinigameDispatcher on the game contract address:
let minigame = IMinigameDispatcher { contract_address: game_address };
let token_id = minigame.mint_game(
    Option::None,           // minter override
    Option::Some(1_u32),    // settings_id (packed into token_id)
    Option::None, Option::None, Option::None,
    Option::None, Option::None, Option::None, Option::None,
    player_address,
    false, false,
    salt,  // u16 — differentiates mints for same player+settings
    0,
);
```

---

## Phase 4 — Token ID Type Change

Change `u128` / `u256` token IDs to `felt252` everywhere.

| File | Change |
|------|--------|
| `models/game_info.cairo` | `game_id: u128` → `token_id: felt252` |
| `systems/game_token.cairo` | All method signatures and internal refs |
| `libs/gameplay.cairo` | `GameState.game_id: u128` → `game_id: felt252` |
| `libs/hash.cairo` | `make_seed(contract_address, token_id.low)` → `make_seed(contract_address, token_id)` |

---

## Phase 5 — Gameplay Logic Changes

### `new_game` (replaces `mint`)

Called by a player **after** minting a token via `mint_game()`. `pre_action` handles
ownership verification — no separate `assert_token_ownership` call needed.

```cairo
fn new_game(ref self: ContractState, token_id: felt252) {
    self.minigame.pre_action(token_id); // verifies ownership + game not over

    let mut world = self.world_default();
    let caller = starknet::get_caller_address();
    let seed = make_seed(starknet::get_contract_address(), token_id);

    world.write_model(@GameInfo {
        token_id,
        seed,
        top_score_address: caller,
        top_score_move_count: 0,
        top_score: 0,
        finished: false,
    });

    self.minigame.post_action(token_id);
}
```

### `start_game` / `move`

Pure computation — no state writes, so no `pre_action`/`post_action` needed.
Update `game_id` references to `token_id: felt252`. No other logic change.

### `submit_game` — score tracking

Wrap with `pre_action`/`post_action`. Score is stored directly in the Dojo model
(`GameInfo.top_score`, `GameInfo.top_score_move_count`) — EGS reads it via the
`IMinigameTokenData::score()` interface implemented in Phase 2. There are **no**
`minigame.update_score()` or `minigame.game_over()` method calls.

```cairo
fn submit_game(ref self: ContractState, token_id: felt252, moves: Array<Direction>) -> GameState {
    self.minigame.pre_action(token_id);

    let mut world = self.world_default();
    let mut info: GameInfo = world.read_model(token_id);
    // ... existing game logic ...
    // Update top score in the model:
    if game_state.score > info.top_score {
        info.top_score = game_state.score;
        info.top_score_address = starknet::get_caller_address();
        info.top_score_move_count = game_state.move_count;
    }
    info.finished = game_state.finished;
    world.write_model(@info);

    self.minigame.post_action(token_id);
    game_state
}
```

Remove:
```cairo
// DELETE these blocks:
let owner = self.owner_of(game_id.into());
if owner != caller {
    self.erc721._approve(caller, game_id.into(), 0x0.try_into().unwrap());
    self.erc721_combo.transfer_from(owner, caller, game_id.into());
}
world.emit_event(@GameScoredEvent { ... });
```

---

## Phase 6 — Model & Event Changes (`models/game_info.cairo`)

### `GameInfo` model
- `game_id: u128` → `token_id: felt252`
- Remove `minter_address` (tracked on MinigameToken)
- Add `finished: bool` — read by `IMinigameTokenData::game_over()`

```cairo
#[derive(Clone, Drop, Serde, Introspect, PartialEq, Debug)]
#[dojo::model]
pub struct GameInfo {
    #[key]
    pub token_id: felt252,
    pub seed: felt252,
    pub top_score_address: ContractAddress,
    pub top_score_move_count: u16,
    pub top_score: u16,
    pub finished: bool,
}
```

### Events
- Delete `GameScoredEvent` — EGS reads score via `IMinigameTokenData` interface, no event needed
- Remove from `tester.cairo` namespace_def and `lib.cairo` if registered there

---

## Phase 7 — Metadata & Rendering

The `render_contract_uri` and `render_token_uri` hooks (nft_combo-specific) are removed.
EGS default rendering is used; pass `Option::None` for `renderer_address` in `dojo_init`.

The large SVG/image data in `libs/metadata.cairo` can be kept for reference but is no
longer called from any hook. The EGS renderer will pull metadata from the MinigameToken
and game registration data set in `minigame.initializer(...)`.

---

## Phase 8 — DNS & Dispatcher (`libs/dns.cairo`)

- Rename `IGameTokenDispatcher` → `IFeralGameDispatcher`
- Rename `IGameTokenDispatcherTrait` → `IFeralGameDispatcherTrait`
  _(update the import in `systems/game_token.cairo` and `tests/tester.cairo`)_
- `game_dispatcher()` returns `IFeralGameDispatcher`
- `SELECTORS::GAME_TOKEN` can stay as-is (contract tag is still `feral-game_token`)

---

## Phase 9 — Tests ✅ Partially Done

> **Completed:** All tests migrated to `snforge`. `dojo_cairo_test` removed.

The key change vs. the old test approach: tokens are minted via `IMinigameDispatcher::mint_game()`
on the game contract itself (not a stub address). The full EGS stack (Denshokan token + registry)
is deployed using helpers from `denshokan_testing`.

### Setup helpers (replace `tester.cairo` world setup)

```cairo
use denshokan_testing::helpers::constants::{ALICE, GAME_CREATOR};
use denshokan_testing::helpers::setup::{deploy_denshokan, deploy_minigame_registry};
use game_components_embeddable_game_standard::minigame::interface::{
    IMinigameDispatcher, IMinigameDispatcherTrait,
    IMinigameTokenDataDispatcher, IMinigameTokenDataDispatcherTrait,
    IMinigameDetailsDispatcher, IMinigameDetailsDispatcherTrait,
};

fn setup_feral_game() -> (IFeralGameDispatcher, ContractAddress) {
    let registry = deploy_minigame_registry();
    let (denshokan_address, _, _, _) = deploy_denshokan(registry.contract_address);

    // Declare and deploy the Dojo world + game contract
    // (keep existing Dojo world setup; pass denshokan_address to dojo_init)
    let game_address = deploy_game_contract(denshokan_address);
    let game = IFeralGameDispatcher { contract_address: game_address };
    (game, game_address)
}

fn mint_token(game_address: ContractAddress, player: ContractAddress, salt: u16) -> felt252 {
    let minigame = IMinigameDispatcher { contract_address: game_address };
    minigame.mint_game(
        Option::None, Option::None, Option::None, Option::None, Option::None,
        Option::None, Option::None, Option::None, Option::None,
        player, false, false, salt, 0,
    )
}
```

### `tests/tester.cairo` changes

- Remove `IGameTokenDispatcherTrait` import; use `IFeralGameDispatcherTrait`
- Remove `ERC721`-related imports from `nft_combo`
- `setup_world()`: use `deploy_denshokan` / `deploy_minigame_registry` from `denshokan_testing`
  to get a real `minigame_token_address` (not a stub)
- Update `namespace_def()`: remove `e_GameScoredEvent` registration

### `tests/game_token_tests.cairo`

**Delete these tests** (functionality moved to Denshokan/MinigameToken):
- `test_token_initialized`
- `test_token_token_uri`
- `test_token_set_minting_paused`
- `test_token_set_minting_paused_mint`
- `test_token_set_minting_paused_not_admin`
- `test_token_mint`

**Update remaining tests:**
- Replace `_mint_token(ref sys, recipient)` with `mint_token(game_address, player, salt)`
  that calls `IMinigameDispatcher::mint_game()` on the game contract
- All `game_id: u128` / `token_id: u256` literals → `felt252`
- Remove all `owner_of`, `balance_of` assertions
- `test_top_score`: remove ownership transfer assertions; verify `GameInfo.top_score*` only
- Verify score via `IMinigameTokenDataDispatcher::score(token_id)` (not direct model read)

**Add:**
- `test_new_game_ok` — mint token, call `new_game(token_id)`, verify `GameInfo` written
- `test_new_game_invalid_token` — call `new_game` without minting, expect panic
- `test_game_over` — submit finished game, assert `token_data.game_over(token_id) == true`
- `test_score_increases` — submit game with non-zero score, assert `token_data.score(token_id) > 0`
- `test_token_name` — assert `IMinigameDetailsDispatcher::token_name(token_id)` correct
- `test_game_details` — assert `game_details(token_id)` returns expected fields

### Event spy pattern (for submit_game events)

```cairo
use snforge_std::{spy_events, EventSpyAssertionsTrait};

// Wrap game contract events for spy assertions:
#[derive(Drop, starknet::Event)]
enum FeralGameEvent {
    MinigameEvent: MinigameComponent::Event,
    // add any custom events here
}
```

---

## Phase 10 — Sozo / Deployment Config

In `dojo_dev.toml` / `dojo_release.toml` (or equivalent profile files):

```toml
[[contracts]]
tag = "feral-game_token"
# Add minigame_token_address as init calldata:
init_calldata = ["<PG_MINIGAME_TOKEN_ADDRESS_ON_SEPOLIA>"]
```

Obtain the PG-hosted MinigameToken address from Provable Games documentation or
the Arcade platform for each network (sepolia / mainnet).

---

## File Change Summary

| File | Action |
|------|--------|
| `Scarb.toml` | Remove `nft_combo`; add `game_components_*`, `denshokan_*` packages; keep OZ v3.0.0 |
| `systems/game_token.cairo` | Major rewrite — add `MinigameComponent`, `SettingsComponent`, `ObjectivesComponent`, `SRC5Component`; implement `IMinigameTokenData` + `IMinigameDetails`; keep `SRC5Component` |
| `models/game_info.cairo` | `game_id: u128` → `token_id: felt252`; remove `minter_address`; add `finished: bool`; remove `GameScoredEvent` |
| `libs/dns.cairo` | Rename dispatcher types |
| `libs/gameplay.cairo` | `game_id: u128` → `game_id: felt252` in `GameState` |
| `libs/hash.cairo` | Update seed call for `felt252` token ID |
| `libs/metadata.cairo` | No functional change; hooks removed, data kept for reference |
| `tests/tester.cairo` | Replace stub `minigame_token_address` with `deploy_denshokan()`; remove ERC721 imports; update dispatcher |
| `tests/game_token_tests.cairo` | Delete ERC721/mint tests; replace `_mint_token` with `mint_game()`; update gameplay tests; add EGS interface tests |
| `lib.cairo` | Remove `e_GameScoredEvent` if registered |
