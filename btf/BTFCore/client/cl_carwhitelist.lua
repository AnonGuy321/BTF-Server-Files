local a = {["demonhawkk"] = {1}, ["hycadesupra"] = {1, 2}, ["customx6m"] = {1, 2}}
local function b(c)
    DisableControlAction(0, 32, true)
    DisableControlAction(0, 33, true)
    DisableControlAction(0, 34, true)
    DisableControlAction(0, 35, true)
    DisableControlAction(0, 71, true)
    DisableControlAction(0, 72, true)
    DisableControlAction(0, 350, true)
    DisableControlAction(0, 351, true)
    SetVehicleRocketBoostPercentage(c, 0.0)
    BeginTextCommandThefeedPost("STRING")
    drawNativeText("You are not allowed to drive this vehicle")
    EndTextCommandThefeedPostTicker(false, false)
end
local function d()
    local c, e = tBTF.getPlayerVehicle()
    local f = tBTF.getUserId()
    if c ~= 0 and e then
        local g = GetEntityModel(c)
        for d, h in pairs(a) do
            if GetHashKey(d) == g then
                local i = false
                for j, k in pairs(h) do
                    if k == f then
                        i = true
                        break
                    end
                end
                if not i then
                    b(c)
                end
                return
            end
        end
    end
end
tBTF.createThreadOnTick(d)