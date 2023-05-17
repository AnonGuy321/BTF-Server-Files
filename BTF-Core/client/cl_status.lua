local UserID = 0
local PlayerCount = 0

RegisterNetEvent('discord:getpermid2')
AddEventHandler('discord:getpermid2', function(UserID)
    SetDiscordAppId(1103817326970806313)
    SetDiscordRichPresenceAsset('big')
    SetDiscordRichPresenceAssetText('BTF')
    SetDiscordRichPresenceAssetSmallText('BTF British RP')
    SetDiscordRichPresenceAction(0, "Join BTF", "https://discord.gg/btf5m")
  --  SetDiscordRichPresenceAction(1, "Join BTF", "https://cfx.re/join/6qjbrd")
   -- SetRichPresence("[ID: " .. tostring(UserID) .. "] |" .. #GetActivePlayers() " /64")
end)






RegisterNetEvent('BTF:StartGetPlayersLoopCL')
AddEventHandler('BTF:StartGetPlayersLoopCL', function()
    StartLoop()
end)

RegisterNetEvent('BTF:ReturnGetPlayersLoopCL')
AddEventHandler('BTF:ReturnGetPlayersLoopCL', function(UserID, PlayerCount)
    UserID = UserID
    PlayerCount = PlayerCount
    SetRichPresence("[ID: "..UserID.."] | "..PlayerCount.." / 64")
end)

function StartLoop()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5000)
            TriggerServerEvent("BTF:StartGetPlayersLoopSV")
        end
    end)
end