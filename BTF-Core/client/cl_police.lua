local isInPolice = false
local currentAmmunition = nil
local currentGunHash = nil
local currentGunPrice = nil
local currentGunName = nil
local currentGunHash1 = nil
local currentGunPrice1 = nil
local currentGunName1 = nil
returnedPDsmallGuns2 = {}

RMenu.Add('pdsmall', 'main', RageUI.CreateMenu("", "~g~BTF Police Armoury", 1300, 50, "banners", "police"))
RMenu.Add("pdsmall", "sub", RageUI.CreateSubMenu(RMenu:Get("pdsmall", "main"), "", "~g~BTF Police Armoury", 1300, 50, "banners", "police"))
RMenu.Add("pdsmall", "whitelistedguns", RageUI.CreateSubMenu(RMenu:Get("pdsmall", "main"), "", "~g~BTF Police Armoury", 1300, 50, "banners", "police"))
RageUI.CreateWhile(1.0, RMenu:Get('pdsmall', 'main'), nil, function()
    RageUI.IsVisible(RMenu:Get('pdsmall', 'main'), true, false, true, function()
        for i , p in pairs(police.guns) do 
            RageUI.Button(p.name , nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Active then
                    currentGunHash = nil
                end
                if Selected then
                    currentGunHash = p.hash
                    currentGunPrice = p.price
                    currentGunName = p.name
                end
            end, RMenu:Get("pdsmall", "sub"))
        end
        for i , w in pairs(returnedPDsmallGuns2) do 
            RageUI.Button(w.name , nil, {RightLabel = '→→→'}, true, function(Hovered, Active, Selected)
                if Active then
                    currentGunHash1 = nil
                end
                if Selected then
                    currentGunHash1 = w.gunhash
                    currentGunPrice1 = w.price
                    currentGunName1 = w.name
                end
            end,RMenu:Get("pdsmall", "whitelistedguns"))
        end
    end, function()
    end)
    RageUI.IsVisible(RMenu:Get("pdsmall", "sub"), true, false, true, function()
        RageUI.Button("Purchase Weapon Body" , "Purchase "..currentGunName.." and Max Ammo", { RightLabel = "~g~£"..tostring(getMoneyStringFormatted(currentGunPrice)) }, true, function(Hovered, Active, Selected)
            if Selected then
                local Ped = PlayerPedId()
                if HasPedGotWeapon(Ped, currentGunHash, false) then
                    notify("~r~You already have this weapon equipped.")
                else
                TriggerServerEvent("Polices:buywap", currentGunHash)
                end
            end
        end)
     if  currentGunHash ~= "WEAPON_FLASHLIGHT" or currentGunHash ~= "WEAPON_NIGHTSTICK" or currentGunHash ~= "WEAPON_STUNGUN" or currentGunHash ~= "WEAPON_SPEEDGUN" then 
        RageUI.Button("Buy Max Ammo", "Purchase Max Ammo for "..currentGunName, {  RightLabel = "~g~£"..tostring(getMoneyStringFormatted(math.floor(currentGunPrice / 2))) }, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent("Polices:BuyWeaponAmmo", currentGunHash)
            end
        end)
       end
    end, function()
 end)
    
    RageUI.IsVisible(RMenu:Get("pdsmall", "whitelistedguns"), true, false, true, function()
        RageUI.Button("Purchase Weapon Body" , "Purchase "..currentGunName1.." and Max Ammo", {  RightLabel = "~g~£"..tostring(getMoneyStringFormatted(math.floor(currentGunPrice1))) }, true, function(Hovered, Active, Selected)
            if Selected then
                local Ped = PlayerPedId()
                if HasPedGotWeapon(Ped, currentGunHash1, false) then
                    notify("~r~You already have this weapon equipped.")
                else
                TriggerServerEvent("Polices:buyWLwap", currentGunHash1)
                end
            end
        end)
    
        RageUI.Button("Buy Max Ammo", "Purchase Max Ammo for "..currentGunName1, {  RightLabel = "~g~£"..tostring(getMoneyStringFormatted(math.floor(currentGunPrice1 / 2))) }, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent("Polices:BuyWLWeaponAmmo", currentGunHash1)
                 end
             end)
        end, function()
    end)
end)

