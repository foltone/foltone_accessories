Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)


local MenuLunette = RageUI.CreateMenu("Lunette", 'Lunette');
local open = false
function MenuLunette.Closed()
	open = false
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
    FreezeEntityPosition(PlayerPedId(), false)
    RenderScriptCams(0, true, 1000)
    DestroyAllCams(true) 
    DestroyCam(cam, false)
end

local glasses_1c, glasses_2c = {}, {}
local index = {
    glasses_1 = 0,
    glasses_2 = 0
}

function GetComponent()
    local glasses_1Comp = GetNumberOfPedDrawableVariations(PlayerPedId(), 1)
    for i=0, glasses_1Comp, 1 do
        table.insert(glasses_1c, i)
    end
end  
GetComponent()

function RageUI.PoolMenus:FoltoneMenuLunette()
	MenuLunette:IsVisible(function(Items)
        Load()
        Items:AddList("Lunette n°1 :", glasses_1c, index.glasses_1, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                index.glasses_1 = Index
            end
            if (Index) == Index then
                SetPedPropIndex(PlayerPedId(), 1, Index-1, pglasses_2 or 0, 2)
                local glasses_2Comp = 1 
                glasses_2Comp = GetNumberOfPedTextureVariations(PlayerPedId(), 1, Index-1)
                glasses_2c = {}
                if debug then 
                end
                for i=0, glasses_2Comp, 1 do
                table.insert(glasses_2c,i)
                end
                pglasses_1 = Index-1
            end
        end)
        Items:AddList("Lunette n°2 :", glasses_2c, index.glasses_2, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                index.glasses_2 = Index
            end
            if (Index) == Index then
                SetPedPropIndex(PlayerPedId(), 1, pglasses_1, Index-1, 2)
                pglasses_2 = Index-1
            end
        end)

        Items:AddButton("Payer", nil, { IsDisabled = false, RightLabel = "~g~" .. FoltoneLunette.Prix .. "$" }, function(onSelected)
            if (onSelected) then
                TriggerServerEvent('foltone_glasses:acheterglasses', pglasses_1, pglasses_2, FoltoneLunette.Prix)
            end
        end)
	end, function(Panels)
	end)
end


Citizen.CreateThread(function()
	while true do
		local wait = 500
		local playerCoords = GetEntityCoords(PlayerPedId())
		for k, v in pairs(FoltoneLunette.Position) do
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
					RageUI.Visible(MenuLunette, not RageUI.Visible(MenuLunette))
                end
            end
        end
        Citizen.Wait(wait)
	end
end)

RegisterNetEvent("foltone_glasses:yesmoney")
AddEventHandler(("foltone_glasses:yesmoney"), function(glasses_1, glasses_2)
    TriggerEvent("skinchanger:change", "glasses_1", glasses_1, -1)
    TriggerEvent("skinchanger:change", "glasses_2", glasses_2)
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)
    end)
end)

RegisterNetEvent("foltone_glasses:nomoney")
AddEventHandler(("foltone_glasses:nomoney"), function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
end)

function CreateCam()
	local coords = GetEntityCoords(GetPlayerPed(-1))
    cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', coords.x-0.8, coords.y-0.4, coords.z+0.7, 0.0, 0.0, 0.0, 40.0, true, true)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z+0.6)
    RenderScriptCams(true, false, false, true, true)
end

function Load()
    FreezeEntityPosition(PlayerPedId(), true) 
    EnableControlAction(0, 47, true)   
    if IsDisabledControlPressed(0, 23) then
        SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId())-1.5)
    elseif IsDisabledControlPressed(0, 47) then
        SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId())+1.5)
    elseif IsDisabledControlPressed(0, 11) then
        SetCamFov(cam, GetCamFov(cam)+0.2)
    elseif IsDisabledControlPressed(0, 10) then
        SetCamFov(cam, GetCamFov(cam)-0.2)
    end
    MenuLunette:AddInstructionButton({[1] = GetControlInstructionalButton(0, 47, 0), [2] = "Tourner à Gauche"})
    MenuLunette:AddInstructionButton({[1] = GetControlInstructionalButton(0, 23, 0), [2] = "Tourner à Droite"}) 
    MenuLunette:AddInstructionButton({[1] = GetControlInstructionalButton(0, 11, 0), [2] = "Dézoom"})
    MenuLunette:AddInstructionButton({[1] = GetControlInstructionalButton(0, 10, 0), [2] = "Zoom"})
end
