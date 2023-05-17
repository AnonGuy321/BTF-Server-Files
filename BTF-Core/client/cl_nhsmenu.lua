RMenu.Add('BTFNHSMenu', 'main', RageUI.CreateMenu("BTF NHS", "~g~NHS Menu",1250,100))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('BTFNHSMenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = true, instructionalButton = true}, function()
            if IsPedInAnyVehicle(PlayerPedId(), false) == false then

                RageUI.Button("Perform Cardiopulmonary Resuscitation (CPR)" , "~b~Perform CPR on the nearest player in a coma", { RightLabel = '→'}, true, function(Hovered, Active, Selected) 
                    if Selected then 
                        TriggerServerEvent('BTF:PerformCPR')
                    end
                end)

                RageUI.Button("Heal Nearest Player", "~b~Heal the nearest player", { RightLabel = '→'}, true, function(Hovered, Active, Selected) 
                  if Selected then 
                      TriggerServerEvent('BTF:HealPlayer')
                  end
              end)
                

            end
        end)
    end
end)

RegisterCommand('nhs', function()
  if IsPedInAnyVehicle(PlayerPedId(), false) == false then
    TriggerServerEvent('BTF:OpenNHSMenu')
  end
end)

RegisterNetEvent("BTF:NHSMenuOpened")
AddEventHandler("BTF:NHSMenuOpened",function()
  RageUI.Visible(RMenu:Get('BTFNHSMenu', 'main'), not RageUI.Visible(RMenu:Get('BTFNHSMenu', 'main')))
end)

RegisterKeyMapping('nhs', 'Opens the NHS menu', 'keyboard', 'U')