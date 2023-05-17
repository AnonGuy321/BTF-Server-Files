prefix = '^1[BTF TIPS]^4 '

BTFTips = 
{ 
    prefix.."^4Watch out, there is more recoil than usual in this city",
    prefix.."^4Support BTF discord.gg/btf5m for some cool VIP perks!",
    prefix.."^4Support BTF discord.gg/btf5m for some cool VIP perks!",
    prefix.."^4Support BTF discord.gg/btf5m for some cool VIP perks!",
    prefix.."^4Support BTF discord.gg/btf5m for some cool VIP perks!",
    prefix.."^4Press L to open your inventory",
    prefix.."^4KOS is only allowed at redzones!",
    prefix.."^4You can point with B",
    prefix.."^4You can make your minimap bigger with Z",
    prefix.."^4You can perform CPR on your dead friends, with a small chance of resuscitation",
    prefix.."^4You sell all legal goods (Copper,Gold etc..) at the Trader which is south of the map near the docks",
    prefix.."^4You can get your GP to take a look at you and restore your health at any Hospital",
    prefix.."^4Check out our Discord for whitelisted faction applications, discord.gg/btf5m",
    prefix.."^4Want to join the PD? Apply at discord.gg/btf5m",
    prefix.."^4Use /ooc or // to ask out of character questions",
    prefix.."^4To call an admin, type /calladmin",
    prefix.."^4To report a player you can create a player report on the support discord",
    prefix.."^4You can lock your car with the comma key [,]",
    prefix.."^4If you are experiencing texture loss set your Texture Quality to Normal in graphics settings!",
    prefix.."^4F6 to see your licenses",
    prefix.."^4F5 to see your gang menu",
    prefix.."^4F10 to see your past warnings/kicks/bans",
    prefix.."^4M for vehicle functions/control",
    prefix.."^4Join our discord for discussion & development news https://discord.gg/btf5m",
    prefix.."^4Join our discord for discussion & development news https://discord.gg/btf5m",
    prefix.."^4Join our discord for discussion & development news https://discord.gg/btf5m",
    prefix.."^4Join our discord for discussion & development news https://discord.gg/btf5m",
    prefix.."^4Press F1 for help on getting started, controls & rules",
    prefix.."^4Press F1 for help on getting started, controls & rules",
    prefix.."^4Press F1 for help on getting started, controls & rules",
    prefix.."^4Press F1 for help on getting started, controls & rules",
    prefix.."^4Join our discord to purchase custom cars & guns! https://discord.gg/btf5m",
    prefix.."^4Join our discord to purchase custom cars & guns! https://discord.gg/btf5m",
    prefix.."^4Join our discord to purchase custom cars & guns! https://discord.gg/btf5m",
    prefix.."^4Join our discord to purchase custom cars & guns! https://discord.gg/btf5m",
    prefix.."^4Join our discord to purchase custom cars & guns! https://discord.gg/btf5m",
    prefix.."^4Join our discord to purchase custom cars & guns! https://discord.gg/btf5m",
    prefix.."^4Join our discord to purchase custom cars & guns! https://discord.gg/btf5m",
    prefix.."^4Join our discord to purchase custom cars & guns! https://discord.gg/btf5m",
    prefix.."^4Join our discord to purchase custom cars & guns! https://discord.gg/btf5m",
    prefix.."^4Join our discord to purchase custom cars & guns! https://discord.gg/btf5m",
    prefix.."^4Remember, selling or advertising the sale of anything in out of character chat is not allowed!",
    prefix.."^4Remember, selling or advertising the sale of anything in out of character chat is not allowed!",
    prefix.."^4Remember, selling or advertising the sale of anything in out of character chat is not allowed!",
    prefix.."^4Remember, selling or advertising the sale of anything in out of character chat is not allowed!",
    prefix.."^4Remember, selling or advertising the sale of anything in out of character chat is not allowed!",
    prefix.."^4Check out the #how-to-play channel in our discord for a quick guide on getting ahead in the city!",
    prefix.."^4Check out the #how-to-play channel in our discord for a quick guide on getting ahead in the city!",
    prefix.."^4Check out the #how-to-play channel in our discord for a quick guide on getting ahead in the city!",
}


Citizen.CreateThread(function()
    Wait(100000)
    while true do
        math.randomseed(GetGameTimer())
        num = math.random(1,#BTFTips)
        TriggerEvent('chatMessage',"", {255, 51, 51}, "" .. BTFTips[num], "ooc")
        Wait(600000)
    end
end)
