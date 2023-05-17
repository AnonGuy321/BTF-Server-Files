RegisterCommand('lockcar', function()
    local veh, name, nveh = tBTF.getNearestOwnedVehicle(5)
    if veh then 
        tBTF.vc_toggleLock(GetHashKey(nveh))
        tBTF.playSound("HUD_MINI_GAME_SOUNDSET", "5_SEC_WARNING")
    end
end)

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      if IsControlJustReleased(0,  82) then
          ExecuteCommand('lockcar')
      end
      end
  end)