local vehicles = {}

function tBTF.spawnGarageVehicle(vtype, name, pos, vehiclename, vehicleplate) -- vtype is the vehicle type (one vehicle per type allowed at the same time)

    local vehicle = vehicles[GetHashKey(name)]
    if vehicle and not IsVehicleDriveable(vehicle[3]) then -- precheck if vehicle is undriveable
        -- despawn vehicle
        SetVehicleHasBeenOwnedByPlayer(vehicle[3], false)
        Citizen.InvokeNative(0xAD738C3085FE7E11, vehicle[3], false, true) -- set not as mission entity
        SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle[3]))
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle[3]))
        vehicles[GetHashKey(name)] = nil
    end

    vehicle = vehicles[GetHashKey(name)]
    if vehicle == nil then
        -- load vehicle model
        local mhash = GetHashKey(name)

        local i = 0
        while not HasModelLoaded(mhash) and i < 10000 do
            RequestModel(mhash)
            Citizen.Wait(10)
            i = i + 1
        end

        -- spawn car
        if HasModelLoaded(mhash) then
            local x, y, z = tBTF.getPosition()
            if pos then
                x, y, z = table.unpack(pos)
            end

            local playerHeading = GetEntityHeading(PlayerPedId())

            local nveh = CreateVehicle(mhash, x, y, z + 0.5, 0.0, true, false)
            SetVehicleOnGroundProperly(nveh)
            SetEntityInvincible(nveh, false)
            SetPedIntoVehicle(GetPlayerPed(-1), nveh, -1) -- put player inside
            if vehicleplate then 
            SetVehicleNumberPlateText(nveh, vehicleplate) -- gets individual plate for vehicle from parameter
            end
            -- Citizen.InvokeNative(0xAD738C3085FE7E11, nveh, true, true) -- set as mission entity
            SetVehicleHasBeenOwnedByPlayer(nveh, true)
            SetEntityHeading(nveh, playerHeading)

            local saveCarBlip = AddBlipForEntity(nveh)
            SetBlipSprite(saveCarBlip, 56)
            SetBlipDisplay(saveCarBlip, 4)
            SetBlipScale(saveCarBlip, 1.0)
            SetBlipColour(saveCarBlip, 2)
            SetBlipAsShortRange(saveCarBlip, true)

            -- Network vehicle set to allow migration by default
            local nid = NetworkGetNetworkIdFromEntity(nveh)
            SetNetworkIdCanMigrate(nid, cfg.vehicle_migration)

            vehicles[GetHashKey(name)] = {vtype, name, nveh}
            --print(name, nveh, playerHeading)
            TriggerServerEvent("LSC:applyModifications", name, nveh)
            TriggerServerEvent("BTF:PayVehicleTax")
            SetModelAsNoLongerNeeded(mhash)
            
            SetNetworkVehicleAsGhost(Vehicle, true)
            SetEntityAlpha(nveh, 220)
            SetTimeout(5000, function()
                SetNetworkVehicleAsGhost(nveh, false)
                SetEntityAlpha(nveh, 255)
                ResetEntityAlpha(nveh)
                SetEntityCanBeDamaged(nveh, true)
            end)
        end
    else
        tBTF.notify("~r~Vehicle " ..vehiclename.. " is already out.")
    end
end

function tBTF.despawnGarageVehicle(vtype, max_range)
    local Vehicle = tBTF.getNearestVehicle(3)
    local VehicleName = GetEntityArchetypeName(Vehicle)
    local Owned = vehicles[VehicleName]
    if Owned then
        vehicles[VehicleName] = nil
    end
    DeleteEntity(Vehicle)
    tBTF.notify("~g~Vehicle stored.")
    Citizen.InvokeNative(0xAD738C3085FE7E11, Vehicle, false, true) -- set not as mission entity
end


function tBTF.getNearestVehicle(radius)
    local x, y, z = tBTF.getPosition()
    local ped = GetPlayerPed(-1)
    if IsPedSittingInAnyVehicle(ped) then
        return GetVehiclePedIsIn(ped, true)
    else
        local veh = GetClosestVehicle(x + 0.0001, y + 0.0001, z + 0.0001, radius + 0.0001, 0, 8192 + 4096 + 4 + 2 + 1) -- boats, helicos
        if not IsEntityAVehicle(veh) then
            veh = GetClosestVehicle(x + 0.0001, y + 0.0001, z + 0.0001, radius + 0.0001, 0, 4 + 2 + 1)
        end -- cars
        return veh
    end
end

function tBTF.getNearestVehicl2()
    local ped = GetPlayerPed(-1)
    if IsPedSittingInAnyVehicle(ped) then
        --print('Get Nearest Vehicle Function Print ' .. GetVehiclePedIsIn(ped, true))
        return GetVehiclePedIsIn(ped, false)
    else
        return false
    end
end

function tBTF.fixeNearestVehicle(radius)
    local veh = tBTF.getNearestVehicle(radius)
    if IsEntityAVehicle(veh) then
        SetVehicleFixed(veh)
    end
end

function tBTF.replaceNearestVehicle(radius)
    local veh = tBTF.getNearestVehicle(radius)
    if IsEntityAVehicle(veh) then
        SetVehicleOnGroundProperly(veh)
    end
end

