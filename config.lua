Config = {}

Config.Months = { 10 } -- months it runs in, {} for all year
Config.NightHours = { from = 21, to = 5 }

Config.CheckInterval = 45 -- seconds
Config.Chance = 25 -- % per check, once the haunting level allows a scare
Config.Cooldown = { min = 10, max = 25 } -- minutes after a ghost
Config.MinorCooldown = { min = 1, max = 3 } -- minutes after a small scare
Config.AloneRadius = 50.0

-- haunting level goes 0 - 100, up while alone outside at night and down otherwise
Config.Haunting = {
    gain = 5, -- per check
    decay = 15, -- per check
    drop = 50, -- after a ghost scare
    tiers = { 20, 50, 80 }, -- level needed for tier 1, 2 and 3
}

Config.GhostAlpha = 150 -- 0 - 255
Config.GhostModels = {
    'u_m_y_zombie_01',
    'u_f_y_corpse_01',
    'u_m_y_corpse_01',
    'u_f_m_corpse_01',
}

-- tier 1 are the small scares, weight 0 disables a scare
Config.Scares = {
    glimpse = { tier = 1, weight = 30 },
    footsteps = { tier = 1, weight = 30 },
    blackout = { tier = 1, weight = 20 },
    phone = { tier = 1, weight = 20 },

    behind = { tier = 2, weight = 30 },
    road = { tier = 2, weight = 25 },
    jumpout = { tier = 2, weight = 25 },
    passenger = { tier = 2, weight = 20 },
    screamer = { tier = 2, weight = 15 },

    follow = { tier = 3, weight = 50 },
    angel = { tier = 3, weight = 50 },
    possessed = { tier = 3, weight = 50 },
    stalker = { tier = 3, weight = 50 },
}

-- chance is added on top of Config.Chance
Config.Hotspots = {
    { coords = vec3(-1690.0, -290.0, 51.0), radius = 200.0, chance = 20 }, -- Hill Valley Church
    { coords = vec3(3060.0, 5565.0, 197.0), radius = 300.0, chance = 30 }, -- Mount Gordo
    { coords = vec3(-560.0, 5300.0, 70.0), radius = 400.0, chance = 15 }, -- Paleto Forest
    { coords = vec3(2000.0, 4900.0, 43.0), radius = 300.0, chance = 10 }, -- Grapeseed
}

Config.EmfItem = 'emf_reader'
Config.EmfRange = 60.0
Config.EmfChance = 10 -- extra % while the reader is on
