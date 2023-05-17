
-- periodic player state update

local state_ready = false

AddEventHandler("playerSpawned",function() -- delay state recording
  state_ready = false
  
  Citizen.CreateThread(function()
    Citizen.Wait(30000)
    state_ready = true
  end)
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(BTFConfig.PlayerSavingTime)
    if IsPlayerPlaying(PlayerId()) and state_ready then
        local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
        BTFserver.updatePos({x,y,z})
        BTFserver.updateHealth({tBTF.getHealth()})
        BTFserver.updateArmour({GetPedArmour(PlayerPedId())})
        BTFserver.updateWeapons({tBTF.getWeapons()})
        BTFserver.updateCustomization({tBTF.getCustomization()})
        TriggerServerEvent('BTF:changeHairStyle')
        TriggerServerEvent('BTF:ChangeTattoos')
      
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(30000)
    BTFserver.UpdatePlayTime()
  end
end)

-- def
local weapon_types = {
  -- [Knives]
  "WEAPON_broom", 
  "WEAPON_dildo",
  "WEAPON_toiletbrush",
  "WEAPON_shank",
  -- [Pistol]
  "WEAPON_m1911",
  "WEAPON_beretta",
  "WEAPON_TEC9",
  "WEAPON_hawk",
  "WEAPON_PYTHON",
  "WEAPON_USPSKILLCONFIRMED",
  -- [SMG]
  'WEAPON_scorpianblue',
  'WEAPON_blackicepeacekeeper',
  "WEAPON_UMP45",
  -- [PD]
  "WEAPON_remington870",
  "WEAPON_mp5",
  "WEAPON_PDMCX",
  "WEAPON_PDHK416",
  "WEAPON_REMINGTON700",
  "WEAPON_GLOCK",
  "WEAPON_STUNGUN",
  "WEAPON_CQ300",
  "WEAPON_SPAR17",
  "WEAPON_M4SANDSTORM",
  -- [Rebel]
  "WEAPON_MOSIN",
  "WEAPON_m4a1",
  "WEAPON_m16a1",
  "WEAPON_pp",
  "WEAPON_MK1EMR",
  "WEAPON_MXM",
  "WEAPON_MXC",
  "WEAPON_saige",
  "WEAPON_SVD",
  "WEAPON_AK200",
  "WEAPON_COMBATPISTOL",
  "WEAPON_SPAR16",
  -- [Light Arms]
  "WEAPON_goldendeagle",
  "WEAPON_mac10",
  "WEAPON_olympia", 
  "WEAPON_usps",
  -- [Large Arms]
  "WEAPON_akm",
  "WEAPON_AX50",
  "WEAPON_PHANTOM",
  "WEAPON_CMPCARBINE",
  "WEAPON_ODIN",
  "WEAPON_SPACEFLIGHTMP5",
  "WEAPON_WESTYARES",
  "WEAPON_vesper",
  "WEAPON_aks74u",
  "WEAPON_mp7",
  "WEAPON_mp40",
  "WEAPON_winchester",
  "WEAPON_SAGIRI",
  "WEAPON_DIAMONDMP5",
  "WEAPON_GOLDAK",
  "WEAPON_FNTACSHOTGUN",
  "WEAPON_AK74",
  -- SAME AS REBEL ATM
  "WEAPON_NERFMOSIN",
  "WEAPON_NEONOIRMAC10",
  "WEAPON_BLASTXPHANTOM",
  "WEAPON_GRAU556",
  "WEAPON_CHERRYMOSIN",
  "WEAPON_M4A4FIRE",
  "WEAPON_PURPLEVANDAL",
  "WEAPON_RUSTAK",
  "WEAPON_REAVEROP",
  "WEAPON_HKJAMO",
  "WEAPON_ICEVECTOR",
  "WEAPON_MEDSWORD",
  "WEAPON_UMPV2NEONOIR",
  "WEAPON_PRIMEVANDAL",
  "WEAPON_L96A3",
  "WEAPON_SA80",
  "WEAPON_M16A1PD",
  "WEAPON_RGXVANDAL",
  "WEAPON_MP9PD",
  "WEAPON_SABERVADER",
  "WEAPON_NOVMOSIN",
}

function tBTF.getWeaponTypes()
  return weapon_types
