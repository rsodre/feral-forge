#[cfg(test)]
pub mod tester {
    use starknet::{ContractAddress, testing};
    // use dojo::model::{ModelStorage, ModelStorageTest};
    use dojo::world::{
        IWorldDispatcherTrait,
        WorldStorage,
        // WorldStorageTrait,
    };
    use dojo_cairo_test::{
        ContractDef, ContractDefTrait, NamespaceDef, TestResource, WorldStorageTestTrait,
        spawn_test_world,
    };
    pub use feral::libs::{
        dns::{DnsTrait,
            IGameTokenDispatcher, IGameTokenDispatcherTrait
        },
        gameplay::{GameMatrix},
    };

    pub fn impersonate(caller: ContractAddress) {
        starknet::testing::set_account_contract_address(caller);    // starknet::get_execution_info().tx_info.account_contract_address
        starknet::testing::set_contract_address(caller);            // starknet::get_execution_info().contract_address
    }

    pub fn ZERO()      -> ContractAddress { 0x0.try_into().unwrap() }
    pub fn OWNER()     -> ContractAddress { 0x111.try_into().unwrap() } // mock owner of duelists 1-2
    pub fn OTHER()     -> ContractAddress { 0x222.try_into().unwrap() } // mock owner of duelists 3-4
    pub fn ADMIN()     -> ContractAddress { 0x333.try_into().unwrap() } // mock owner of duelists 3-4
    pub fn RECIPIENT() -> ContractAddress { 0x444.try_into().unwrap() }


    #[derive(Copy, Drop)]
    pub struct TesterSystems {
        pub world: WorldStorage,
        pub game: IGameTokenDispatcher,
    }

    fn namespace_def() -> NamespaceDef {
        let ndef: NamespaceDef = NamespaceDef {
            namespace: "feral",
            resources: [
                TestResource::Model(feral::models::game_info::m_GameInfo::TEST_CLASS_HASH.into()),
                TestResource::Event(feral::models::game_info::e_GameScoredEvent::TEST_CLASS_HASH.into()),
                TestResource::Contract(feral::systems::game_token::game_token::TEST_CLASS_HASH.into()),
            ].span(),
        };
        (ndef)
    }
    fn contract_defs() -> Span<ContractDef> {
        [
            ContractDefTrait::new(@"feral", @"game_token")
                .with_writer_of([dojo::utils::bytearray_hash(@"feral")].span())
        ].span()
    }

    #[test]
    pub fn setup_world() -> TesterSystems {
        let ndef: NamespaceDef = namespace_def();
        let mut world: WorldStorage = spawn_test_world(
            dojo::world::world::TEST_CLASS_HASH,
            [ndef].span(),
        );
        world.sync_perms_and_inits(contract_defs());
        world.dispatcher.grant_owner(dojo::utils::bytearray_hash(@"feral"), OWNER());
        world.dispatcher.grant_owner(selector_from_tag!("feral-game_token"), OWNER());

        let game: IGameTokenDispatcher = world.game_dispatcher();

        testing::set_block_number(1);
        testing::set_block_timestamp(1);
        impersonate(OWNER());

        (TesterSystems {
            world,
            game,
        })
    }

    pub fn print_matrix(m: @GameMatrix, prefix: ByteArray) {
        println!("-------:");
        println!("[{}][0]: {} {} {} {}", prefix, m.b_1_1, m.b_1_2, m.b_1_3, m.b_1_4);
        println!("[{}][1]: {} {} {} {}", prefix, m.b_2_1, m.b_2_2, m.b_2_3, m.b_2_4);
        println!("[{}][2]: {} {} {} {}", prefix, m.b_3_1, m.b_3_2, m.b_3_3, m.b_3_4);
        println!("[{}][3]: {} {} {} {}", prefix, m.b_4_1, m.b_4_2, m.b_4_3, m.b_4_4);
    }
}
