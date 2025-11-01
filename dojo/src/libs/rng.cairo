
#[derive(Copy, Drop, Serde)]
pub struct Seeder {
    pub seed: felt252,
    pub current: u128,
}

//---------------------------------------
// Traits
//

#[generate_trait]
pub impl SeederImpl of SeederTrait {
    fn new(seed: felt252, token_id: u128) -> Seeder {
        (Seeder {
            seed,
            current: 0,
        })
    }
    fn get_next_u8(ref self: Seeder, max_exclusive: u8) -> u8 {
        ((self._next(max_exclusive.into(), 0xff, 0x100)).try_into().unwrap())
    }
    #[inline(always)]
    fn _next(ref self: Seeder, max_exclusive: usize, mask: u128, shift: u128) -> u128 {
        self._recycle(shift);
        let result: u128 = ((self.current & mask) % max_exclusive.into());
        (result)
    }
    fn _recycle(ref self: Seeder, shift: u128) {
        if (self.current == 0) {
            // first time
            let s256: u256 = self.seed.into();
            self.current = s256.low;
        } else {
            // shift current value...
            self.current = self.current / shift;
            assert(self.current > 0, 'RNG is empty!');
        }
    }
}



//----------------------------
// tests
//
#[cfg(test)]
mod unit {
    use super::*;

    #[test]
    fn test_seeder() {
        let seed: felt252 = 0x88030201;
        let mut seeder: Seeder = SeederTrait::new(seed, 1);
        let value: u8 = seeder.get_next_u8(0xff);
        assert_eq!(value, 0x01, "seeder.get_next_u8()");
        assert_eq!(seeder.seed, seed, "seeder.seed");
        assert_eq!(seeder.current, 0x88030201, "seeder.current");
        let value: u8 = seeder.get_next_u8(0xff);
        assert_eq!(value, 0x02, "seeder.get_next_u8()");
        assert_eq!(seeder.seed, seed, "seeder.seed");
        assert_eq!(seeder.current, 0x880302, "seeder.current");
        let value: u8 = seeder.get_next_u8(0xff);
        assert_eq!(value, 0x03, "seeder.get_next_u8()");
        assert_eq!(seeder.seed, seed, "seeder.seed");
        assert_eq!(seeder.current, 0x8803, "seeder.current");
        let value: u8 = seeder.get_next_u8(0xff);
        assert_eq!(value, 0x88, "seeder.get_next_u8()");
        assert_eq!(seeder.seed, seed, "seeder.seed");
        assert_eq!(seeder.current, 0x88, "seeder.current");
    }
}
