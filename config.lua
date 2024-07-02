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
Config.GoldRockProp      = 'mp_sca_rock_grp_l_03' -- rock prop goldore
Config.SliverRockProp    = 'mp_sca_rock_grp_l_03' -- rock prop silverore
Config.CopperRockProp    = 'mp_sca_rock_grp_l_03' -- rock prop copperore
Config.IronRockProp      = 'mp_sca_rock_grp_l_03' -- rock prop ironore

-- cronjob
Config.MiningCronJob = '0 * * * *' -- cronjob time (every hour = 0 * * * *) / (every 30 mins = */30 * * * *)
Config.ServerNotify  = true
