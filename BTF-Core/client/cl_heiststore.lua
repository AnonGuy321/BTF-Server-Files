local cfg = module("BTF-Core", "cfg/cfg_stores")
local inMenu = false
local currentShop = nil
local currentItemID = nil
local currentItemPrice = nil
local currentItemName = nil
local maxAmount = {}
local amount = 1

for i = 1, 100 do
    table.insert(maxAmount, i)
end

RMenu.Add("BTF:HeistShops", "main", RageUI.CreateMenu("Heist Store", "~b~Heist Store", 1350, 50))
RMenu.Add("BTF:HeistShops", "sub", RageUI.CreateSubMenu(RMenu:Get("BTF:HeistShops", "main"), "Heist Store", "~b~Confirm Purchase", 1350, 50))

RageUI.CreateWhile(1.0, RMenu:Get("BTF:HeistShops", "main"), nil, function()
    RageUI.IsVisible(RMenu:Get("BTF:HeistShops", "main"), true, false, true, function()
        for k, v in pairs(cfg.items) do
            if v.type == 'robbery' then
                RageUI.Button(v.name, nil, {RightLabel = "£"..getMoneyStringFormatted(v.price)}, true, function(Hovered, Active, Selected)
                    if Selected then
                        currentItemID = v.itemID
                        currentItemPrice = v.price
                        currentItemName = v.name
                    end
                end, RMenu:Get("BTF:HeistShops", "sub", true))
            end
        end
    end, function() 
    end)

    RageUI.IsVisible(RMenu:Get("BTF:HeistShops", "sub"), true, false, true, function()
        RageUI.List("Amount", maxAmount, amount, nil, {}, true, function(Hovered, Active, Selected, Index)
            amount = Index
        end)
        if currentItemName == 'Jewellery' then
            RageUI.Button("~g~Confirm Sale", nil, {RightLabel = "£"..getMoneyStringFormatted(currentItemPrice * amount)}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("BTF:SellHeistItem", currentItemID, amount)
                end
            end, RMenu:Get("BTF:HeistShops", "main", true))
        else
            RageUI.Button("~g~Confirm Purchase", nil, {RightLabel = "£"..getMoneyStringFormatted(currentItemPrice * amount)}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("BTF:BuyHeistItem", currentItemID, amount)
                end
            end, RMenu:Get("BTF:HeistShops", "main", true))
        end

    end, function()
    end)
end)

Citizen.CreateThread(function()

    v = vector3(707.03851318359,-966.29754638672,30.412847518921)
    local blip = AddBlipForCoord(v)
    SetBlipSprite(blip, 363)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 26)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Heist Store")
    EndTextCommandSetBlipName(blip)
    
    while true do
        Citizen.Wait(0)
        if isInArea(v, 5) then
            DrawMarker(31, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 0, 255, 60, false, true, 2, true)
        end

        if isInArea(v, 1.0) and inMenu == false then
            alert('~r~Press ~INPUT_VEH_HORN~ to open the Heist Store!')
            if IsControlJustPressed(0, 51) then 
                inMenu = true
                currentShop = k
                RageUI.Visible(RMenu:Get("BTF:HeistShops", "main"), true)
            end
        end

        if isInArea(v, 1.0) == false and inMenu and k == currentShop then
            inMenu = false
            currentShop = nil
            currentItemID = nil
            currentItemPrice = nil
            currentItemName = nil
            RageUI.CloseAll()
        end
    end
end)

function isInArea(v, dis) 
    if #(GetEntityCoords(PlayerPedId()) - v) <= dis then  
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

function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end
