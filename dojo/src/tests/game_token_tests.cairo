#[cfg(test)]
mod tests {
    use starknet::ContractAddress;
    use dojo::{
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
                IFeralGameDispatcherTrait,
                OWNER, OTHER, RECIPIENT,
            },
        },
    };

    use game_components_embeddable_game_standard::minigame::interface::{
        IMinigameDispatcher, IMinigameDispatcherTrait,
        IMinigameTokenDataDispatcher, IMinigameTokenDataDispatcherTrait,
        IMinigameDetailsDispatcher, IMinigameDetailsDispatcherTrait,
    };
    use game_components_embeddable_game_standard::minigame::structs::GameDetail;

    fn mint_token(ref sys: TesterSystems, player: ContractAddress, salt: u16) -> felt252 {
        let minigame = IMinigameDispatcher { contract_address: sys.game.contract_address };
        // mint via caller
        snforge_std::start_cheat_caller_address(sys.game.contract_address, player);
        let token_id = minigame.mint_game(
            Option::None, Option::Some(1_u32), Option::None, Option::None, Option::None,
            Option::None, Option::None, Option::None, Option::None,
            player, false, false, salt, 0,
        );
        sys.game.new_game(token_id);
        snforge_std::stop_cheat_caller_address(sys.game.contract_address);
        (token_id)
    }

    fn _submit_game(ref sys: TesterSystems, caller: ContractAddress, token_id: felt252, moves: Array<Direction>) -> GameState {
        snforge_std::start_cheat_caller_address(sys.game.contract_address, caller);
        let game_state: GameState = sys.game.submit_game(token_id, moves);
        snforge_std::stop_cheat_caller_address(sys.game.contract_address);
        (game_state)
    }


    #[test]
    fn test_new_game_ok() {
        let mut sys: TesterSystems = tester::setup_world();
        let token_id_1 = mint_token(ref sys, OWNER(), 1);
        let game_info_1: GameInfo = sys.world.read_model(token_id_1);
        assert_eq!(game_info_1.top_score_address, OWNER(), "address owner");
        assert_ne!(game_info_1.seed, 0, "seed 1");
        assert_eq!(game_info_1.finished, false, "finished false");

        let token_id_2 = mint_token(ref sys, OTHER(), 2);
        let game_info_2: GameInfo = sys.world.read_model(token_id_2);
        assert_ne!(game_info_2.seed, 0, "seed 2");
        assert_ne!(game_info_2.seed, game_info_1.seed, "diff seeds");

        let got_info_1: GameInfo = sys.game.get_game_info(token_id_1);
        assert_eq!(got_info_1.seed, game_info_1.seed, "got_info_1");
    }

    #[test]
    #[should_panic(expected:('Caller is not token owner',))]
    fn test_new_game_invalid_token() {
        let mut sys: TesterSystems = tester::setup_world();
        sys.game.new_game(12345);
    }

    #[test]
    fn test_token_name() {
        let mut sys: TesterSystems = tester::setup_world();
        let details = IMinigameDetailsDispatcher { contract_address: sys.game.contract_address };
        let name = details.token_name(1);
        assert_eq!(name, metadata::TOKEN_NAME(), "token name");
    }

    #[test]
    fn test_game_details() {
        let mut sys: TesterSystems = tester::setup_world();
        let token_id = mint_token(ref sys, OWNER(), 1);
        let details = IMinigameDetailsDispatcher { contract_address: sys.game.contract_address };
        let d = details.game_details(token_id);
        assert_eq!(d.len(), 2, "details len");
        assert_eq!(*d.at(0).name, 'Top Score', "top score name");
        assert_eq!(*d.at(1).name, 'Best Move Count', "best moves name");
    }


    //-----------------------------------
    // gameplay
    //

    #[test]
    fn test_gameplay_offchain_ok() {
        let mut sys: TesterSystems = tester::setup_world();
        let token_id = mint_token(ref sys, OWNER(), 1);
        let game_info: GameInfo = sys.world.read_model(token_id);
        
        let game_state_0: GameState = sys.game.start_game(token_id);
        assert_eq!(game_state_0.game_id, token_id, "game_state_0");
        assert_eq!(game_state_0.seed, game_info.seed, "game_state");
        assert_eq!(game_state_0.matrix.count_beasts(), 2, "game_state_0");
        assert_eq!(game_state_0.move_count, 0, "game_state_0");
        assert_eq!(game_state_0.score, 0, "game_state_0");
        assert_eq!(game_state_0.finished, false, "game_state_0");

        let game_state_1: GameState = sys.game.move(game_state_0, Direction::Right);
        assert_eq!(game_state_1.game_id, token_id, "game_state_1");
        assert_ne!(game_state_1.seed, game_state_0.seed, "game_state_1");
        assert_ge!(game_state_1.matrix.count_beasts(), 3, "game_state_1");
        assert_eq!(game_state_1.move_count, 1, "game_state_1");
        assert_gt!(game_state_1.score, game_state_0.score, "game_state_1");
        assert_eq!(game_state_1.finished, false, "game_state_1");

        let game_state_2: GameState = sys.game.move(game_state_1, Direction::Down);
        assert_eq!(game_state_2.game_id, token_id, "game_state_2");
        assert_ne!(game_state_2.seed, game_state_1.seed, "game_state_2");
        assert_ge!(game_state_2.matrix.count_beasts(), 3, "game_state_2");
        assert_eq!(game_state_2.move_count, 2, "game_state_2");
        assert_gt!(game_state_2.score, game_state_1.score, "game_state_2");
        assert_eq!(game_state_2.finished, false, "game_state_2");
    }

    #[test]
    fn test_gameplay_submit_ok() {
        let mut sys: TesterSystems = tester::setup_world();
        let token_id = mint_token(ref sys, OWNER(), 1);
        let mut game_state: GameState = sys.game.start_game(token_id);
        let moves: Array<Direction> = array![
            Direction::Right, Direction::Down, Direction::Down, Direction::Left,
            Direction::Up, Direction::Right, Direction::Down, Direction::Left,
            Direction::Up, Direction::Left, Direction::Up, Direction::Right,
            Direction::Down, Direction::Left, Direction::Up, Direction::Right,
            Direction::Down, Direction::Left, Direction::Up,
        ];
        for move in moves.clone() {
            game_state = sys.game.move(game_state, move);
        };
        
        let game_state_submitted: GameState = _submit_game(ref sys, OWNER(), token_id, moves);
        
        assert_eq!(game_state_submitted.game_id, token_id, "game_state_submitted");
        assert_eq!(game_state_submitted.seed, game_state.seed, "game_state_submitted");
        assert_eq!(game_state_submitted.matrix.count_beasts(), game_state.matrix.count_beasts(), "game_state_submitted");
        assert_eq!(game_state_submitted.move_count, game_state.move_count, "game_state_submitted");
        assert_eq!(game_state_submitted.score, game_state.score, "game_state_submitted");
        assert_eq!(game_state_submitted.finished, game_state.finished, "game_state_submitted");

        let token_data = IMinigameTokenDataDispatcher { contract_address: sys.game.contract_address };
        if game_state_submitted.finished {
            assert_eq!(token_data.game_over(token_id), true, "game over true");
        } else {
            assert_eq!(token_data.game_over(token_id), false, "game over false");
        }
        assert_gt!(token_data.score(token_id), 0, "score > 0");
    }


    #[test]
    fn test_top_score() {
        let mut sys: TesterSystems = tester::setup_world();
        let token_id = mint_token(ref sys, OWNER(), 1);
        let _game_state_0: GameState = sys.game.start_game(token_id);
        
        // Player 1...
        let moves: Array<Direction> = array![Direction::Right, Direction::Down];
        let game_state_1: GameState = _submit_game(ref sys, OWNER(), token_id, moves);
        assert_eq!(game_state_1.move_count, 2, "game_state_1");
        assert_gt!(game_state_1.score, 2, "game_state_1");
        
        let game_info_1: GameInfo = sys.world.read_model(token_id);
        assert_eq!(game_info_1.top_score_address, OWNER(), "game_info_1 address");
        assert_eq!(game_info_1.top_score_move_count, 2, "game_info_1 count");
        assert_gt!(game_info_1.top_score, 2, "game_info_1 score");
        
        let token_data = IMinigameTokenDataDispatcher { contract_address: sys.game.contract_address };
        assert_eq!(token_data.score(token_id).into(), game_info_1.top_score, "score match");

        // Player 2 updates... (new top)
        let moves2: Array<Direction> = array![
            Direction::Right, Direction::Down, Direction::Right, Direction::Down, Direction::Up, Direction::Left,
        ];
        let game_state_2: GameState = _submit_game(ref sys, OTHER(), token_id, moves2);
        assert_eq!(game_state_2.move_count, 6, "game_state_2");
        assert_gt!(game_state_2.score, 2, "game_state_2");
        
        let game_info_2: GameInfo = sys.world.read_model(token_id);
        assert_eq!(game_info_2.top_score_address, OTHER(), "game_info_2 address");
        assert_eq!(game_info_2.top_score_move_count, 6, "game_info_2 count");
        assert_gt!(game_info_2.top_score, game_info_1.top_score, "game_info_2 score");

        // Player 3... (not qualified)
        let moves3: Array<Direction> = array![Direction::Down, Direction::Up];
        let game_state_3: GameState = _submit_game(ref sys, RECIPIENT(), token_id, moves3);
        assert_eq!(game_state_3.move_count, 2, "game_state_3");
        assert_gt!(game_state_3.score, 2, "game_state_3");
        
        let game_info_3: GameInfo = sys.world.read_model(token_id);
        assert_eq!(game_info_3.top_score_address, game_info_2.top_score_address, "game_info_3 address");
        assert_eq!(game_info_3.top_score_move_count, game_info_2.top_score_move_count, "game_info_3 count");
        assert_eq!(game_info_3.top_score, game_info_2.top_score, "game_info_3 score");
    }

    #[test]
    #[should_panic(expected:('FERAL: Invalid direction',))]
    fn test_gameplay_move_invalid_direction() {
        let mut sys: TesterSystems = tester::setup_world();
        let token_id = mint_token(ref sys, OWNER(), 1);
        let mut game_state: GameState = sys.game.start_game(token_id);
        sys.game.move(game_state, Direction::None);
    }

    #[test]
    #[should_panic(expected:('FERAL: Invalid moves',))]
    fn test_gameplay_start_invalid_moves() {
        let mut sys: TesterSystems = tester::setup_world();
        let token_id = mint_token(ref sys, OWNER(), 1);
        _submit_game(ref sys, OWNER(), token_id, array![]);
    }

}
