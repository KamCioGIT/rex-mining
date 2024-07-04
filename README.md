# RexshackGaming
- discord : https://discord.gg/YUV7ebzkqs
- youtube : https://www.youtube.com/@rexshack/videos
- tebex store : https://rexshackgaming.tebex.io/
- support me : https://ko-fi.com/rexshackgaming

# rex-mining
- For RSG RedM Framework : https://discord.gg/eW3ADkf4Af

# Dependancies
- rsg-core
- rsg-target
- ox_lib

# Installation:
- ensure that the dependancies are added and started
- items have already been added to rsg-core check you have the latest version
- images have already been added to rsg-core check you have the latest version
- add the following table to your database : rex-mining.sql
- add rex-mining to your resources folder

# Starting the resource:
- add the following to your server.cfg file : ensure rex-mining

# Add job
- add jobs to "\rsg-core\shared\jobs.lua"
```lua
    ['miner'] = {
        label = 'Miner',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Miner', payment = 3 },
        },
    },
```

# Commands Use (admin only)
```
- admin use command /creategoldnode (creates a gold mining node and saves to the database)
- admin use command /createsilvernode (creates a silver mining node and saves to the database)
- admin use command /createcoppernode (creates a copper mining node and saves to the database)
- admin use command /createironnode (creates a iron mining node and saves to the database)
```