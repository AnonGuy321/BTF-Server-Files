local InRangeGather = false
local InRangeProcess = false
local InRangeSell = false
local CanSeeMarker = false

-- [LSD Gather] --
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(500)

    if IsPlayerNearCoords(vector3(cfgdrugs.LSD.Gather.x,cfgdrugs.LSD.Gather.y,cfgdrugs.LSD.Gather.z), 30.0) then
      SetTextEntry_2("STRING")
      AddTextComponentString("Press [E] to gather Lysergic Acid")
      EndTextCommandPrint(1000, 1)
      if not InRangeGather then
        InRangeGather = true
        Citizen.CreateThread(function()
          while InRangeGather do
            Citizen.Wait(0)
            --alert("~w~Press ~INPUT_VEH_HORN~ to gather Lysergic Acid")
            if IsControlJustReleased(0, 51)  then
              if not pedinveh then
                Action = true
                local ped = PlayerPedId()
                RequestAnimDict("weapons@first_person@aim_rng@generic@projectile@thermal_charge@")
                while (not HasAnimDictLoaded("weapons@first_person@aim_rng@generic@projectile@thermal_charge@")) do Citizen.Wait(0) end
                TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_GARDENER_PLANT', false, true)
                exports.rprogress:Start("", 5000)
                ClearPedTasksImmediately(ped)

                BTFcfgdrugsServer.LSDGather()
                Action = false
              else
                BTF.notify({"~r~You cant gather Lysergic Acid while Driving!"})
              end
            end
          end
        end)
      end
    else
      InRangeGather = false
    end


    -- [LSD Process] --

    if IsPlayerNearCoords(vector3(cfgdrugs.LSD.Process.x,cfgdrugs.LSD.Process.y,cfgdrugs.LSD.Process.z), 30.0) then
      SetTextEntry_2("STRING")
      AddTextComponentString("Press [E] to process LSD")
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
              TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CLIPBOARD', false, true)

              exports.rprogress:Start("", 5000)
              BTFcfgdrugsServer.CanProcessLSD({}, function(canProcess, ketAmount)
                if canProcess and ketAmount then

                  local pid = PlayerPedId()
           


            

                  Citizen.Wait(1)

                  BTFcfgdrugsServer.ProcessLSD()

                  BTF.notify({"~w~Processed~g~ LSD~w~ 1."})
                  Action = false
                end
                if not canProcess then
                  BTF.notify({"~r~You do not have the required license."})
                  else 
                    if not ketAmount then
                      BTF.notify({"~r~You do not have enough Lysergic Acid."})
                    end
                end
              end)
              ClearPedTasks(ped, true)
            end
          end
        end)
      end
    else
      InRangeProcess = false
    end

    -- [LSD Seller] --

    if IsPlayerNearCoords(vector3(cfgdrugs.LSD.Sell.x,cfgdrugs.LSD.Sell.y,cfgdrugs.LSD.Sell.z), 100.0) then
      if not CanSeeMarker then
        CanSeeMarker = true
        Citizen.CreateThread(function()
          while CanSeeMarker do
            Citizen.Wait(0)
            -- Draw3DText(cfgdrugs.LSD.Sell.x,cfgdrugs.LSD.Sell.y,cfgdrugs.LSD.Sell.z, "Sell LSD")

            DrawMarker(2,  cfgdrugs.LSD.Sell.x,cfgdrugs.LSD.Sell.y,cfgdrugs.LSD.Sell.z+1 - 0.98, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 219, 0, 252, 150, true, true, 0, 0, 0, 0, 0)

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

            local v1 = vector3(cfgdrugs.LSD.Sell.x,cfgdrugs.LSD.Sell.y,cfgdrugs.LSD.Sell.z)

            if isInMenu == false then

            if isInArea(v1, 1.4) then 
                alert('Press ~INPUT_VEH_HORN~ to access ~b~LSD Seller')
                if IsControlJustPressed(0, 51) then 
                    currentAmmunition = k
                    RageUI.Visible(RMenu:Get("LSDMenu", "LSD Seller"), true)
                    isInMenu = true
                    currentAmmunition = k 
                end
            end
            end
            if isInArea(v1, 1.4) == false and isInMenu and k == currentAmmunition then
                RageUI.Visible(RMenu:Get("LSDMenu", "LSD Seller"), false)
                isInMenu = false
                currentAmmunition = nil
            end
        Citizen.Wait(0)
    end
end)


RMenu.Add('LSDMenu', 'LSD Seller', RageUI.CreateMenu("", "LSD Seller",1300, 50, "banners", "LSD"))

RageUI.CreateWhile(1.0, RMenu:Get('LSDMenu', 'LSD Seller'):SetPosition(1300, 50), nil, function()
  RageUI.IsVisible(RMenu:Get('LSDMenu', 'LSD Seller'), true, false, true, function()
    
    RageUI.Button("Sell LSD" , nil, {RightLabel = "~g~£50,000"}, true, function(Hovered, Active, Selected)
        if Selected then
            sellingLSDUnits()
        end
    end)

  end, function() end)

end)

function sellingLSDUnits()
    BTFcfgdrugsServer.SellLSD({tonumber(1)})
    return false
end

function isInArea(v, dis) 
    
  if #(GetEntityCoords(PlayerPedId(-1)) - v) <= dis then  
      return true
  else 
      return false
  end
end
