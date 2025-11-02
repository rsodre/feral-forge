use feral::systems::game::game::{
    Errors as GameErrors,
};
use feral::libs::{
    gameplay::{
        Direction,
        GameMatrix,
    },
    constants::{
        BEAST_ID::*,
        TIER::*,
    },
    beasts::{BeastTrait},
    rng::{Seeder, SeederTrait},
};

#[generate_trait]
pub impl ForgeImpl of ForgeTrait {

    //
    // Set a tile in the game matrix
    /// (used to initialize the game matrix)
    //
    // @param: tile_index the index of the tile to set
    // @param: beast_id the beast_id to set
    fn set_tile(ref self: GameMatrix, tile_index: u8, beast_id: u8) {
        assert(tile_index < 16, GameErrors::INVALID_TILE);
        assert(beast_id == 0 || BeastTrait::is_beast(beast_id), GameErrors::INVALID_BEAST);
        match tile_index {
            0  => { self.b_1_1 = beast_id; },
            1  => { self.b_1_2 = beast_id; },
            2  => { self.b_1_3 = beast_id; },
            3  => { self.b_1_4 = beast_id; },
            4  => { self.b_2_1 = beast_id; },
            5  => { self.b_2_2 = beast_id; },
            6  => { self.b_2_3 = beast_id; },
            7  => { self.b_2_4 = beast_id; },
            8  => { self.b_3_1 = beast_id; },
            9  => { self.b_3_2 = beast_id; },
            10 => { self.b_3_3 = beast_id; },
            11 => { self.b_3_4 = beast_id; },
            12 => { self.b_4_1 = beast_id; },
            13 => { self.b_4_2 = beast_id; },
            14 => { self.b_4_3 = beast_id; },
            15 => { self.b_4_4 = beast_id; },
            _ => {},
        }
    }

    //
    // Core game loop -- one player move
    // process the game matrix in a direction
    //
    // @param: dir the direction to forge
    // @param: spawn_new_tile if true, spawn a new tile if there are free tiles
    // @param: seeder the seeder to use
    // @returns: the number of freed tiles
    fn forge_direction(ref self: GameMatrix, dir: Direction, spawn_new_tile: bool, ref seeder: Seeder) -> u8 {
        let mut f_1: u8 = 0;
        let mut f_2: u8 = 0;
        let mut f_3: u8 = 0;
        let mut f_4: u8 = 0;
        match dir {
            Direction::Right => {
                Self::_merge_row(ref self.b_1_4, ref self.b_1_3, ref self.b_1_2, ref self.b_1_1, ref f_1, ref seeder);
                Self::_merge_row(ref self.b_2_4, ref self.b_2_3, ref self.b_2_2, ref self.b_2_1, ref f_2, ref seeder);
                Self::_merge_row(ref self.b_3_4, ref self.b_3_3, ref self.b_3_2, ref self.b_3_1, ref f_3, ref seeder);
                Self::_merge_row(ref self.b_4_4, ref self.b_4_3, ref self.b_4_2, ref self.b_4_1, ref f_4, ref seeder);
            },
            Direction::Left => {
                Self::_merge_row(ref self.b_1_1, ref self.b_1_2, ref self.b_1_3, ref self.b_1_4, ref f_1, ref seeder);
                Self::_merge_row(ref self.b_2_1, ref self.b_2_2, ref self.b_2_3, ref self.b_2_4, ref f_2, ref seeder);
                Self::_merge_row(ref self.b_3_1, ref self.b_3_2, ref self.b_3_3, ref self.b_3_4, ref f_3, ref seeder);
                Self::_merge_row(ref self.b_4_1, ref self.b_4_2, ref self.b_4_3, ref self.b_4_4, ref f_4, ref seeder);
            },
            Direction::Down => {
                Self::_merge_row(ref self.b_4_1, ref self.b_3_1, ref self.b_2_1, ref self.b_1_1, ref f_1, ref seeder);
                Self::_merge_row(ref self.b_4_2, ref self.b_3_2, ref self.b_2_2, ref self.b_1_2, ref f_2, ref seeder);
                Self::_merge_row(ref self.b_4_3, ref self.b_3_3, ref self.b_2_3, ref self.b_1_3, ref f_3, ref seeder);
                Self::_merge_row(ref self.b_4_4, ref self.b_3_4, ref self.b_2_4, ref self.b_1_4, ref f_4, ref seeder);
            },
            Direction::Up => {
                Self::_merge_row(ref self.b_1_1, ref self.b_2_1, ref self.b_3_1, ref self.b_4_1, ref f_1, ref seeder);
                Self::_merge_row(ref self.b_1_2, ref self.b_2_2, ref self.b_3_2, ref self.b_4_2, ref f_2, ref seeder);
                Self::_merge_row(ref self.b_1_3, ref self.b_2_3, ref self.b_3_3, ref self.b_4_3, ref f_3, ref seeder);
                Self::_merge_row(ref self.b_1_4, ref self.b_2_4, ref self.b_3_4, ref self.b_4_4, ref f_4, ref seeder);
            },
            Direction::None => {},
        }
        // spawn a new T5 beast
        let mut free: u8 = (f_1 + f_2 + f_3 + f_4);
        if (spawn_new_tile && free > 0) {
            let beast_id: u8 = BeastTrait::randomize_beast_of_tier(T5, ref seeder);
            let ft: u8 = seeder.get_next_u8(free);
            let (row, t): (u8, u8) =
                if (ft < f_1) {(1, ft)}
                else if (ft < f_1 + f_2) {(2, ft - f_1)}
                else if (ft < f_1 + f_2 + f_3) {(3, ft - f_1 - f_2)}
                else {(4, ft - f_1 - f_2 - f_3)};
            // set tile
            match dir {
                Direction::Right => {
                    if (row == 1) { Self::_spawn_free_tile(ref self.b_1_4, ref self.b_1_3, ref self.b_1_2, ref self.b_1_1, beast_id, t); }
                    else if (row == 2) { Self::_spawn_free_tile(ref self.b_2_4, ref self.b_2_3, ref self.b_2_2, ref self.b_2_1, beast_id, t); }
                    else if (row == 3) { Self::_spawn_free_tile(ref self.b_3_4, ref self.b_3_3, ref self.b_3_2, ref self.b_3_1, beast_id, t); }
                    else if (row == 4) { Self::_spawn_free_tile(ref self.b_4_4, ref self.b_4_3, ref self.b_4_2, ref self.b_4_1, beast_id, t); }
                },
                Direction::Left => {
                    if (row == 1) { Self::_spawn_free_tile(ref self.b_1_1, ref self.b_1_2, ref self.b_1_3, ref self.b_1_4, beast_id, t); }
                    else if (row == 2) { Self::_spawn_free_tile(ref self.b_2_1, ref self.b_2_2, ref self.b_2_3, ref self.b_2_4, beast_id, t); }
                    else if (row == 3) { Self::_spawn_free_tile(ref self.b_3_1, ref self.b_3_2, ref self.b_3_3, ref self.b_3_4, beast_id, t); }
                    else if (row == 4) { Self::_spawn_free_tile(ref self.b_4_1, ref self.b_4_2, ref self.b_4_3, ref self.b_4_4, beast_id, t); }
                },
                Direction::Down => {
                    if (row == 1) { Self::_spawn_free_tile(ref self.b_4_1, ref self.b_3_1, ref self.b_2_1, ref self.b_1_1, beast_id, t); }
                    else if (row == 2) { Self::_spawn_free_tile(ref self.b_4_2, ref self.b_3_2, ref self.b_2_2, ref self.b_1_2, beast_id, t); }
                    else if (row == 3) { Self::_spawn_free_tile(ref self.b_4_3, ref self.b_3_3, ref self.b_2_3, ref self.b_1_3, beast_id, t); }
                    else if (row == 4) { Self::_spawn_free_tile(ref self.b_4_4, ref self.b_3_4, ref self.b_2_4, ref self.b_1_4, beast_id, t); }
                },
                Direction::Up => {
                    if (row == 1) { Self::_spawn_free_tile(ref self.b_1_1, ref self.b_2_1, ref self.b_3_1, ref self.b_4_1, beast_id, t); }
                    else if (row == 2) { Self::_spawn_free_tile(ref self.b_1_2, ref self.b_2_2, ref self.b_3_2, ref self.b_4_2, beast_id, t); }
                    else if (row == 3) { Self::_spawn_free_tile(ref self.b_1_3, ref self.b_2_3, ref self.b_3_3, ref self.b_4_3, beast_id, t); }
                    else if (row == 4) { Self::_spawn_free_tile(ref self.b_1_4, ref self.b_2_4, ref self.b_3_4, ref self.b_4_4, beast_id, t); }
                },
                Direction::None => {},
            }
            // one less free tile
            free -= 1;
        }
        // return the number of freed tiles
        (free)
    }