RegisterNetEvent("PDSMALL:GUNSRETURNED")
AddEventHandler("PDSMALL:GUNSRETURNED", function(table)
    returnedPDsmallGuns2 = table 
end)

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(0)
        for k, v in pairs(police.armourshops) do 
            if isInArea(v, 1.4) then
                alert('Press ~INPUT_VEH_HORN~ to get Kelver')
                if IsControlJustPressed(0, 51) then 
                    TriggerServerEvent('Police:buyarmour', 0 , 100)
                end
            end
        end
    end
end)


Citizen.CreateThread(function()
    while true do
    Citizen.Wait(0)
        for k, v in pairs(police.armourshops) do 
            if #(vec(v.x,v.y,v.z+1 - 0.98) - GetEntityCoords(PlayerPedId())) < 10.5 then
                DrawMarker(20, v, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.6, 0.6, 0.6, 0, 0, 255, 60, 0, 1, 2, 0, 0, 0, false) 
            end
        end
   end
end)


RegisterNetEvent('Polices:menu')
AddEventHandler('Polices:menu', function()
    RageUI.Visible(RMenu:Get("pdsmall", "main"))
    alert('~r~Insufficent funds')
end)


Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(0)
        for k, v in pairs(police.gunshops) do
            if currentGunHash ~= nil or currentGunHash1 ~= nil then
                for k,v in pairs(weaponmodels.models) do 
                    if currentGunHash == v[1] or currentGunHash1 == v[1] then
                        model = k
                    end
                end
                local N=loadModel(model)
                local O=CreateObject(N,v.x,v.y,v.z+0.1,false,false,false)
                while currentGunHash ~= nil or currentGunHash1 ~= nil and DoesEntityExist(O)do 
                    SetEntityHeading(O,GetEntityHeading(O)+1%360)
                    Wait(0)
                end
                DeleteEntity(O)
            end 
            if isInArea(v, 100.0) then 
                DrawMarker(27, v.x,v.y,v.z - 0.999999, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 2.5, 0, 170, 255, 250, 0, 0, 2, 0, 0, 0, false)
            end
            if isInPolice == false then
            if isInArea(v, 1.4) then 
                alert('Press ~INPUT_VEH_HORN~ to access Police Armoury')
                if IsControlJustPressed(0, 51) then 
                    TriggerServerEvent("PDSMALL:PULLWHITELISTEDWEAPONS")
                    currentAmmunition = k
                    RageUI.Visible(RMenu:Get("pdsmall", "main"), true)
                    isInPolice = true
                    currentAmmunition = k 
                end
            end
            end
            if isInArea(v, 1.4) == false and isInPolice and k == currentAmmunition then
                RageUI.Visible(RMenu:Get("pdsmall", "main"), false)
                RageUI.Visible(RMenu:Get("pdsmall", "sub"), false)
                RageUI.Visible(RMenu:Get("pdsmall", "whitelistedguns"), false)
                isInPolice = false
                currentAmmunition = nil
                currentGunHash = nil
                currentGunPrice = nil
                currentGunName = nil
                currentGunHash1 = nil
                currentGunPrice1 = nil
                currentGunName1 = nil
            end
        end
    end
end)

BTFclient = Proxy.getInterface("BTF")
RegisterNetEvent("Polices:givewap")
AddEventHandler("Polices:givewap", function(hash)
    BTFclient.allowWeapon({hash, "-1"})
    GiveWeaponToPed(PlayerPedId(), hash, 250, false, false, 0)
end)

RegisterNetEvent("Polices:givearmour")
AddEventHandler("Polices:givearmour", function(level) 
    SetPedArmour(PlayerPedId(), level)
end)

function isInArea(v, dis) 
    
    if #(GetEntityCoords(PlayerPedId(-1)) - v) <= dis then  
        return true
    else 
        return false
    end
end

function alert(msg) 
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end
