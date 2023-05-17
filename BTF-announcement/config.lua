BTFAnnouncementConfig = {}
 
-- AUDIO --
BTFAnnouncementConfig.UseSound = true
BTFAnnouncementConfig.AudioName = "ROUND_ENDING_STINGER_CUSTOM"
BTFAnnouncementConfig.AudioRefrence = "CELEBRATION_SOUNDSET"
 
-- MESSAGE --
BTFAnnouncementConfig.TitleName = "BTF Announcement!"
BTFAnnouncementConfig.ShowTime = 20
BTFAnnouncementConfig.ErrorTitle = 'Error'
BTFAnnouncementConfig.ErrorTextPermissions = "You don't have enough permissions to execute this command."
BTFAnnouncementConfig.ErrorTextCharacterLimit = "Maximum characters reached for this style"
 
-- COMMAND --
BTFAnnouncementConfig.Command = "announce"
BTFAnnouncementConfig.CommandHelpText = "Make a server announcement"
BTFAnnouncementConfig.CommandStyleText = "style"
BTFAnnouncementConfig.CommandStyleHelp = "Select the style of announcement"
BTFAnnouncementConfig.CommandMessageText = "message"
BTFAnnouncementConfig.CommandMessageHelp = "Enter the message you'd like to to include within the announcement"
 
-- PERMISSIONS --
BTFAnnouncementConfig.UsingQBCore = false
BTFAnnouncementConfig.QBCorePermission = 'admin'
BTFAnnouncementConfig.AloudLicences = {
    'license:', -- Enter the licences of users that should have access to this command. This will be ignored if you're using QBCore.
    'xbl:',
    'live:',
    'discord:259797127012679691',
    'discord:746375095559127153',
    'fivem:Evn1',
    'license2:'
}
BTFAnnouncementConfig.DebugMode = false -- If this is set to true, the licence of the user that is trying to execute the command will show within the server console.