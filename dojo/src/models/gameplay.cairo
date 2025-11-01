use feral::libs::beasts::{BeastTrait};
use feral::libs::rng::{Seeder};

#[derive(Copy, Drop, Serde, Debug, Default)]
pub enum Direction {
    #[default]
    None,   // 0
    Right,  // 1
    Left,   // 2
    Down,   // 3
    Up,     // 4
}

#[derive(Copy, Drop, Serde, Debug, Default)]
pub struct CoreMatrix {
    pub m_1_1: u8, pub m_1_2: u8, pub m_1_3: u8, pub m_1_4: u8,
    pub m_2_1: u8, pub m_2_2: u8, pub m_2_3: u8, pub m_2_4: u8,
    pub m_3_1: u8, pub m_3_2: u8, pub m_3_3: u8, pub m_3_4: u8,
    pub m_4_1: u8, pub m_4_2: u8, pub m_4_3: u8, pub m_4_4: u8,
}

#[generate_trait]
impl GameplayImpl of GameplayTrait {
    fn process_matrix(ref self: CoreMatrix, dir: Direction, ref seeder: Seeder) {
        match dir {
            Direction::Right => {
                Self::_process_row(ref self.m_1_1, ref self.m_1_2, ref self.m_1_3, ref self.m_1_4, ref seeder);
                Self::_process_row(ref self.m_2_1, ref self.m_2_2, ref self.m_2_3, ref self.m_2_4, ref seeder);
                Self::_process_row(ref self.m_3_1, ref self.m_3_2, ref self.m_3_3, ref self.m_3_4, ref seeder);
                Self::_process_row(ref self.m_4_1, ref self.m_4_2, ref self.m_4_3, ref self.m_4_4, ref seeder);
            },
            Direction::Left => {
                Self::_process_row(ref self.m_1_4, ref self.m_1_3, ref self.m_1_2, ref self.m_1_1, ref seeder);
                Self::_process_row(ref self.m_2_4, ref self.m_2_3, ref self.m_2_2, ref self.m_2_1, ref seeder);
                Self::_process_row(ref self.m_3_4, ref self.m_3_3, ref self.m_3_2, ref self.m_3_1, ref seeder);
                Self::_process_row(ref self.m_4_4, ref self.m_4_3, ref self.m_4_2, ref self.m_4_1, ref seeder);
            },
            Direction::Down => {
                Self::_process_row(ref self.m_1_1, ref self.m_2_1, ref self.m_3_1, ref self.m_4_1, ref seeder);
                Self::_process_row(ref self.m_1_2, ref self.m_2_2, ref self.m_3_2, ref self.m_4_2, ref seeder);
                Self::_process_row(ref self.m_1_3, ref self.m_2_3, ref self.m_3_3, ref self.m_4_3, ref seeder);
                Self::_process_row(ref self.m_1_4, ref self.m_2_4, ref self.m_3_4, ref self.m_4_4, ref seeder);
            },
            Direction::Up => {
                Self::_process_row(ref self.m_4_1, ref self.m_3_1, ref self.m_2_1, ref self.m_1_1, ref seeder);
                Self::_process_row(ref self.m_4_2, ref self.m_3_2, ref self.m_2_2, ref self.m_1_2, ref seeder);
                Self::_process_row(ref self.m_4_3, ref self.m_3_3, ref self.m_2_3, ref self.m_1_3, ref seeder);
                Self::_process_row(ref self.m_4_4, ref self.m_3_4, ref self.m_2_4, ref self.m_1_4, ref seeder);
            },
            Direction::None => {},
        }
    }
    fn _process_row(ref v_0: u8, ref v_1: u8, ref v_2: u8, ref v_3: u8, ref seeder: Seeder) {
        // let mut p: u8 = 0;
        // let mut t: u8 = 0;
        // for s in 0..3 {
        // }
    }
    // for a pair(v_0, v_1), returns the new pair and space count (r_0, r_1, spaces)
    fn _process_pair(v_0: u8, v_1: u8, ref seeder: Seeder) -> (u8, u8, u8) {
        if (v_0 == 0 && v_1 == 0) {
            (0, 0, 2)
        } else if (v_0 == 0) {
            (v_1, 0, 1)
        } else if (v_1 == 0) {
            (v_0, 0, 1)
        } else if (v_0 == v_1) {
            if (BeastTrait::is_shiny(v_0)) {
                // already shiny, no changes
                (v_0, v_1, 0)
            } else {
                // >>> merge into a shiny
                (BeastTrait::to_shiny(v_0), 0, 1)
            }
        } else if (BeastTrait::is_shiny(v_0) || BeastTrait::is_shiny(v_1)) {
            // shiny is final, no changes
            (v_0, v_1, 0)
        } else {
            let t_0: u8 = BeastTrait::to_tier(v_0);
            if (t_0 > 1 && t_0 == BeastTrait::to_tier(v_1)) {
                // >>> merge to the next tier
                (BeastTrait::randomize_beast_of_tier(t_0 - 1, ref seeder), 0, 1)
            } else {
                // different tiers, no changes
                (v_0, v_1, 0)
            }
        }
    }
}