    //
    // Fill a free tile with a new beast
    // * Free tiles are always from right to left
    fn _spawn_free_tile(ref b_0: u8, ref b_1: u8, ref b_2: u8, ref b_3: u8, beast_id: u8, tile_index: u8) {
        if (tile_index == 0) { b_3 = beast_id; }
        else if (tile_index == 1) { b_2 = beast_id; }
        else if (tile_index == 2) { b_1 = beast_id; }
        else if (tile_index == 3) { b_0 = beast_id; }
    }

    //
    // Try to merge a row of 4 tiles
    // * Collapses from right to left
    // * Any free space is left to the right
    fn _merge_row(ref b_0: u8, ref b_1: u8, ref b_2: u8, ref b_3: u8, ref free: u8, ref seeder: Seeder) {
        free = 0;
        let (r_0, r_1, f, merged): (u8, u8, u8, bool) = Self::_merge_pair(b_0, b_1, ref seeder);
        if (f == 2) {
            // case [A:0]
            free = f;
            // 0,0,?,?
            // 1st pair is free, not merged
            let (r_0, r_1, f, _): (u8, u8, u8, bool) = Self::_merge_pair(b_2, b_3, ref seeder);
            free += f;
            // x,x,0,0
            b_0 = r_0;
            b_1 = r_1;
            b_2 = 0;
            b_3 = 0;
            // finished!
        } else if (f == 0) {
            // case [B:]
            // [x,x],?,?
            b_0 = r_0;
            b_1 = r_1;
            // 1st pair is full, try next pair
            let (r_0, r_1, f, _): (u8, u8, u8, bool) = Self::_merge_pair(b_1, b_2, ref seeder);
            // x,[x,x],?
            b_1 = r_0;
            if (merged) {
                // case [B:1]
                free += f;
                // x,[x,0],? merged
                // shift last tile
                b_2 = b_3;
                b_3 = 0;
                if (b_2 == 0) {
                    free += 1; // shifted tile was free
                }
                // finished!
            } else if (f == 1) {
                // case [B:2]
                // x,[x,0],?
                // try tith last tile
                let (r_0, r_1, f, _): (u8, u8, u8, bool) = Self::_merge_pair(b_1, b_3, ref seeder);
                free += f;
                // x,x,x,?
                b_1 = r_0;
                b_2 = r_1;
                b_3 = 0;
                free += 1;
                // finished!
            } else { // (f == 0)
                // case [B:3]
                b_2 = r_1;
                // x,[x,x],?
                // try last pair
                let (r_0, r_1, f, _): (u8, u8, u8, bool) = Self::_merge_pair(b_2, b_3, ref seeder);
                free += f;
                // x,x,x,x
                b_2 = r_0;
                b_3 = r_1;
                // finished!
            }
        } else { // (f_0 == 1)
            // case [C:]
            free = f;
            // x,0,?,?
            b_0 = r_0;
            if (merged) {
                // case [C:1]
                // 1st pair was merged, try to merge the second pair
                let (r_0, r_1, f, _): (u8, u8, u8, bool) = Self::_merge_pair(b_2, b_3, ref seeder);
                free += f;
                // x,x,x,x
                b_1 = r_0;
                b_2 = r_1;
                b_3 = 0;
                // finished!
            } else { // (f == 1)
                // case [C:2:]
                // 1 tile shifted, match with the next tile
                let (r_0, r_1, f, merged): (u8, u8, u8, bool) = Self::_merge_pair(b_0, b_2, ref seeder);
                free += f;
                b_0 = r_0;
                b_1 = r_1;
                if (merged) {
                    // case [C:2:1]
                    // x,?,0,0
                    // merged shifted b_0 + b_2
                    b_1 = b_3; // shift the last tile
                    b_2 = 0;
                    b_3 = 0;
                    if (b_1 == 0) {
                        free += 1; // shifted tile was free
                    }
                    // finished!
                } else if (f == 1) {
                    // case [C:2:2]
                    // x,0,0,?
                    // b_2 was free, try to merge b_0 + b_3
                    let (r_0, r_1, f, _): (u8, u8, u8, bool) = Self::_merge_pair(b_0, b_3, ref seeder);
                    free += f;
                    b_0 = r_0;
                    b_1 = r_1;
                    b_2 = 0;
                    b_3 = 0;
                    // finished!
                } else { // (f == 0)
                    // case [C:2:3]
                    // x,x,0,?
                    // shifted b_2, try to merge it with b_3
                    let (r_0, r_1, f, _): (u8, u8, u8, bool) = Self::_merge_pair(b_1, b_3, ref seeder);
                    free += f;
                    b_1 = r_0;
                    b_2 = r_1;
                    b_3 = 0;
                    // finished!
                }
            }
        }
    }

