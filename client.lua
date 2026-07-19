--[[
    map-hud — health, shield (armor), waypoint distance + ETA
    (default circular GTA minimap — no custom square box)
]]

local isVisible = true
local lastKey = ''

local function setVisible(show)
    if isVisible == show then
        return
    end
    isVisible = show
    SendNUIMessage({ action = 'visible', show = show })
end

local function getWaypoint()
    local blip = GetFirstBlipInfoId(8) -- waypoint
    if not DoesBlipExist(blip) then
        return nil
    end
    local coords = GetBlipInfoIdCoord(blip)
    if not coords or (coords.x == 0.0 and coords.y == 0.0) then
        return nil
    end
    return coords
end

local function formatDistance(meters)
    local miles = meters / 1609.344
    if miles < 0.1 then
        local feet = meters * 3.28084
        return string.format('%.0f ft', feet)
    end
    if miles < 10 then
        return string.format('%.1f mi', miles)
    end
    return string.format('%.0f mi', miles)
end

local function formatEta(seconds)
    if seconds == nil or seconds < 0 then
        return '--:--'
    end
    if seconds < 60 then
        return string.format('0:%02d', math.floor(seconds))
    end
    local m = math.floor(seconds / 60)
    local s = math.floor(seconds % 60)
    if m >= 60 then
        local h = math.floor(m / 60)
        m = m % 60
        return string.format('%d:%02d:%02d', h, m, s)
    end
    return string.format('%d:%02d', m, s)
end

local function estimateEtaSeconds(meters, speedMs)
    local minCruise = 8.0
    local useSpeed = speedMs
    if useSpeed < 2.5 then
        useSpeed = minCruise
    end
    return meters / useSpeed
end

CreateThread(function()
    Wait(500)
    setVisible(true)

    while true do
        local ped = PlayerPedId()
        local pause = IsPauseMenuActive()

        local hideRadar = false
        if GetResourceState('bsrp') == 'started' then
            local ok, loaded = pcall(function()
                return exports.bsrp:IsPlayerLoaded()
            end)
            if ok and not loaded then
                hideRadar = true
            end
        end

        if pause or IsPlayerDead(PlayerId()) or hideRadar then
            setVisible(false)
            if hideRadar then DisplayRadar(false) end
            Wait(250)
        else
            DisplayRadar(true)
            setVisible(true)

            HideHudComponentThisFrame(6)
            HideHudComponentThisFrame(7)
            HideHudComponentThisFrame(8)
            HideHudComponentThisFrame(9)

            local health = GetEntityHealth(ped)
            local maxHealth = GetEntityMaxHealth(ped)
            local hpPct
            if maxHealth > 100 then
                hpPct = ((health - 100) / (maxHealth - 100)) * 100.0
            else
                hpPct = (health / math.max(maxHealth, 1)) * 100.0
            end
            hpPct = math.max(0.0, math.min(100.0, hpPct))

            local armor = GetPedArmour(ped)
            local armorPct = math.max(0.0, math.min(100.0, armor + 0.0))

            local speedMs = GetEntitySpeed(ped)
            local wp = getWaypoint()
            local hasWaypoint = wp ~= nil
            local distStr = ''
            local etaStr = ''
            local distM = 0

            if hasWaypoint then
                local coords = GetEntityCoords(ped)
                distM = #(coords - vector3(wp.x, wp.y, wp.z))
                distStr = formatDistance(distM)
                etaStr = formatEta(estimateEtaSeconds(distM, speedMs))
            end

            local key = string.format(
                '%.0f|%.0f|%s|%s|%s',
                hpPct,
                armorPct,
                hasWaypoint and '1' or '0',
                distStr,
                etaStr
            )

            if key ~= lastKey then
                lastKey = key
                SendNUIMessage({
                    action = 'update',
                    health = hpPct,
                    armor = armorPct,
                    waypoint = hasWaypoint,
                    distance = distStr,
                    eta = etaStr,
                    meters = distM,
                })
            end

            Wait(100)
        end
    end
end)

CreateThread(function()
    while true do
        local blip = GetFirstBlipInfoId(8)
        if DoesBlipExist(blip) then
            SetBlipColour(blip, 29)
            if SetBlipRouteColour then
                SetBlipRouteColour(blip, 29)
            end
            Wait(500)
        else
            Wait(1000)
        end
    end
end)

RegisterCommand('togglehud', function()
    setVisible(not isVisible)
    lastKey = ''
end, false)

TriggerEvent('chat:addSuggestion', '/togglehud', 'Toggle the map status HUD')
