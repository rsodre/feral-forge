import { useEffect, useMemo, useState } from 'react'
import { create } from 'zustand'
import { immer } from 'zustand/middleware/immer'
import { BigNumberish } from 'starknet'
import { lookupAddresses } from '@cartridge/controller'
import { bigintToAddress, bigintToHex, isPositiveBigint } from '../utils/types'

interface State {
  data: {
    [address: string]: string
  },
  initializeAccounts: (accounts: BigNumberish[]) => void,
  getUndefinedAccounts: (accounts: (BigNumberish | undefined)[]) => string[],
  updateControllerNames: (addressToNames: Map<string, string>) => void;
  getNameFromAddress: (address: BigNumberish | undefined) => string | undefined;
  getAddressFromName: (name: string) => BigNumberish | undefined;
}

const _makeKey = (address: BigNumberish | undefined): string | undefined => (
  address && isPositiveBigint(address) ? bigintToAddress(address) : undefined
)

const createStore = () => {
  const _updateName = (state: State, address: BigNumberish, name: string) => {
    const _key = _makeKey(address);
    if (_key) {
      state.data[_key] = name;
    }
  }
  return create<State>()(immer((set, get) => ({
    data: {},
    initializeAccounts: (accounts: BigNumberish[]) => {
      set((state: State) => {
        accounts.forEach((address) => {
          _updateName(state, address, '')
        })
      });
    },
    getUndefinedAccounts: (accounts: (BigNumberish | undefined)[]): string[] => {
      return accounts
        .filter((key) => key !== undefined) // remove undefined keys
        .filter((key, index, self) => self.indexOf(key) === index) // remove duplicates
        .filter((key) => (get().data[_makeKey(BigInt(key ?? 0)) as string] === undefined)) // remove already fetched keys
        .map(bigintToAddress)
    },
    updateControllerNames: (addressToNames: Map<string, string>) => {
      // console.log(">>> updateControllerNames() =>", addressToNames)
      set((state: State) => {
        addressToNames.forEach((name: string, address: string) => {
          _updateName(state, BigInt(address), name)
        })
      });
    },
    getNameFromAddress: (address: BigNumberish | undefined): string | undefined => {
      const _key = _makeKey(address);
      return _key ? get().data[_key] : undefined;
    },
    getAddressFromName: (name: string): BigNumberish | undefined => {
      return Object.keys(get().data).find((key) => (get().data[key] === name));
    },
  })))
}

export const useControllerNameStore = createStore();


//-----------------------------------
// Hooks
//

export function useFetchControllerUsername(address: BigNumberish) {
  const addresses = useMemo(() => [address], [address])
  return useFetchControllerUsernames(addresses)
}

export function useFetchControllerUsernames(addresses: BigNumberish[]) {
  const getUndefinedAccounts = useControllerNameStore((state) => state.getUndefinedAccounts)
  const updateControllerNames = useControllerNameStore((state) => state.updateControllerNames)
  const initializeAccounts = useControllerNameStore((state) => state.initializeAccounts)

  const undefinedAccounts = useMemo(() => getUndefinedAccounts(addresses), [addresses])
  useEffect(() => {
    if (undefinedAccounts.length > 0) {
      // fetch...
      // console.log(">>> fetch usernames...", undefinedAccounts)
      lookupAddresses(undefinedAccounts.map(a => bigintToHex(a))).then((result) => {
        updateControllerNames(result)
      })
      // initialize...
      initializeAccounts(undefinedAccounts)
    }
  }, [undefinedAccounts])

  return {}
}

export function useControllerUsername(address: BigNumberish | undefined) {
  const getNameFromAddress = useControllerNameStore((state) => state.getNameFromAddress)
  const data = useControllerNameStore((state) => state.data)
  const username = useMemo(() => getNameFromAddress(address), [address, data])
  // useEffect(() => console.log('username >>>', username), [username])
  return { username }
}




// export function useControllerUsernameLookup(address: BigNumberish) {
//   const { usernames, isLoading } = useControllerUsernamesLookup(address)
//   const { exists, username } = useMemo(() => {
//     if (isLoading) {
//       return { username: undefined, exists: undefined }
//     }
//     const username = usernames.get(bigintToHex(address))
//     return {
//       username: username ?? '...',
//       exists: username !== undefined,
//     }
//   }, [usernames, isLoading])
//   return {
//     exists,
//     username,
//     isLoading,
//   }
// }
