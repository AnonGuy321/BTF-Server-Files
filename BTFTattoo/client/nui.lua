-- Open the nui
RegisterNetEvent("Mx :: OpenTattoos")
AddEventHandler("Mx :: OpenTattoos", function()
    if not opened then
        HideClothes(true, AutoHideClothes)
        opened = true
        update_tattoos = {table.unpack(my_tattoos)}
        SendNUIMessage({
            ui = "Interface",
            NuiOpen = true,
            list = tattoos_list,
            scale = scale, x = pos_x, y = pos_y,
            Texts_Nui = Texts_Nui,
        }) 
        Notify("~g~"..Texts.Open_Store)
    end
end)

-- Close the nui
function CloseNuiTattos()
    if opened then
        opened = false
        RegisterTattoos()
        SendNUIMessage({
            ui = "Interface",
            NuiOpen = false,
        }) 
        HideClothes(false, AutoHideClothes)
        Notify("~g~"..Texts.Close_Store)
    end
end

-- Closed shop (Finished)
RegisterNetEvent("Mx :: ClosedStore")
AddEventHandler("Mx :: ClosedStore", function(tattoos, money)
    if tattoos == -1 or num == -1 then
        Notify("~r~"..Texts.Without_money)
    else
        my_tattoos = {table.unpack(tattoos)}

        if not freetattoos then
            Notify("~g~"..Texts.Spent1.." "..Texts.Money_Symbol..""..tattoos_price.." "..Texts.Spent2)
        end
    end
    tattoos_price = 0
end)

-- Update the tattoos as you go through the store
RegisterNUICallback('UpdateTattoo', function(data, cb)
    local ped = PlayerPedId()
    ClearPedDecorations(ped)

    local dlc = data.mx.dlc
    local hash = data.mx.current
    local key = data.mx.key

    if hash ~= nil or hash == 'RemoverAll' then
        if dlc == 'RemoverAll' and hash == 'RemoverAll' then
            if key == "Enter" or key == "Delete" then
                update_tattoos = {}
            end
        else
            local Has = false
            if dlc == 'hair_degrade' then
                Has = HasTattoo(degrades[dlc][hash].dlc, degrades[dlc][hash].nameHash)
            else
                Has = HasTattoo(dlc, tattoosList[dlc][hash].nameHash)
            end
            
            ShowNotify(data, 0, false)
            if key == "Left" or key == "Right" then
                ShowNotify(data, 0, Has)
                if not Has then
                    if dlc == 'hair_degrade' then
                        ApplyPedOverlay(ped, GetHashKey(degrades[dlc][hash].dlc), GetHashKey(degrades[dlc][hash].nameHash))  
                    else
                        ApplyPedOverlay(ped, GetHashKey(dlc), GetHashKey(tattoosList[dlc][hash].nameHash))  
                    end 
                end  
            elseif key == "Enter" then
                if not Has then
                    ShowNotify(data, 1, false)
                    PriceTattoos("+", dlc)

                    if dlc == 'hair_degrade' then
                        AddRemoveTattoo(true, update_tattoos, degrades[dlc][hash].dlc, degrades[dlc][hash].nameHash)
                    else
                        AddRemoveTattoo(true, update_tattoos, dlc, tattoosList[dlc][hash].nameHash)
                    end
                end
            elseif key == "Delete" then
                ShowNotify(data, 2, false)
                PriceTattoos("-", dlc)

                if dlc == 'hair_degrade' then
                    AddRemoveTattoo(false, update_tattoos, degrades[dlc][hash].dlc, degrades[dlc][hash].nameHash)
                else
                    AddRemoveTattoo(false, update_tattoos, dlc, tattoosList[dlc][hash].nameHash)
                end
            end

            for i, k in pairs(update_tattoos) do
                ApplyPedOverlay(ped, GetHashKey(k.dlc), GetHashKey(k.hash))
            end
        end
    end
    cb('ok')
end)

