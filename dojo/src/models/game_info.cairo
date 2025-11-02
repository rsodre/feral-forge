// use dojo::{world::WorldStorage, model::{ModelStorage}};
use starknet::ContractAddress;

#[derive(Clone, Drop, Serde, Introspect, PartialEq, Debug)]
#[dojo::model]
pub struct GameInfo {
    #[key]
    pub game_id: u128,
    //-----------------------------------
    pub minter_address: ContractAddress,
    pub seed: felt252,
    // top score holder
    pub top_score_address: ContractAddress,
    pub top_score_move_count: u16,
    pub top_score: u16,
}

//---------------------------------
// events
//
#[derive(Copy, Drop, Serde)]
#[dojo::event(historical:false)]
pub struct GameScoredEvent {
    #[key]
    pub game_id: u128,
    #[key]
    pub player_address: ContractAddress,
    /// Properties ///
    pub move_count: u16,
    pub score: u16,
}
