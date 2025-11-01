pub mod systems {
    pub mod game;
}

pub mod models {
    pub mod game_info;
}

pub mod libs {
    pub mod constants;
    pub mod metadata;
    pub mod dns;
    pub mod beasts;
    pub mod hash;
    pub mod merge;
    pub mod rng;
}

pub mod tests {
    mod tester;
    mod game_tests;
}
