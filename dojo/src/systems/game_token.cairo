use feral::models::game_info::{GameInfo};
use feral::libs::gameplay::{
    Direction,
    GameState,
};


#[starknet::interface]
pub trait IFeralGame<TState> {
    fn new_game(ref self: TState, token_id: felt252);
    fn start_game(self: @TState, token_id: felt252) -> GameState;
    fn move(self: @TState, game_state: GameState, direction: Direction) -> GameState;
    fn submit_game(ref self: TState, token_id: felt252, moves: Array<Direction>) -> GameState;
    fn get_game_info(self: @TState, token_id: felt252) -> GameInfo;
    fn get_games_info(self: @TState, token_id: felt252, count: usize) -> Array<GameInfo>;
}


#[dojo::contract]
pub mod game_token {
    use core::num::traits::Zero;
    use starknet::ContractAddress;
    use dojo::{
        world::{WorldStorage},
        model::{ModelStorage},
    };

    //-----------------------------------
    // EGS components
    //
    use game_components_embeddable_game_standard::minigame::minigame_component::MinigameComponent;
    use game_components_embeddable_game_standard::minigame::extensions::settings::settings::SettingsComponent;
    use game_components_embeddable_game_standard::minigame::extensions::objectives::objectives::ObjectivesComponent;
    use openzeppelin_introspection::src5::SRC5Component;

    component!(path: MinigameComponent,   storage: minigame,   event: MinigameEvent);
    component!(path: SettingsComponent,   storage: settings,   event: SettingsEvent);
    component!(path: ObjectivesComponent, storage: objectives, event: ObjectivesEvent);
    component!(path: SRC5Component,       storage: src5,       event: SRC5Event);