    //
    // Try to merge a pair of tiles
    // * Same tier: merge into next tier (T5>T4, ...)
    // * Same beast: merge into a shiny, of that tier (T1>S1, ...)
    // @param: (b_0, b_1) a pair of beast_id or empty tiles (0)
    // @returns: (r_0, r_1, f, m) the new pair, the number of freed tiles, and a merged flag
    fn _merge_pair(b_0: u8, b_1: u8, ref seeder: Seeder) -> (u8, u8, u8, bool) {
        if (b_0 == 0 && b_1 == 0) {
            (0, 0, 2, false)
        } else if (b_0 == 0) {
            (b_1, 0, 1, false)
        } else if (b_1 == 0) {
            (b_0, 0, 1, false)
        } else if (BeastTrait::is_shiny(b_0) || BeastTrait::is_shiny(b_1)) {
            // shiny is final, no changes
            (b_0, b_1, 0, false)
        } else if (b_0 == b_1) {
            // >>> merge into a shiny
            let b: u8 = BeastTrait::to_shiny(b_0);
            (b, 0, 1, true)
        } else {
            let t_0: u8 = BeastTrait::to_tier(b_0);
            if (t_0 > 1 && t_0 == BeastTrait::to_tier(b_1)) {
                // >>> merge to higher tier
                let b: u8 = BeastTrait::randomize_beast_of_tier(t_0 - 1, ref seeder);
                (b, 0, 1, true)
            } else {
                // different tiers, no changes
                (b_0, b_1, 0, false)
            }
        }
    }
}



//---------------------------------------
// tests
//
#[cfg(test)]
mod tests {
    use super::*;

    fn _assert_pair_same(i1: u8, i2: u8, o1: u8, o2: u8, merged: bool, ref seeder: Seeder) {
        let prefix: ByteArray = format!("({},{}) -> ({},{})", i1, i2, o1, o2);
        let (r1, r2, _, m): (u8, u8, u8, bool) = ForgeTrait::_merge_pair(i1, i2, ref seeder);
        assert_eq!(r1, o1, "_assert_pair_same[{}] r1", prefix);
        assert_eq!(r2, o2, "_assert_pair_same[{}] r2", prefix);
        assert_eq!(merged, m, "_assert_pair_same[{}] merged", prefix);
    }
    fn _assert_pair_merge(i1: u8, i2: u8, ot: u8, ref seeder: Seeder) {
        let t1: u8 = BeastTrait::to_tier(i1);
        let t2: u8 = BeastTrait::to_tier(i2);
        let prefix: ByteArray = format!("({}:{},{}:{}) -> ({})", i1, t1, i2, t2, ot);
        let (r1, r2, _, merged): (u8, u8, u8, bool) = ForgeTrait::_merge_pair(i1, i2, ref seeder);
        let rt1: u8 = BeastTrait::to_tier(r1);
        assert_eq!(rt1, ot, "_assert_pair_merge[{}] r1({})", prefix, r1);
        assert_eq!(r2, 0, "_assert_pair_merge[{}] r2 == 0", prefix);
        assert!(merged, "_assert_pair_merge[{}] merged", prefix);
    }
    
    #[test]
    fn test_merge_pair() {
        let mut seeder: Seeder = Seeder {
            seed: 0x05fa5438c7ccbcbae63ec200779acf8b71f34f432e9f0e7adec7a74230850c6b,
            current: 0,
        };
        // no changes
        _assert_pair_same(0, 0, 0, 0, false, ref seeder);
        _assert_pair_same(0, 1, 1, 0, false, ref seeder);
        _assert_pair_same(1, 0, 1, 0, false, ref seeder);
        _assert_pair_same(1, 2, 1, 2, false, ref seeder); // T1 (final)
        _assert_pair_same(2, 1, 2, 1, false, ref seeder); // T1 (final)
        _assert_pair_same(1, 5, 1, 5, false, ref seeder); // T1 (final)
        _assert_pair_same(5, 1, 5, 1, false, ref seeder); // T1 (final)
        _assert_pair_same(25, 26, 25, 26, false, ref seeder); // T1 (final)
        _assert_pair_same(6, 11, 6, 11, false, ref seeder); // T2+T3
        _assert_pair_same(11, 6, 11, 6, false, ref seeder); // T2+T3
        _assert_pair_same(11, 16, 11, 16, false, ref seeder); // T3+T4
        _assert_pair_same(16, 11, 16, 11, false, ref seeder); // T3+T4
        _assert_pair_same(16, 21, 16, 21, false, ref seeder); // T4+T5
        _assert_pair_same(21, 16, 21, 16, false, ref seeder); // T4+T5
        _assert_pair_same(101, 1, 101, 1, false, ref seeder); // shiny vs normal
        _assert_pair_same(1, 101, 1, 101, false, ref seeder); // normal vs shiny
        _assert_pair_same(101, 101, 101, 101, false, ref seeder); // shinies
        _assert_pair_same(101, 102, 101, 102, false, ref seeder); // shinies
        _assert_pair_same(102, 101, 102, 101, false, ref seeder); // shinies
        // merge shinies
        _assert_pair_same(1, 1, 101, 0, true, ref seeder);
        _assert_pair_same(6, 6, 106, 0, true, ref seeder);
        _assert_pair_same(11, 11, 111, 0, true, ref seeder);
        _assert_pair_same(16, 16, 116, 0, true, ref seeder);
        _assert_pair_same(21, 21, 121, 0, true, ref seeder);
        _assert_pair_same(25, 25, 125, 0, true, ref seeder);
        _assert_pair_same(26, 26, 126, 0, true, ref seeder);
        // upgrades...
        _assert_pair_merge(6, 7, T1, ref seeder); // T2 > T1
        _assert_pair_merge(7, 6, T1, ref seeder); // T2 > T1
        _assert_pair_merge(6, 31, T1, ref seeder); // T2 > T1
        _assert_pair_merge(31, 6, T1, ref seeder); // T2 > T1
        _assert_pair_merge(11, 12, T2, ref seeder); // T3 > T2
        _assert_pair_merge(12, 11, T2, ref seeder); // T3 > T2
        _assert_pair_merge(16, 17, T3, ref seeder); // T4 > T3
        _assert_pair_merge(17, 16, T3, ref seeder); // T4 > T3
        _assert_pair_merge(21, 22, T4, ref seeder); // T5 > T4
        _assert_pair_merge(22, 21, T4, ref seeder); // T5 > T4
        _assert_pair_merge(25, 75, T4, ref seeder); // T5 > T4
    }

