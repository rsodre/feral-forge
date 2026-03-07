#[cfg(test)]
pub mod tester {
    use starknet::ContractAddress;
    use dojo::world::{
        IWorldDispatcherTrait,
        WorldStorage,
    };
    use dojo_snf_test::{
        ContractDef, ContractDefTrait, NamespaceDef, TestResource, WorldStorageTestTrait,
        spawn_test_world, set_caller_address,
    };
    pub use feral::libs::{
        dns::{DnsTrait,
            IGameTokenDispatcher, IGameTokenDispatcherTrait
        },
        gameplay::{GameMatrix},
    };

    pub fn impersonate(caller: ContractAddress) {
        set_caller_address(caller);
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
                TestResource::Model("GameInfo"),
                TestResource::Event("GameScoredEvent"),
                TestResource::Contract("game_token"),
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

    pub fn setup_world() -> TesterSystems {
        let ndef: NamespaceDef = namespace_def();
        let mut world: WorldStorage = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());
        world.dispatcher.grant_owner(dojo::utils::bytearray_hash(@"feral"), OWNER());
        world.dispatcher.grant_owner(selector_from_tag!("feral-game_token"), OWNER());

        let game: IGameTokenDispatcher = world.game_dispatcher();

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
