
//
// from: 
// https://github.com/Provable-Games/summit/blob/3d1ebe8e07c31b74d8279b4b2090016b9fec39b2/client/src/utils/BeastData.ts
//

pub mod BEAST_ID {
    pub const B00: u8 = 0;
    // Magical T1
    pub const B01: u8 = 1;
    pub const B02: u8 = 2;
    pub const B03: u8 = 3;
    pub const B04: u8 = 4;
    pub const B05: u8 = 5;
    // Magical T2
    pub const B06: u8 = 6;
    pub const B07: u8 = 7;
    pub const B08: u8 = 8;
    pub const B09: u8 = 9;
    pub const B10: u8 = 10;
    // Magical T3
    pub const B11: u8 = 11;
    pub const B12: u8 = 12;
    pub const B13: u8 = 13;
    pub const B14: u8 = 14;
    pub const B15: u8 = 15;
    // Magical T4
    pub const B16: u8 = 16;
    pub const B17: u8 = 17;
    pub const B18: u8 = 18;
    pub const B19: u8 = 19;
    pub const B20: u8 = 20;
    // Magical T5
    pub const B21: u8 = 21;
    pub const B22: u8 = 22;
    pub const B23: u8 = 23;
    pub const B24: u8 = 24;
    pub const B25: u8 = 25;
    // Hunter T1
    pub const B26: u8 = 26;
    pub const B27: u8 = 27;
    pub const B28: u8 = 28;
    pub const B29: u8 = 29;
    pub const B30: u8 = 30;
    // Hunter T2
    pub const B31: u8 = 31;
    pub const B32: u8 = 32;
    pub const B33: u8 = 33;
    pub const B34: u8 = 34;
    pub const B35: u8 = 35;
    // Hunter T3
    pub const B36: u8 = 36;
    pub const B37: u8 = 37;
    pub const B38: u8 = 38;
    pub const B39: u8 = 39;
    pub const B40: u8 = 40;
    // Hunter T4
    pub const B41: u8 = 41;
    pub const B42: u8 = 42;
    pub const B43: u8 = 43;
    pub const B44: u8 = 44;
    pub const B45: u8 = 45;
    // Hunter T5
    pub const B46: u8 = 46;
    pub const B47: u8 = 47;
    pub const B48: u8 = 48;
    pub const B49: u8 = 49;
    pub const B50: u8 = 50;
    // Brute T1
    pub const B51: u8 = 51;
    pub const B52: u8 = 52;
    pub const B53: u8 = 53;
    pub const B54: u8 = 54;
    pub const B55: u8 = 55;
    // Brute T2
    pub const B56: u8 = 56;
    pub const B57: u8 = 57;
    pub const B58: u8 = 58;
    pub const B59: u8 = 59;
    pub const B60: u8 = 60;
    // Brute T3
    pub const B61: u8 = 61;
    pub const B62: u8 = 62;
    pub const B63: u8 = 63;
    pub const B64: u8 = 64;
    pub const B65: u8 = 65;
    // Brute T4
    pub const B66: u8 = 66;
    pub const B67: u8 = 67;
    pub const B68: u8 = 68;
    pub const B69: u8 = 69;
    pub const B70: u8 = 70;
    // Brute T5
    pub const B71: u8 = 71;
    pub const B72: u8 = 72;
    pub const B73: u8 = 73;
    pub const B74: u8 = 74;
    pub const B75: u8 = 75;
    //------------------------
    // Shiny Magical T1
    pub const SH01: u8 = 101;
    pub const SH02: u8 = 102;
    pub const SH03: u8 = 103;
    pub const SH04: u8 = 104;
    pub const SH05: u8 = 105;
    // Shiny Magical T2
    pub const SH06: u8 = 106;
    pub const SH07: u8 = 107;
    pub const SH08: u8 = 108;
    pub const SH09: u8 = 109;
    pub const SH10: u8 = 110;
    // Magical T3
    pub const SH11: u8 = 111;
    pub const SH12: u8 = 112;
    pub const SH13: u8 = 113;
    pub const SH14: u8 = 114;
    pub const SH15: u8 = 115;
    // Shiny Magical T4
    pub const SH16: u8 = 116;
    pub const SH17: u8 = 117;
    pub const SH18: u8 = 118;
    pub const SH19: u8 = 119;
    pub const SH20: u8 = 120;
    // Shiny Magical T5
    pub const SH21: u8 = 121;
    pub const SH22: u8 = 122;
    pub const SH23: u8 = 123;
    pub const SH24: u8 = 124;
    pub const SH25: u8 = 125;
    // Shiny Hunter T1
    pub const SH26: u8 = 126;
    pub const SH27: u8 = 127;
    pub const SH28: u8 = 128;
    pub const SH29: u8 = 129;
    pub const SH30: u8 = 130;
    // Shiny Hunter T2
    pub const SH31: u8 = 131;
    pub const SH32: u8 = 132;
    pub const SH33: u8 = 133;
    pub const SH34: u8 = 134;
    pub const SH35: u8 = 135;
    // Shiny Hunter T3
    pub const SH36: u8 = 136;
    pub const SH37: u8 = 137;
    pub const SH38: u8 = 138;
    pub const SH39: u8 = 139;
    pub const SH40: u8 = 140;
    // Shiny Hunter T4
    pub const SH41: u8 = 141;
    pub const SH42: u8 = 142;
    pub const SH43: u8 = 143;
    pub const SH44: u8 = 144;
    pub const SH45: u8 = 145;
    // Hunter T5
    pub const SH46: u8 = 146;
    pub const SH47: u8 = 147;
    pub const SH48: u8 = 148;
    pub const SH49: u8 = 149;
    pub const SH50: u8 = 150;
    // Shiny Brute T1
    pub const SH51: u8 = 151;
    pub const SH52: u8 = 152;
    pub const SH53: u8 = 153;
    pub const SH54: u8 = 154;
    pub const SH55: u8 = 155;
    // Shiny Brute T2
    pub const SH56: u8 = 156;
    pub const SH57: u8 = 157;
    pub const SH58: u8 = 158;
    pub const SH59: u8 = 159;
    pub const SH60: u8 = 160;
    // Shiny Brute T3
    pub const SH61: u8 = 161;
    pub const SH62: u8 = 162;
    pub const SH63: u8 = 163;
    pub const SH64: u8 = 164;
    pub const SH65: u8 = 165;
    // Shiny Brute T4
    pub const SH66: u8 = 166;
    pub const SH67: u8 = 167;
    pub const SH68: u8 = 168;
    pub const SH69: u8 = 169;
    pub const SH70: u8 = 170;
    // Shiny Brute T5
    pub const SH71: u8 = 171;
    pub const SH72: u8 = 172;
    pub const SH73: u8 = 173;
    pub const SH74: u8 = 174;
    pub const SH75: u8 = 175;
}