end

function tBTF.getWeapons()
  local player = GetPlayerPed(-1)

  local ammo_types = {} -- remember ammo type to not duplicate ammo amount

  local weapons = {}
  for k,v in pairs(weapon_types) do
    local hash = GetHashKey(v)
    if HasPedGotWeapon(player,hash) then
      local weapon = {}
      weapons[v] = weapon

      local atype = Citizen.InvokeNative(0x7FEAD38B326B9F74, player, hash)
      if ammo_types[atype] == nil then
        ammo_types[atype] = true
        weapon.ammo = GetAmmoInPedWeapon(player,hash)
      else
        weapon.ammo = 0
      end
    end
  end

  return weapons
end

function tBTF.giveWeapons(weapons,clear_before)
  local player = GetPlayerPed(-1)

  -- give weapons to player

  if clear_before then
    RemoveAllPedWeapons(player,true)
  end

  for k,weapon in pairs(weapons) do
    local hash = GetHashKey(k)
    local ammo = weapon.ammo or 0
    tBTF.allowWeapon(k)
    GiveWeaponToPed(player, hash, ammo, false)
  end
end

function tBTF.giveWeaponAmmo(hash, amount)
  SetPedAmmo(PlayerPedId(), hash, amount)
end

-- PLAYER CUSTOMIZATION

-- parse part key (a ped part or a prop part)
-- return is_proppart, index
local function a(b)
  if type(b)=="string"and string.sub(b,1,1)=="p"then 
      return true,tonumber(string.sub(b,2))
  else return false,tonumber(b)
  end 
end;
function tBTF.getDrawables(c)
  local d,e=a(c)
  if d then 
      return GetNumberOfPedPropDrawableVariations(PlayerPedId(),e)
  else 
      return GetNumberOfPedDrawableVariations(PlayerPedId(),e)
  end 
end;
function tBTF.getDrawableTextures(c,f)
  local d,e=a(c)
  if d then 
      return GetNumberOfPedPropTextureVariations(PlayerPedId(),e,f)
  else 
      return GetNumberOfPedTextureVariations(PlayerPedId(),e,f)
  end 
end;
function tBTF.getCustomization()
  local g=PlayerPedId()
  local h={}
  h.modelhash=GetEntityModel(g)
  for i=0,20 do 
      h[i]={GetPedDrawableVariation(g,i),GetPedTextureVariation(g,i),GetPedPaletteVariation(g,i)}
  end;
  for i=0,10 do 
      h["p"..i]={GetPedPropIndex(g,i),math.max(GetPedPropTextureIndex(g,i),0)}
  end;
  return h 
end;
function tBTF.setCustomization(h,j,k)
  if h then 
      local g=PlayerPedId()
      local l=nil;
      if h.modelhash~=nil then 
          l=h.modelhash 
      elseif h.model~=nil then 
          l=GetHashKey(h.model)
      end;
      local m=loadModel(l)
      local n=GetEntityModel(g)
      if m then 
          if n~=m or j then 
              local o=tBTF.getWeapons()
              local p=GetEntityHealth(g)
              SetPlayerModel(PlayerId(),l)
              Wait(0)
              tBTF.giveWeapons(o,true)
              if k==nil or k==false then 
                  tBTF.setHealth(p)
              end;
              SetModelAsNoLongerNeeded(l)
              TriggerServerEvent("BTF:reapplyFaceData")
              g=PlayerPedId()
          end;
          for q,r in pairs(h)do 
              if q~="model"and q~="modelhash"then 
                  if tonumber(q)then 
                      q=tonumber(q)
                  end;
                  local d,e=a(q)
                  if d then 
                      if r[1]<0 then 
                          ClearPedProp(g,e)
                      else 
                          SetPedPropIndex(g,e,r[1],r[2],r[3]or 2)
                      end 
                  else 
                      SetPedComponentVariation(g,e,r[1],r[2],r[3]or 2)
                  end 
              end 
          end 
      end 
  end 
end

RegisterNetEvent('checkAmmo')
AddEventHandler('checkAmmo', function()
    if IsPedArmed(PlayerPedId(), 4) then 
        TriggerServerEvent('sendAmmo', true)
    else
        TriggerServerEvent('sendAmmo', false)
    end
end)