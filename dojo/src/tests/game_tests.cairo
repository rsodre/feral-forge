#[cfg(test)]
mod tests {
    use starknet::ContractAddress;
    use dojo::{
        // world::{WorldStorage},
        model::{ModelStorage},
    };
    use feral::{
        models::{
            game_info::{GameInfo},
        },
        libs::{
            metadata,
            gameplay::{GameState, Direction},
            forge::{ForgeTrait},
        },
        tests::tester::{
            tester,
            tester::{
                TesterSystems,
                IGameDispatcherTrait,
                OWNER, OTHER,
            },
        },
    };

    fn _mint_token(ref sys: TesterSystems, recipient: ContractAddress) -> u128 {
        tester::impersonate(recipient);
        let token_id: u128 = sys.game.mint_game(recipient);
        (token_id)
    }

    #[test]
    fn test_token_initialized() {
        let mut sys: TesterSystems = tester::setup_world();
        println!("GAME TOKEN NAME: [{}]", sys.game.name());
        println!("GAME TOKEN SYMBOL: [{}]", sys.game.symbol());
        assert_ne!(sys.game.name(), "", "empty name");
        assert_ne!(sys.game.symbol(), "", "empty symbol");
        assert_eq!(sys.game.name(), metadata::TOKEN_NAME(), "wrong name");
        assert_eq!(sys.game.symbol(), metadata::TOKEN_SYMBOL(), "wrong symbol");
    }


    #[test]
    fn test_token_token_uri() {
        let mut sys: TesterSystems = tester::setup_world();
        _mint_token(ref sys, OWNER());
        let uri: ByteArray = sys.game.token_uri(1);
        assert_gt!(uri.len(), 1000, "token_uri.len()");
        println!("GAME TOKEN URI: [{}]", uri);
    }


    //-----------------------------------
    // admin functions
    //

    #[test]
    fn test_token_set_minting_paused() {
        let mut sys: TesterSystems = tester::setup_world();
        tester::impersonate(OWNER());
        assert_eq!(sys.game.is_minting_paused(), false, "default");
        sys.game.set_minting_paused(true);
        assert_eq!(sys.game.is_minting_paused(), true, "set_minting_paused(true)");
        sys.game.set_minting_paused(false);
        assert_eq!(sys.game.is_minting_paused(), false, "set_minting_paused(false)");
    }

    #[test]
    #[should_panic(expected: ('ERC721Combo: minting is paused','ENTRYPOINT_FAILED'))]
    fn test_token_set_minting_paused_mint() {
        let mut sys: TesterSystems = tester::setup_world();
        tester::impersonate(OWNER());
        sys.game.set_minting_paused(true);
        assert_eq!(sys.game.is_minting_paused(), true, "set_minting_paused(true)");
        _mint_token(ref sys, OWNER());
    }

    #[test]
    #[should_panic(expected: ('FERAL: Invalid caller','ENTRYPOINT_FAILED'))]
    fn test_token_set_minting_paused_not_admin() {
        let mut sys: TesterSystems = tester::setup_world();
        tester::impersonate(OTHER());
        sys.game.set_minting_paused(true);
    }


    //-----------------------------------
    // minting
    //

    #[test]
    fn test_token_mint() {
        let mut sys: TesterSystems = tester::setup_world();

        _mint_token(ref sys, OWNER());
        assert_eq!(sys.game.total_supply(), 1, "token_1");
        assert_eq!(sys.game.owner_of(1), OWNER(), "token_1");
        assert_eq!(sys.game.balance_of(OWNER()), 1, "token_1");
        let game_info_1: GameInfo = sys.world.read_model(1);
        assert_ne!(game_info_1.seed, 0, "token_1");

        _mint_token(ref sys, OTHER());
        assert_eq!(sys.game.total_supply(), 2, "token_2");
        assert_eq!(sys.game.owner_of(2), OTHER(), "token_2");
        assert_eq!(sys.game.balance_of(OTHER()), 1, "token_2");
        let game_info_2: GameInfo = sys.world.read_model(2);
        assert_ne!(game_info_2.seed, 0, "token_2");
        assert_ne!(game_info_2.seed, game_info_1.seed, "token_2");

        _mint_token(ref sys, OWNER());
        assert_eq!(sys.game.total_supply(), 3, "token_3");
        assert_eq!(sys.game.owner_of(3), OWNER(), "token_3");
        assert_eq!(sys.game.balance_of(OWNER()), 2, "token_3");
        let game_info_3: GameInfo = sys.world.read_model(3);
        assert_ne!(game_info_3.seed, game_info_1.seed, "token_3");
        assert_ne!(game_info_3.seed, game_info_2.seed, "token_3");
        assert_ne!(game_info_3.seed, 0, "token_3");
    }


    //-----------------------------------
    // gameplay
    //

