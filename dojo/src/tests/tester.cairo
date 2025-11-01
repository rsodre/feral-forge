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
            IGameDispatcher, IGameDispatcherTrait
        },
    };

    pub fn impersonate(caller: ContractAddress) {
        starknet::testing::set_account_contract_address(caller);    // starknet::get_execution_info().tx_info.account_contract_address
        starknet::testing::set_contract_address(caller);            // starknet::get_execution_info().contract_address
    }

    pub fn ZERO()      -> ContractAddress { 0x0.try_into().unwrap() }
    pub fn OWNER()     -> ContractAddress { 0x1.try_into().unwrap() } // mock owner of duelists 1-2
    pub fn OTHER()     -> ContractAddress { 0x2.try_into().unwrap() } // mock owner of duelists 3-4
    pub fn ADMIN()     -> ContractAddress { 0x3.try_into().unwrap() } // mock owner of duelists 3-4
    pub fn RECIPIENT() -> ContractAddress { 0x4.try_into().unwrap() }


    #[derive(Copy, Drop)]
    pub struct TesterSystems {
        pub world: WorldStorage,
        pub game: IGameDispatcher,
    }

    fn namespace_def() -> NamespaceDef {
        let ndef: NamespaceDef = NamespaceDef {
            namespace: "feral",
            resources: [
                TestResource::Model(feral::models::game_info::m_GameInfo::TEST_CLASS_HASH.into()),
                TestResource::Contract(feral::systems::game::game::TEST_CLASS_HASH.into()),
            ].span(),
        };
        (ndef)
    }
    fn contract_defs() -> Span<ContractDef> {
        [
            ContractDefTrait::new(@"feral", @"game")
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
        world.dispatcher.grant_owner(selector_from_tag!("feral-game"), OWNER());

        let game: IGameDispatcher = world.game_dispatcher();

        testing::set_block_number(1);
        testing::set_block_timestamp(1);
        impersonate(OWNER());

        (TesterSystems {
            world,
            game,
        })
    }
}
