ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj 
end)

local open = false 
local MenuArmurerie = RageUI.CreateMenu("Armurerie", "Interaction")
MenuArmurerie.Display.Header = true 
MenuArmurerie.Close = function()
    open = false 
end 

function OpenMenuArmurerie()
    if open then 
        open = false 
        RageUI.Visible(MenuArmurerie, true)
        return 
    else 
        open = true 
        RageUI.Visible(MenuArmurerie, true)
        CreateThread(function()
            while open do 
                RageUI.IsVisible(MenuArmurerie, function()

                    RageUI.Separator("  ↓                         ~y~Accessoire                        ~s~↓")
                    for k, v in pairs(Config.accessoire) do 
                        RageUI.Button(v.Nom .. '', nil, {RightLabel = "~g~" ..v.Price.." $"}, true, {
                            onSelected = function()
                                TriggerServerEvent('nrc:Arme', v.Nom, v.Arme, v.Price)
                                RageUI.CloseAll()
                            end
                        })
                    end 

                    RageUI.Separator("  ↓                      ~o~Armes Blanche                     ~s~↓")
                    for k, v in pairs(Config.armeblanche) do 
                        RageUI.Button(v.Nom .. '', nil, {RightLabel = "~g~" ..v.Price.." $"}, true, {
                            onSelected = function()
                                TriggerServerEvent('nrc:Arme', v.Nom, v.Arme, v.Price)
                                RageUI.CloseAll()
                            end 
                        })
                    end

                    RageUI.Separator("  ↓                      ~r~Armes de point                     ~s~↓")
                    for k, v in pairs(Config.armedepoint) do 
                        RageUI.Button(v.Nom .. '', nil, {RightLabel = "~g~" ..v.Price.." $"}, true, {
                            onSelected = function()
                                TriggerServerEvent('nrc:Arme', v.Nom, v.Arme, v.Price)
                                RageUI.CloseAll()
                            end 
                        })
                    end
                end)
            Wait(0)
            end
        end)
    end 
end

Citizen.CreateThread(function()
    while true do
		local wait = 750

			for k in pairs(Config.pos) do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local pos = Config.pos
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

            if dist <= Config.MarkerDistance then
                wait = 0
                ESX.ShowHelpNotification("Appuyer sur [~o~E~s~] pour accéder à ~o~l'armurerie !")
                DrawMarker(Config.MarkerType, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.MarkerSizeLargeur, Config.MarkerSizeEpaisseur, Config.MarkerSizeHauteur, Config.MarkerColorR, Config.MarkerColorG, Config.MarkerColorB, Config.MarkerOpacite, Config.MarkerSaute, true, p19, Config.MarkerTourne)  
            end

			if dist <= 4.0 then
                wait = 0
                if IsControlJustPressed(1,51) then
                    OpenMenuArmurerie()
                end
		    end
		end
    Wait(wait)
    end
end)

RegisterNetEvent('nrc:giveArme')
AddEventHandler('nrc:giveArme', function(gun)
    local ped = PlayerPedId()
    local arme = gun
    local weaponhash = GetHashKey(arme)

    GiveWeaponToPed(ped, weaponhash, 200, false, true)
end)

-- Blip 
Citizen.CreateThread(function()
    for i=1, #Config.pos, 1 do 
        local armeblip = AddBlipForCoord(Config.pos[i].x, Config.pos[i].y, Config.pos[i].z)
        SetBlipSprite(armeblip, 110)
        SetBlipColour(armeblip, 47)
        SetBlipScale(armeblip, 0.9)
        SetBlipAsShortRange(armeblip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Armurerie")
        EndTextCommandSetBlipName(armeblip)
    end
end)

-- Ped --
local positionPedAmmu = {
	{x = -331.66, y = 6085.03, z = 30.45, h = 224.62},
    {x = 1692.02, y = 3761.11, z = 33.70, h = 226.18},  
    {x = 22.55, y = -1105.46, z = 28.8, h = 163.32}, 
}

Citizen.CreateThread(function()
    local hash = GetHashKey("s_m_y_ammucity_01")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
	end
	for k,v in pairs(positionPedAmmu) do
	ped = CreatePed("PED_TYPE_CIVMALE", "s_m_y_ammucity_01", v.x, v.y, v.z, v.h, false, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
	end
end)
