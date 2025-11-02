use dojo::world::WorldStorage;
use dojo::model::ModelStorage;
use feral::systems::game::game::{Errors as GameErrors};
use feral::models::game_info::GameInfo;
use feral::libs::rng::{Seeder, SeederTrait};
use feral::libs::forge::{ForgeTrait};
use feral::libs::beasts::{BeastTrait};
use feral::libs::constants::{TIER};

// Directions to forge/merge
#[derive(Copy, Drop, Serde, Debug, Default)]
pub enum Direction {
    #[default]
    None,   // 0
    Right,  // 1
    Left,   // 2
    Down,   // 3
    Up,     // 4
}

// the game board
// each tile contains a beast_id or zero
#[derive(Copy, Drop, Serde, Debug, Default)]
pub struct GameMatrix {
    pub b_1_1: u8, pub b_1_2: u8, pub b_1_3: u8, pub b_1_4: u8,
    pub b_2_1: u8, pub b_2_2: u8, pub b_2_3: u8, pub b_2_4: u8,
    pub b_3_1: u8, pub b_3_2: u8, pub b_3_3: u8, pub b_3_4: u8,
    pub b_4_1: u8, pub b_4_2: u8, pub b_4_3: u8, pub b_4_4: u8,
}

// the game board
// each tile contains a beast_id or zero
#[derive(Copy, Drop, Serde, Debug, Default)]
pub struct GameState {
    pub game_id: u128,
    pub seed: felt252,
    pub matrix: GameMatrix,
    pub free_tiles: u8,
    pub finished: bool,
    pub score: u32,
}


#[generate_trait]
pub impl DirectionImpl of DirectionTrait {
    fn is_valid(self: Direction) -> bool {
        (match self {
            Direction::Right | Direction::Left | Direction::Down | Direction::Up => true,
            _ => false,
        })
    }
}

#[generate_trait]
pub impl GameplayImpl of GameplayTrait {
    //
    // create a new game state
    fn start_game(self: @WorldStorage, game_id: u128) -> GameState {
        let game_info: GameInfo = self.read_model(game_id);
        let mut game_state: GameState = GameState {
            game_id,
            seed: game_info.seed,
            matrix: Default::default(),
            free_tiles: (16 - 2),
            finished: false,
            score: 0,
        };
        // initialize the game matrix
        let mut seeder: Seeder = game_state.make_seeder();
        // randomize two beasts
        let b_1: u8 = BeastTrait::randomize_beast_of_tier(TIER::T5, ref seeder);
        let b_2: u8 = BeastTrait::randomize_beast_of_tier(TIER::T5, ref seeder);
        // randomize two tiles in opposite sides
        let t_1: u8 = seeder.get_next_u8(8);
        let t_2: u8 = seeder.get_next_u8(8) + 8;
        // set tiles
        game_state.matrix.set_tile(t_1, b_1);
        game_state.matrix.set_tile(t_2, b_2);
        // return the game state
        (game_state)
    }

    //
    // create a new game state
    fn move(ref self: GameState, direction: Direction) {
        assert(!self.finished, GameErrors::GAME_FINISHED);
        assert(direction.is_valid(), GameErrors::INVALID_DIRECTION);
        // re-hash the seed
        let mut seeder: Seeder = self.make_seeder();
        seeder.rehash();
        // move!
        self.free_tiles = self.matrix.forge_direction(direction, true, ref seeder);
        self.finished = (self.free_tiles == 0);
    }

    fn make_seeder(self: @GameState) -> Seeder {
        (Seeder {
            seed: *self.seed,
            current: 0,
        })
    }

    fn calc_score(ref self: GameState) {
        self.score =
            self.matrix.b_1_1.get_score()
            + self.matrix.b_1_2.get_score()
            + self.matrix.b_1_3.get_score()
            + self.matrix.b_1_4.get_score()
            + self.matrix.b_2_1.get_score()
            + self.matrix.b_2_2.get_score()
            + self.matrix.b_2_3.get_score()
            + self.matrix.b_2_4.get_score()
            + self.matrix.b_3_1.get_score()
            + self.matrix.b_3_2.get_score()
            + self.matrix.b_3_3.get_score()
            + self.matrix.b_3_4.get_score()
            + self.matrix.b_4_1.get_score()
            + self.matrix.b_4_2.get_score()
            + self.matrix.b_4_3.get_score()
            + self.matrix.b_4_4.get_score();
    }
}
