local ox_inventory = exports.ox_inventory

RegisterNetEvent("blackmarket:purchase", function(item, price)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        ox_inventory:AddItem(src, item, 1)
        TriggerClientEvent('ox_lib:notify', src, {type = 'success', description = "Purchase successful!"})
    else
        TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = "Not enough money!"})
    end
end)

RegisterNetEvent("blackmarket:launderMoney", function(amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local dirty = xPlayer.getAccount("black_money").money

    if dirty >= amount then
        xPlayer.removeAccountMoney("black_money", amount)

        local hour = tonumber(os.date("%H"))
        local feePercent = Config.Launder.DayPercent
        if hour >= 18 or hour < 6 then
            feePercent = Config.Launder.NightPercent
        end

        local fee = math.floor(amount * (feePercent / 100))
        local clean = amount - fee

        xPlayer.addMoney(clean)
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'success',
            description = ("You laundered $%s (Fee: %s%%)"):format(clean, feePercent)
        })
    else
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = "Not enough dirty money!"
        })
    end
end)
