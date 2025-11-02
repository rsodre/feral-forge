// use core::num::traits::Zero;
use starknet::{ContractAddress};
use dojo::world::{WorldStorage, WorldStorageTrait};
use dojo::meta::interface::{
    IDeployedResourceDispatcher, IDeployedResourceDispatcherTrait,
};

pub use feral::{
    systems::game_token::{IGameTokenDispatcher, IGameTokenDispatcherTrait},
};

pub mod SELECTORS {
    // systems
    pub const GAME_TOKEN: felt252 = selector_from_tag!("feral-game_token");
}

#[generate_trait]
pub impl DnsImpl of DnsTrait {
    #[inline(always)]
    fn find_contract_name(self: @WorldStorage, contract_address: ContractAddress) -> ByteArray {
        (IDeployedResourceDispatcher{contract_address}.dojo_name())
    }
    fn find_contract_address(self: @WorldStorage, contract_name: @ByteArray) -> ContractAddress {
        // let (contract_address, _) = self.dns(contract_name).unwrap(); // will panic if not found
        (self.dns_address(contract_name).unwrap_or(0x0.try_into().unwrap()))
    }

    //--------------------------
    // system addresses
    //
    #[inline(always)]
    fn game_address(self: @WorldStorage) -> ContractAddress {
        (self.find_contract_address(@"game_token"))
    }

    //--------------------------
    // dispatchers
    //
    #[inline(always)]
    fn game_dispatcher(self: @WorldStorage) -> IGameTokenDispatcher {
        (IGameTokenDispatcher{ contract_address: self.game_address() })
    }
}
