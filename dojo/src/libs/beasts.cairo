use super::constants::TIER::T2;
use feral::libs::rng::{Seeder, SeederTrait};
use feral::libs::constants::{BEAST_NAME, TIER::*};

//
// from: 
// https://github.com/Provable-Games/summit/blob/3d1ebe8e07c31b74d8279b4b2090016b9fec39b2/client/src/utils/BeastData.ts
//

#[generate_trait]
pub impl BeastImpl of BeastTrait {
    #[inline(always)]
    fn is_beast(beast_id: u8) -> bool {
        (beast_id >= 1 && beast_id <= 75)
    }
    #[inline(always)]
    fn is_shiny(beast_id: u8) -> bool {
        (beast_id > 100) // assume it's a valid beast_id
    }
    #[inline(always)]
    fn to_shiny(beast_id: u8) -> u8 {
        (beast_id + 100) // assume it's a valid standard beast_id (1-75)
    }
    #[inline(always)]
    fn from_shiny(beast_id: u8) -> u8 {
        (beast_id - 100) // assume it's a valid shiny beast_id (101-175)
    }
    #[inline(always)]
    fn randomize_beast_of_tier(tier: u8, ref seeder: Seeder) -> u8 {
        let r: u8 = seeder.get_next_u8(15);
        let bhm: u8 = ((r / 5) * 25);   // type
        let t: u8 = ((tier - 1) * 5);   // tier offset
        let i: u8 = ((r % 5) + 1);      // index
        let b: u8 = (bhm + t + i);
        (b)
    }

    fn get_score(self: u8) -> u16 {
        let tier: u8 = Self::to_tier_shiny(self);
        if      (tier == T5) {(1)}
        else if (tier == T4) {(3)}
        else if (tier == T3) {(10)}
        else if (tier == T2) {(30)}
        else if (tier == T1) {(100)}
        else if (tier == S5) {(50)}
        else if (tier == S4) {(100)}
        else if (tier == S3) {(150)}
        else if (tier == S2) {(200)}
        else if (tier == S1) {(250)}
        else {(0)}
    }

