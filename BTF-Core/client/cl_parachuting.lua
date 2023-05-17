local CanSeeMarker = false

RegisterNetEvent("BTF:goParachuting")
AddEventHandler("BTF:goParachuting", function()
    if not a then
        a = true
        CreateThread(function()
            GiveWeaponToPed(PlayerPedId(), "GADGET_PARACHUTE")
            DoScreenFadeOut(3000)
            while not IsScreenFadedOut() do
                Wait(0)
            end
            playerCoords = GetEntityCoords(GetPlayerPed(-1))
            SetEntityCoords(GetPlayerPed(-1), playerCoords.x, playerCoords.y, playerCoords.z + 1000.0)
            DoScreenFadeIn(2000)
            Wait(2000)
            SetPlayerInvincible(GetPlayerPed(-1), true)
            SetEntityProofs(GetPlayerPed(-1), true, true, true, true, true, false, 0, false)
            while true do
                if a then
                    if IsPedInParachuteFreeFall(GetPlayerPed(-1)) and not HasEntityCollidedWithAnything(GetPlayerPed(-1)) then
                        ApplyForceToEntity(GetPlayerPed(-1),true,0.0,200.0,2.5,0.0,0.0,0.0,false,true,false,false,false,true)
                    else
                        a = false
                    end
                else
                    break
                end
                Wait(0)
            end
            Wait(3000)
            SetPlayerInvincible(GetPlayerPed(-1), false)
            SetEntityProofs(GetPlayerPed(-1), false, false, false, false, false, false, 0, false)
        end)
    end
end)


Citizen.CreateThread(function()
  local parachuteped = GetHashKey("u_m_m_streetart_01") --  u_m_m_streetart_01
  RequestModel(parachuteped)
  while not HasModelLoaded(parachuteped) do
      Wait(0)
  end

  RequestAnimDict("mini@strip_club@idles@bouncer@base")
  while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
    Wait(1)
  end

  local parachuteentity = CreatePed(26,parachuteped,-1634.4165039062,-1012.8129272461,13.106356620789-1.0,10,false,true)
  SetModelAsNoLongerNeeded(parachuteped)     
  SetEntityCanBeDamaged(parachuteentity, 0)
  SetPedAsEnemy(parachuteentity, 0)   
  SetBlockingOfNonTemporaryEvents(parachuteentity, 1)
  SetPedResetFlag(parachuteentity, 249, 1)
  SetPedConfigFlag(parachuteentity, 185, true)
  SetPedConfigFlag(parachuteentity, 108, true)
  SetEntityInvincible(parachuteentity, true)
  SetEntityCanBeDamaged(parachuteentity, false)
  SetPedCanEvasiveDive(parachuteentity, 0)
  SetPedCanRagdollFromPlayerImpact(parachuteentity, 0)
  SetPedConfigFlag(parachuteentity, 208, true)       
  FreezeEntityPosition(parachuteentity, true)
  TaskPlayAnim(parachuteentity,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)  while true do
    Citizen.Wait(500)
      if #(vec(-1634.609375,-1011.1988525391,13.095387458801+1 - 0.98) - GetEntityCoords(PlayerPedId())) < 100 then
      if not CanSeeMarker then
        CanSeeMarker = true
        Citizen.CreateThread(function()
          while CanSeeMarker do
            Citizen.Wait(0)
            DrawMarker(9, -1634.609375,-1011.1988525391,13.095387458801, 0.0, 0.0, 0.0, 90.0, 0.0, 0.0, 0.8, 0.8, 0.8, 224, 224, 224, 1.0, false, false, 2, true, "dp_clothing", "parachute", false)
          end
        end)
      end
    else
      CanSeeMarker = false
    end
  end
end)

local isInMenu = false
Citizen.CreateThread(function() 
    while true do
        local v1 = vector3(-1634.609375,-1011.1988525391,13.095387458801)
        if isInMenu == false then
            if isInArea(v1, 1.4) then 
                alert('Press ~INPUT_VEH_HORN~ to go Parachuting ~g~[£15,000]')
                if IsControlJustPressed(0, 51) then
                    TriggerServerEvent('BTF:checkParachuteMoney')
                end
            end
        end
        Citizen.Wait(0)
    end
end)

function isInArea(v, dis) 
  if #(GetEntityCoords(PlayerPedId(-1)) - v) <= dis then  
      return true
  else 
      return false
  end
end

