local comaAnim = {}
in_coma = false
local coma_left = 30
local secondsTilBleedout = 60   
local playerCanRespawn = false 
local calledNHS = false
local deathString = ""
local deathPosition
local notified = false
local killfeed = false
fullyComa = false
local comaAnim = {}
local DeathAnim = 50
local e = 0
local f = 300
local g = false
local i = 100
local n = 102
WeaponNames={}
WeaponSpawnCodes={}
local o=module("cfg/weapons")
local p={}
local q={}
Citizen.CreateThread(function()
    q=o.nativeWeaponModelsToNames
    for r,s in pairs(o.weapons)do 
        q[r]=s.name
    end
    for r,t in pairs(q)do 
        WeaponNames[GetHashKey(r)]=t
        p[GetHashKey(r)]=r
    end
end)
Citizen.CreateThread(function()
    while true do 
        if in_coma then
			if not calledNHS then
				if IsControlJustPressed(1, 51) then
					tBTF.notify('~g~NHS called to your approximate location')
                    TriggerEvent("BTF:DEATH_SCREEN_NHS_CALLED")
				end
			end
            DisableControlAction(0,323,true)
            DisableControlAction(0,182,true)
            DisableControlAction(0,37,true)
        end
        Wait(0) 
    end 
end)

AddEventHandler("BTF:countdownEnded",function()
    g = true
end)

Citizen.CreateThread(function()
    while true do 
      if IsDisabledControlJustPressed(0,38) then
        if g and in_coma then
            TriggerEvent("BTF:CLOSE_DEATH_SCREEN")
            TriggerServerEvent("BTF:PoliceCheck")
            TriggerServerEvent("BTF:RebelCheck")
            TriggerServerEvent("BTF:VIPCheck")
            TriggerServerEvent("BTF:getHouses")
            setRedzoneTimerDisabled(false)
            tBTF.respawnPlayer()
            DoScreenFadeIn(900)
            TriggerEvent("BTF:StartRespawnCam")
            TriggerEvent("BTF:OpenRespawnMenu")
        end
        Wait(1000)
      end
      Wait(0)
    end
end)


Citizen.CreateThread(function() -- coma thread
    Wait(500)
    exports.spawnmanager:setAutoSpawn(false)
    while true do
        Wait(0)
        local ped = GetPlayerPed(-1)
        local health = GetEntityHealth(ped)
        if IsEntityDead(GetPlayerPed(-1)) and not in_coma then --Wait for death check
            pbCounter = 100
            local plyCoords = GetEntityCoords(GetPlayerPed(-1),true)
            BTFserver.StoreWeaponsDead()
            BTFserver.Coma()
            TriggerEvent('BTF:IsInMoneyComa', true)
            TriggerServerEvent('BTF:InComa')
            BTFserver.MoneyDrop()
            TriggerEvent('BTF:5Seconds')
            TriggerServerEvent("Server:SoundToCoords", plyCoords.x, plyCoords.y, plyCoords.z, 60.0, "Untitled", 0.4);
            tBTF.ejectVehicle()
            in_coma = true
            TriggerServerEvent("BTF:getNumOfNHSOnline")
            TriggerEvent("btf:PlaySound", "dead")
            SendNUIMessage({action = in_coma})
            -- if GetActivePlayers() 
            if isPlayerInRedZone() then 
                secondsTilBleedout = 10
            end
            deathPosition = plyCoords
            local x,y,z = table.unpack(deathPosition)
            BTFserver.updatePos({x,y,z})
            BTFserver.updateHealth({0})
            Wait(250) --Need wait, otherwise will autorevive in next check
        end

        if DeathAnim <= 0  then --Been 10 seconds, proceed to play anim check 
            DeathAnim = 50 
            local entityDead = GetEntityHealth(GetPlayerPed(-1))
            while entityDead <= 100 do
                Wait(0)
                local x,y,z = tBTF.getPosition()
                NetworkResurrectLocalPlayer(x, y, z, GetEntityHeading(GetPlayerPed(-1)), true, true, false)
                entityDead = GetEntityHealth(GetPlayerPed(-1))
                fullyComa = true
            end
            SetEntityHealth(GetPlayerPed(-1), 102)
            SetEntityInvincible(GetPlayerPed(-1),true)
            comaAnim = getRandomComaAnimation()
            if not HasAnimDictLoaded(comaAnim.dict) then
                RequestAnimDict(comaAnim.dict)
                while not HasAnimDictLoaded(comaAnim.dict) do
                    Wait(0)
                end
            end
            TaskPlayAnim(GetPlayerPed(-1), comaAnim.dict, comaAnim.anim, 3.0, 1.0, -1, 1, 0, 0, 0, 0 )
        end

        if health > cfg.coma_threshold and in_coma then --Revive check
            if IsEntityDead(GetPlayerPed(-1)) then
                local x,y,z = tBTF.getPosition()
                NetworkResurrectLocalPlayer(x, y, z, GetEntityHeading(GetPlayerPed(-1)), true, true, false)
                Wait(0)
            end
        
            playerCanRespawn = false 
            tBTF.disableComa()
            DeathAnim = 50 

            SetEntityInvincible(GetPlayerPed(-1),false)
            ClearPedSecondaryTask(GetPlayerPed(-1))
            Citizen.CreateThread(function()
                Wait(500)
                ClearPedSecondaryTask(GetPlayerPed(-1))
                ClearPedTasks(GetPlayerPed(-1))
            end)    
        end 

        local health = GetEntityHealth(GetPlayerPed(-1))
        if health <= cfg.coma_threshold and not in_coma then 
            SetEntityHealth(GetPlayerPed(-1),0)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if in_coma then
            local playerPed = PlayerPedId()
            if not IsEntityDead(playerPed) then
                if comaAnim.dict == nil then
                    comaAnim = getRandomComaAnimation()
                end
                if not IsEntityPlayingAnim(playerPed,comaAnim.dict,comaAnim.anim,3)  then
                    if comaAnim.dict ~= nil then
                        if not HasAnimDictLoaded(comaAnim.dict) then
                            RequestAnimDict(comaAnim.dict)
                            while not HasAnimDictLoaded(comaAnim.dict) do
                                Wait(0)
                            end
                        end
                        TaskPlayAnim(playerPed, comaAnim.dict, comaAnim.anim, 3.0, 1.0, -1, 1, 0, 0, 0, 0 )
                    end
                end
            end
            if GetEntityHealth(playerPed) > cfg.coma_threshold then 
                tBTF.disableComa()
                if IsEntityDead(playerPed) then
                    local x,y,z = tBTF.getPosition()
                    NetworkResurrectLocalPlayer(x, y, z, GetEntityHeading(GetPlayerPed(-1)),true, true, false)
                    Wait(0)
                end
                tBTF.disableComa()
                DeathAnim = 50 
                deathString = ""
                SetEntityInvincible(playerPed,false)
                ClearPedSecondaryTask(playerPed) 
            end
        end
        Wait(0)
    end
end)







