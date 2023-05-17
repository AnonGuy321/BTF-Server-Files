local distanceToNHSEntrance = 1000
local distanceToNHSExit = 1000
local NHSEntranceVector = vector3(331.79479980469,-595.53161621094,43.284049987793)
local NHSExitVector = vector3(344.80969238281,-586.3955078125,28.796829223633)

RMenu.Add('NHS_enter', 'NHS', RageUI.CreateMenu("", "",0,100,"shopui_title_NHS", "shopui_title_NHS"))
RMenu:Get('NHS_enter', 'NHS'):SetSubtitle("~b~ENTER")
RMenu.Add('NHS_exit', 'NHS', RageUI.CreateMenu("", "",0,100,"shopui_title_NHS", "shopui_title_NHS"))
RMenu:Get('NHS_exit', 'NHS'):SetSubtitle("~b~EXIT")

function showNHSEnter(flag)
    RageUI.Visible(RMenu:Get('NHS_enter', 'NHS'), flag)
end

function showNHSExit(flag)
    RageUI.Visible(RMenu:Get('NHS_exit', 'NHS'), flag)
end


RageUI.CreateWhile(1.0, RMenu:Get('NHS_exit', 'NHS'), nil, function()
    RageUI.IsVisible(RMenu:Get('NHS_exit', 'NHS'), true, false, true, function()

        RageUI.ButtonWithStyle("Bottom Floor", nil,{ RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
            if (Hovered) then

            end
            if (Active) then

            end
            if (Selected) then
                SetEntityCoords(PlayerPedId(),NHSEntranceVector.x,NHSEntranceVector.y,NHSEntranceVector.z)
                for k,v in pairs(cardObjects) do
                    for _,obj in pairs(v) do
                        DeleteObject(obj)
                    end
                end	
            end
        end)

    end)
end)


RageUI.CreateWhile(1.0, RMenu:Get('NHS_enter', 'NHS'), nil, function()
    RageUI.IsVisible(RMenu:Get('NHS_enter', 'NHS'), true, false, true, function()

        RageUI.ButtonWithStyle("Top Floor", nil,{ RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
            if (Hovered) then

            end
            if (Active) then

            end
            if (Selected) then
                SetEntityCoords(PlayerPedId(),NHSExitVector.x,NHSExitVector.y,NHSExitVector.z)
            end
        end)

    end)
end)



Citizen.CreateThread(function()
    while true do 
        if distanceToNHSEntrance < 1.5  then 
            showNHSEnter(true)
        elseif distanceToNHSEntrance < 2.5 then 
            showNHSEnter(false)
        end
        if distanceToNHSExit < 1.5  then 
            showNHSExit(true)
        elseif distanceToNHSExit < 2.5 then 
            showNHSExit(false)
        end
        DrawMarker(27, NHSEntranceVector.x, NHSEntranceVector.y, NHSEntranceVector.z-1.0, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255,255,255, 200, 0, 0, 0, 0)
        DrawMarker(27, NHSExitVector.x, NHSExitVector.y, NHSExitVector.z-1.0, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255,255,255, 200, 0, 0, 0, 0)
        Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do 
        local playerCoords = GetEntityCoords(PlayerPedId())

        distanceToNHSEntrance = #(playerCoords-NHSEntranceVector)
        distanceToNHSExit = #(playerCoords-NHSExitVector)
        Wait(100)
    end
end)