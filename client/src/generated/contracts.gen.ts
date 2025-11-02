import { DojoProvider, DojoCall } from "@dojoengine/core";
import { Account, AccountInterface, BigNumberish, CairoOption, CairoCustomEnum } from "starknet";
import * as models from "./models.gen";

export function setupWorld(provider: DojoProvider) {

	const build_game_token_approve_calldata = (to: string, tokenId: BigNumberish): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "approve",
			calldata: [to, tokenId],
		};
	};

	const game_token_approve = async (snAccount: Account | AccountInterface, to: string, tokenId: BigNumberish) => {
		try {
			return await provider.execute(
				snAccount,
				build_game_token_approve_calldata(to, tokenId),
				"feral",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_availableSupply_calldata = (): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "availableSupply",
			calldata: [],
		};
	};

	const game_token_availableSupply = async () => {
		try {
			return await provider.call("feral", build_game_token_availableSupply_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_balanceOf_calldata = (account: string): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "balanceOf",
			calldata: [account],
		};
	};

	const game_token_balanceOf = async (account: string) => {
		try {
			return await provider.call("feral", build_game_token_balanceOf_calldata(account));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_contractUri_calldata = (): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "contractURI",
			calldata: [],
		};
	};

	const game_token_contractUri = async () => {
		try {
			return await provider.call("feral", build_game_token_contractUri_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_defaultRoyalty_calldata = (): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "defaultRoyalty",
			calldata: [],
		};
	};

	const game_token_defaultRoyalty = async () => {
		try {
			return await provider.call("feral", build_game_token_defaultRoyalty_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_getApproved_calldata = (tokenId: BigNumberish): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "getApproved",
			calldata: [tokenId],
		};
	};

	const game_token_getApproved = async (tokenId: BigNumberish) => {
		try {
			return await provider.call("feral", build_game_token_getApproved_calldata(tokenId));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_getGameInfo_calldata = (gameId: BigNumberish): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "get_game_info",
			calldata: [gameId],
		};
	};

	const game_token_getGameInfo = async (gameId: BigNumberish) => {
		try {
			return await provider.call("feral", build_game_token_getGameInfo_calldata(gameId));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_isApprovedForAll_calldata = (owner: string, operator: string): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "isApprovedForAll",
			calldata: [owner, operator],
		};
	};

	const game_token_isApprovedForAll = async (owner: string, operator: string) => {
		try {
			return await provider.call("feral", build_game_token_isApprovedForAll_calldata(owner, operator));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_isMintedOut_calldata = (): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "is_minted_out",
			calldata: [],
		};
	};

	const game_token_isMintedOut = async () => {
		try {
			return await provider.call("feral", build_game_token_isMintedOut_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_isMintingPaused_calldata = (): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "is_minting_paused",
			calldata: [],
		};
	};

	const game_token_isMintingPaused = async () => {
		try {
			return await provider.call("feral", build_game_token_isMintingPaused_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_isOwnerOf_calldata = (address: string, tokenId: BigNumberish): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "is_owner_of",
			calldata: [address, tokenId],
		};
	};

	const game_token_isOwnerOf = async (address: string, tokenId: BigNumberish) => {
		try {
			return await provider.call("feral", build_game_token_isOwnerOf_calldata(address, tokenId));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_lastTokenId_calldata = (): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "last_token_id",
			calldata: [],
		};
	};

	const game_token_lastTokenId = async () => {
		try {
			return await provider.call("feral", build_game_token_lastTokenId_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_maxSupply_calldata = (): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "maxSupply",
			calldata: [],
		};
	};

	const game_token_maxSupply = async () => {
		try {
			return await provider.call("feral", build_game_token_maxSupply_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_mint_calldata = (recipient: string): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "mint",
			calldata: [recipient],
		};
	};

	const game_token_mint = async (snAccount: Account | AccountInterface, recipient: string) => {
		try {
			return await provider.execute(
				snAccount,
				build_game_token_mint_calldata(recipient),
				"feral",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_mintedSupply_calldata = (): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "mintedSupply",
			calldata: [],
		};
	};

	const game_token_mintedSupply = async () => {
		try {
			return await provider.call("feral", build_game_token_mintedSupply_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_move_calldata = (gameState: models.GameState, direction: CairoCustomEnum): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "move",
			calldata: [gameState, direction],
		};
	};

	const game_token_move = async (gameState: models.GameState, direction: CairoCustomEnum) => {
		try {
			return await provider.call("feral", build_game_token_move_calldata(gameState, direction));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_name_calldata = (): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "name",
			calldata: [],
		};
	};

	const game_token_name = async () => {
		try {
			return await provider.call("feral", build_game_token_name_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_ownerOf_calldata = (tokenId: BigNumberish): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "ownerOf",
			calldata: [tokenId],
		};
	};

	const game_token_ownerOf = async (tokenId: BigNumberish) => {
		try {
			return await provider.call("feral", build_game_token_ownerOf_calldata(tokenId));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_reservedSupply_calldata = (): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "reservedSupply",
			calldata: [],
		};
	};

	const game_token_reservedSupply = async () => {
		try {
			return await provider.call("feral", build_game_token_reservedSupply_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_royaltyInfo_calldata = (tokenId: BigNumberish, salePrice: BigNumberish): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "royaltyInfo",
			calldata: [tokenId, salePrice],
		};
	};

	const game_token_royaltyInfo = async (tokenId: BigNumberish, salePrice: BigNumberish) => {
		try {
			return await provider.call("feral", build_game_token_royaltyInfo_calldata(tokenId, salePrice));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_safeTransferFrom_calldata = (from: string, to: string, tokenId: BigNumberish, data: Array<BigNumberish>): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "safeTransferFrom",
			calldata: [from, to, tokenId, data],
		};
	};

	const game_token_safeTransferFrom = async (snAccount: Account | AccountInterface, from: string, to: string, tokenId: BigNumberish, data: Array<BigNumberish>) => {
		try {
			return await provider.execute(
				snAccount,
				build_game_token_safeTransferFrom_calldata(from, to, tokenId, data),
				"feral",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_setApprovalForAll_calldata = (operator: string, approved: boolean): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "setApprovalForAll",
			calldata: [operator, approved],
		};
	};

	const game_token_setApprovalForAll = async (snAccount: Account | AccountInterface, operator: string, approved: boolean) => {
		try {
			return await provider.execute(
				snAccount,
				build_game_token_setApprovalForAll_calldata(operator, approved),
				"feral",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_setMintingPaused_calldata = (isPaused: boolean): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "set_minting_paused",
			calldata: [isPaused],
		};
	};

	const game_token_setMintingPaused = async (snAccount: Account | AccountInterface, isPaused: boolean) => {
		try {
			return await provider.execute(
				snAccount,
				build_game_token_setMintingPaused_calldata(isPaused),
				"feral",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_startGame_calldata = (gameId: BigNumberish): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "start_game",
			calldata: [gameId],
		};
	};

	const game_token_startGame = async (gameId: BigNumberish) => {
		try {
			return await provider.call("feral", build_game_token_startGame_calldata(gameId));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_submitGame_calldata = (gameId: BigNumberish, moves: Array<Direction>): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "submit_game",
			calldata: [gameId, moves],
		};
	};

	const game_token_submitGame = async (snAccount: Account | AccountInterface, gameId: BigNumberish, moves: Array<Direction>) => {
		try {
			return await provider.execute(
				snAccount,
				build_game_token_submitGame_calldata(gameId, moves),
				"feral",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_supportsInterface_calldata = (interfaceId: BigNumberish): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "supports_interface",
			calldata: [interfaceId],
		};
	};

	const game_token_supportsInterface = async (interfaceId: BigNumberish) => {
		try {
			return await provider.call("feral", build_game_token_supportsInterface_calldata(interfaceId));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_symbol_calldata = (): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "symbol",
			calldata: [],
		};
	};

	const game_token_symbol = async () => {
		try {
			return await provider.call("feral", build_game_token_symbol_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_tokenRoyalty_calldata = (tokenId: BigNumberish): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "tokenRoyalty",
			calldata: [tokenId],
		};
	};

	const game_token_tokenRoyalty = async (tokenId: BigNumberish) => {
		try {
			return await provider.call("feral", build_game_token_tokenRoyalty_calldata(tokenId));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_tokenUri_calldata = (tokenId: BigNumberish): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "tokenURI",
			calldata: [tokenId],
		};
	};

	const game_token_tokenUri = async (tokenId: BigNumberish) => {
		try {
			return await provider.call("feral", build_game_token_tokenUri_calldata(tokenId));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_tokenExists_calldata = (tokenId: BigNumberish): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "token_exists",
			calldata: [tokenId],
		};
	};

	const game_token_tokenExists = async (tokenId: BigNumberish) => {
		try {
			return await provider.call("feral", build_game_token_tokenExists_calldata(tokenId));
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_totalSupply_calldata = (): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "totalSupply",
			calldata: [],
		};
	};

	const game_token_totalSupply = async () => {
		try {
			return await provider.call("feral", build_game_token_totalSupply_calldata());
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_transferFrom_calldata = (from: string, to: string, tokenId: BigNumberish): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "transferFrom",
			calldata: [from, to, tokenId],
		};
	};

	const game_token_transferFrom = async (snAccount: Account | AccountInterface, from: string, to: string, tokenId: BigNumberish) => {
		try {
			return await provider.execute(
				snAccount,
				build_game_token_transferFrom_calldata(from, to, tokenId),
				"feral",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_updateContractMetadata_calldata = (): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "update_contract_metadata",
			calldata: [],
		};
	};

	const game_token_updateContractMetadata = async (snAccount: Account | AccountInterface) => {
		try {
			return await provider.execute(
				snAccount,
				build_game_token_updateContractMetadata_calldata(),
				"feral",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_updateTokenMetadata_calldata = (tokenId: BigNumberish): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "update_token_metadata",
			calldata: [tokenId],
		};
	};

	const game_token_updateTokenMetadata = async (snAccount: Account | AccountInterface, tokenId: BigNumberish) => {
		try {
			return await provider.execute(
				snAccount,
				build_game_token_updateTokenMetadata_calldata(tokenId),
				"feral",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};

	const build_game_token_updateTokensMetadata_calldata = (fromTokenId: BigNumberish, toTokenId: BigNumberish): DojoCall => {
		return {
			contractName: "game_token",
			entrypoint: "update_tokens_metadata",
			calldata: [fromTokenId, toTokenId],
		};
	};

	const game_token_updateTokensMetadata = async (snAccount: Account | AccountInterface, fromTokenId: BigNumberish, toTokenId: BigNumberish) => {
		try {
			return await provider.execute(
				snAccount,
				build_game_token_updateTokensMetadata_calldata(fromTokenId, toTokenId),
				"feral",
			);
		} catch (error) {
			console.error(error);
			throw error;
		}
	};



	return {
		game_token: {
			approve: game_token_approve,
			buildApproveCalldata: build_game_token_approve_calldata,
			availableSupply: game_token_availableSupply,
			buildAvailableSupplyCalldata: build_game_token_availableSupply_calldata,
			balanceOf: game_token_balanceOf,
			buildBalanceOfCalldata: build_game_token_balanceOf_calldata,
			contractUri: game_token_contractUri,
			buildContractUriCalldata: build_game_token_contractUri_calldata,
			defaultRoyalty: game_token_defaultRoyalty,
			buildDefaultRoyaltyCalldata: build_game_token_defaultRoyalty_calldata,
			getApproved: game_token_getApproved,
			buildGetApprovedCalldata: build_game_token_getApproved_calldata,
			getGameInfo: game_token_getGameInfo,
			buildGetGameInfoCalldata: build_game_token_getGameInfo_calldata,
			isApprovedForAll: game_token_isApprovedForAll,
			buildIsApprovedForAllCalldata: build_game_token_isApprovedForAll_calldata,
			isMintedOut: game_token_isMintedOut,
			buildIsMintedOutCalldata: build_game_token_isMintedOut_calldata,
			isMintingPaused: game_token_isMintingPaused,
			buildIsMintingPausedCalldata: build_game_token_isMintingPaused_calldata,
			isOwnerOf: game_token_isOwnerOf,
			buildIsOwnerOfCalldata: build_game_token_isOwnerOf_calldata,
			lastTokenId: game_token_lastTokenId,
			buildLastTokenIdCalldata: build_game_token_lastTokenId_calldata,
			maxSupply: game_token_maxSupply,
			buildMaxSupplyCalldata: build_game_token_maxSupply_calldata,
			mint: game_token_mint,
			buildMintCalldata: build_game_token_mint_calldata,
			mintedSupply: game_token_mintedSupply,
			buildMintedSupplyCalldata: build_game_token_mintedSupply_calldata,
			move: game_token_move,
			buildMoveCalldata: build_game_token_move_calldata,
			name: game_token_name,
			buildNameCalldata: build_game_token_name_calldata,
			ownerOf: game_token_ownerOf,
			buildOwnerOfCalldata: build_game_token_ownerOf_calldata,
			reservedSupply: game_token_reservedSupply,
			buildReservedSupplyCalldata: build_game_token_reservedSupply_calldata,
			royaltyInfo: game_token_royaltyInfo,
			buildRoyaltyInfoCalldata: build_game_token_royaltyInfo_calldata,
			safeTransferFrom: game_token_safeTransferFrom,
			buildSafeTransferFromCalldata: build_game_token_safeTransferFrom_calldata,
			setApprovalForAll: game_token_setApprovalForAll,
			buildSetApprovalForAllCalldata: build_game_token_setApprovalForAll_calldata,
			setMintingPaused: game_token_setMintingPaused,
			buildSetMintingPausedCalldata: build_game_token_setMintingPaused_calldata,
			startGame: game_token_startGame,
			buildStartGameCalldata: build_game_token_startGame_calldata,
			submitGame: game_token_submitGame,
			buildSubmitGameCalldata: build_game_token_submitGame_calldata,
			supportsInterface: game_token_supportsInterface,
			buildSupportsInterfaceCalldata: build_game_token_supportsInterface_calldata,
			symbol: game_token_symbol,
			buildSymbolCalldata: build_game_token_symbol_calldata,
			tokenRoyalty: game_token_tokenRoyalty,
			buildTokenRoyaltyCalldata: build_game_token_tokenRoyalty_calldata,
			tokenUri: game_token_tokenUri,
			buildTokenUriCalldata: build_game_token_tokenUri_calldata,
			tokenExists: game_token_tokenExists,
			buildTokenExistsCalldata: build_game_token_tokenExists_calldata,
			totalSupply: game_token_totalSupply,
			buildTotalSupplyCalldata: build_game_token_totalSupply_calldata,
			transferFrom: game_token_transferFrom,
			buildTransferFromCalldata: build_game_token_transferFrom_calldata,
			updateContractMetadata: game_token_updateContractMetadata,
			buildUpdateContractMetadataCalldata: build_game_token_updateContractMetadata_calldata,
			updateTokenMetadata: game_token_updateTokenMetadata,
			buildUpdateTokenMetadataCalldata: build_game_token_updateTokenMetadata_calldata,
			updateTokensMetadata: game_token_updateTokensMetadata,
			buildUpdateTokensMetadataCalldata: build_game_token_updateTokensMetadata_calldata,
		},
	};
}