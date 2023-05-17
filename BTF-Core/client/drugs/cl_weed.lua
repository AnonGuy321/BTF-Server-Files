local InRangeGather = false
local InRangeProcess = false
local InRangeSell = false
local CanSeeMarker = false

-- [Weed Gather] --
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10)

    if IsPlayerNearCoords(vector3(cfgdrugs.Weed.Gather.x,cfgdrugs.Weed.Gather.y,cfgdrugs.Weed.Gather.z), 15.0) then
      SetTextEntry_2("STRING")
      AddTextComponentString("Press [E] to gather Cannabis Sativa")
      EndTextCommandPrint(1000, 1)
      if not InRangeGather then
        InRangeGather = true
        Citizen.CreateThread(function()
          while InRangeGather do
            Citizen.Wait(0)
     
            if IsControlJustReleased(0, 51)  then
              if not pedinveh then
                Action = true
                local ped = PlayerPedId()

                TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_KNEEL', false, true)
                exports.rprogress:Start("", 5000)
                ClearPedTasksImmediately(ped)
      
                BTFcfgdrugsServer.WeedGather ()
                Action = false
              else
                BTF.notify({"~r~You cant gather Weed while Driving!"})
              end
            end
          end
        end)
      end
    else
      InRangeGather = false
    end


    -- [Weed Process] --

    if IsPlayerNearCoords(vector3(cfgdrugs.Weed.Process.x,cfgdrugs.Weed.Process.y,cfgdrugs.Weed.Process.z), 25) then
      SetTextEntry_2("STRING")
      AddTextComponentString("Press [E] to process Weed")
      EndTextCommandPrint(1000, 1)
      if not InRangeProcess then
        InRangeProcess = true
        Citizen.CreateThread(function()
          while InRangeProcess do
            Citizen.Wait(0)
  
            
            if IsControlJustReleased(0, 51)  then
              Action = true
              local ped = PlayerPedId()

              RequestAnimDict("weapons@first_person@aim_rng@generic@projectile@thermal_charge@")
              while (not HasAnimDictLoaded("weapons@first_person@aim_rng@generic@projectile@thermal_charge@")) do Citizen.Wait(0) end
              TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_GARDENER_PLANT', false, true)
              exports.rprogress:Start("", 5000)
              BTFcfgdrugsServer.CanProcessWeed({}, function(canProcess, ketAmount)
                if canProcess and ketAmount then

          


                  BTFcfgdrugsServer.ProcessWeed()

                  BTF.notify({"~w~Processed~g~ Weed~w~ 1."})
                  Action = false
                end
                if not canProcess then
                  BTF.notify({"~r~You do not have the required license."})
                  else
                    if not ketAmount then
                      BTF.notify({"~r~You do not have enough Cannabis Sativa."})
                    end
                end
              end)
              ClearPedTasksImmediately(ped)
            end
          end
        end)
      end
    else
      InRangeProcess = false
    end

    -- [Weed Seller] --

    if IsPlayerNearCoords(vector3(cfgdrugs.Weed.Sell.x,cfgdrugs.Weed.Sell.y,cfgdrugs.Weed.Sell.z), 100.0) then
      if not CanSeeMarker then
        CanSeeMarker = true
        Citizen.CreateThread(function()
          while CanSeeMarker do
            Citizen.Wait(0)
            -- Draw3DText(cfgdrugs.Weed.Sell.x,cfgdrugs.Weed.Sell.y,cfgdrugs.Weed.Sell.z, "Sell Weed")

            DrawMarker(2,  cfgdrugs.Weed.Sell.x,cfgdrugs.Weed.Sell.y,cfgdrugs.Weed.Sell.z+1 - 0.98, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 0, 255, 13, 150, true, true, 0, 0, 0, 0, 0)

          end
        end)
      end
    else
      CanSeeMarker = false
    end
  end
end)

local isInMenu = false
local currentAmmunition = nil
Citizen.CreateThread(function() 
    while true do

            local v1 = vector3(cfgdrugs.Weed.Sell.x,cfgdrugs.Weed.Sell.y,cfgdrugs.Weed.Sell.z)

            if isInMenu == false then

            if isInArea(v1, 1.4) then 
                alert('Press ~INPUT_VEH_HORN~ to access ~g~Weed Seller')
                if IsControlJustPressed(0, 51) then 
                    currentAmmunition = k
                    RageUI.Visible(RMenu:Get("WeedMenu", "Weed Seller"), true)
                    isInMenu = true
                    currentAmmunition = k 
                end
            end
            end
            if isInArea(v1, 1.4) == false and isInMenu and k == currentAmmunition then
                RageUI.Visible(RMenu:Get("WeedMenu", ""), false)
                isInMenu = false
                currentAmmunition = nil
            end
        Citizen.Wait(0)
    end
end)


RMenu.Add('WeedMenu', 'Weed Seller', RageUI.CreateMenu("", "~g~Weed Seller",1300, 50, "banners", "weed"))

RageUI.CreateWhile(1.0, RMenu:Get('WeedMenu', 'Weed Seller'):SetPosition(1300, 50), nil, function()
  RageUI.IsVisible(RMenu:Get('WeedMenu', 'Weed Seller'), true, false, true, function()
    
    RageUI.Button("Sell Weed" , nil, {RightLabel = "~g~£2,500"}, true, function(Hovered, Active, Selected)
        if Selected then
            sellingWeedUnits()
        end
    end)

  end, function() end)

end)

function sellingWeedUnits()
    BTFcfgdrugsServer.SellWeed({tonumber(1)})
    return false
end

function isInArea(v, dis) 
    
  if #(GetEntityCoords(PlayerPedId(-1)) - v) <= dis then  
      return true
  else 
      return false
  end
end

