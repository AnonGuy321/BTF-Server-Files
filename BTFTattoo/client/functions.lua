-- Perform the movement on the nui
function MoveNui(value)
    SendNUIMessage({
        ui = "Keys",
        mover = value
    })
end

-- Create the icons on the map
function CreateIcons()
	for i, k in pairs(tattoosShops) do
		local BlipMap = AddBlipForCoord(k.coords.x, k.coords.y, k.coords.z)
		SetBlipSprite(BlipMap, 75)
		SetBlipColour(BlipMap, 1)
		SetBlipScale(BlipMap, 0.7)
		SetBlipAsShortRange(BlipMap, true)
		AddTextEntry("BlipMap", "Tattoo Shop")
		BeginTextCommandSetBlipName("BlipMap")
		AddTextComponentSubstringBlipName(BlipMap)
		EndTextCommandSetBlipName(BlipMap)
	end
end

-- Add or remove vector tattoos
function AddRemoveTattoo(add, vector, dlc, hash)
    local ped = PlayerPedId()
    ClearPedDecorations(ped)

    local indice = 1
    local found = false
    for i, k in pairs(vector) do
        if k.dlc == dlc and k.hash == hash then
            found = true
            indice = i
            break
        end
    end

    if add then
        if not found then
            table.insert(vector, {dlc=dlc,hash=hash})
        end
    else
        if found then
            table.remove(vector, indice)
        end
    end
end

-- Displays notifications on the nui
function ShowNotify(data, num, bool)
    SendNUIMessage({
        ui = "Added",
        dlc = data.mx.dlc,
        add = num,
    })

    SendNUIMessage({
        ui = "Info",
        dlc = data.mx.dlc,
        possui = bool
    })
end

-- Checks whether the player has the selected tattoo
function HasTattoo(dlc, hash)
    for i, k in pairs(update_tattoos) do
        if k.hash == hash and k.dlc == dlc then
            return true
        end
    end
    return false
end

-- Calculates the price of tattoos
function PriceTattoos(type, dlc)
    if type ~= "" then
        for h, j in pairs(tattoos_list) do 
            if dlc == j.dlc then
                if type == "+" then
                    tattoos_price = tattoos_price + j.price
                else
                    tattoos_price = tattoos_price - j.price
                end
            end
        end

        if tattoos_price < 0 then
            tattoos_price = 0
        end
    end
end

-- Complete registration
function RegisterTattoos()
    TriggerServerEvent("Mx :: RegisterTattoos", update_tattoos, tattoos_price, freetattoos)
    update_tattoos = {}

    local ped = PlayerPedId()
    ClearPedDecorations(ped)
end

-- Get the ped clothes
function PickUpCurrentClothes()
    CurrentClothes = {}

    local ped = PlayerPedId() 

    local clothing_trunk = GetPedDrawableVariation(ped, 3)
    local clothing_pants = GetPedDrawableVariation(ped, 4)
    local color_pants = GetPedTextureVariation(ped, 4)
    local clothing_shoes = GetPedDrawableVariation(ped, 6)
    local color_shoes = GetPedTextureVariation(ped, 6)
    local clothing_shirt = GetPedDrawableVariation(ped, 8)
    local color_shirt = GetPedTextureVariation(ped, 8)
    local clothing_jacket = GetPedDrawableVariation(ped, 11)
    local color_jacket = GetPedTextureVariation(ped, 11)
    local clothing_vest = GetPedDrawableVariation(ped, 9)
    local color_vest = GetPedTextureVariation(ped, 9)
    local clothing_schoolbag = GetPedDrawableVariation(ped, 5)
    local color_schoolbag = GetPedTextureVariation(ped, 5)
    local clothing_masks = GetPedDrawableVariation(ped, 1)
    local color_masks = GetPedTextureVariation(ped, 1)
    local item_hat = GetPedPropIndex(ped, 0)
    local color_hat = GetPedPropTextureIndex(ped, 0)
    local item_glasses = GetPedPropIndex(ped, 1)
    local color_glasses = GetPedPropTextureIndex(ped, 1)

    table.insert(CurrentClothes, { name = "Trunk", type = "Variation", item = 3, id = clothing_trunk, id_cor = 0 })                     
    table.insert(CurrentClothes, { name = "Pants", type = "Variation", item = 4, id = clothing_pants, id_cor = color_pants })           
    table.insert(CurrentClothes, { name = "Shoes", type = "Variation", item = 6, id = clothing_shoes, id_cor = color_shoes })           
    table.insert(CurrentClothes, { name = "Shirt", type = "Variation", item = 8, id = clothing_shirt, id_cor = color_shirt })           
    table.insert(CurrentClothes, { name = "Jacket", type = "Variation", item = 11, id = clothing_jacket, id_cor = color_jacket })        
    table.insert(CurrentClothes, { name = "Vest", type = "Variation", item = 9, id = clothing_vest, id_cor = color_vest })             
    table.insert(CurrentClothes, { name = "Bag", type = "Variation", item = 5, id = clothing_schoolbag, id_cor = color_schoolbag })   
    table.insert(CurrentClothes, { name = "Masks", type = "Variation", item = 1, id = clothing_masks, id_cor = color_masks })           
    table.insert(CurrentClothes, { name = "Hats", type = "Prop", item = 0, id = item_hat, id_cor = color_hat })                        
    table.insert(CurrentClothes, { name = "Glasses", type = "Prop", item = 1, id = item_glasses, id_cor = color_glasses } )               
end

-- Get the sex of the ped
function GetModel()
    local body_model = "male"
    local model_ped = GetEntityModel(PlayerPedId())
    if model_ped == GetHashKey("mp_f_freemode_01") then
        body_model = "female"
    end
    return body_model
end

-- Removes or Replaces the clothes on the ped
function HideClothes(ocultar, enable_opcao)
    if enable_opcao then
        local sexo = GetModel()
        local ped = PlayerPedId()

        if not ocultar then
            for i, k in pairs(CurrentClothes) do 
                if k.type == "Variation" then
                    SetPedComponentVariation(ped, k.item, k.id, k.id_cor) 
                elseif k.type == "Prop" then
                    SetPedPropIndex(ped, k.item, k.id, k.id_cor) 
                end
            end
        else
            PickUpCurrentClothes()

            for i, k in pairs(list_cloth) do 
                if k.type == "Variation" then
                    if sexo == 'male' then
                        SetPedComponentVariation(ped, k.item, k.male_id, 0, 0) 
                    else
                        SetPedComponentVariation(ped, k.item, k.female_id, 0, 0) 
                    end
                elseif k.type == "Prop" then
                    if sexo == 'male' then
                        SetPedPropIndex(ped, k.item, k.male_id, 0) 
                    else
                        SetPedPropIndex(ped, k.item, k.female_id, 0) 
                    end
                end
            end
        end
    end
end

-- Stock notify
function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(true, true)
end