    fn _count_free_row(i1: u8, i2: u8, i3: u8, i4: u8) -> u8 {
        (if (i1==0){1}else{0} + if(i2==0){1}else{0} + if(i3==0){1}else{0} + if(i4==0){1}else{0})
    }
    fn _count_free_matrix(m: GameMatrix) -> u8 {
        (
            _count_free_row(m.b_1_1, m.b_1_2, m.b_1_3, m.b_1_4) +
            _count_free_row(m.b_2_1, m.b_2_2, m.b_2_3, m.b_2_4) +
            _count_free_row(m.b_3_1, m.b_3_2, m.b_3_3, m.b_3_4) +
            _count_free_row(m.b_4_1, m.b_4_2, m.b_4_3, m.b_4_4)
        )
    }

    fn _assert_row_shift(
        mut i1: u8, mut i2: u8, mut i3: u8, mut i4: u8,
        o1: u8, o2: u8, o3: u8, o4: u8,
        ref seeder: Seeder,
    ) {
        let ti1: u8 = BeastTrait::to_tier_shiny(i1);
        let ti2: u8 = BeastTrait::to_tier_shiny(i2);
        let ti3: u8 = BeastTrait::to_tier_shiny(i3);
        let ti4: u8 = BeastTrait::to_tier_shiny(i4);
        let to1: u8 = BeastTrait::to_tier_shiny(o1);
        let to2: u8 = BeastTrait::to_tier_shiny(o2);
        let to3: u8 = BeastTrait::to_tier_shiny(o3);
        let to4: u8 = BeastTrait::to_tier_shiny(o4);
        let prefix: ByteArray = format!("({}:{},{}:{},{}:{},{}:{}) -> ({}:{},{}:{},{}:{},{}:{})", i1, ti1, i2, ti2, i3, ti3, i4, ti4, o1, to1, o2, to2, o3, to3, o4, to4);
        let mut f: u8 = 0;
        ForgeTrait::_merge_row(ref i1, ref i2, ref i3, ref i4, ref f, ref seeder);
        assert_eq!(i1, o1, "_assert_row_shift[{}] i1", prefix);
        assert_eq!(i2, o2, "_assert_row_shift[{}] i2", prefix);
        assert_eq!(i3, o3, "_assert_row_shift[{}] i3", prefix);
        assert_eq!(i4, o4, "_assert_row_shift[{}] i4", prefix);
        assert_eq!(f, _count_free_row(o1, o2, o3, o4), "_assert_row_shift[{}] free", prefix);
    }
    fn _assert_row_merge(
        mut i1: u8, mut i2: u8, mut i3: u8, mut i4: u8,
        to1: u8, to2: u8, to3: u8, to4: u8,
        ref seeder: Seeder,
    ) {
        let ti1: u8 = BeastTrait::to_tier_shiny(i1);
        let ti2: u8 = BeastTrait::to_tier_shiny(i2);
        let ti3: u8 = BeastTrait::to_tier_shiny(i3);
        let ti4: u8 = BeastTrait::to_tier_shiny(i4);
        let prefix: ByteArray = format!("({}:{},{}:{},{}:{},{}:{}) -> ({},{},{},{})", i1, ti1, i2, ti2, i3, ti3, i4, ti4, to1, to2, to3, to4);
        let mut f: u8 = 0;
        ForgeTrait::_merge_row(ref i1, ref i2, ref i3, ref i4, ref f, ref seeder);
        let ti1: u8 = BeastTrait::to_tier_shiny(i1);
        let ti2: u8 = BeastTrait::to_tier_shiny(i2);
        let ti3: u8 = BeastTrait::to_tier_shiny(i3);
        let ti4: u8 = BeastTrait::to_tier_shiny(i4);
        assert_eq!(ti1, to1, "_assert_row_merge[{}] i1({})", prefix, i1);
        assert_eq!(ti2, to2, "_assert_row_merge[{}] i2({})", prefix, i2);
        assert_eq!(ti3, to3, "_assert_row_merge[{}] i3({})", prefix, i3);
        assert_eq!(ti4, to4, "_assert_row_merge[{}] i4({})", prefix, i4);
        assert_eq!(f, _count_free_row(to1, to2, to3, to4), "_assert_row_merge[{}] free", prefix);
    }

    #[test]
    fn test_merge_row_shift() {
        let mut seeder: Seeder = Seeder {
            seed: 0x05fa5438c7ccbcbae63ec200779acf8b71f34f432e9f0e7adec7a74230850c6b,
            current: 0,
        };
        //
        // empty
        _assert_row_shift(
            0, 0, 0, 0,
            0, 0, 0, 0, ref seeder);
        //
        // full
        _assert_row_shift(
            B01, B06, B11, B16,
            B01, B06, B11, B16, ref seeder);
        _assert_row_shift(
            B01, SH01, B11, SH01,
            B01, SH01, B11, SH01, ref seeder);
        //
        // shift 1
        _assert_row_shift(
            B01, 0, 0, 0,
            B01, 0, 0, 0, ref seeder);
        _assert_row_shift(
            0, B01, 0, 0,
            B01, 0, 0, 0, ref seeder);
        _assert_row_shift(
            0, 0, B01, 0,
            B01, 0, 0, 0, ref seeder);
        _assert_row_shift(
            0, 0, 0, B01,
            B01, 0, 0, 0, ref seeder);
        //
        // shift 1
        _assert_row_shift(
            B01, B06, 0, 0,
            B01, B06, 0, 0, ref seeder);
        _assert_row_shift(
            B01, 0, B06, 0,
            B01, B06, 0, 0, ref seeder);
        _assert_row_shift(
            B01, 0, 0, B06,
            B01, B06, 0, 0, ref seeder);
        _assert_row_shift(
            0, B01, B06, 0,
            B01, B06, 0, 0, ref seeder);
        _assert_row_shift(
            0, 0, B01, B06,
            B01, B06, 0, 0, ref seeder);
        _assert_row_shift(
            0, B01, 0, B06,
            B01, B06, 0, 0, ref seeder);
        //
        // shift 3
        _assert_row_shift(
            B01, B06, B11, 0,
            B01, B06, B11, 0, ref seeder);
        _assert_row_shift(
            B01, B06, 0, B11,
            B01, B06, B11, 0, ref seeder);
        _assert_row_shift(
            B01, 0, B06, B11,
            B01, B06, B11, 0, ref seeder);
        _assert_row_shift(
            0, B01, B06, B11,
            B01, B06, B11, 0, ref seeder);
    }

