local RSGCore = exports['rsg-core']:GetCoreObject()
local SpawnedProps = {}
local isBusy = false
local mineAnimation = 'amb_work@world_human_pickaxe@wall@male_d@base'
local anim = 'base'

local LoadAnimDict = function(dict)
    local isLoaded = HasAnimDictLoaded(dict)
    while not isLoaded do
        RequestAnimDict(dict)
        Wait(0)
        isLoaded = not isLoaded
    end
end

---------------------------------------------
-- spawn rocks
---------------------------------------------
CreateThread(function()
    while true do
        Wait(150)

        local pos = GetEntityCoords(cache.ped)
        local InRange = false

        for i = 1, #Config.Rocks do
            local prop = vector3(Config.Rocks[i].x, Config.Rocks[i].y, Config.Rocks[i].z)
            local dist = #(pos - prop)
            if dist >= 50.0 then goto continue end

            local hasSpawned = false
            InRange = true

            for z = 1, #SpawnedProps do
                local p = SpawnedProps[z]

                if p.id == Config.Rocks[i].id then
                    hasSpawned = true
                end
            end

            if hasSpawned then goto continue end

            local modelHash = Config.Rocks[i].hash
            local data = {}
            
            if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                    Wait(1)
                end
            end
            
            data.obj = CreateObject(modelHash, Config.Rocks[i].x, Config.Rocks[i].y, Config.Rocks[i].z -1.8, false, false, false)
            SetEntityHeading(data.obj, Config.Rocks[i].h)
            SetEntityAsMissionEntity(data.obj, true)
            Wait(1000)
            FreezeEntityPosition(data.obj, true)
            SetModelAsNoLongerNeeded(data.obj)

            -- rock id
            data.id = Config.Rocks[i].id

            -- veg modifiy
            if Config.EnableVegModifier then
                
                local veg_modifier_sphere = 0
                
                if veg_modifier_sphere == nil or veg_modifier_sphere == 0 then
                    local veg_radius = 3.0
                    local veg_Flags =  1 + 2 + 4 + 8 + 16 + 32 + 64 + 128 + 256
                    local veg_ModType = 1
                    
                    veg_modifier_sphere = AddVegModifierSphere(Config.Rocks[i].x, Config.Rocks[i].y, Config.Rocks[i].z, veg_radius, veg_ModType, veg_Flags, 0)
                    
                else
                    RemoveVegModifierSphere(Citizen.PointerValueIntInitialized(veg_modifier_sphere), 0)
                    veg_modifier_sphere = 0
                end
            end

            SpawnedProps[#SpawnedProps + 1] = data
            hasSpawned = false

            -- create target for the entity
            exports['rsg-target']:AddTargetEntity(data.obj, {
                options = {
                    {
                        type = 'client',
                        event = 'rex-mining:client:minerock',
                        icon = "far fa-eye",
                        label = 'Mine Rock',
                        action = function()
                            TriggerEvent('rex-mining:client:minerock', data.id)
                        end
                    },
                },
                distance = 1.5
            })
            -- end of target

            ::continue::
        end

        if not InRange then
            Wait(5000)
        end
    end
end)

---------------------------------------------
-- check job / check pickaxe / do mining
---------------------------------------------
RegisterNetEvent('rex-mining:client:minerock', function(rockid)

    -- callback and get rock info
    RSGCore.Functions.TriggerCallback('rex-mining:server:getrockinfo', function(result)

        local propid = result[1].propid
        local proptype = result[1].proptype
        local active = result[1].active
        local yeld = result[1].yeld
        local Player = RSGCore.Functions.GetPlayerData()
        local job = Player.job.name
        local hasItem = RSGCore.Functions.HasItem('pickaxe')
        
        if active == 0 then
            lib.notify({ title = 'Already been mined!', duration = 7000, type = 'error' })
            return
        end

        -- check job
        if job ~= 'miner' then
            lib.notify({ title = 'You are not a miner!', duration = 7000, type = 'error' })
            return
        end

        -- check if you are busy
        if isBusy then
            lib.notify({ title = 'You are busy at the moment!', duration = 7000, type = 'error' })
            return
        end

        -- check pickaxe
        if not hasItem then
            lib.notify({ title = 'You need a pickaxe!', duration = 7000, type = 'error' })
            return
        end

        isBusy = true

        if not IsPedMale(cache.ped) then
            -- female ped
            local coords = GetEntityCoords(cache.ped)
            local boneIndex = GetEntityBoneIndexByName(cache.ped, 'SKEL_R_Finger00')
            local pickaxe = CreateObject(joaat('p_pickaxe01x'), coords, true, true, true)
            SetCurrentPedWeapon(cache.ped, "WEAPON_UNARMED", true)
            FreezeEntityPosition(cache.ped, true)
            ClearPedTasksImmediately(cache.ped)
            AttachEntityToEntity(pickaxe, cache.ped, boneIndex, -0.35, -0.21, -0.39, -8.0, 47.0, 11.0, true, false, true, false, 0, true)
            TriggerEvent('rex-mining:client:animation')
            Wait(20000)
            ClearPedTasksImmediately(cache.ped)
            FreezeEntityPosition(cache.ped, false)
            SetEntityAsNoLongerNeeded(pickaxe)
            DeleteEntity(pickaxe)
            TriggerServerEvent('rex-mining:server:giveyeld', propid, proptype, active, yeld)
        else
            -- male ped
            SetCurrentPedWeapon(cache.ped, "WEAPON_UNARMED", true)
            FreezeEntityPosition(cache.ped, true)
            ClearPedTasksImmediately(cache.ped)
            TaskStartScenarioInPlace(cache.ped, joaat('WORLD_HUMAN_PICKAXE_WALL'), 20000, true, false, false, false)
            Wait(20000)
            ClearPedTasksImmediately(cache.ped)
            FreezeEntityPosition(cache.ped, false)
            TriggerServerEvent('rex-mining:server:giveyeld', propid, proptype, active, yeld)
        end
        
        isBusy = false

    end, rockid)
end)

---------------------------------------------
-- used for female mining animation
---------------------------------------------
AddEventHandler('rex-mining:client:animation', function()
    LoadAnimDict(mineAnimation)
    while not HasAnimDictLoaded(mineAnimation) do
        Wait(100)
    end
    TaskPlayAnim(cache.ped, mineAnimation, anim, 3.0, 3.0, -1, 1, 0, false, false, false)
end)

---------------------------------------------
-- remove prop object
---------------------------------------------
RegisterNetEvent('rex-mining:client:removePropObject')
AddEventHandler('rex-mining:client:removePropObject', function(prop)
    for i = 1, #SpawnedProps do
        local o = SpawnedProps[i]

        if o.id == prop then
            SetEntityAsMissionEntity(o.obj, false)
            FreezeEntityPosition(o.obj, false)
            DeleteObject(o.obj)
        end
    end
end)

---------------------------------------------
-- update props
---------------------------------------------
RegisterNetEvent('rex-mining:client:updatePropData')
AddEventHandler('rex-mining:client:updatePropData', function(data)
    Config.Rocks = data
end)

---------------------------------------------
-- place prop
---------------------------------------------
RegisterNetEvent('rex-mining:client:placeNewProp')
AddEventHandler('rex-mining:client:placeNewProp', function(proptype, pHash, pos, heading)
    RSGCore.Functions.TriggerCallback('rex-mining:server:countprop', function(result)

        if CanPlacePropHere(pos) and not IsPedInAnyVehicle(PlayerPedId(), false) and not isBusy then
            isBusy = true
            TriggerServerEvent('rex-mining:server:newProp', proptype, pos, heading, pHash)
            isBusy = false
            return
        else
            lib.notify({ title = 'Can\'t Place Here', type = 'error', duration = 7000 })
        end

    end, proptype)

end)

---------------------------------------------
-- check to see if prop can be place here
---------------------------------------------
function CanPlacePropHere(pos)
    local canPlace = true

    local ZoneTypeId = 1
    local x,y,z =  table.unpack(GetEntityCoords(cache.ped))
    local town = Citizen.InvokeNative(0x43AD8FC02B429D33, x,y,z, ZoneTypeId)
    if town ~= false then
        canPlace = false
    end

    for i = 1, #Config.Rocks do
        local checkprops = vector3(Config.Rocks[i].x, Config.Rocks[i].y, Config.Rocks[i].z)
        local dist = #(pos - checkprops)
        if dist < 1.3 then
            canPlace = false
        end
    end
    return canPlace
end

---------------------------------------------
-- clean up
---------------------------------------------
AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    for i = 1, #SpawnedProps do
        local props = SpawnedProps[i].obj
        SetEntityAsMissionEntity(props, false)
        FreezeEntityPosition(props, false)
        DeleteObject(props)
    end
end)
