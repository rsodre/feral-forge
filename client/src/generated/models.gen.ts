import type { SchemaType as ISchemaType } from "@dojoengine/sdk";

import { CairoCustomEnum, BigNumberish } from 'starknet';

// Type definition for `feral::models::game_info::GameInfo` struct
export interface GameInfo {
	game_id: BigNumberish;
	minter_address: string;
	seed: BigNumberish;
	top_score_address: string;
	top_score_move_count: BigNumberish;
	top_score: BigNumberish;
}

// Type definition for `feral::models::game_info::GameScoredEvent` struct
export interface GameScoredEvent {
	game_id: BigNumberish;
	player_address: string;
	move_count: BigNumberish;
	score: BigNumberish;
}

// Type definition for `feral::libs::gameplay::GameMatrix` struct
export interface GameMatrix {
	b_1_1: BigNumberish;
	b_1_2: BigNumberish;
	b_1_3: BigNumberish;
	b_1_4: BigNumberish;
	b_2_1: BigNumberish;
	b_2_2: BigNumberish;
	b_2_3: BigNumberish;
	b_2_4: BigNumberish;
	b_3_1: BigNumberish;
	b_3_2: BigNumberish;
	b_3_3: BigNumberish;
	b_3_4: BigNumberish;
	b_4_1: BigNumberish;
	b_4_2: BigNumberish;
	b_4_3: BigNumberish;
	b_4_4: BigNumberish;
}

// Type definition for `feral::libs::gameplay::GameState` struct
export interface GameState {
	game_id: BigNumberish;
	seed: BigNumberish;
	matrix: GameMatrix;
	free_tiles: BigNumberish;
	move_count: BigNumberish;
	finished: boolean;
	score: BigNumberish;
}

// Type definition for `nft_combo::erc721::erc721_combo::ERC721ComboComponent::BatchMetadataUpdate` struct
export interface BatchMetadataUpdate {
	from_token_id: BigNumberish;
	to_token_id: BigNumberish;
}

// Type definition for `nft_combo::erc721::erc721_combo::ERC721ComboComponent::MetadataUpdate` struct
export interface MetadataUpdate {
	token_id: BigNumberish;
}

// Type definition for `openzeppelin_token::erc721::erc721::ERC721Component::Approval` struct
export interface Approval {
	owner: string;
	approved: string;
	token_id: BigNumberish;
}

// Type definition for `openzeppelin_token::erc721::erc721::ERC721Component::ApprovalForAll` struct
export interface ApprovalForAll {
	owner: string;
	operator: string;
	approved: boolean;
}

// Type definition for `openzeppelin_token::erc721::erc721::ERC721Component::Transfer` struct
export interface Transfer {
	from: string;
	to: string;
	token_id: BigNumberish;
}

// Type definition for `feral::libs::gameplay::Direction` enum
export const direction = [
	'None',
	'Right',
	'Left',
	'Down',
	'Up',
] as const;
export type Direction = { [key in typeof direction[number]]: string };
export type DirectionEnum = CairoCustomEnum;

export interface SchemaType extends ISchemaType {
	feral: {
		GameInfo: GameInfo,
		GameScoredEvent: GameScoredEvent,
		GameMatrix: GameMatrix,
		GameState: GameState,
		BatchMetadataUpdate: BatchMetadataUpdate,
		MetadataUpdate: MetadataUpdate,
		Approval: Approval,
		ApprovalForAll: ApprovalForAll,
		Transfer: Transfer,
	},
}
export const schema: SchemaType = {
	feral: {
		GameInfo: {
			game_id: 0,
			minter_address: "",
			seed: 0,
			top_score_address: "",
			top_score_move_count: 0,
			top_score: 0,
		},
		GameScoredEvent: {
			game_id: 0,
			player_address: "",
			move_count: 0,
			score: 0,
		},
		GameMatrix: {
			b_1_1: 0,
			b_1_2: 0,
			b_1_3: 0,
			b_1_4: 0,
			b_2_1: 0,
			b_2_2: 0,
			b_2_3: 0,
			b_2_4: 0,
			b_3_1: 0,
			b_3_2: 0,
			b_3_3: 0,
			b_3_4: 0,
			b_4_1: 0,
			b_4_2: 0,
			b_4_3: 0,
			b_4_4: 0,
		},
		GameState: {
			game_id: 0,
			seed: 0,
		matrix: { b_1_1: 0, b_1_2: 0, b_1_3: 0, b_1_4: 0, b_2_1: 0, b_2_2: 0, b_2_3: 0, b_2_4: 0, b_3_1: 0, b_3_2: 0, b_3_3: 0, b_3_4: 0, b_4_1: 0, b_4_2: 0, b_4_3: 0, b_4_4: 0, },
			free_tiles: 0,
			move_count: 0,
			finished: false,
			score: 0,
		},
		BatchMetadataUpdate: {
		from_token_id: 0,
		to_token_id: 0,
		},
		MetadataUpdate: {
		token_id: 0,
		},
		Approval: {
			owner: "",
			approved: "",
		token_id: 0,
		},
		ApprovalForAll: {
			owner: "",
			operator: "",
			approved: false,
		},
		Transfer: {
			from: "",
			to: "",
		token_id: 0,
		},
	},
};
export enum ModelsMapping {
	GameInfo = 'feral-GameInfo',
	GameScoredEvent = 'feral-GameScoredEvent',
	Direction = 'feral-Direction',
	GameMatrix = 'feral-GameMatrix',
	GameState = 'feral-GameState',
	BatchMetadataUpdate = 'nft_combo-BatchMetadataUpdate',
	ContractURIUpdated = 'nft_combo-ContractURIUpdated',
	MetadataUpdate = 'nft_combo-MetadataUpdate',
	Approval = 'openzeppelin_token-Approval',
	ApprovalForAll = 'openzeppelin_token-ApprovalForAll',
	Transfer = 'openzeppelin_token-Transfer',
}