Citizen.CreateThread(function()
    while true do 
        if in_coma then
            secondsTilBleedout = secondsTilBleedout - 1
        end
        Wait(1000)
    end
end) 

Citizen.CreateThread(function()
    while DeathAnim <= 5 and DeathAnim >= 0 do
        Wait(1000)
        DeathAnim = DeathAnim - 1
    end
end) 

RegisterNetEvent("BTF:5Seconds")
AddEventHandler("BTF:5Seconds", function()
    DeathAnim = 5
    while DeathAnim <= 5 and DeathAnim >= 0 do
        Wait(1000)
        DeathAnim = DeathAnim - 1
    end
end)

function tBTF.respawnPlayer()

    DoScreenFadeOut(1000)
    Wait(1000)
    DoScreenFadeIn(500)
    exports.spawnmanager:spawnPlayer()
    playerCanRespawn = false 
    deathString = ""
  
    
    local ped = GetPlayerPed(-1)
    tBTF.reviveComa()
    tBTF.ClearWeapons()
end


function tBTF.disableComa()
    in_coma = false
    killfeed = false
end

function tBTF.isInComa()
    return in_coma
end

RegisterNetEvent("BTF:FixClient")
AddEventHandler("BTF:FixClient", function()
    local resurrectspamm = true
    Citizen.CreateThread(function()
        while true do 
            Wait(0)
            if resurrectspamm == true then
                DoScreenFadeOut(500)
                Citizen.Wait(500)
                NetworkSetVoiceActive(true)
                SetPlayerTalkingOverride(PlayerId(), true)
                fullyComa = false
                notified = false
                local ped = PlayerPedId()
                local x,y,z = GetEntityCoords(ped)
                respawnedrecent = false 
                NetworkResurrectLocalPlayer(x, y, z, true, true, false)
                Citizen.Wait(0)
                calledNHS = false
                ClearPedTasksImmediately(PlayerPedId())
                resurrectspamm = false
                in_coma = false
                killfeed = false
                EnableControlAction(0, 73, true)
                tBTF.stopScreenEffect(cfg.coma_effect)
                TriggerEvent("BTF:CLOSE_DEATH_SCREEN")
                DoScreenFadeIn(500)
                Citizen.Wait(500)
            end 
        end
    end)
end)

local L = {}
function tBTF.getKillerInfo()
    return L
end