pub mod TIER {
    pub const T0: u8 = 0;
    pub const T1: u8 = 1;
    pub const T2: u8 = 2;
    pub const T3: u8 = 3;
    pub const T4: u8 = 4;
    pub const T5: u8 = 5;
    pub const S1: u8 = 101;
    pub const S2: u8 = 102;
    pub const S3: u8 = 103;
    pub const S4: u8 = 104;
    pub const S5: u8 = 105;
}

// // Tiers, from weaker to stronger
// pub enum Tier {
//     #[default]
//     None,   // 0
//     T5,     // 1
//     T4,     // 2
//     T3,     // 3
//     T2,     // 4
//     T1,     // 5
//     S1,     // 6  -> 101
//     S2,     // 7  -> 102
//     S3,     // 8  -> 103
//     S4,     // 9  -> 104
//     S5,     // 10 -> 105
// }

pub mod TYPE {
    pub const UNKNOWN: felt252 = '';
    pub const MAGIC: felt252 = 'Magic';
    pub const HUNTER: felt252 = 'Hunter';
    pub const BRUTE: felt252 = 'Brute';
}

pub mod BEAST_NAME {
    pub const UNKNOWN: felt252 = '';
    // Magical T1
    pub const WARLOCK: felt252 = 'Warlock'; // 1
    pub const TYPHON: felt252 = 'Typhon'; // 2
    pub const JIANGSHI: felt252 = 'Jiangshi'; // 3
    pub const ANANSI: felt252 = 'Anansi'; // 4
    pub const BASILISK: felt252 = 'Basilisk'; // 5
    // Magical T2
    pub const GORGON: felt252 = 'Gorgon'; // 6
    pub const KITSUNE: felt252 = 'Kitsune'; // 7
    pub const LICH: felt252 = 'Lich'; // 8
    pub const CHIMERA: felt252 = 'Chimera'; // 9
    pub const WENDIGO: felt252 = 'Wendigo'; // 10
    // Magical T3
    pub const RAKSHASA: felt252 = 'Rakshasa'; // 11
    pub const WEREWOLF: felt252 = 'Werewolf'; // 12
    pub const BANSHEE: felt252 = 'Banshee'; // 13
    pub const DRAUGR: felt252 = 'Draugr'; // 14
    pub const VAMPIRE: felt252 = 'Vampire'; // 15
    // Magical T4
    pub const GOBLIN: felt252 = 'Goblin'; // 16
    pub const GHOUL: felt252 = 'Ghoul'; // 17
    pub const WRAITH: felt252 = 'Wraith'; // 18
    pub const SPRITE: felt252 = 'Sprite'; // 19
    pub const KAPPA: felt252 = 'Kappa'; // 20
    // Magical T5
    pub const FAIRY: felt252 = 'Fairy'; // 21
    pub const LEPRECHAUN: felt252 = 'Leprechaun'; // 22
    pub const KELPIE: felt252 = 'Kelpie'; // 23
    pub const PIXIE: felt252 = 'Pixie'; // 24
    pub const GNOME: felt252 = 'Gnome'; // 25
    // Hunter T1
    pub const GRIFFIN: felt252 = 'Griffin'; // 26
    pub const MANTICORE: felt252 = 'Manticore'; // 27
    pub const PHOENIX: felt252 = 'Phoenix'; // 28
    pub const DRAGON: felt252 = 'Dragon'; // 29
    pub const MINOTAUR: felt252 = 'Minotaur'; // 30
    // Hunter T2
    pub const QILIN: felt252 = 'Qilin'; // 31
    pub const AMMIT: felt252 = 'Ammit'; // 32
    pub const NUE: felt252 = 'Nue'; // 33
    pub const SKINWALKER: felt252 = 'Skinwalker'; // 34
    pub const CHUPACABRA: felt252 = 'Chupacabra'; // 35
    // Hunter T3
    pub const WERETIGER: felt252 = 'Weretiger'; // 36
    pub const WYVERN: felt252 = 'Wyvern'; // 37
    pub const ROC: felt252 = 'Roc'; // 38
    pub const HARPY: felt252 = 'Harpy'; // 39
    pub const PEGASUS: felt252 = 'Pegasus'; // 40
    // Hunter T4
    pub const HIPPOGRIFF: felt252 = 'Hippogriff'; // 41
    pub const FENRIR: felt252 = 'Fenrir'; // 42
    pub const JAGUAR: felt252 = 'Jaguar'; // 43
    pub const SATORI: felt252 = 'Satori'; // 44
    pub const DIREWOLF: felt252 = 'Direwolf'; // 45
    // Hunter T5
    pub const BEAR: felt252 = 'Bear'; // 46
    pub const WOLF: felt252 = 'Wolf'; // 47
    pub const MANTIS: felt252 = 'Mantis'; // 48
    pub const SPIDER: felt252 = 'Spider'; // 49
    pub const RAT: felt252 = 'Rat'; // 50
    // Brute T1
    pub const KRAKEN: felt252 = 'Kraken'; // 51
    pub const COLOSSUS: felt252 = 'Colossus'; // 52
    pub const BALROG: felt252 = 'Balrog'; // 53
    pub const LEVIATHAN: felt252 = 'Leviathan'; // 54
    pub const TARRASQUE: felt252 = 'Tarrasque'; // 55
    // Brute T2
    pub const TITAN: felt252 = 'Titan'; // 56
    pub const NEPHILIM: felt252 = 'Nephilim'; // 57
    pub const BEHEMOTH: felt252 = 'Behemoth'; // 58
    pub const HYDRA: felt252 = 'Hydra'; // 59
    pub const JUGGERNAUT: felt252 = 'Juggernaut'; // 60
    // Brute T3
    pub const ONI: felt252 = 'Oni'; // 61
    pub const JOTUNN: felt252 = 'Jotunn'; // 62
    pub const ETTIN: felt252 = 'Ettin'; // 63
    pub const CYCLOPS: felt252 = 'Cyclops'; // 64
    pub const GIANT: felt252 = 'Giant'; // 65
    // Brute T4
    pub const NEMEANLION: felt252 = 'Nemeanlion'; // 66
    pub const BERSERKER: felt252 = 'Berserker'; // 67
    pub const YETI: felt252 = 'Yeti'; // 68
    pub const GOLEM: felt252 = 'Golem'; // 69
    pub const ENT: felt252 = 'Ent'; // 70
    // Brute T5
    pub const TROLL: felt252 = 'Troll'; // 71
    pub const BIGFOOT: felt252 = 'Bigfoot'; // 72
    pub const OGRE: felt252 = 'Ogre'; // 73
    pub const ORC: felt252 = 'Orc'; // 74
    pub const SKELETON: felt252 = 'Skeleton'; // 75
}
