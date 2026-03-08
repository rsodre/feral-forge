// use dojo::{world::WorldStorage, model::{ModelStorage}};
use starknet::ContractAddress;

#[derive(Clone, Drop, Serde, Introspect, PartialEq, Debug)]
#[dojo::model]
pub struct GameInfo {
    #[key]
    pub token_id: felt252,
    pub seed: felt252,
    pub top_score_address: ContractAddress,
    pub top_score_move_count: u16,
    pub top_score: u16,
    pub finished: bool,
}
