pub mod systems {
    pub mod game;
}

pub mod models {
    pub mod game_info;
}

pub mod libs {
    pub mod constants;
    pub mod metadata;
    pub mod gameplay;
    pub mod beasts;
    pub mod forge;
    pub mod dns;
    // misc
    pub mod hash;
    pub mod rng;
}

pub mod tests {
    pub mod tester;
    pub mod game_tests;
}
