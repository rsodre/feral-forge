#[cfg(test)]
mod tests {
    use dojo::model::{ModelStorage, ModelStorageTest};
    use dojo::world::{WorldStorage, WorldStorageTrait};
    use dojo_cairo_test::{
        ContractDef, ContractDefTrait, NamespaceDef, TestResource, WorldStorageTestTrait,
        spawn_test_world,
    };
    use feral::models::models::{Direction, Moves, Position};
    use feral::systems::game::{IActionsDispatcher, IActionsDispatcherTrait};
    use starknet::ContractAddress;

    fn namespace_def() -> NamespaceDef {
        let ndef = NamespaceDef {
            namespace: "feral",
            resources: [
                TestResource::Model(feral::models::models::m_Position::TEST_CLASS_HASH.into()),
                TestResource::Model(feral::models::models::m_Moves::TEST_CLASS_HASH.into()),
                TestResource::Event(feral::systems::game::game::e_Moved::TEST_CLASS_HASH.into()),
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
    fn test_world_test_set() {
        // Initialize test environment
        let caller: ContractAddress = 0.try_into().unwrap();
        let ndef: NamespaceDef = namespace_def();

        // Register the resources.
        let mut world: WorldStorage = spawn_test_world(
            dojo::world::world::TEST_CLASS_HASH,
            [ndef].span(),
        );

        // Ensures permissions and initializations are synced.
        world.sync_perms_and_inits(contract_defs());

        // Test initial position
        let mut position: Position = world.read_model(caller);
        assert(position.vec.x == 0 && position.vec.y == 0, 'initial position wrong');

        // Test write_model_test
        position.vec.x = 122;
        position.vec.y = 88;

        world.write_model_test(@position);

        let mut position: Position = world.read_model(caller);
        assert(position.vec.y == 88, 'write_value_from_id failed');

        // Test model deletion
        world.erase_model(@position);
        let position: Position = world.read_model(caller);
        assert(position.vec.x == 0 && position.vec.y == 0, 'erase_model failed');
    }

    #[test]
    #[available_gas(30000000)]
    fn test_move() {
        let caller: ContractAddress = 0.try_into().unwrap();

        let ndef: NamespaceDef = namespace_def();
        let mut world: WorldStorage = spawn_test_world(
            dojo::world::world::TEST_CLASS_HASH,
            [ndef].span(),
        );
        world.sync_perms_and_inits(contract_defs());

        let (contract_address, _) = world.dns(@"game").unwrap();
        let game_system = IActionsDispatcher { contract_address };

        game_system.spawn();
        let initial_moves: Moves = world.read_model(caller);
        let initial_position: Position = world.read_model(caller);

        assert(
            initial_position.vec.x == 10 && initial_position.vec.y == 10, 'wrong initial position',
        );

        game_system.move(Direction::Right);

        let moves: Moves = world.read_model(caller);
        let right_dir_felt: felt252 = Direction::Right.into();

        assert(moves.remaining == initial_moves.remaining - 1, 'moves is wrong');
        assert(moves.last_direction.unwrap().into() == right_dir_felt, 'last direction is wrong');

        let new_position: Position = world.read_model(caller);
        assert(new_position.vec.x == initial_position.vec.x + 1, 'position x is wrong');
        assert(new_position.vec.y == initial_position.vec.y, 'position y is wrong');
    }
}