    #[test]
    fn test_merge_row_merge() {
        let mut seeder: Seeder = Seeder {
            seed: 0x05fa5438c7ccbcbae63ec200779acf8b71f34f432e9f0e7adec7a74230850c6b,
            current: 0,
        };
        //
        // [A:0]
        _assert_row_merge(
            0, 0, 0, 0,
            0, 0, 0, 0, ref seeder);
        _assert_row_merge(
            0, 0, 0, B07,
            T2, 0, 0, 0, ref seeder);
        _assert_row_merge(
            0, 0, B06, 0,
            T2, 0, 0, 0, ref seeder);
        _assert_row_merge(
            0, 0, B06, B07,
            T1, 0, 0, 0, ref seeder);
        //
        // [B:3]
        _assert_row_merge(
            B01, B06, B11, B16,
            T1, T2, T3, T4, ref seeder);
        _assert_row_merge(
            B01, B06, B11, B12,
            T1, T2, T2, 0, ref seeder);
        _assert_row_merge(
            B01, B06, B11, 0,
            T1, T2, T3, 0, ref seeder);
        //
        // merged 1st...
        seeder.rehash(); // boost RNG
        _assert_row_merge( // [B:1]
            B06, B07, B11, 0,
            T1, T3, 0, 0, ref seeder);
        _assert_row_merge( // [B:1]
            B06, B07, 0, B11,
            T1, T3, 0, 0, ref seeder);
        _assert_row_merge( // [B:1]
            B06, B07, B11, B16,
            T1, T3, T4, 0, ref seeder);
        _assert_row_merge( // [B:1]
            B06, B07, B16, B11,
            T1, T4, T3, 0, ref seeder);
        _assert_row_merge( // [B:2]
            B11, B06, B07, 0,
            T3, T1, 0, 0, ref seeder);
        _assert_row_merge( // [C:2:]
            B11, 0, B06, B07,
            T3, T1, 0, 0, ref seeder);
        // merged 2nd...
        _assert_row_merge(
            B11, B06, B07, 0,
            T3, T1, 0, 0, ref seeder);
        _assert_row_merge(
            0, B11, B06, B07,
            T3, T1, 0, 0, ref seeder);
        _assert_row_merge(
            B06, 0, B07, B11,
            T1, T3, 0, 0, ref seeder);
        _assert_row_merge(
            B11, B06, 0, B07,
            T3, T1, 0, 0, ref seeder);
        //
        // merged full
        seeder.rehash(); // boost RNG
        _assert_row_merge( // [C:1]
            B06, B07, B06, 0,
            T1, T2, 0, 0, ref seeder);
        _assert_row_merge( // [C:1]
            B06, B07, 0, B07,
            T1, T2, 0, 0, ref seeder);
        _assert_row_merge( // [C:1]
            B06, B07, B06, B07,
            T1, T1, 0, 0, ref seeder);
        _assert_row_merge( // [C:1]
            B06, B07, B21, B22,
            T1, T4, 0, 0, ref seeder);
        _assert_row_merge( // [C:1]
            B06, B07, B21, B16,
            T1, T5, T4, 0, ref seeder);
        //
        // merged 1 only
        _assert_row_merge( // [C:1]
            B06, B07, 0, 0,
            T1, 0, 0, 0, ref seeder);
        _assert_row_merge( // [C:2:1]
            0, B06, B07, 0,
            T1, 0, 0, 0, ref seeder);
        _assert_row_merge( // [C:2:1]
            B06, 0, B07, 0,
            T1, 0, 0, 0, ref seeder);
        _assert_row_merge( // [C:2:2]
            0, B06, 0, B07,
            T1, 0, 0, 0, ref seeder);
        _assert_row_merge( // [C:2:2]
            B06, 0, 0, B07,
            T1, 0, 0, 0, ref seeder);
        _assert_row_merge( // [C:2:3]
            0, B01, B06, B07,
            T1, T1, 0, 0, ref seeder);
        _assert_row_merge( // [C:2:3]
            B01, 0, B06, B07,
            T1, T1, 0, 0, ref seeder);
        //
        // merge 1 + shift 2
        seeder.rehash(); // boost RNG
        _assert_row_merge(
            B06, B07, B11, B16,
            T1, T3, T4, 0, ref seeder);
        _assert_row_merge(
            B11, B06, B07, B16,
            T3, T1, T4, 0, ref seeder);
        _assert_row_merge(
            B16, B11, B06, B07,
            T4, T3, T1, 0, ref seeder);

        //
        // merge shiny T1
        _assert_row_merge(
            B01, B01, 0, 0,
            S1, 0, 0, 0, ref seeder);
        _assert_row_merge(
            0, B01, B01, 0,
            S1, 0, 0, 0, ref seeder);
        _assert_row_merge(
            0, 0, B01, B01,
            S1, 0, 0, 0, ref seeder);
        _assert_row_merge(
            B01, 0, B01, 0,
            S1, 0, 0, 0, ref seeder);
        _assert_row_merge(
            0, B01, 0, B01,
            S1, 0, 0, 0, ref seeder);
        _assert_row_merge(
            B01, 0, 0, B01,
            S1, 0, 0, 0, ref seeder);
        // merge shiny T2
        _assert_row_merge(
            B06, B06, 0, 0,
            S2, 0, 0, 0, ref seeder);
        _assert_row_merge(
            0, B06, B06, 0,
            S2, 0, 0, 0, ref seeder);
        _assert_row_merge(
            0, 0, B06, B06,
            S2, 0, 0, 0, ref seeder);
        _assert_row_merge(
            B06, 0, B06, 0,
            S2, 0, 0, 0, ref seeder);
        _assert_row_merge(
            0, B06, 0, B06,
            S2, 0, 0, 0, ref seeder);
        _assert_row_merge(
            B06, 0, 0, B06,
            S2, 0, 0, 0, ref seeder);
    }