    //---------------------------------------
    // Beast Lore
    //
    // convert standard beasts to tier (T1-T5)
    fn to_tier(beast_id: u8) -> u8 {
        if (Self::is_beast(beast_id)) {
            ((((beast_id - 1) / 5) % 5) + 1)
        } else {
            (0)
        }
    }
    // convert standard and shiny beasts to tier (T1-T5, S1-S5)
    fn to_tier_shiny(beast_id: u8) -> u8 {
        if (Self::is_shiny(beast_id)) {
            (Self::to_shiny(Self::to_tier(Self::from_shiny(beast_id))))
        } else {
            (Self::to_tier(beast_id))
        }
    }
    fn _to_tier_match(beast_id: u8) -> u8 {
        match beast_id {
            0 => (0),
            1  | 2  | 3  | 4  | 5  | 26 | 27 | 28 | 29 | 30 | 51 | 52 | 53 | 54 | 55 => (T1),
            6  | 7  | 8  | 9 |  10 | 31 | 32 | 33 | 34 | 35 | 56 | 57 | 58 | 59 | 60 => (T2),
            11 | 12 | 13 | 14 | 15 | 36 | 37 | 38 | 39 | 40 | 61 | 62 | 63 | 64 | 65 => (T3),
            16 | 17 | 18 | 19 | 20 | 41 | 42 | 43 | 44 | 45 | 66 | 67 | 68 | 69 | 70 => (T4),
            21 | 22 | 23 | 24 | 25 | 46 | 47 | 48 | 49 | 50 | 71 | 72 | 73 | 74 | 75 => (T5),
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
            // Magical T1
            1 => BEAST_NAME::WARLOCK,
            2 => BEAST_NAME::TYPHON,
            3 => BEAST_NAME::JIANGSHI,
            4 => BEAST_NAME::ANANSI,
            5 => BEAST_NAME::BASILISK,
            // Magical T2
            6 => BEAST_NAME::GORGON,
            7 => BEAST_NAME::KITSUNE,
            8 => BEAST_NAME::LICH,
            9 => BEAST_NAME::CHIMERA,
            10 => BEAST_NAME::WENDIGO,
            // Magical T3
            11 => BEAST_NAME::RAKSHASA,
            12 => BEAST_NAME::WEREWOLF,
            13 => BEAST_NAME::BANSHEE,
            14 => BEAST_NAME::DRAUGR,
            15 => BEAST_NAME::VAMPIRE,
            // Magical T4
            16 => BEAST_NAME::GOBLIN,
            17 => BEAST_NAME::GHOUL,
            18 => BEAST_NAME::WRAITH,
            19 => BEAST_NAME::SPRITE,
            20 => BEAST_NAME::KAPPA,
            // Magical T5
            21 => BEAST_NAME::FAIRY,
            22 => BEAST_NAME::LEPRECHAUN,
            23 => BEAST_NAME::KELPIE,
            24 => BEAST_NAME::PIXIE,
            25 => BEAST_NAME::GNOME,
            // Hunter T1
            26 => BEAST_NAME::GRIFFIN,
            27 => BEAST_NAME::MANTICORE,
            28 => BEAST_NAME::PHOENIX,
            29 => BEAST_NAME::DRAGON,
            30 => BEAST_NAME::MINOTAUR,
            // Hunter T2
            31 => BEAST_NAME::QILIN,
            32 => BEAST_NAME::AMMIT,
            33 => BEAST_NAME::NUE,
            34 => BEAST_NAME::SKINWALKER,
            35 => BEAST_NAME::CHUPACABRA,
            // Hunter T3
            36 => BEAST_NAME::WERETIGER,
            37 => BEAST_NAME::WYVERN,
            38 => BEAST_NAME::ROC,
            39 => BEAST_NAME::HARPY,
            40 => BEAST_NAME::PEGASUS,
            // Hunter T4
            41 => BEAST_NAME::HIPPOGRIFF,
            42 => BEAST_NAME::FENRIR,
            43 => BEAST_NAME::JAGUAR,
            44 => BEAST_NAME::SATORI,
            45 => BEAST_NAME::DIREWOLF,
            // Hunter T5
            46 => BEAST_NAME::BEAR,
            47 => BEAST_NAME::WOLF,
            48 => BEAST_NAME::MANTIS,
            49 => BEAST_NAME::SPIDER,
            50 => BEAST_NAME::RAT,
            // Brute T1
            51 => BEAST_NAME::KRAKEN,
            52 => BEAST_NAME::COLOSSUS,
            53 => BEAST_NAME::BALROG,
            54 => BEAST_NAME::LEVIATHAN,
            55 => BEAST_NAME::TARRASQUE,
            // Brute T2
            56 => BEAST_NAME::TITAN,
            57 => BEAST_NAME::NEPHILIM,
            58 => BEAST_NAME::BEHEMOTH,
            59 => BEAST_NAME::HYDRA,
            60 => BEAST_NAME::JUGGERNAUT,
            // Brute T3
            61 => BEAST_NAME::ONI,
            62 => BEAST_NAME::JOTUNN,
            63 => BEAST_NAME::ETTIN,
            64 => BEAST_NAME::CYCLOPS,
            65 => BEAST_NAME::GIANT,
            // Brute T4
            66 => BEAST_NAME::NEMEANLION,
            67 => BEAST_NAME::BERSERKER,
            68 => BEAST_NAME::YETI,
            69 => BEAST_NAME::GOLEM,
            70 => BEAST_NAME::ENT,
            // Brute T5
            71 => BEAST_NAME::TROLL,
            72 => BEAST_NAME::BIGFOOT,
            73 => BEAST_NAME::OGRE,
            74 => BEAST_NAME::ORC,
            75 => BEAST_NAME::SKELETON,
            _ => '',
        }
    }
}



//---------------------------------------
// tests
//
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_is_beast() {
        for i in 0_u8..255_u8 {
            assert_eq!(BeastTrait::is_beast(i), (i >= 1 && i <= 75));
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
