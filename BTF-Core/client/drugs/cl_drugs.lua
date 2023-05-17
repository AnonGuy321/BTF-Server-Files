BTFcfgdrugsClientT = {}
Tunnel.bindInterface("BTF_cfgdrugs",BTFcfgdrugsClientT)
Proxy.addInterface("BTF_cfgdrugs",BTFcfgdrugsClientT)
BTFcfgdrugsServer = Tunnel.getInterface("BTF_cfgdrugs","BTF_cfgdrugs")
BTF = Proxy.getInterface("BTF")

pedcoords = vector3(0,0,0)
pedinveh = false
Action = false

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(100)
    local ped = PlayerPedId()
    pedcoords = GetEntityCoords(ped)
    pedinveh = IsPedInAnyVehicle(ped, true)
  end
end)

function IsPlayerNearCoords(coords, radius)
  local distance = #(pedcoords - coords)
  if distance < (radius + 0.00001) then
    return true
  end
  return false
end

function alert(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0, 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(34,139,34, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