    fn _assert_matrix_shift(mi: GameMatrix, mo: GameMatrix, dir: Direction, ref seeder: Seeder, prefix: ByteArray) {
        let mut m: GameMatrix = mi;
        let free: u8 = ForgeTrait::forge_direction(ref m, dir, false, ref seeder);
        assert_eq!(m.b_1_1, mo.b_1_1, "_assert_matrix_shift[{}]", prefix);
        assert_eq!(m.b_1_2, mo.b_1_2, "_assert_matrix_shift[{}]", prefix);
        assert_eq!(m.b_1_3, mo.b_1_3, "_assert_matrix_shift[{}]", prefix);
        assert_eq!(m.b_1_4, mo.b_1_4, "_assert_matrix_shift[{}]", prefix);
        assert_eq!(m.b_2_1, mo.b_2_1, "_assert_matrix_shift[{}]", prefix);
        assert_eq!(m.b_2_2, mo.b_2_2, "_assert_matrix_shift[{}]", prefix);
        assert_eq!(m.b_2_3, mo.b_2_3, "_assert_matrix_shift[{}]", prefix);
        assert_eq!(m.b_2_4, mo.b_2_4, "_assert_matrix_shift[{}]", prefix);
        assert_eq!(m.b_3_1, mo.b_3_1, "_assert_matrix_shift[{}]", prefix);
        assert_eq!(m.b_3_2, mo.b_3_2, "_assert_matrix_shift[{}]", prefix);
        assert_eq!(m.b_3_3, mo.b_3_3, "_assert_matrix_shift[{}]", prefix);
        assert_eq!(m.b_3_4, mo.b_3_4, "_assert_matrix_shift[{}]", prefix);
        assert_eq!(m.b_4_1, mo.b_4_1, "_assert_matrix_shift[{}]", prefix);
        assert_eq!(m.b_4_2, mo.b_4_2, "_assert_matrix_shift[{}]", prefix);
        assert_eq!(m.b_4_3, mo.b_4_3, "_assert_matrix_shift[{}]", prefix);
        assert_eq!(m.b_4_4, mo.b_4_4, "_assert_matrix_shift[{}]", prefix);
        let ff: u8 = _count_free_matrix(m);
        assert_eq!(free, ff, "_assert_matrix_shift[{}] free", prefix);
    }

    fn _assert_matrix_merge(mi: GameMatrix, to: GameMatrix, dir: Direction, ref seeder: Seeder, prefix: ByteArray) -> GameMatrix {
        let mut m: GameMatrix = mi;
        let free: u8 = ForgeTrait::forge_direction(ref m, dir, false, ref seeder);
        assert_eq!(BeastTrait::to_tier_shiny(m.b_1_1), to.b_1_1, "_assert_matrix_merge[{}] ({})", prefix, m.b_1_1);
        assert_eq!(BeastTrait::to_tier_shiny(m.b_1_2), to.b_1_2, "_assert_matrix_merge[{}] ({})", prefix, m.b_1_2);
        assert_eq!(BeastTrait::to_tier_shiny(m.b_1_3), to.b_1_3, "_assert_matrix_merge[{}] ({})", prefix, m.b_1_3);
        assert_eq!(BeastTrait::to_tier_shiny(m.b_1_4), to.b_1_4, "_assert_matrix_merge[{}] ({})", prefix, m.b_1_4);
        assert_eq!(BeastTrait::to_tier_shiny(m.b_2_1), to.b_2_1, "_assert_matrix_merge[{}] ({})", prefix, m.b_2_1);
        assert_eq!(BeastTrait::to_tier_shiny(m.b_2_2), to.b_2_2, "_assert_matrix_merge[{}] ({})", prefix, m.b_2_2);
        assert_eq!(BeastTrait::to_tier_shiny(m.b_2_3), to.b_2_3, "_assert_matrix_merge[{}] ({})", prefix, m.b_2_3);
        assert_eq!(BeastTrait::to_tier_shiny(m.b_2_4), to.b_2_4, "_assert_matrix_merge[{}] ({})", prefix, m.b_2_4);
        assert_eq!(BeastTrait::to_tier_shiny(m.b_3_1), to.b_3_1, "_assert_matrix_merge[{}] ({})", prefix, m.b_3_1);
        assert_eq!(BeastTrait::to_tier_shiny(m.b_3_2), to.b_3_2, "_assert_matrix_merge[{}] ({})", prefix, m.b_3_2);
        assert_eq!(BeastTrait::to_tier_shiny(m.b_3_3), to.b_3_3, "_assert_matrix_merge[{}] ({})", prefix, m.b_3_3);
        assert_eq!(BeastTrait::to_tier_shiny(m.b_3_4), to.b_3_4, "_assert_matrix_merge[{}] ({})", prefix, m.b_3_4);
        assert_eq!(BeastTrait::to_tier_shiny(m.b_4_1), to.b_4_1, "_assert_matrix_merge[{}] ({})", prefix, m.b_4_1);
        assert_eq!(BeastTrait::to_tier_shiny(m.b_4_2), to.b_4_2, "_assert_matrix_merge[{}] ({})", prefix, m.b_4_2);
        assert_eq!(BeastTrait::to_tier_shiny(m.b_4_3), to.b_4_3, "_assert_matrix_merge[{}] ({})", prefix, m.b_4_3);
        assert_eq!(BeastTrait::to_tier_shiny(m.b_4_4), to.b_4_4, "_assert_matrix_merge[{}] ({})", prefix, m.b_4_4);
        let ff: u8 = _count_free_matrix(m);
        assert_eq!(free, ff, "_assert_matrix_merge[{}] free", prefix);
        (m)
    }

