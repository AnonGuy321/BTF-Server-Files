local BTF = {}


function BTF.loadModel(r)
    local s
    print(r)
    if type(r) ~= "string" then
        s = r
    else
        s = GetHashKey(r)
    end
    if IsModelInCdimage(s) then
        if not HasModelLoaded(s) then
            RequestModel(s)
            while not HasModelLoaded(s) do
                Wait(0)
            end
        end
        return s
    else
        return nil
    end
end

function BTF.spawnVehicle(X, v, w, H, Y, Z, _, a0)
    local a1 = BTF.loadModel(X)
    print(a1)
    local a2 = CreateVehicle(a1, v, w, H, Y, _, a0)
    SetEntityAsMissionEntity(a2)
    SetModelAsNoLongerNeeded(a1)
    if Z then
        TaskWarpPedIntoVehicle(PlayerPedId(), a2, -1)
    end
    setVehicleFuel(a2, 100)
    return a2
end
