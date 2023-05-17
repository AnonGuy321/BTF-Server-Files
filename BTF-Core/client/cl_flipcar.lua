RegisterNetEvent("flipCar")
AddEventHandler("flipCar", function()
    local player = PlayerId()
    local playerPed = GetPlayerPed(player)
    
    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        
        if IsEntityUpsidedown(vehicle) then
            if not GetIsVehicleEngineRunning(vehicle) then
                ShowNotification("~b~Flipping car")

                Citizen.Wait(6000)

                local coords = GetEntityCoords(vehicle, false)
                SetEntityCoords(vehicle, coords.x, coords.y, coords.z + 2.5, false, false, false, false)
                SetVehicleOnGroundProperly(vehicle)

                ShowNotification("~g~Car flipped successfully!")
            else
                ShowNotification("~r~Turn off the engine before flipping the car.")
            end
        else
            ShowNotification("~r~Your car is not flipped.")
        end
    else
        ShowNotification("~r~You need to be inside a flipped car.")
    end
end)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end