    #[test]
    fn test_forge_direction_shift() {
        let mut seeder: Seeder = Seeder {
            seed: 0x05fa5438c7ccbcbae63ec200779acf8b71f34f432e9f0e7adec7a74230850c6b,
            current: 0,
        };
        let m: GameMatrix = GameMatrix {
            b_1_1: B01, b_1_2: B06, b_1_3: 0, b_1_4: 0,
            b_2_1: B11, b_2_2: B26, b_2_3: 0, b_2_4: 0,
            b_3_1: 0, b_3_2: 0, b_3_3: 0, b_3_4: 0,
            b_4_1: 0, b_4_2: 0, b_4_3: 0, b_4_4: 0,
        };
        // >> RIGHT
        let m_right: GameMatrix = GameMatrix {
            b_1_1: 0, b_1_2: 0, b_1_3: B01, b_1_4: B06,
            b_2_1: 0, b_2_2: 0, b_2_3: B11, b_2_4: B26,
            b_3_1: 0, b_3_2: 0, b_3_3: 0, b_3_4: 0,
            b_4_1: 0, b_4_2: 0, b_4_3: 0, b_4_4: 0,
        };
        let m_down: GameMatrix = GameMatrix {
            b_1_1: 0, b_1_2: 0, b_1_3: 0, b_1_4: 0,
            b_2_1: 0, b_2_2: 0, b_2_3: 0, b_2_4: 0,
            b_3_1: 0, b_3_2: 0, b_3_3: B01, b_3_4: B06,
            b_4_1: 0, b_4_2: 0, b_4_3: B11, b_4_4: B26,
        };
        let m_left: GameMatrix = GameMatrix {
            b_1_1: 0, b_1_2: 0, b_1_3: 0, b_1_4: 0,
            b_2_1: 0, b_2_2: 0, b_2_3: 0, b_2_4: 0,
            b_3_1: B01, b_3_2: B06, b_3_3: 0, b_3_4: 0,
            b_4_1: B11, b_4_2: B26, b_4_3: 0, b_4_4: 0,
        };
        _assert_matrix_shift(m, m_right, Direction::Right, ref seeder, "RIGHT");
        _assert_matrix_shift(m_right, m_down, Direction::Down, ref seeder, "DOWN");
        _assert_matrix_shift(m_down, m_left, Direction::Left, ref seeder, "LEFT");
        _assert_matrix_shift(m_left, m, Direction::Up, ref seeder, "UP");
    }

    #[test]
    fn test_forge_direction_merge() {
        let mut seeder: Seeder = Seeder {
            // seed: 0x05fa5438c7ccbcbae63ec200779acf8b71f34f432e9f0e7adec7a74230850c6b,
            seed: 0x127fd5f1fe78a71f8bcd1fec63e3fe2f0486b6ecd5c86a0466c3a21fa5cfc,
            current: 0,
        };
        let m: GameMatrix = GameMatrix {
            b_1_1: B21, b_1_2: B22, b_1_3: B21, b_1_4: B22,
            b_2_1: B21, b_2_2: B22, b_2_3: B21, b_2_4: B22,
            b_3_1: B21, b_3_2: B22, b_3_3: B21, b_3_4: B22,
            b_4_1: B21, b_4_2: B22, b_4_3: B21, b_4_4: B22,
        };
        // >> RIGHT
        let mut m_right: GameMatrix = GameMatrix {
            b_1_1: 0, b_1_2: 0, b_1_3: T4, b_1_4: T4,
            b_2_1: 0, b_2_2: 0, b_2_3: T4, b_2_4: T4,
            b_3_1: 0, b_3_2: 0, b_3_3: T4, b_3_4: T4,
            b_4_1: 0, b_4_2: 0, b_4_3: T4, b_4_4: T4,
        };
        let mut m_down: GameMatrix = GameMatrix {
            b_1_1: 0, b_1_2: 0, b_1_3: 0, b_1_4: 0,
            b_2_1: 0, b_2_2: 0, b_2_3: 0, b_2_4: 0,
            b_3_1: 0, b_3_2: 0, b_3_3: T3, b_3_4: T3,
            b_4_1: 0, b_4_2: 0, b_4_3: T3, b_4_4: T3,
        };
        let mut m_left: GameMatrix = GameMatrix {
            b_1_1: 0, b_1_2: 0, b_1_3: 0, b_1_4: 0,
            b_2_1: 0, b_2_2: 0, b_2_3: 0, b_2_4: 0,
            b_3_1: T2, b_3_2: 0, b_3_3: 0, b_3_4: 0,
            b_4_1: T2, b_4_2: 0, b_4_3: 0, b_4_4: 0,
        };
        let mut m_up: GameMatrix = GameMatrix {
            b_1_1: T1, b_1_2: 0, b_1_3: 0, b_1_4: 0,
            b_2_1: 0, b_2_2: 0, b_2_3: 0, b_2_4: 0,
            b_3_1: 0, b_3_2: 0, b_3_3: 0, b_3_4: 0,
            b_4_1: 0, b_4_2: 0, b_4_3: 0, b_4_4: 0,
        };
        m_right = _assert_matrix_merge(m, m_right, Direction::Right, ref seeder, "RIGHT");
        m_down = _assert_matrix_merge(m_right, m_down, Direction::Down, ref seeder, "DOWN");
        m_left = _assert_matrix_merge(m_down, m_left, Direction::Left, ref seeder, "LEFT");
        m_up = _assert_matrix_merge(m_left, m_up, Direction::Up, ref seeder, "UP");
    }


