function Crosshair(enable)
    SendNUIMessage({
      crosshair = enable
    })
  end
  
  RegisterNetEvent("BTF:PutCrossHairOnScreen")
  AddEventHandler("BTF:PutCrossHairOnScreen", function(bool)
    Crosshair(bool)
  end)