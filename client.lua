local lastPurchase = 0
local inZone = false

CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        for _, loc in pairs(Config.Locations) do
            local dist = #(coords - loc)
            if dist < 15.0 then
                sleep = 0
                DrawMarker(2, loc.x, loc.y, loc.z + 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                           0.3, 0.3, 0.3, 255, 0, 0, 150, false, false, 2, false, nil, nil, false)

                if dist < 1.5 then
                    if not inZone then
                        lib.showTextUI('[E] Open Black Market', {position = "top-center"})
                        inZone = true
                    end
                    if IsControlJustReleased(0, 38) then
                        OpenBlackMarket()
                    end
                elseif inZone then
                    lib.hideTextUI()
                    inZone = false
                end
            end
        end
        Wait(sleep)
    end
end)

function OpenBlackMarket()
    local options = {
        {title = "Weapons", description = "Buy illegal weapons", event = "blackmarket:openCategory", args = {category = "Weapons"}},
        {title = "Drugs", description = "Buy illegal drugs", event = "blackmarket:openCategory", args = {category = "Drugs"}},
        {title = "Money Laundering", description = "Clean your dirty money", event = "blackmarket:launderMenu"}
    }
    lib.registerContext({
        id = 'blackmarket_main',
        title = 'Black Market',
        options = options
    })
    lib.showContext('blackmarket_main')
end

RegisterNetEvent("blackmarket:openCategory", function(data)
    local category = data.category
    local items = Config[category]
    local options = {}

    for _, v in ipairs(items) do
        table.insert(options, {
            title = v.label,
            description = ("Price: $%s"):format(v.price),
            event = "blackmarket:buyItem",
            args = {item = v.item, price = v.price}
        })
    end

    lib.registerContext({
        id = 'blackmarket_' .. category,
        title = category,
        menu = 'blackmarket_main',
        options = options
    })
    lib.showContext('blackmarket_' .. category)
end)

RegisterNetEvent("blackmarket:buyItem", function(data)
    if (GetGameTimer() - lastPurchase) < (Config.Cooldown * 1000) then
        lib.notify({type = 'error', description = "You must wait before buying again!"})
        return
    end
    lastPurchase = GetGameTimer()
    TriggerServerEvent("blackmarket:purchase", data.item, data.price)
end)

RegisterNetEvent("blackmarket:launderMenu", function()
    local amount = lib.inputDialog("Launder Money", {"Amount of dirty money to clean"})
    if amount and tonumber(amount) > 0 then
        if lib.progressBar({
            duration = 5000,
            label = 'Laundering money...',
            useWhileDead = false,
            canCancel = true,
            disable = { car = true, move = true, combat = true }
        }) then
            TriggerServerEvent("blackmarket:launderMoney", tonumber(amount))
        else
            lib.notify({type = 'error', description = "You cancelled the laundering process!"})
        end
    end
end)