    #[abi(embed_v0)]
    impl MinigameImpl = MinigameComponent::MinigameImpl<ContractState>;
    impl MinigameInternalImpl = MinigameComponent::InternalImpl<ContractState>;
    impl SettingsInternalImpl = SettingsComponent::InternalImpl<ContractState>;
    impl ObjectivesInternalImpl = ObjectivesComponent::InternalImpl<ContractState>;
    #[abi(embed_v0)]
    impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        minigame:   MinigameComponent::Storage,
        #[substorage(v0)]
        settings:   SettingsComponent::Storage,
        #[substorage(v0)]
        objectives: ObjectivesComponent::Storage,
        #[substorage(v0)]
        src5:       SRC5Component::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        MinigameEvent:   MinigameComponent::Event,
        #[flat]
        SettingsEvent:   SettingsComponent::Event,
        #[flat]
        ObjectivesEvent: ObjectivesComponent::Event,
        #[flat]
        SRC5Event:       SRC5Component::Event,
    }
    //
    // EGS components end
    //-----------------------------------

    use game_components_embeddable_game_standard::minigame::interface::{
        IMinigameDetails, IMinigameTokenData,
    };
    use game_components_embeddable_game_standard::minigame::extensions::settings::interface::{
        IMinigameSettings, IMinigameSettingsDetails,
    };
    use game_components_embeddable_game_standard::minigame::extensions::objectives::interface::{
        IMinigameObjectives, IMinigameObjectivesDetails,
    };
    use game_components_embeddable_game_standard::minigame::extensions::objectives::structs::{
        GameObjectiveDetails,
    };
    use game_components_embeddable_game_standard::minigame::extensions::settings::structs::{
        GameSetting, GameSettingDetails,
    };
    use game_components_embeddable_game_standard::minigame::structs::GameDetail;
    use game_components_utilities::utils::encoding::u128_to_ascii_felt;

    use feral::models::game_info::{GameInfo};
    use feral::libs::{
        metadata,
        hash::{make_seed},
        gameplay::{
            GameState,
            GameplayTrait,
            Direction,
        },
    };

    pub mod Errors {
        pub const INVALID_CALLER: felt252 = 'FERAL: Invalid caller';
        pub const INVALID_GAME: felt252   = 'FERAL: Invalid game';
        pub const INVALID_MOVES: felt252  = 'FERAL: Invalid moves';
        pub const GAME_FINISHED: felt252  = 'FERAL: Game finished';
        pub const INVALID_DIRECTION: felt252 = 'FERAL: Invalid direction';
        pub const INVALID_TILE: felt252   = 'FERAL: Invalid tile';
        pub const INVALID_BEAST: felt252  = 'FERAL: Invalid beast';
    }

    fn dojo_init(ref self: ContractState, minigame_token_address: ContractAddress) {
        self.settings.initializer();
        self.objectives.initializer();
        self.minigame.initializer(
            starknet::get_caller_address(),                 // game_creator
            metadata::TOKEN_NAME(),                         // game_name
            metadata::DESCRIPTION(),                        // game_description
            metadata::DEVELOPER_NAME(),                     // developer
            metadata::PUBLISHER_NAME(),                     // publisher
            metadata::GAME_GENRE(),                         // genre
            metadata::CONTRACT_IMAGE(),                     // game_image
            Option::Some(metadata::BACKGROUND_COLOR()),     // color
            Option::Some(metadata::EXTERNAL_LINK()),        // client_url
            Option::None,                                   // renderer_address (EGS default)
            Option::Some(starknet::get_contract_address()), // settings_address
            Option::Some(starknet::get_contract_address()), // objectives_address
            minigame_token_address,
            Option::None,                                   // royalty_fraction
            Option::None,                                   // skills_address
            1_u64,                                          // version
        );
    }

    #[generate_trait]
    impl WorldDefaultImpl of WorldDefaultTrait {
        #[inline(always)]
        fn world_default(self: @ContractState) -> WorldStorage {
            (self.world(@"feral"))
        }
    }



    //-----------------------------------
    // IFeralGame
    //
    #[abi(embed_v0)]
    impl FeralGameImpl of super::IFeralGame<ContractState> {

        fn new_game(ref self: ContractState, token_id: felt252) {
            self.minigame.pre_action(token_id); // verifies ownership + game not over

            let mut world: WorldStorage = self.world_default();
            let caller: ContractAddress = starknet::get_caller_address();
            let seed: felt252 = make_seed(starknet::get_contract_address(), token_id);

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

        fn start_game(self: @ContractState, token_id: felt252) -> GameState {
            let world: WorldStorage = self.world_default();
            (world.start_game(token_id))
        }

        fn move(self: @ContractState, mut game_state: GameState, direction: Direction) -> GameState {
            game_state.move(direction);
            game_state.calc_score();
            (game_state)
        }

        fn submit_game(ref self: ContractState, token_id: felt252, moves: Array<Direction>) -> GameState {
            self.minigame.pre_action(token_id);

            let mut world: WorldStorage = self.world_default();
            assert(moves.len().is_non_zero(), Errors::INVALID_MOVES);
            let mut game_state: GameState = world.start_game(token_id);
            for i in 0..moves.len() {
                let direction: Direction = *moves[i];
                game_state.move(direction);
                if game_state.finished { break; }
            }
            game_state.calc_score();
            let mut game_info: GameInfo = world.read_model(token_id);
            let is_new_top_score: bool = (
                game_state.score > game_info.top_score ||
                (game_state.score == game_info.top_score && game_state.move_count < game_info.top_score_move_count)
            );
            if is_new_top_score {
                let caller: ContractAddress = starknet::get_caller_address();
                game_info.top_score_address = caller;
                game_info.top_score_move_count = game_state.move_count;
                game_info.top_score = game_state.score;
            }
            game_info.finished = game_state.finished;
            world.write_model(@game_info);

            self.minigame.post_action(token_id);
            (game_state)
        }

        fn get_game_info(self: @ContractState, token_id: felt252) -> GameInfo {
            let world: WorldStorage = self.world_default();
            (world.read_model(token_id))
        }

        fn get_games_info(self: @ContractState, token_id: felt252, count: usize) -> Array<GameInfo> {
            let world: WorldStorage = self.world_default();
            let mut id: felt252 = token_id;
            let mut result: Array<GameInfo> = array![];
            for _ in 0..count {
                result.append(world.read_model(id));
                id = id + 1;
            };
            (result)
        }
    }



    //-----------------------------------
    // IMinigameTokenData
    //
    // game_over() is a placeholder until Phase 6 adds GameInfo.finished.
    //
    #[abi(embed_v0)]
    impl TokenDataImpl of IMinigameTokenData<ContractState> {
        fn score(self: @ContractState, token_id: felt252) -> u64 {
            let world = self.world_default();
            let info: GameInfo = world.read_model(token_id);
            info.top_score.into()
        }
        fn game_over(self: @ContractState, token_id: felt252) -> bool {
            let world = self.world_default();
            let info: GameInfo = world.read_model(token_id);
            info.finished
        }
        fn score_batch(self: @ContractState, token_ids: Span<felt252>) -> Array<u64> {
            let mut out = array![];
            for i in 0..token_ids.len() {
                out.append(self.score(*token_ids.at(i)));
            }
            out
        }
        fn game_over_batch(self: @ContractState, token_ids: Span<felt252>) -> Array<bool> {
            let mut out = array![];
            for i in 0..token_ids.len() {
                out.append(self.game_over(*token_ids.at(i)));
            }
            out
        }
    }


    //-----------------------------------
    // IMinigameDetails
    //
    #[abi(embed_v0)]
    impl DetailsImpl of IMinigameDetails<ContractState> {
        fn token_name(self: @ContractState, token_id: felt252) -> ByteArray {
            metadata::TOKEN_NAME()
        }
        fn token_description(self: @ContractState, token_id: felt252) -> ByteArray {
            let world = self.world_default();
            let info: GameInfo = world.read_model(token_id);
            format!("Feral Forge. Top score: {} in {} moves.", info.top_score, info.top_score_move_count)
        }
        fn game_details(self: @ContractState, token_id: felt252) -> Span<GameDetail> {
            let world = self.world_default();
            let info: GameInfo = world.read_model(token_id);
            array![
                GameDetail { name: 'Score',       value: u128_to_ascii_felt(info.top_score.into()) },
                GameDetail { name: 'Move Count',  value: u128_to_ascii_felt(info.top_score_move_count.into()) },
            ].span()
        }
        fn token_name_batch(self: @ContractState, token_ids: Span<felt252>) -> Array<ByteArray> {
            let mut out: Array<ByteArray> = array![];
            for i in 0..token_ids.len() {
                out.append(self.token_name(*token_ids.at(i)));
            }
            out
        }
        fn token_description_batch(self: @ContractState, token_ids: Span<felt252>) -> Array<ByteArray> {
            let mut out: Array<ByteArray> = array![];
            for i in 0..token_ids.len() {
                out.append(self.token_description(*token_ids.at(i)));
            }
            out
        }
        fn game_details_batch(self: @ContractState, token_ids: Span<felt252>) -> Array<Span<GameDetail>> {
            let mut out: Array<Span<GameDetail>> = array![];
            for i in 0..token_ids.len() {
                out.append(self.game_details(*token_ids.at(i)));
            }
            out
        }
    }


    // ======================================================================
    // IMinigameSettings
    // ======================================================================

    #[abi(embed_v0)]
    impl GameSettingsImpl of IMinigameSettings<ContractState> {
        fn settings_exist(self: @ContractState, settings_id: u32) -> bool {
            (settings_id == 1)
        }

        fn settings_exist_batch(self: @ContractState, settings_ids: Span<u32>) -> Array<bool> {
            let mut results: Array<bool> = array![];
            for i in 0..settings_ids.len() {
                results.append(self.settings_exist(*settings_ids.at(i)));
            }
            results
        }
    }


    // ======================================================================
    // IMinigameSettingsDetails
    // ======================================================================

    #[abi(embed_v0)]
    impl GameSettingsDetailsImpl of IMinigameSettingsDetails<ContractState> {
        fn settings_details(self: @ContractState, settings_id: u32) -> GameSettingDetails {
            (GameSettingDetails {
                name: "Classic",
                description: "Classic 4x4 grid game",
                settings: array![
                    GameSetting { name: 'Grid Size', value: u128_to_ascii_felt(4) },
                ].span(),
            })
        }

        fn settings_details_batch(
            self: @ContractState, settings_ids: Span<u32>,
        ) -> Array<GameSettingDetails> {
            let mut results: Array<GameSettingDetails> = array![];
            for i in 0..settings_ids.len() {
                results.append(self.settings_details(*settings_ids.at(i)));
            }
            (results)
        }

        fn settings_count(self: @ContractState) -> u32 {
            (1)
        }
    }


    // ======================================================================
    // IMinigameObjectives
    // ======================================================================

    #[abi(embed_v0)]
    impl GameObjectivesImpl of IMinigameObjectives<ContractState> {
        fn objective_exists(self: @ContractState, objective_id: u32) -> bool {
            (false)
        }

        fn completed_objective(self: @ContractState, token_id: felt252, objective_id: u32) -> bool {
            (false)
        }

        fn objective_exists_batch(self: @ContractState, objective_ids: Span<u32>) -> Array<bool> {
            let mut results: Array<bool> = array![];
            for i in 0..objective_ids.len() {
                results.append(self.objective_exists(*objective_ids.at(i)));
            }
            results
        }
    }


    // ======================================================================
    // IMinigameObjectivesDetails
    // ======================================================================

    #[abi(embed_v0)]
    impl GameObjectivesDetailsImpl of IMinigameObjectivesDetails<ContractState> {
        fn objectives_details(self: @ContractState, objective_id: u32) -> GameObjectiveDetails {
            
            assert!(false, "Objective does not exist");
            (GameObjectiveDetails { name: "", description: "", objectives: array![].span() })

            // // Build objectives array with type and threshold info
            // let type_str: felt252 = if objective_type == 1 {
            //     'Win'
            // } else if objective_type == 2 {
            //     'WinWithinN'
            // } else {
            //     'PerfectGame'
            // };
            // let mut objectives = array![];
            // objectives.append(GameObjective { name: 'type', value: type_str });
            // objectives
            //     .append(
            //         GameObjective {
            //             name: 'threshold', value: u128_to_ascii_felt(threshold.into()),
            //         },
            //     );
            // GameObjectiveDetails { name, description, objectives: objectives.span() }
        }

        fn objectives_details_batch(
            self: @ContractState, objective_ids: Span<u32>,
        ) -> Array<GameObjectiveDetails> {
            let mut results: Array<GameObjectiveDetails> = array![];
            for i in 0..objective_ids.len() {
                results.append(self.objectives_details(*objective_ids.at(i)));
            }
            results
        }

        fn objectives_count(self: @ContractState) -> u32 {
            (0)
        }
    }

}
