
#[derive(Copy, Drop, Serde)]
pub struct Seeder {
    pub seed: felt252,
    pub current: u256,
}

//---------------------------------------
// Traits
//
use feral::libs::{hash};

// #[generate_trait]
// pub impl SeedImpl of SeedTrait {
//     fn new(contract_address: ContractAddress, token_id: u128) -> Seed {
//         let seed: felt252 = hash::make_seed(contract_address, token_id);
//         (Seed { token_id, seed })
//     }
// }

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
        let result: u128 = ((self.current.low & mask) % max_exclusive.into());
        (result)
    }
    fn _recycle(ref self: Seeder, shift: u128) {
        if (self.current == 0) {
            // first time
            self.current = self.seed.into();
        } else {
            // shift current value...
            self.current.low = self.current.low / shift;
            // if less than 2 bytes, recycle
            if (self.current.low < 0x100) {
                if (self.current.high != 0) {
                    // use high part if available
                    self.current.low = self.current.high;
                    self.current.high = 0;
                } else {
                    // hash original seed for more values
                    self.seed = hash::hash_values([self.seed].span());
                    self.current = self.seed.into();
                }
            }
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
        let seed: felt252 = u256 {
            high: 0x302010,
            low: 0x030201,
        }.try_into().unwrap();
        let mut seeder: Seeder = SeederTrait::new(seed, 1);
        let value: u8 = seeder.get_next_u8(0xff);
        assert_eq!(value, 0x01, "seeder.get_next_u8()");
        assert_eq!(seeder.seed, seed, "seeder.seed");
        assert_eq!(seeder.current.high, 0x302010, "seeder.high");
        assert_eq!(seeder.current.low, 0x030201, "seeder.low");
        let value: u8 = seeder.get_next_u8(0xff);
        assert_eq!(value, 0x02, "seeder.get_next_u8()");
        assert_eq!(seeder.seed, seed, "seeder.seed");
        assert_eq!(seeder.current.high, 0x302010, "seeder.high");
        assert_eq!(seeder.current.low, 0x0302, "seeder.low");
        // let value: u8 = seeder.get_next_u8(0xff);
        // assert_eq!(value, 0x03, "seeder.get_next_u8()");
        // assert_eq!(seeder.seed, seed, "seeder.seed");
        // assert_eq!(seeder.current.high, 0x302010, "seeder.high");
        // assert_eq!(seeder.current.low, 0x03, "seeder.low");
        let value: u8 = seeder.get_next_u8(0xff);
        assert_eq!(value, 0x10, "seeder.get_next_u8()");
        assert_eq!(seeder.seed, seed, "seeder.seed");
        assert_eq!(seeder.current.high, 0, "seeder.high");
        assert_eq!(seeder.current.low, 0x302010, "seeder.low");
        let value: u8 = seeder.get_next_u8(0xff);
        assert_eq!(value, 0x20, "seeder.get_next_u8()");
        assert_eq!(seeder.seed, seed, "seeder.seed");
        assert_eq!(seeder.current.high, 0, "seeder.high");
        assert_eq!(seeder.current.low, 0x3020, "seeder.low");
        // let value: u8 = seeder.get_next_u8(0xff);
        // assert_eq!(value, 0x30, "seeder.get_next_u8()");
        // assert_eq!(seeder.seed, seed, "seeder.seed");
        // assert_eq!(seeder.current.high, 0, "seeder.high");
        // assert_eq!(seeder.current.low, 0x30, "seeder.low");
        // last value, will hash new seed
        let _value: u8 = seeder.get_next_u8(0xff);
        // assert_gt!(value, 0x0, "seeder.get_next_u16()");
        // assert_ne!(seeder.seed, seed, "seeder.seed");
        assert_gt!(seeder.current.high, 0xffffffffffffffff, "seeder.high");
        assert_gt!(seeder.current.low, 0xffffffffffffffff, "seeder.low");
    }
}
