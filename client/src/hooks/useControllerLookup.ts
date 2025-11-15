import { useEffect, useMemo, useState } from 'react'
import { BigNumberish } from 'starknet'
import { lookupAddresses } from '@cartridge/controller'
import { bigintToHex, isPositiveBigint } from '../utils/types'

export function useControllerUsernameLookup(address: BigNumberish) {
  const { usernames, isLoading } = useControllerUsernamesLookup(address)
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

export function useControllerUsernamesLookup(addresses: BigNumberish | BigNumberish[]) {
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
