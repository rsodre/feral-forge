import { useCallback, useEffect, useMemo, useState } from 'react'
import { useAccount } from '@starknet-react/core'
import { ControllerConnector } from '@cartridge/connector'
import { ProfileContextTypeVariant } from '@cartridge/controller'

//-----------------------------------
// Interact with connected controller
//
export const useConnectedController = () => {
  const { isConnected, connector } = useAccount()

  // connector
  const connectorId = useMemo(() => (connector?.id), [connector])
  const controllerConnector = useMemo<ControllerConnector>(() => (
    connector as unknown as ControllerConnector
  ), [connector, connectorId])

  // username
  const [username, setUsername] = useState<string | undefined>(undefined)
  useEffect(() => {
    setUsername(undefined)
    if (isConnected && controllerConnector) {
      controllerConnector?.username()?.then((n) => setUsername((n || 'unknown').toLowerCase()))
    }
  }, [controllerConnector, isConnected])

  // callbacks
  const openSettings = useCallback((isConnected && controllerConnector) ? async () => {
    controllerConnector?.controller?.openSettings()
  } : () => { }, [controllerConnector, isConnected])
  const openProfile = useCallback((isConnected && controllerConnector) ? async (tab?: ProfileContextTypeVariant) => {
    controllerConnector?.controller?.openProfile(tab)
  } : () => { }, [controllerConnector, isConnected])

  return {
    connectorId,
    controllerConnector,
    isControllerConnected: (controllerConnector != null),
    username,
    name: username,
    icon: connector?.icon,
    openSettings,
    openProfile,
    openInventory: () => openProfile('inventory'),
    openTrophies: () => openProfile('trophies'),
    openAchievements: () => openProfile('achievements'),
    openActivity: () => openProfile('activity'),
  }
}

