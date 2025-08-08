Config = {}

-- Marker locations
Config.Locations = {
    vector3(125.6, -1286.2, 29.3),
    vector3(-1135.5, -1991.2, 13.1),
    vector3(1701.1, 3761.5, 34.0)
}

-- Cooldown in seconds for purchases
Config.Cooldown = 10 -- 10 seconds

-- Weapons category
Config.Weapons = {
    {label = "Pistol", item = "weapon_pistol", price = 5000},
    {label = "SMG", item = "weapon_smg", price = 12000},
    {label = "Assault Rifle", item = "weapon_assaultrifle", price = 25000}
}

-- Drugs category
Config.Drugs = {
    {label = "Cocaine (10g)", item = "cocaine", price = 1000},
    {label = "Weed (10g)", item = "weed", price = 800},
    {label = "Meth (10g)", item = "meth", price = 1500}
}

-- Laundering settings
Config.Launder = {
    DayPercent = 10,  -- Fee during day
    NightPercent = 5  -- Fee during night
}
