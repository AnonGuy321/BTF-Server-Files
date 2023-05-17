--[[Proxy/Tunnel]]--

BTFClampClientT = {}
Tunnel.bindInterface("BTF_Clamp",BTFClampClientT)
Proxy.addInterface("BTF_Clamp",BTFClampClientT)
BTFClampServer = Tunnel.getInterface("BTF_Clamp","BTF_Clamp")
BTF = Proxy.getInterface("BTF")

Clamps = {}
DisabledVehs = {}

function BTFClampClientT.ClampVehicle()
  local x,y,z = BTF.getPosition()
  local ped =PlayerPedId()
  local veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, 5.0, 0, 4+2+1)
  if DoesEntityExist(veh) then
    local clampHash = 'prop_clamp'
    RequestModel(clampHash)
    while not HasModelLoaded(clampHash) do
      Citizen.Wait(0)
    end
    local clamp = CreateObject(clampHash, x, y, z, true, true, true)
    local boneIndex = GetEntityBoneIndexByName(veh, "wheel_lf")
    SetEntityHeading(clamp, 0.0)
    SetEntityRotation(clamp, 60.0, 20.0, 10.0, 1, true)
    AttachEntityToEntity(clamp, veh, boneIndex, -0.10, 0.15, -0.30, 180.0, 200.0, 90.0, true, true, false, false, 2, true)
    SetEntityRotation(clamp, 60.0, 20.0, 10.0, 1, true)
    SetEntityAsMissionEntity(clamp, true, true)
    FreezeEntityPosition(clamp, true)
    BTFClampServer.ChangeVehState({VehToNet(veh), true})
    local clampID = #Clamps + 1
    Clamps[clampID] = {clamp, veh}
    BTF.notify({"~g~You have clamped the vehicle, clamp ID " .. clampID .. "."})
  else
    BTF.notify({"~r~There is no vehicle nearby."})
  end
end

function BTFClampClientT.ChangeVehState(veh, disable)
  if disable then
    local veh = NetToVeh(veh)
    DisabledVehs[veh] = true
    Citizen.CreateThread(function()
      while DisabledVehs[veh] do
        Citizen.Wait(500)
        SetVehicleEngineOn(veh, false, false, true)
      end
    end)
  else
    DisabledVehs[NetToVeh(veh)] = false
    Citizen.Wait(500)
    SetVehicleEngineOn(NetToVeh(veh), true, false, false)
  end
end

TriggerEvent('chat:addSuggestion', '/clamp', 'Clamps closest vehicle.')
TriggerEvent('chat:addSuggestion', '/removeclamps', 'Removes all your clamped cars.')
RegisterCommand("removeclamps", function(source, args, rawCommand)
  for k, v in pairs(Clamps) do
    if v ~= nil then
      DeleteEntity(v[1])
      BTFClampServer.ChangeVehState({VehToNet(v[2]), false})
    end
  end
  Clamps = {}
  BTF.notify({"~g~All clamps removed."})
end, false)

RegisterNetEvent("BTF:UnClampVehicles")
AddEventHandler("BTF:UnClampVehicles", function()
  for k, v in pairs(Clamps) do
    if v ~= nil then
      DeleteEntity(v[1])
      BTFClampServer.ChangeVehState({VehToNet(v[2]), false})
    end
  end
  Clamps = {}
  BTF.notify({"~g~All clamps removed."})
end, false)









TriggerEvent('chat:addSuggestion', '/removeclamp', 'Removes clamp.', {{ name="ClampID", help="Clamp ID you want to remove."}})
RegisterCommand("removeclamp", function(source, args, rawCommand)
  local ID = tonumber(args[1])
  if Clamps[ID] == nil then
    BTF.notify({"~r~Please enter a valid clamp ID."})
  else
    DeleteEntity(Clamps[ID][1])
    BTFClampServer.ChangeVehState({VehToNet(Clamps[ID][2]), false})
    Clamps[ID] = nil
    BTF.notify({"~g~Clamp removed."})
  end
end, false)
