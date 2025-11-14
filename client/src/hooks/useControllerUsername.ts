import { useEffect, useMemo, useState } from 'react'
import { create } from 'zustand'
import { immer } from 'zustand/middleware/immer'
import { BigNumberish } from 'starknet'
import { lookupAddresses } from '@cartridge/controller'
import { bigintToAddress, bigintToHex, isPositiveBigint } from '../utils/types'

// interface Names {
//   controllerName?: string
//   starkName?: string
//   ensName?: string
//   displayName?: string
// }
// interface NamesByAddress {
//   [address: string]: Names
// }
// interface State {
//   data: NamesByAddress,
//   updateControllerNames: (addressToNames: Map<string, string>) => void;
//   getDisplayNameFromAddress: (address: BigNumberish) => string | null;
//   getAddressFromName: (name: string) => BigNumberish | null;
// }

// const _key = (address: BigNumberish | undefined): string | null => (
//   isPositiveBigint(address) ? bigintToAddress(address) : null
// )

// const createStore = () => {
//   const _updateNames = (state: State, address: BigNumberish, names: Names) => {
//     const key = _key(address);
//     state.data[key] = {
//       ...(state.data[key] ?? {}),
//       ...names,
//     };
//     state.data[key].displayName =
//       state.data[key].ensName ??
//       state.data[key].starkName ??
//       state.data[key].controllerName ??
//       null;
//   }
//   return create<State>()(immer((set, get) => ({
//     data: {},
//     initializeAddresses: (addresses: BigNumberish[]) => {
//       set((state: State) => {
//         addresses.forEach((address: BigNumberish) => {
//           _updateNames(state, address, {})
//         })
//       });
//     },
//     updateControllerNames: (addressToNames: Map<string, string>) => {
//       // console.log("updateControllerNames() =>", addressToNames)
//       set((state: State) => {
//         addressToNames.forEach((name: string, address: string) => {
//           _updateNames(state, address, {
//             controllerName: name ? `${name}.ctrl` : null,
//           })
//         })
//       });
//     },
//     getDisplayNameFromAddress: (address: BigNumberish): string | null => {
//       const key = _key(address);
//       return get().data[key]?.displayName;
//     },
//     getAddressFromName: (name: string): BigNumberish | null => {
//       const data = get().data;
//       const key = Object.keys(data).find((key) => (
//         name === data[key]?.ensName ||
//         name === data[key]?.starkName ||
//         name === data[key]?.controllerName ||
//         `${name}.ctrl` === data[key]?.controllerName
//       ));
//       return key ?? null;
//     },
//   })))
// }

// export const useNameStore = createStore();


export function useControllerUsername(address: BigNumberish) {
  const { usernames, isLoading } = useControllerUsernames(address)
  const { exists, username } = useMemo(() => {
    if (isLoading) {
      return { username: undefined, exists: undefined }
    }
    const username = usernames.get(bigintToHex(address))
    return {
      username: username ?? '...',
      exists: username !== undefined,
    }
  }, [usernames, isLoading])
  return {
    exists,
    username,
    isLoading,
  }
}

export function useControllerUsernames(addresses: BigNumberish | BigNumberish[]) {
  const [usernames, setUsernames] = useState<Map<string, string>>(new Map())
  const [isLoading, setIsLoading] = useState(false)
  useEffect(() => {
    const _addresses =
      Array.isArray(addresses) ? addresses
        : isPositiveBigint(addresses) ? [addresses]
          : []
    if (_addresses.length == 0) {
      setUsernames(new Map())
    } else {
      setIsLoading(true)
      lookupAddresses(_addresses.map(a => bigintToHex(a))).then((result) => {
        setUsernames(result)
        setIsLoading(false)
      })
    }
  }, [addresses])
  return {
    usernames,
    isLoading,
  }
}