#[cfg(test)]
mod tests {
    use super::*;

    fn _assert_pair_same(i1: u8, i2: u8, o1: u8, o2: u8, ref seeder: Seeder) {
        let prefix: ByteArray = format!("({},{}) -> ({},{})", i1, i2, o1, o2);
        let (r1, r2, _): (u8, u8, u8) = GameplayTrait::_process_pair(i1, i2, ref seeder);
        assert_eq!(r1, o1, "_assert_pair_same[{}] r1", prefix);
        assert_eq!(r2, o2, "_assert_pair_same[{}] r2", prefix);
    }
    fn _assert_pair_tier(i1: u8, i2: u8, ot: u8, ref seeder: Seeder) {
        let prefix: ByteArray = format!("({},{}) -> ({})", i1, i2, ot);
        let (r1, r2, _): (u8, u8, u8) = GameplayTrait::_process_pair(i1, i2, ref seeder);
        let rt1: u8 = BeastTrait::to_tier(r1);
        assert_eq!(rt1, ot, "_assert_pair[{}] r1 {}", prefix, r1);
        assert_eq!(r2, 0, "_assert_pair[{}] r2 == 0", prefix);
    }
    
    #[test]
    fn test_process_pair() {
        let mut seeder: Seeder = Seeder {
            seed: 0x05fa5438c7ccbcbae63ec200779acf8b71f34f432e9f0e7adec7a74230850c6b,
            current: 0,
        };
        // no changes
        _assert_pair_same(0, 0, 0, 0, ref seeder);
        _assert_pair_same(0, 1, 1, 0, ref seeder);
        _assert_pair_same(1, 0, 1, 0, ref seeder);
        _assert_pair_same(1, 6, 1, 6, ref seeder);
        _assert_pair_same(6, 1, 6, 1, ref seeder);
        _assert_pair_same(1, 2, 1, 2, ref seeder); // T1
        _assert_pair_same(2, 1, 2, 1, ref seeder); // T1
        _assert_pair_same(25, 26, 25, 26, ref seeder); // T1
        _assert_pair_same(25, 25, 125, 0, ref seeder); // T1
        _assert_pair_same(101, 1, 101, 1, ref seeder);
        _assert_pair_same(1, 101, 1, 101, ref seeder);
        _assert_pair_same(101, 101, 101, 101, ref seeder);
        _assert_pair_same(101, 102, 101, 102, ref seeder);
        _assert_pair_same(102, 101, 102, 101, ref seeder);
        _assert_pair_same(1, 1, 101, 0, ref seeder);
        _assert_pair_same(6, 6, 106, 0, ref seeder);
        _assert_pair_same(11, 11, 111, 0, ref seeder);
        _assert_pair_same(16, 16, 116, 0, ref seeder);
        _assert_pair_same(21, 21, 121, 0, ref seeder);
        _assert_pair_same(26, 26, 126, 0, ref seeder);
        // upgrades...
        _assert_pair_tier(6, 7, 1, ref seeder); // T2
        _assert_pair_tier(6, 7, 1, ref seeder); // T2
        _assert_pair_tier(6, 31, 1, ref seeder); // T2
        _assert_pair_tier(31, 6, 1, ref seeder); // T2
        _assert_pair_tier(11, 12, 2, ref seeder); // T3
        _assert_pair_tier(12, 11, 2, ref seeder); // T3
        _assert_pair_tier(16, 17, 3, ref seeder); // T4
        _assert_pair_tier(17, 16, 3, ref seeder); // T4
        _assert_pair_tier(21, 22, 4, ref seeder); // T5
        _assert_pair_tier(22, 21, 4, ref seeder); // T5
        _assert_pair_tier(25, 75, 4, ref seeder); // T5
    }

}
