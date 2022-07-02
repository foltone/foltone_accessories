Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)


local MenuChapeau = RageUI.CreateMenu("Chapeau", 'Chapeau');
local open = false
function MenuChapeau.Closed()
	open = false
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
    FreezeEntityPosition(PlayerPedId(), false)
    RenderScriptCams(0, true, 1000)
    DestroyAllCams(true) 
    DestroyCam(cam, false)
end

local helmet_1c, helmet_2c = {}, {}
local index = {
    helmet_1 = 0,
    helmet_2 = 0
}

function GetComponent()
    local helmet_1Comp = GetNumberOfPedDrawableVariations(PlayerPedId(), 1)
    for i=0, helmet_1Comp, 1 do
        table.insert(helmet_1c, i)
    end
end  
GetComponent()

function RageUI.PoolMenus:FoltoneMenuChapeau()
	MenuChapeau:IsVisible(function(Items)
        Load()
        Items:AddList("Chapeau n°1 :", helmet_1c, index.helmet_1, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                index.helmet_1 = Index
            end
            if (Index) == Index then
                SetPedPropIndex(PlayerPedId(), 0, Index-1, phelmet_2 or 0, 2)
                local helmet_2Comp = 1
                helmet_2Comp = GetNumberOfPedTextureVariations(PlayerPedId(), 1, Index-1)
                helmet_2c = {}
                if debug then 
                end
                for i=0, helmet_2Comp, 1 do
                table.insert(helmet_2c,i)
                end
                phelmet_1 = Index-1
            end
        end)
        Items:AddList("Chapeau n°2 :", helmet_2c, index.helmet_2, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            if (onListChange) then
                index.helmet_2 = Index
            end
            if (Index) == Index then
                SetPedPropIndex(PlayerPedId(), 0, phelmet_1, Index-1, 2)
                phelmet_2 = Index-1
            end
        end)

        Items:AddButton("Payer", nil, { IsDisabled = false, RightLabel = "~g~" .. FoltoneChapeau.Prix .. "$" }, function(onSelected)
            if (onSelected) then
                TriggerServerEvent('foltone_helmet:acheterhelmet', phelmet_1, phelmet_2, FoltoneChapeau.Prix)
            end
        end)
	end, function(Panels)
	end)
end


Citizen.CreateThread(function()
	while true do
		local wait = 500
		local playerCoords = GetEntityCoords(PlayerPedId())
		for k, v in pairs(FoltoneChapeau.Position) do
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
					RageUI.Visible(MenuChapeau, not RageUI.Visible(MenuChapeau))
                end
            end
        end
        Citizen.Wait(wait)
	end
end)

RegisterNetEvent("foltone_helmet:yesmoney")
AddEventHandler(("foltone_helmet:yesmoney"), function(helmet_1, helmet_2)
    TriggerEvent("skinchanger:change", "helmet_1", helmet_1, -1)
    TriggerEvent("skinchanger:change", "helmet_2", helmet_2)
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)
    end)
end)

RegisterNetEvent("foltone_helmet:nomoney")
AddEventHandler(("foltone_helmet:nomoney"), function()
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
    MenuChapeau:AddInstructionButton({[1] = GetControlInstructionalButton(0, 47, 0), [2] = "Tourner à Gauche"})
    MenuChapeau:AddInstructionButton({[1] = GetControlInstructionalButton(0, 23, 0), [2] = "Tourner à Droite"}) 
    MenuChapeau:AddInstructionButton({[1] = GetControlInstructionalButton(0, 11, 0), [2] = "Dézoom"})
    MenuChapeau:AddInstructionButton({[1] = GetControlInstructionalButton(0, 10, 0), [2] = "Zoom"})
end
