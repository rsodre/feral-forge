//
// from: 
// https://github.com/Provable-Games/summit/blob/3d1ebe8e07c31b74d8279b4b2090016b9fec39b2/client/src/utils/BeastData.ts
//




#[generate_trait]
impl BeastImpl of BeastTrait {
    #[inline(always)]
    fn exists(beast_id: u8) -> bool {
        (beast_id >= 1 && beast_id <= 75)
    }
    fn to_tier(beast_id: u8) -> u8 {
        if (Self::exists(beast_id)) {
            ((((beast_id - 1) / 5) % 5) + 1)
        } else {
            (0)
        }
    }
    fn to_tier_match(beast_id: u8) -> u8 {
        match beast_id {
            0 => 0,
            1 | 2 | 3 | 4 | 5 |  26 | 27 | 28 | 29 | 30 | 51 | 52 | 53 | 54 | 55 => 1,
            6 | 7 | 8 | 9 | 10 | 31 | 32 | 33 | 34 | 35 | 56 | 57 | 58 | 59 | 60 => 2,
            11 | 12 | 13 | 14 | 15 | 36 | 37 | 38 | 39 | 40 | 61 | 62 | 63 | 64 | 65 => 3,
            16 | 17 | 18 | 19 | 20 | 41 | 42 | 43 | 44 | 45 | 66 | 67 | 68 | 69 | 70 => 4,
            21 | 22 | 23 | 24 | 25 | 46 | 47 | 48 | 49 | 50 | 71 | 72 | 73 | 74 | 75 => 5,
            _ => 0,
        }
    }
    fn to_type_match(beast_id: u8) -> felt252 {
        match beast_id {
            0 => '',
            1 | 2 | 3 | 4 | 5 |
            6 | 7 | 8 | 9 | 10 | 
            11 | 12 | 13 | 14 | 15 | 
            16 | 17 | 18 | 19 | 20 | 
            21 | 22 | 23 | 24 | 25 => 'Magic',
            26 | 27 | 28 | 29 | 30 |
            31 | 32 | 33 | 34 | 35 |
            36 | 37 | 38 | 39 | 40 |
            41 | 42 | 43 | 44 | 45 |
            46 | 47 | 48 | 49 | 50 => 'Hunter',
            51 | 52 | 53 | 54 | 55 |
            56 | 57 | 58 | 59 | 60 |
            61 | 62 | 63 | 64 | 65 |
            66 | 67 | 68 | 69 | 70 |
            71 | 72 | 73 | 74 | 75 => 'Brute',
            _ => '',
        }
    }
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
        assert!(!BeastTrait::exists(0));
        // from 1 to 75...
        assert!(BeastTrait::exists(1));
        assert!(BeastTrait::exists(2));
        assert!(BeastTrait::exists(3));
        //...
        assert!(BeastTrait::exists(73));
        assert!(BeastTrait::exists(74));
        assert!(BeastTrait::exists(75));
        // invalid from here on...
        assert!(!BeastTrait::exists(76));
        assert!(!BeastTrait::exists(100));
        assert!(!BeastTrait::exists(255));
    }

    #[test]
    fn test_beast_to_tier() {
        assert_eq!(BeastTrait::to_tier(0), BeastTrait::to_tier_match(0));
        // Tier 1
        assert_eq!(BeastTrait::to_tier(1), BeastTrait::to_tier_match(1));
        assert_eq!(BeastTrait::to_tier(2), BeastTrait::to_tier_match(2));
        assert_eq!(BeastTrait::to_tier(3), BeastTrait::to_tier_match(3));
        assert_eq!(BeastTrait::to_tier(4), BeastTrait::to_tier_match(4));
        assert_eq!(BeastTrait::to_tier(5), BeastTrait::to_tier_match(5));
        // Tier 2
        assert_eq!(BeastTrait::to_tier(6), BeastTrait::to_tier_match(6));
        assert_eq!(BeastTrait::to_tier(7), BeastTrait::to_tier_match(7));
        assert_eq!(BeastTrait::to_tier(8), BeastTrait::to_tier_match(8));
        assert_eq!(BeastTrait::to_tier(9), BeastTrait::to_tier_match(9));
        assert_eq!(BeastTrait::to_tier(10), BeastTrait::to_tier_match(10));
        // Tier 3
        assert_eq!(BeastTrait::to_tier(11), BeastTrait::to_tier_match(11));
        assert_eq!(BeastTrait::to_tier(12), BeastTrait::to_tier_match(12));
        assert_eq!(BeastTrait::to_tier(13), BeastTrait::to_tier_match(13));
        assert_eq!(BeastTrait::to_tier(14), BeastTrait::to_tier_match(14));
        assert_eq!(BeastTrait::to_tier(15), BeastTrait::to_tier_match(15));
        // Tier 4
        assert_eq!(BeastTrait::to_tier(16), BeastTrait::to_tier_match(16));
        assert_eq!(BeastTrait::to_tier(17), BeastTrait::to_tier_match(17));
        assert_eq!(BeastTrait::to_tier(18), BeastTrait::to_tier_match(18));
        assert_eq!(BeastTrait::to_tier(19), BeastTrait::to_tier_match(19));
        assert_eq!(BeastTrait::to_tier(20), BeastTrait::to_tier_match(20));
        // Tier 5
        assert_eq!(BeastTrait::to_tier(21), BeastTrait::to_tier_match(21));
        assert_eq!(BeastTrait::to_tier(22), BeastTrait::to_tier_match(22));
        assert_eq!(BeastTrait::to_tier(23), BeastTrait::to_tier_match(23));
        assert_eq!(BeastTrait::to_tier(24), BeastTrait::to_tier_match(24));
        assert_eq!(BeastTrait::to_tier(25), BeastTrait::to_tier_match(25));
        // Tier 1
        assert_eq!(BeastTrait::to_tier(26), BeastTrait::to_tier_match(26));
        assert_eq!(BeastTrait::to_tier(27), BeastTrait::to_tier_match(27));
        assert_eq!(BeastTrait::to_tier(28), BeastTrait::to_tier_match(28));
        assert_eq!(BeastTrait::to_tier(29), BeastTrait::to_tier_match(29));
        assert_eq!(BeastTrait::to_tier(30), BeastTrait::to_tier_match(30));
        // Tier 2
        assert_eq!(BeastTrait::to_tier(31), BeastTrait::to_tier_match(31));
        assert_eq!(BeastTrait::to_tier(32), BeastTrait::to_tier_match(32));
        assert_eq!(BeastTrait::to_tier(33), BeastTrait::to_tier_match(33));
        assert_eq!(BeastTrait::to_tier(34), BeastTrait::to_tier_match(34));
        assert_eq!(BeastTrait::to_tier(35), BeastTrait::to_tier_match(35));
        // Tier 3
        assert_eq!(BeastTrait::to_tier(36), BeastTrait::to_tier_match(36));
        assert_eq!(BeastTrait::to_tier(37), BeastTrait::to_tier_match(37));
        assert_eq!(BeastTrait::to_tier(38), BeastTrait::to_tier_match(38));
        assert_eq!(BeastTrait::to_tier(39), BeastTrait::to_tier_match(39));
        assert_eq!(BeastTrait::to_tier(40), BeastTrait::to_tier_match(40));
        // Tier 4
        assert_eq!(BeastTrait::to_tier(41), BeastTrait::to_tier_match(41));
        assert_eq!(BeastTrait::to_tier(42), BeastTrait::to_tier_match(42));
        assert_eq!(BeastTrait::to_tier(43), BeastTrait::to_tier_match(43));
        assert_eq!(BeastTrait::to_tier(44), BeastTrait::to_tier_match(44));
        assert_eq!(BeastTrait::to_tier(45), BeastTrait::to_tier_match(45));
        // Tier 5
        assert_eq!(BeastTrait::to_tier(46), BeastTrait::to_tier_match(46));
        assert_eq!(BeastTrait::to_tier(47), BeastTrait::to_tier_match(47));
        assert_eq!(BeastTrait::to_tier(48), BeastTrait::to_tier_match(48));
        assert_eq!(BeastTrait::to_tier(49), BeastTrait::to_tier_match(49));
        assert_eq!(BeastTrait::to_tier(50), BeastTrait::to_tier_match(50));
        // Tier 1
        assert_eq!(BeastTrait::to_tier(51), BeastTrait::to_tier_match(51));
        assert_eq!(BeastTrait::to_tier(52), BeastTrait::to_tier_match(52));
        assert_eq!(BeastTrait::to_tier(53), BeastTrait::to_tier_match(53));
        assert_eq!(BeastTrait::to_tier(54), BeastTrait::to_tier_match(54));
        assert_eq!(BeastTrait::to_tier(55), BeastTrait::to_tier_match(55));
        // Tier 2
        assert_eq!(BeastTrait::to_tier(56), BeastTrait::to_tier_match(56));
        assert_eq!(BeastTrait::to_tier(57), BeastTrait::to_tier_match(57));
        assert_eq!(BeastTrait::to_tier(58), BeastTrait::to_tier_match(58));
        assert_eq!(BeastTrait::to_tier(59), BeastTrait::to_tier_match(59));
        assert_eq!(BeastTrait::to_tier(60), BeastTrait::to_tier_match(60));
        // Tier 3
        assert_eq!(BeastTrait::to_tier(61), BeastTrait::to_tier_match(61));
        assert_eq!(BeastTrait::to_tier(62), BeastTrait::to_tier_match(62));
        assert_eq!(BeastTrait::to_tier(63), BeastTrait::to_tier_match(63));
        assert_eq!(BeastTrait::to_tier(64), BeastTrait::to_tier_match(64));
        assert_eq!(BeastTrait::to_tier(65), BeastTrait::to_tier_match(65));
        // Tier 4
        assert_eq!(BeastTrait::to_tier(66), BeastTrait::to_tier_match(66));
        assert_eq!(BeastTrait::to_tier(67), BeastTrait::to_tier_match(67));
        assert_eq!(BeastTrait::to_tier(68), BeastTrait::to_tier_match(68));
        assert_eq!(BeastTrait::to_tier(69), BeastTrait::to_tier_match(69));
        assert_eq!(BeastTrait::to_tier(70), BeastTrait::to_tier_match(70));
        // Tier 5
        assert_eq!(BeastTrait::to_tier(71), BeastTrait::to_tier_match(71));
        assert_eq!(BeastTrait::to_tier(72), BeastTrait::to_tier_match(72));
        assert_eq!(BeastTrait::to_tier(73), BeastTrait::to_tier_match(73));
        assert_eq!(BeastTrait::to_tier(74), BeastTrait::to_tier_match(74));
        assert_eq!(BeastTrait::to_tier(75), BeastTrait::to_tier_match(75));
        // invalid from here on...
        assert_eq!(BeastTrait::to_tier(76), BeastTrait::to_tier_match(76));
    }


}