    #[test]
    fn test_forge_direction_spawn() {
        let mut seeder: Seeder = Seeder {
            seed: 0x127fd5f1fe78a71f8bcd1fec63e3fe2f0486b6ecd5c86a0466c3a21fa5cfc,
            current: 0,
        };
        //
        // Up -- fill bottom
        let mut m: GameMatrix = GameMatrix {
            b_1_1: B11, b_1_2: B02, b_1_3: B11, b_1_4: B02,
            b_2_1: B02, b_2_2: B11, b_2_3: B02, b_2_4: B11,
            b_3_1: B11, b_3_2: B02, b_3_3: B11, b_3_4: B02,
            b_4_1: 0, b_4_2: 0, b_4_3: 0, b_4_4: 0,
            // b_4_1: B02, b_4_2: B11, b_4_3: B02, b_4_4: B11,
        };
        assert_eq!(_count_free_matrix(m), 4, "Up");
        ForgeTrait::forge_direction(ref m, Direction::Up, true, ref seeder);
        assert_eq!(_count_free_matrix(m), 3, "Up");
        ForgeTrait::forge_direction(ref m, Direction::Up, true, ref seeder);
        assert_eq!(_count_free_matrix(m), 2, "Up");
        ForgeTrait::forge_direction(ref m, Direction::Up, true, ref seeder);
        assert_eq!(_count_free_matrix(m), 1, "Up");
        ForgeTrait::forge_direction(ref m, Direction::Up, true, ref seeder);
// _print_matrix(m, "Up");
        assert_eq!(_count_free_matrix(m), 0, "Up");
        //
        // Down -- fill top
        let mut m: GameMatrix = GameMatrix {
            // b_1_1: B11, b_1_2: B02, b_1_3: B11, b_1_4: B02,
            b_1_1: 0, b_1_2: 0, b_1_3: 0, b_1_4: 0,
            b_2_1: B02, b_2_2: B11, b_2_3: B02, b_2_4: B11,
            b_3_1: B11, b_3_2: B02, b_3_3: B11, b_3_4: B02,
            b_4_1: B02, b_4_2: B11, b_4_3: B02, b_4_4: B11,
        };
        seeder.rehash(); // boost RNG
        assert_eq!(_count_free_matrix(m), 4, "Down");
        ForgeTrait::forge_direction(ref m, Direction::Down, true, ref seeder);
        assert_eq!(_count_free_matrix(m), 3, "Down");
        ForgeTrait::forge_direction(ref m, Direction::Down, true, ref seeder);
        assert_eq!(_count_free_matrix(m), 2, "Down");
        ForgeTrait::forge_direction(ref m, Direction::Down, true, ref seeder);
        assert_eq!(_count_free_matrix(m), 1, "Down");
        ForgeTrait::forge_direction(ref m, Direction::Down, true, ref seeder);
// _print_matrix(m, "Down");
        assert_eq!(_count_free_matrix(m), 0, "Down");
        //
        // Right -- fill left
        let mut m: GameMatrix = GameMatrix {
            b_1_1: 0, b_1_2: B02, b_1_3: B11, b_1_4: B02,
            b_2_1: 0, b_2_2: B11, b_2_3: B02, b_2_4: B11,
            b_3_1: 0, b_3_2: B02, b_3_3: B11, b_3_4: B02,
            b_4_1: 0, b_4_2: B11, b_4_3: B02, b_4_4: B11,
        };
        seeder.rehash(); // boost RNG
        assert_eq!(_count_free_matrix(m), 4, "Right");
        ForgeTrait::forge_direction(ref m, Direction::Right, true, ref seeder);
        assert_eq!(_count_free_matrix(m), 3, "Right");
        ForgeTrait::forge_direction(ref m, Direction::Right, true, ref seeder);
        assert_eq!(_count_free_matrix(m), 2, "Right");
        ForgeTrait::forge_direction(ref m, Direction::Right, true, ref seeder);
        assert_eq!(_count_free_matrix(m), 1, "Right");
        ForgeTrait::forge_direction(ref m, Direction::Right, true, ref seeder);
// _print_matrix(m, "Right");
        assert_eq!(_count_free_matrix(m), 0, "Right");
        //
        // Left -- fill right
        let mut m: GameMatrix = GameMatrix {
            b_1_1: B11, b_1_2: B02, b_1_3: B11, b_1_4: 0,
            b_2_1: B02, b_2_2: B11, b_2_3: B02, b_2_4: 0,
            b_3_1: B11, b_3_2: B02, b_3_3: B11, b_3_4: 0,
            b_4_1: B02, b_4_2: B11, b_4_3: B02, b_4_4: 0,
        };
        seeder.rehash(); // boost RNG
        assert_eq!(_count_free_matrix(m), 4, "Left");
        ForgeTrait::forge_direction(ref m, Direction::Left, true, ref seeder);
        assert_eq!(_count_free_matrix(m), 3, "Left");
        ForgeTrait::forge_direction(ref m, Direction::Left, true, ref seeder);
        assert_eq!(_count_free_matrix(m), 2, "Left");
        ForgeTrait::forge_direction(ref m, Direction::Left, true, ref seeder);
        assert_eq!(_count_free_matrix(m), 1, "Left");
        ForgeTrait::forge_direction(ref m, Direction::Left, true, ref seeder);
// _print_matrix(m, "Left");
        assert_eq!(_count_free_matrix(m), 0, "Left");
    }


    #[test]
    #[ignore]
    fn test_forge_direction_spawn_simulate() {
        let mut seeder: Seeder = Seeder {
            seed: 0x127fd5f1fe78a71f8bcd1fec63e3fe2f0486b6ecd5c86a0466c3a21fa5cfc,
            current: 0,
        };
        let mut m: GameMatrix = GameMatrix {
            b_1_1: B11, b_1_2: 0, b_1_3: 0, b_1_4: 0,
            b_2_1: B02, b_2_2: 0, b_2_3: 0, b_2_4: 0,
            b_3_1: B11, b_3_2: 0, b_3_3: 0, b_3_4: 0,
            b_4_1: B02, b_4_2: 0, b_4_3: 0, b_4_4: 0,
        };
        seeder.rehash(); // boost RNG
_print_matrix(m, "Left");
        ForgeTrait::forge_direction(ref m, Direction::Left, true, ref seeder);
_print_matrix(m, "Left");
        ForgeTrait::forge_direction(ref m, Direction::Left, true, ref seeder);
_print_matrix(m, "Left");
        ForgeTrait::forge_direction(ref m, Direction::Left, true, ref seeder);
_print_matrix(m, "Left");
        ForgeTrait::forge_direction(ref m, Direction::Left, true, ref seeder);
_print_matrix(m, "Left");
        ForgeTrait::forge_direction(ref m, Direction::Left, true, ref seeder);
_print_matrix(m, "Left");
        ForgeTrait::forge_direction(ref m, Direction::Left, true, ref seeder);
_print_matrix(m, "Left");
        ForgeTrait::forge_direction(ref m, Direction::Left, true, ref seeder);
_print_matrix(m, "Left");
        ForgeTrait::forge_direction(ref m, Direction::Left, true, ref seeder);
    }

    fn _print_matrix(m: GameMatrix, prefix: ByteArray) {
        println!("-------:");
        println!("[{}][0]: {} {} {} {}", prefix, m.b_1_1, m.b_1_2, m.b_1_3, m.b_1_4);
        println!("[{}][1]: {} {} {} {}", prefix, m.b_2_1, m.b_2_2, m.b_2_3, m.b_2_4);
        println!("[{}][2]: {} {} {} {}", prefix, m.b_3_1, m.b_3_2, m.b_3_3, m.b_3_4);
        println!("[{}][3]: {} {} {} {}", prefix, m.b_4_1, m.b_4_2, m.b_4_3, m.b_4_4);
    }

}
