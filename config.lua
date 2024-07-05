Config = Config or {}
Config.Rocks = {}

---------------------------------------------
-- deploy prop settings
---------------------------------------------
Config.ForwardDistance   = 1.5
Config.PromptGroupName   = 'Place Rock'
Config.PromptCancelName  = 'Cancel'
Config.PromptPlaceName   = 'Place'
Config.PromptRotateLeft  = 'Rotate Left'
Config.PromptRotateRight = 'Rotate Right'

---------------------------------------------
-- settings
---------------------------------------------
Config.EnableVegModifier = true -- if set true clears vegetation
Config.GoldRockProp   = `mp_sca_rock_grp_l_03` -- rock prop goldore
Config.SilverRockProp = `mp_sca_rock_grp_l_03` -- rock prop silverore
Config.IronRockProp   = `mp_sca_rock_grp_l_03` -- rock prop ironore
Config.CopperRockProp = `mp_sca_rock_grp_l_03` -- rock prop copperore
Config.CoalRockProp   = `mp_sca_rock_grp_l_03` -- rock prop coal
Config.GemChance      = 5 -- 5% chance of getting a gem

-- cronjob
Config.MiningCronJob = '0 * * * *' -- cronjob time (every hour = 0 * * * *) / (every 30 mins = */30 * * * *)
Config.ServerNotify  = false

-- gem types rewards
Config.GemTypes = {
    'diamond',
    'ruby',
    'emerald',
    'opal',
    'sapphire'
}
