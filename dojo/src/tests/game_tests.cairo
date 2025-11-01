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

}
