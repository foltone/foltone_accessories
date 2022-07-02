Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)


local MenuMask = RageUI.CreateMenu("Masque", 'Masque');
local open = false
function MenuMask.Closed()
	open = false
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
    FreezeEntityPosition(PlayerPedId(), false)
end

local mask_1c, mask_2c = {}, {}
local index = {
    mask_1 = 0,
    mask_2 = 0
}

function GetComponent()
    local mask_1Comp = GetNumberOfPedDrawableVariations(PlayerPedId(), 1)
    for i=0, mask_1Comp, 1 do
        table.insert(mask_1c, i)
    end
end  
GetComponent()

function RageUI.PoolMenus:FoltoneMenuMask()
	MenuMask:IsVisible(function(Items)
        Items:AddList("Masque n°1 :", mask_1c, index.mask_1, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                index.mask_1 = Index
            end
            if (Index) == Index then
                SetPedComponentVariation(PlayerPedId(), 1, Index-1, pmask_2 or 0, 2)
                local mask_2Comp = 1 
                mask_2Comp = GetNumberOfPedTextureVariations(PlayerPedId(), 1, Index-1)
                mask_2c = {}
                if debug then 
                end
                for i=0, mask_2Comp, 1 do
                table.insert(mask_2c,i)
                end
                pmask_1 = Index-1
            end
        end)
        Items:AddList("Masque n°2 :", mask_2c, index.mask_2, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                index.mask_2 = Index
            end
            if (Index) == Index then
                SetPedComponentVariation(PlayerPedId(), 1, pmask_1, Index-1, 2)
                pmask_2 = Index-1
            end
        end)

        Items:AddButton("Payer", nil, { IsDisabled = false, RightLabel = "~g~" .. FoltoneMask.Prix .. "$" }, function(onSelected)
            if (onSelected) then
                TriggerServerEvent('foltone_mask:achetermask', pmask_1, pmask_2, FoltoneMask.Prix)
            end
        end)
	end, function(Panels)
	end)
end


Citizen.CreateThread(function()
	while true do
		local wait = 500
		local playerCoords = GetEntityCoords(PlayerPedId())
		for k, v in pairs(FoltoneMask.Position) do
			local distance = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)
            if distance <= 8.0 then
                wait= 0
                DrawMarker(6, v.x, v.y, v.z-1, 0.0, 0.0, 9.0, 0.0, 0.0, 0.0, 0.5, 1.0, 0.5, 113, 203, 113, 255, false, false, 2, false, false, false, false)
            end
            if distance <= 1.0 then
				wait = 0
                if not open then
                    ESX.ShowHelpNotification("Appuyer sur ~g~[E]~s~ pour accéder au ~g~magasin", 1)
                end
                if IsControlJustPressed(1, 51) then
                    FreezeEntityPosition(PlayerPedId(), true)
                    CreateCam()
                    open = true
					RageUI.Visible(MenuMask, not RageUI.Visible(MenuMask))
                end
            end
        end
        Citizen.Wait(wait)
	end
end)

Citizen.CreateThread(function()
	for k, v in pairs(FoltoneMask.Position) do
        --blip
		local BlipMask = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(BlipMask, 362)
		SetBlipScale (BlipMask, 0.7)
		SetBlipColour(BlipMask, 2)
		SetBlipAsShortRange(BlipMask, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Magasin de Masque')
		EndTextCommandSetBlipName(BlipMask)
	end
end)

RegisterNetEvent("foltone_mask:yesmoney")
AddEventHandler(("foltone_mask:yesmoney"), function(mask_1, mask_2)
    TriggerEvent("skinchanger:change", "mask_1", mask_1, -1)
    TriggerEvent("skinchanger:change", "mask_2", mask_2)
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)
    end)
end)

RegisterNetEvent("foltone_mask:nomoney")
AddEventHandler(("foltone_mask:nomoney"), function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
end)