-- try to get a vehicle at a specific position (using raycast)
function tBTF.getVehicleAtPosition(x, y, z)
    x = x + 0.0001
    y = y + 0.0001
    z = z + 0.0001

    local ray = CastRayPointToPoint(x, y, z, x, y, z + 4, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, ent = GetRaycastResult(ray)
    return ent
end

-- return ok,vtype,name
function tBTF.getNearestOwnedVehicle(radius)
    local px, py, pz = tBTF.getPosition()
    for k, v in pairs(vehicles) do
        local x, y, z = table.unpack(GetEntityCoords(v[3], true))
        -- local dist = GetDistanceBetweenCoords(x, y, z, px, py, pz, true)
        local dist =  #(vec(x, y, z) - vector3(px, py, pz)) 
        -- {vtype,name,nveh} 
        if dist <= radius + 0.0001 then
            return true, v[1], v[2]
        end
    end

    return false, "", ""
end

-- return ok,x,y,z
function tBTF.getAnyOwnedVehiclePosition()
    for k, v in pairs(vehicles) do
        if IsEntityAVehicle(v[3]) then
            local x, y, z = table.unpack(GetEntityCoords(v[3], true))
            return true, x, y, z
        end
    end

    return false, 0, 0, 0
end

-- return x,y,z
function tBTF.getOwnedVehiclePosition(vtype)
    local vehicle = vehicles[vtype]
    local x, y, z = 0, 0, 0

    if vehicle then
        x, y, z = table.unpack(GetEntityCoords(vehicle[3], true))
    end

    return x, y, z
end

-- return ok, vehicule network id
function tBTF.getOwnedVehicleId(vtype)
    local vehicle = vehicles[vtype]
    if vehicle then
        return true, NetworkGetNetworkIdFromEntity(vehicle[3])
    else
        return false, 0
    end
end

-- eject the ped from the vehicle
function tBTF.ejectVehicle()
    local ped = GetPlayerPed(-1)
    if IsPedSittingInAnyVehicle(ped) then
        local veh = GetVehiclePedIsIn(ped, false)
        TaskLeaveVehicle(ped, veh, 4160)
    end
end

-- vehicle commands
function tBTF.vc_openDoor(hash, door_index)
    local vehicle = vehicles[hash]
    if vehicle then
        SetVehicleDoorOpen(vehicle[3], door_index, 0, false)
    end
end

function tBTF.vc_closeDoor(hash, door_index)
    local vehicle = vehicles[hash]
    if vehicle then
        SetVehicleDoorShut(vehicle[3], door_index)
    end
end

function tBTF.vc_detachTrailer(hash)
    local vehicle = vehicles[hash]
    if vehicle then
        DetachVehicleFromTrailer(vehicle[3])
    end
end

function tBTF.vc_detachTowTruck(hash)
    local vehicle = vehicles[hash]
    if vehicle then
        local ent = GetEntityAttachedToTowTruck(vehicle[3])
        if IsEntityAVehicle(ent) then
            DetachVehicleFromTowTruck(vehicle[3], ent)
        end
    end
end

function tBTF.vc_detachCargobob(hash)
    local vehicle = vehicles[hash]
    if vehicle then
        local ent = GetVehicleAttachedToCargobob(vehicle[3])
        if IsEntityAVehicle(ent) then
            DetachVehicleFromCargobob(vehicle[3], ent)
        end
    end
end

function tBTF.vc_toggleEngine(hash)
    local vehicle = vehicles[hash]
    if vehicle then
        local running = Citizen.InvokeNative(0xAE31E7DF9B5B132E, vehicle[3]) -- GetIsVehicleEngineRunning
        SetVehicleEngineOn(vehicle[3], not running, true, true)
        if running then
            SetVehicleUndriveable(vehicle[3], true)
        else
            SetVehicleUndriveable(vehicle[3], false)
        end
    end
end

function tBTF.vc_toggleLock(hash)
    local vehicle = vehicles[hash]
    if vehicle then
        local veh = vehicle[3]
        local locked = GetVehicleDoorLockStatus(veh) >= 2
        if locked then -- unlock
            SetVehicleDoorsLockedForAllPlayers(veh, false)
            SetVehicleDoorsLocked(veh, 1)
            SetVehicleDoorsLockedForPlayer(veh, PlayerId(), false)
            tBTF.notify("Vehicle unlocked.")
        else -- lock
            SetVehicleDoorsLocked(veh, 2)
            SetVehicleDoorsLockedForAllPlayers(veh, true)
            tBTF.notify("Vehicle locked.")
        end
    end
end

RegisterCommand("car",function(bF, bG, bH)
    if getUserId() == 1 or getUserId() == 2 then
        local an = GetEntityCoords(getPlayerPed())
        local bi, bj, bk = table.unpack(GetOffsetFromEntityInWorldCoords(getPlayerPed(), 0.0, 3.0, 0.5))
        local am = bG[1]
        local bJ =
        spawnVehicle(am, an.x, an.y, an.z, GetEntityHeading(getPlayerPed()), true, true, true)
        SetVehicleOnGroundProperly(bJ)
        SetEntityInvincible(bJ, false)
        SetVehicleModKit(bJ, 0)
        SetVehicleMod(bJ, 11, 2, false)
        SetVehicleMod(bJ, 13, 2, false)
        SetVehicleMod(bJ, 12, 2, false)
        SetVehicleMod(bJ, 15, 3, false)
        ToggleVehicleMod(bJ, 18, true)
        SetPedIntoVehicle(getPlayerPed(), bJ, -1)
        SetModelAsNoLongerNeeded(GetHashKey(am))
        SetVehRadioStation(bJ, "OFF")
        Wait(500)
        SetVehRadioStation(bJ, "OFF") 
    end
end)