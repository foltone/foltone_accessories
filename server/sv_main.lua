ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('foltone_helmet:acheterhelmet')
AddEventHandler('foltone_helmet:acheterhelmet', function(helmet_1, helmet_2, prix)
    local xPlayer = ESX.GetPlayerFromId(source)
    local LiquideJoueur = xPlayer.getMoney()
    if LiquideJoueur >= prix then
        xPlayer.removeMoney(prix)
        TriggerClientEvent(("foltone_helmet:yesmoney"), source, helmet_1, helmet_2)
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Information!', '~g~Achat effectué!', '', 'CHAR_BANK_FLEECA', 9)
    else
        TriggerClientEvent(("foltone_helmet:nomoney"), source)
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Information!', "~r~Pas assez de liquide!", '', 'CHAR_BLOCKED', 9)
    end
end)

RegisterNetEvent('foltone_glasses:acheterglasses')
AddEventHandler('foltone_glasses:acheterglasses', function(glasses_1, glasses_2, prix)
    local xPlayer = ESX.GetPlayerFromId(source)
    local LiquideJoueur = xPlayer.getMoney()
    if LiquideJoueur >= prix then
        xPlayer.removeMoney(prix)
        TriggerClientEvent(("foltone_glasses:yesmoney"), source, glasses_1, glasses_2)
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Information!', '~g~Achat effectué!', '', 'CHAR_BANK_FLEECA', 9)
    else
        TriggerClientEvent(("foltone_glasses:nomoney"), source)
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Information!', "~r~Pas assez de liquide!", '', 'CHAR_BLOCKED', 9)
    end
end)

RegisterNetEvent('foltone_ears:acheterears')
AddEventHandler('foltone_ears:acheterears', function(ears_1, ears_2, prix)
    local xPlayer = ESX.GetPlayerFromId(source)
    local LiquideJoueur = xPlayer.getMoney()
    if LiquideJoueur >= prix then
        xPlayer.removeMoney(prix)
        TriggerClientEvent(("foltone_ears:yesmoney"), source, ears_1, ears_2)
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Information!', '~g~Achat effectué!', '', 'CHAR_BANK_FLEECA', 9)
    else
        TriggerClientEvent(("foltone_ears:nomoney"), source)
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Information!', "~r~Pas assez de liquide!", '', 'CHAR_BLOCKED', 9)
    end
end)

RegisterNetEvent('foltone_mask:achetermask')
AddEventHandler('foltone_mask:achetermask', function(mask_1, mask_2, prix)
    local xPlayer = ESX.GetPlayerFromId(source)
    local LiquideJoueur = xPlayer.getMoney()
    if LiquideJoueur >= prix then
        xPlayer.removeMoney(prix)
        TriggerClientEvent(("foltone_mask:yesmoney"), source, mask_1, mask_2)
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Information!', '~g~Achat effectué!', '', 'CHAR_BANK_FLEECA', 9)
    else
        TriggerClientEvent(("foltone_mask:nomoney"), source)
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Information!', "~r~Pas assez de liquide!", '', 'CHAR_BLOCKED', 9)
    end
end)