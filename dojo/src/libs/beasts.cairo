//
// from: 
// https://github.com/Provable-Games/summit/blob/3d1ebe8e07c31b74d8279b4b2090016b9fec39b2/client/src/utils/BeastData.ts
//

// pub enum Tier {
//     #[default]
//     None,   // 0
//     T5,     // 1
//     T4,     // 2
//     T3,     // 3
//     T2,     // 4
//     T1,     // 5
//     Shiny,  // 6
// }

// pub mod TYPE {
//     pub const UNKNOWN: felt252 = '';
//     pub const MAGIC: felt252 = 'Magic';
//     pub const HUNTER: felt252 = 'Hunter';
//     pub const BRUTE: felt252 = 'Brute';
// }

use feral::libs::rng::{Seeder, SeederTrait};

#[generate_trait]
pub impl BeastImpl of BeastTrait {
    #[inline(always)]
    fn exists(beast_id: u8) -> bool {
        (beast_id >= 1 && beast_id <= 75)
    }
    #[inline(always)]
    fn is_shiny(beast_id: u8) -> bool {
        (beast_id > 100) // assume it's a valid beast_id
    }
    #[inline(always)]
    fn to_shiny(beast_id: u8) -> u8 {
        (beast_id + 100) // assume it's a valid beast_id
    }
    #[inline(always)]
    fn randomize_beast_of_tier(tier: u8, ref seeder: Seeder) -> u8 {
        let r: u8 = seeder.get_next_u8(15);
// println!("___randomize_beast_of_tier:{} r:{}", tier, r);
        ((r % 5) + 1 + ((r / 5) * 25) + ((tier - 1) * 5))
    }
    fn to_tier(beast_id: u8) -> u8 {
        if (Self::exists(beast_id)) {
            ((((beast_id - 1) / 5) % 5) + 1)
        } else {
            (0)
        }
    }
    fn _to_tier_match(beast_id: u8) -> u8 {
        match beast_id {
            0 => (0),
            1  | 2  | 3  | 4  | 5  | 26 | 27 | 28 | 29 | 30 | 51 | 52 | 53 | 54 | 55 => (1),
            6  | 7  | 8  | 9 |  10 | 31 | 32 | 33 | 34 | 35 | 56 | 57 | 58 | 59 | 60 => (2),
            11 | 12 | 13 | 14 | 15 | 36 | 37 | 38 | 39 | 40 | 61 | 62 | 63 | 64 | 65 => (3),
            16 | 17 | 18 | 19 | 20 | 41 | 42 | 43 | 44 | 45 | 66 | 67 | 68 | 69 | 70 => (4),
            21 | 22 | 23 | 24 | 25 | 46 | 47 | 48 | 49 | 50 | 71 | 72 | 73 | 74 | 75 => (5),
            _ => (0),
        }
    }
    // fn to_type(beast_id: u8) -> felt252 {
    //     if (beast_id >= 1 && beast_id <= 25) {TYPE::MAGIC}
    //     else if (beast_id >= 26 && beast_id <= 50) {TYPE::HUNTER}
    //     else if (beast_id >= 51 && beast_id <= 75) {TYPE::BRUTE}
    //     else {TYPE::UNKNOWN}
    // }
    // fn _to_type_match(beast_id: u8) -> felt252 {
    //     match beast_id {
    //         0 => TYPE::UNKNOWN,
    //         1 | 2 | 3 | 4 | 5 |6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 | 25 => TYPE::MAGIC,
    //         26 | 27 | 28 | 29 | 30 | 31 | 32 | 33 | 34 | 35 | 36 | 37 | 38 | 39 | 40 | 41 | 42 | 43 | 44 | 45 | 46 | 47 | 48 | 49 | 50 => TYPE::HUNTER,
    //         51 | 52 | 53 | 54 | 55 | 56 | 57 | 58 | 59 | 60 | 61 | 62 | 63 | 64 | 65 | 66 | 67 | 68 | 69 | 70 | 71 | 72 | 73 | 74 | 75 => TYPE::BRUTE,
    //         _ => TYPE::UNKNOWN,
    //     }
    // }
    fn to_name(beast_id: u8) -> felt252 {
        match beast_id {
            0 => '',
            1 => 'Warlock',
            2 => 'Typhon',
            3 => 'Jiangshi',
            4 => 'Anansi',
            5 => 'Basilisk',
            6 => 'Gorgon',
            7 => 'Kitsune',
            8 => 'Lich',
            9 => 'Chimera',
            10 => 'Wendigo',
            11 => 'Rakshasa',
            12 => 'Werewolf',
            13 => 'Banshee',
            14 => 'Draugr',
            15 => 'Vampire',
            16 => 'Goblin',
            17 => 'Ghoul',
            18 => 'Wraith',
            19 => 'Sprite',
            20 => 'Kappa',
            21 => 'Fairy',
            22 => 'Leprechaun',
            23 => 'Kelpie',
            24 => 'Pixie',
            25 => 'Gnome',
            26 => 'Griffin',
            27 => 'Manticore',
            28 => 'Phoenix',
            29 => 'Dragon',
            30 => 'Minotaur',
            31 => 'Qilin',
            32 => 'Ammit',
            33 => 'Nue',
            34 => 'Skinwalker',
            35 => 'Chupacabra',
            36 => 'Weretiger',
            37 => 'Wyvern',
            38 => 'Roc',
            39 => 'Harpy',
            40 => 'Pegasus',
            41 => 'Hippogriff',
            42 => 'Fenrir',
            43 => 'Jaguar',
            44 => 'Satori',
            45 => 'Direwolf',
            46 => 'Bear',
            47 => 'Wolf',
            48 => 'Mantis',
            49 => 'Spider',
            50 => 'Rat',
            51 => 'Kraken',
            52 => 'Colossus',
            53 => 'Balrog',
            54 => 'Leviathan',
            55 => 'Tarrasque',
            56 => 'Titan',
            57 => 'Nephilim',
            58 => 'Behemoth',
            59 => 'Hydra',
            60 => 'Juggernaut',
            61 => 'Oni',
            62 => 'Jotunn',
            63 => 'Ettin',
            64 => 'Cyclops',
            65 => 'Giant',
            66 => 'Nemeanlion',
            67 => 'Berserker',
            68 => 'Yeti',
            69 => 'Golem',
            70 => 'Ent',
            71 => 'Troll',
            72 => 'Bigfoot',
            73 => 'Ogre',
            74 => 'Orc',
            75 => 'Skeleton',
            _ => '',
        }
    }
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_beast_exists() {
        for i in 0_u8..255_u8 {
            assert_eq!(BeastTrait::exists(i), (i >= 1 && i <= 75));
        }
    }

    #[test]
    fn test_beast_to_tier() {
        for i in 0_u8..255_u8 {
            assert_eq!(BeastTrait::to_tier(i), BeastTrait::_to_tier_match(i), "beast:{}", i);
        }
    }

    #[test]
    fn test_randomize_beast_of_tier() {
        for t in 1_u8..6_u8 {
            for i in 0_u8..255_u8 {
                let mut seed: Seeder = Seeder {
                    seed: i.into(),
                    current: 0,
                };
                let beast: u8 = BeastTrait::randomize_beast_of_tier(t, ref seed);
                let tier: u8 = BeastTrait::to_tier(beast);
// println!(">>> T{} beast:{} tier:{}", t, beast, tier);
                assert_eq!(tier, t, "tier:{} beast:{} seed:{}", t, beast, i);
            }
        }
    }

}