RegisterNetEvent("BTF:getNumberOfDocsOnline",function(I)
    c = I
    e = 60000
    f = e / 1000
    i = 10
    l = GetGameTimer()
    CreateThread(function()
        local K = GetGameTimer()
        while tBTF.getKillerInfo().ready == nil do
            Wait(0)
        end
        local L = tBTF.getKillerInfo()
        local M = false
        if L.name == nil then
            M = true
        end
        g = false
        TriggerEvent("BTF:SHOW_DEATH_SCREEN", f, L.name or "N/A", L.user_id or "N/A", L.weapon or "N/A", M)
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsEntityDead(PlayerPedId()) then
            local s
            local PedKiller = GetPedSourceOfDeath(PlayerPedId())
            Q=GetPedCauseOfDeath(PlayerPedId())
            print("1" ..Q)
            R=WeaponNames[Q]
            if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
                Killer = NetworkGetPlayerIndexFromPed(PedKiller)
            elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
                Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
            end
            local distance = 0
            local a6 = false
            local az = tBTF.getPedServerId(PedKiller)
            if (Killer == PlayerId()) or (Killer == nil) then
                a6 = true
            else
                L.name = GetPlayerName(Killer)
                distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(PedKiller))
            end
            L.source = az
            L.user_id = tBTF.getPedServerId(PedKiller)
            L.weapon = tostring(R)
            L.ready = true

            if s == nil then
                s = "N/A"
            end
            if distance == nil then
                distance = "N/A"
            end
            if R == nil then
                R = ""
            end
            if not g and in_coma and killfeed then
                print("Killed in coma")
                TriggerServerEvent("BTF:onPlayerKilled", "finished off", tBTF.getPedServerId(PedKiller), s)
            else
                print("Killed normally")
                TriggerServerEvent("BTF:onPlayerKilled", "killed", tBTF.getPedServerId(PedKiller), R, a6, distance)
                killfeed = true
            end
            Killer = nil
            PedKiller = nil
            R = nil
        end
        while IsEntityDead(PlayerPedId()) do
            Citizen.Wait(0)
        end
        L = {}
    end
end)

RegisterCommand("kill", function(source, args, rawCommand)
    TriggerServerEvent("BTF:onPlayerKilled", "killed", 1, "WEAPON_SPAR17", false, 100)
end)

function tBTF.reviveComa()
    local ped = GetPlayerPed(-1)
    SetEntityInvincible(ped,false)
    tBTF.setRagdoll(false)
    tBTF.stopScreenEffect(cfg.coma_effect)
    SetEntityHealth(GetPlayerPed(-1), 200)
end

-- kill the player if in coma
function tBTF.killComa()
    if in_coma then
        coma_left = 0
    end
end

Citizen.CreateThread(function() -- disable health regen, conflicts with coma system
    while true do
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
        Wait(0)
    end
end)

function tBTF.varyHealth(variation)
    local ped = GetPlayerPed(-1)

    local n = math.floor(GetEntityHealth(ped)+variation)
    SetEntityHealth(ped,n)
end

function tBTF.reviveHealth()
    local ped = GetPlayerPed(-1)
    if GetEntityHealth(ped) == 102 then
        SetEntityHealth(ped,200)
    end
end

function tBTF.getHealth()
    return GetEntityHealth(GetPlayerPed(-1))
end

function tBTF.getArmour()
    return GetPedArmour(GetPlayerPed(-1))
end

function tBTF.setHealth(health)
    local n = math.floor(health)
    SetEntityHealth(GetPlayerPed(-1),n)
end

function tBTF.setArmour(armour)
    SetPedArmour(PlayerPedId(), armour)
end

function tBTF.setFriendlyFire(flag)
    local flag = true
    NetworkSetFriendlyFireOption(flag)
    SetCanAttackFriendly(GetPlayerPed(-1), flag, flag)
end

function tBTF.setPolice(flag)
    local flag = false
    local player = PlayerId()
    SetPoliceIgnorePlayer(player, not flag)
    SetDispatchCopsForPlayer(player, flag)
end

function getRandomComaAnimation()
-- --death emotes
    randomComaAnimations = {
        {"combat@damage@writheidle_a","writhe_idle_a"},
        {"combat@damage@writheidle_a","writhe_idle_b"},
        {"combat@damage@writheidle_a","writhe_idle_c"},
        {"combat@damage@writheidle_b","writhe_idle_d"},
        {"combat@damage@writheidle_b","writhe_idle_e"},
        {"combat@damage@writheidle_b","writhe_idle_f"},
        {"combat@damage@writheidle_c","writhe_idle_g"},
        {"combat@damage@rb_writhe","rb_writhe_loop"},
        {"combat@damage@writhe","writhe_loop"},
    }


    comaAnimation = {}
    
    math.randomseed(GetGameTimer())
    num = math.random(1,#randomComaAnimations)
    num = math.random(1,#randomComaAnimations)
    num = math.random(1,#randomComaAnimations)
    
    dict,anim = table.unpack(randomComaAnimations[num])
    comaAnimation["dict"] = dict
    comaAnimation["anim"] = anim
    -- print("GETTING CCOMA ANIM")
    --comaAnimation["dict"] = "combat@damage@writheidle_a"
    --comaAnimation["anim"] = "writhe_idle_a"
    --randomize this :)
    return comaAnimation
end

function DrawAdvancedTextOutline(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)

    SetTextEdge(1, 0, 0, 0, 255)

    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

function tBTF.getHealth()
    return GetEntityHealth(GetPlayerPed(-1))
  end