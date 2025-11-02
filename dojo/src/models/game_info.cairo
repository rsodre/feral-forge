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
}