    #[test]
    fn test_gameplay_offchain_ok() {
        let mut sys: TesterSystems = tester::setup_world();
        // mint
        _mint_token(ref sys, OWNER());
        let game_info: GameInfo = sys.world.read_model(1);
        // start game
        let game_state_0: GameState = sys.game.start_game(1);
        assert_eq!(game_state_0.game_id, 1, "game_state_0");
        assert_eq!(game_state_0.seed, game_info.seed, "game_state");
        assert_eq!(game_state_0.matrix.count_beasts(), 2, "game_state_0");
        assert_eq!(game_state_0.move_count, 0, "game_state_0");
        assert_eq!(game_state_0.score, 0, "game_state_0");
        assert_eq!(game_state_0.finished, false, "game_state_0");
        // tester::print_matrix(@game_state_0.matrix, "game_state_0");
        // move...
        let game_state_1: GameState = sys.game.move(game_state_0, Direction::Right);
        assert_eq!(game_state_1.game_id, 1, "game_state_1");
        assert_ne!(game_state_1.seed, game_state_0.seed, "game_state_1");
        assert_ge!(game_state_1.matrix.count_beasts(), 3, "game_state_1");
        assert_eq!(game_state_1.move_count, 1, "game_state_1");
        assert_gt!(game_state_1.score, game_state_0.score, "game_state_1");
        assert_eq!(game_state_1.finished, false, "game_state_1");
        // tester::print_matrix(@game_state_1.matrix, "game_state_1");
        // move...
        let game_state_2: GameState = sys.game.move(game_state_1, Direction::Down);
        assert_eq!(game_state_2.game_id, 1, "game_state_2");
        assert_ne!(game_state_2.seed, game_state_1.seed, "game_state_2");
        assert_ge!(game_state_2.matrix.count_beasts(), 3, "game_state_2");
        assert_eq!(game_state_2.move_count, 2, "game_state_2");
        assert_gt!(game_state_2.score, game_state_1.score, "game_state_2");
        assert_eq!(game_state_2.finished, false, "game_state_2");
        // tester::print_matrix(@game_state_2.matrix, "game_state_2");
    }

    #[test]
    fn test_gameplay_submit_ok() {
        let mut sys: TesterSystems = tester::setup_world();
        // mint
        _mint_token(ref sys, OWNER());
        let mut game_state: GameState = sys.game.start_game(1);
        // simulate many moves
        let moves: Array<Direction> = array![
            Direction::Right,
            Direction::Down,
            Direction::Down,
            Direction::Left,
            Direction::Up,
            Direction::Right,
            Direction::Down,
            Direction::Left,
            Direction::Up,
            Direction::Left,
            Direction::Up,
            Direction::Right,
            Direction::Down,
            Direction::Left,
            Direction::Up,
            Direction::Right,
            Direction::Down,
            Direction::Left,
            Direction::Up,
        ];
        for move in moves.clone() {
            game_state = sys.game.move(game_state, move);
        }
        tester::print_matrix(@game_state.matrix, "simulated");
        // submit...
        let game_state_submitted: GameState = sys.game.submit_game(1, moves);
        tester::print_matrix(@game_state_submitted.matrix, "submitted");
        // comapre...
        assert_eq!(game_state_submitted.game_id, 1, "game_state_submitted");
        assert_eq!(game_state_submitted.seed, game_state.seed, "game_state_submitted");
        assert_eq!(game_state_submitted.matrix.count_beasts(), game_state.matrix.count_beasts(), "game_state_submitted");
        assert_eq!(game_state_submitted.move_count, game_state.move_count, "game_state_submitted");
        assert_eq!(game_state_submitted.score, game_state.score, "game_state_submitted");
        assert_eq!(game_state_submitted.finished, game_state.finished, "game_state_submitted");
    }

    #[test]
    #[should_panic(expected: ('FERAL: Invalid game','ENTRYPOINT_FAILED'))]
    fn test_gameplay_start_invalid_game() {
        let mut sys: TesterSystems = tester::setup_world();
        sys.game.start_game(1);
    }

    #[test]
    #[should_panic(expected: ('FERAL: Invalid game','ENTRYPOINT_FAILED'))]
    fn test_gameplay_move_invalid_game() {
        let mut sys: TesterSystems = tester::setup_world();
        // mint
        _mint_token(ref sys, OWNER());
        let mut game_state: GameState = sys.game.start_game(1);
        game_state.game_id = 2;
        sys.game.move(game_state, Direction::Right);
    }

    #[test]
    #[should_panic(expected: ('FERAL: Invalid direction','ENTRYPOINT_FAILED'))]
    fn test_gameplay_move_invalid_direction() {
        let mut sys: TesterSystems = tester::setup_world();
        // mint
        _mint_token(ref sys, OWNER());
        let mut game_state: GameState = sys.game.start_game(1);
        sys.game.move(game_state, Direction::None);
    }

}
