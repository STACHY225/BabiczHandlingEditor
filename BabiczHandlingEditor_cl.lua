local values = {
    fMass = {
        type = "float",
        change = 100.0
    },
    fInitialDragCoeff = {
        type = "float",
        change = 1
    },
    -- fDownForceModifier = {
    --     type = "float",
    --     change = 0.05
    -- },
    fPercentSubmerged = {
        type = "float",
        change = 5.0
    },
    vecCentreOfMassOffset = {
        type = "vector",
        change = 0.1
    },
    vecInertiaMultiplier = {
        type = "vector",
        change = 0.1
    },
    fDriveBiasFront = {
        type = "float",
        change = 0.05
    },
    nInitialDriveGears = {
        type = "int",
        change = 1
    },
    fInitialDriveForce = {
        type = "float",
        change = 0.1
    },
    fDriveInertia = {
        type = "float",
        change = 1
    },
    fClutchChangeRateScaleUpShift = {
        type = "float",
        change = 0.5
    },
    fClutchChangeRateScaleDownShift = {
        type = "float",
        change = 0.5
    },
    fInitialDriveMaxFlatVel = {
        type = "float",
        change = 5.0
    },
    fBrakeForce = {
        type = "float",
        change = 0.2
    },
    fBrakeBiasFront = {
        type = "float",
        change = 0.1
    },
    fHandBrakeForce = {
        type = "float",
        change = 0.2
    },
    fSteeringLock = {
        type = "float",
        change = 0.5
    },
    fTractionCurveMax = {
        type = "float",
        change = 0.1
    },
    fTractionCurveMin = {
        type = "float",
        change = 0.1
    },
    fTractionCurveLateral = {
        type = "float",
        change = 1.0
    },
    fTractionSpringDeltaMax = {
        type = "float",
        change = 0.01
    },
    fLowSpeedTractionLossMult = {
        type = "float",
        change = 0.1
    },
    fCamberStiffnesss = {
        type = "float",
        change = 0.01
    },
    fTractionBiasFront = {
        type = "float",
        change = 0.01
    },
    fTractionLossMult = {
        type = "float",
        change = 1.0
    },
    fSuspensionForce = {
        type = "float",
        change = 1.0
    },
    fSuspensionCompDamp = {
        type = "float",
        change = 1.0
    },
    fSuspensionReboundDamp = {
        type = "float",
        change = 1.0
    },
    fSuspensionUpperLimit = {
        type = "float",
        change = 1.0
    },
    fSuspensionLowerLimit = {
        type = "float",
        change = 1.0
    },
    fSuspensionRaise = {
        type = "float",
        change = 1.0
    },
    fSuspensionBiasFront = {
        type = "float",
        change = 1.0
    },
    fAntiRollBarForce = {
        type = "float",
        change = 1.0
    },
    fAntiRollBarBiasFront = {
        type = "float",
        change = 1.0
    },
    fRollCentreHeightFront = {
        type = "float",
        change = 1.0
    },
    fRollCentreHeightRear = {
        type = "float",
        change = 1.0
    },
    fCollisionDamageMult = {
        type = "float",
        change = 1.0
    },
    fWeaponDamageMult = {
        type = "float",
        change = 1.0
    },
    fDeformationDamageMult = {
        type = "float",
        change = 1.0
    },
    fEngineDamageMult = {
        type = "float",
        change = 1.0
    },
    fPetrolTankVolume = {
        type = "float",
        change = 1.0
    },
    fOilVolume = {
        type = "float",
        change = 1.0
    },
    fSeatOffsetDistX = {
        type = "float",
        change = 1.0
    },
    fSeatOffsetDistY = {
        type = "float",
        change = 1.0
    },
    fSeatOffsetDistZ = {
        type = "float",
        change = 1.0
    },
    nMonetaryValue = {
        type = "int",
        change = 1.0
    }
}
local class = "CHandlingData"
local accuracy = 10
local opened = false
local handling, currentVehicle, handlingName, lastModel = {}, nil, false, nil

local RoundValue = function(val)
    return tostring(math.floor((val*10^accuracy)+.5)/10^accuracy)
end

local ShowNotification = function(text)
	SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, false)
end

RegisterCommand("handling", function(_, args)
    if opened then
        SendNUIMessage({
            action = "hide"
        })
        SetNuiFocus(false, false)
        opened = false
    else
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if DoesEntityExist(vehicle) then
            if not args[1] then
                handlingName = false
                ShowNotification("~r~Handling name~w~ not specified - some values may ~r~not work~w~!")
            else
                handlingName, lastModel = args[1], GetEntityModel(vehicle)
            end
            handling, currentVehicle = {}, vehicle
            for k, v in pairs(values) do
                if v.type == "int" then
                    handling[k] = GetVehicleHandlingInt(vehicle, class, k)
                elseif v.type == "float" then
                    handling[k] = RoundValue(GetVehicleHandlingFloat(vehicle, class, k))
                elseif v.type == "vector" then
                    local value = GetVehicleHandlingVector(vehicle, class, k)
                    handling[k.."_x"] = RoundValue(value.x)
                    handling[k.."_y"] = RoundValue(value.y)
                    handling[k.."_z"] = RoundValue(value.z)
                end
            end
            SendNUIMessage({
                action =  "show",
                handling = handling
            })
            SetNuiFocus(true, true)
            opened = true
        else
            ShowNotification("Vehicle not found!")
        end
    end
end, false)


RegisterCommand("*BabiczHandlingEditor", function()
    if not opened then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if DoesEntityExist(vehicle) then
            if GetEntityModel(vehicle) ~= lastModel then
                handlingName = nil
            end
            handling, currentVehicle = {}, vehicle
            for k, v in pairs(values) do
                if v.type == "int" then
                    handling[k] = GetVehicleHandlingInt(vehicle, class, k)
                elseif v.type == "float" then
                    handling[k] = RoundValue(GetVehicleHandlingFloat(vehicle, class, k))
                elseif v.type == "vector" then
                    local value = GetVehicleHandlingVector(vehicle, class, k)
                    handling[k.."_x"] = RoundValue(value.x)
                    handling[k.."_y"] = RoundValue(value.y)
                    handling[k.."_z"] = RoundValue(value.z)
                end
            end
            SendNUIMessage({
                action =  "show",
                handling = handling
            })
            SetNuiFocus(true, true)
            opened = true
            if not handlingName then
                ShowNotification("~r~Handling name~w~ not specified - some values may ~r~not work~w~!")
            end
        else
            ShowNotification("Vehicle not found!")
        end
    end
end)
RegisterKeyMapping("*BabiczHandlingEditor", "Handling Editor", "keyboard", "LSHIFT")

local UpdateHandling = function(target, value)
    if values[target].type == "int" then
        value = math.floor(value)
        handling[target] = value
        if handlingName then
            SetHandlingInt(handlingName, class, target, value)
        end
        SetVehicleHandlingInt(currentVehicle, class, target, value)
    elseif values[target].type == "float" then
        value = value*1.0
        handling[target] = value
        if handlingName then
            SetHandlingFloat(handlingName, class, target, value)
        end
        SetVehicleHandlingFloat(currentVehicle, class, target, value)
    elseif values[target].type == "vector" then
        handling[target] = value
        local target = target:gsub("_x", "")
        if handlingName then
            SetHandlingVector(handlingName, class, target, vector3(handling[k.."_x"], handling[k.."_y"], handling[k.."_z"]))
        end
        SetVehicleHandlingVector(currentVehicle, class, target, vector3(handling[k.."_x"], handling[k.."_y"], handling[k.."_z"]))
    end
    return tostring(handling[target])
end

RegisterNUICallback("update", function(data, cb)
    if data.target and values[data.target] and tonumber(data.value) and handling[data.target] then
        UpdateHandling(data.target, data.value)
    end
    cb(true)
end)

RegisterNUICallback("change", function(data, cb)
    if data.target and values[data.target] and handling[data.target] then
        local value = handling[data.target]
        if data.type == "add" then
            return cb(UpdateHandling(data.target, value + values[data.target].change))
        elseif data.type == "substract" then
            return cb(UpdateHandling(data.target, value - values[data.target].change))
        end
    end
    cb(false)
end)

-- vehicle properties taken from ESX framework
local CloneVehicle = function(veh)
    if DoesEntityExist(veh) then
        local model, coords, heading, networked = GetEntityModel(veh), GetEntityCoords(veh), GetEntityHeading(veh), NetworkGetEntityIsNetworked(veh)
		local colorPrimary, colorSecondary = GetVehicleColours(veh)
		if GetIsVehiclePrimaryColourCustom(veh) then
			local r, g, b = GetVehicleCustomPrimaryColour(veh)
			colorPrimary = {r = r, g = g, b = b}
		end
		if GetIsVehicleSecondaryColourCustom(veh) then
			local r, g, b = GetVehicleCustomSecondaryColour(veh)
			colorSecondary = {r = r, g = g, b = b}
		end
		local pearlescentColor, wheelColor = GetVehicleExtraColours(veh)
		local extras = {}
		for id=0, 12 do
			if DoesExtraExist(veh, id) then
				local state = IsVehicleExtraTurnedOn(veh, id) == 1
				extras[tostring(id)] = state
			end
		end
        local props = {
			plate             = GetVehicleNumberPlateText(veh),
			plateIndex        = GetVehicleNumberPlateTextIndex(veh),
			bodyHealth        = GetVehicleBodyHealth(veh),
			engineHealth      = GetVehicleEngineHealth(veh),
			fuelLevel         = GetVehicleFuelLevel(veh),
			dirtLevel         = GetVehicleDirtLevel(veh),
			color1            = colorPrimary,
			color2            = colorSecondary,
			pearlescentColor  = pearlescentColor,
			wheelColor        = wheelColor,
			wheels            = GetVehicleWheelType(veh),
			windowTint        = GetVehicleWindowTint(veh),
			neonEnabled       = {
				IsVehicleNeonLightEnabled(veh, 0),
				IsVehicleNeonLightEnabled(veh, 1),
				IsVehicleNeonLightEnabled(veh, 2),
				IsVehicleNeonLightEnabled(veh, 3)
			},
			neonColor         = table.pack(GetVehicleNeonLightsColour(veh)),
			extras            = extras,
			tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(veh)),
			modSpoilers       = GetVehicleMod(veh, 0),
			modFrontBumper    = GetVehicleMod(veh, 1),
			modRearBumper     = GetVehicleMod(veh, 2),
			modSideSkirt      = GetVehicleMod(veh, 3),
			modExhaust        = GetVehicleMod(veh, 4),
			modFrame          = GetVehicleMod(veh, 5),
			modGrille         = GetVehicleMod(veh, 6),
			modHood           = GetVehicleMod(veh, 7),
			modFender         = GetVehicleMod(veh, 8),
			modRightFender    = GetVehicleMod(veh, 9),
			modRoof           = GetVehicleMod(veh, 10),
			modEngine         = GetVehicleMod(veh, 11),
			modBrakes         = GetVehicleMod(veh, 12),
			modTransmission   = GetVehicleMod(veh, 13),
			modHorns          = GetVehicleMod(veh, 14),
			modSuspension     = GetVehicleMod(veh, 15),
			modArmor          = GetVehicleMod(veh, 16),
			modTurbo          = IsToggleModOn(veh, 18),
			modSmokeEnabled   = IsToggleModOn(veh, 20),
			modXenon          = IsToggleModOn(veh, 22),
			modFrontWheels    = GetVehicleMod(veh, 23),
			modBackWheels     = GetVehicleMod(veh, 24),
			modPlateHolder    = GetVehicleMod(veh, 25),
			modVanityPlate    = GetVehicleMod(veh, 26),
			modTrimA          = GetVehicleMod(veh, 27),
			modOrnaments      = GetVehicleMod(veh, 28),
			modDashboard      = GetVehicleMod(veh, 29),
			modDial           = GetVehicleMod(veh, 30),
			modDoorSpeaker    = GetVehicleMod(veh, 31),
			modSeats          = GetVehicleMod(veh, 32),
			modSteeringWheel  = GetVehicleMod(veh, 33),
			modShifterLeavers = GetVehicleMod(veh, 34),
			modAPlate         = GetVehicleMod(veh, 35),
			modSpeakers       = GetVehicleMod(veh, 36),
			modTrunk          = GetVehicleMod(veh, 37),
			modHydrolic       = GetVehicleMod(veh, 38),
			modEngineBlock    = GetVehicleMod(veh, 39),
			modAirFilter      = GetVehicleMod(veh, 40),
			modStruts         = GetVehicleMod(veh, 41),
			modArchCover      = GetVehicleMod(veh, 42),
			modAerials        = GetVehicleMod(veh, 43),
			modTrimB          = GetVehicleMod(veh, 44),
			modTank           = GetVehicleMod(veh, 45),
			modWindows        = GetVehicleMod(veh, 46),
			modLivery         = GetVehicleLivery(veh)
		}
        DeleteEntity(veh)
        while not HasModelLoaded(model) do RequestModel(model) Citizen.Wait(0) end
        local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, networked, false)
        while not DoesEntityExist(vehicle) do Citizen.Wait(0) end
        SetModelAsNoLongerNeeded(model)
        SetVehicleModKit(vehicle, 0)
        if props.plate then
            SetVehicleNumberPlateText(vehicle, props.plate)
        end
        if props.plateIndex then
            SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
        end
        if props.health then
            SetEntityHealth(vehicle, props.health)
        end
        if props.bodyHealth then
            SetVehicleBodyHealth(vehicle, props.bodyHealth)
        end
        if props.engineHealth then
            SetVehicleEngineHealth(vehicle, props.engineHealth)
        end
        if props.fuelLevel then
            SetVehicleFuelLevel(vehicle, props.fuelLevel)
        end
        if props.dirtLevel then
            SetVehicleDirtLevel(vehicle, props.dirtLevel)
        end
        if props.color1 then
            if type(props.color1) == "table" then
                SetVehicleCustomPrimaryColour(vehicle, props.color1.r, props.color1.g, props.color1.b)
            else
                local color1, color2 = GetVehicleColours(vehicle)
                SetVehicleColours(vehicle, props.color1, color2)
            end
        end
        if props.color2 then
            if type(props.color2) == "table" then
                SetVehicleCustomSecondaryColour(vehicle, props.color2.r, props.color2.g, props.color2.b)
            else
                local color1, color2 = GetVehicleColours(vehicle)
                SetVehicleColours(vehicle, color1, props.color2)
            end
        end
        if props.pearlescentColor then
            local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
            SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
        end
        if props.wheelColor then
            local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
            SetVehicleExtraColours(vehicle, pearlescentColor, props.wheelColor)
        end
        if props.wheels then
            SetVehicleWheelType(vehicle, props.wheels)
        end
        if props.windowTint then
            SetVehicleWindowTint(vehicle, props.windowTint)
        end
        if props.neonEnabled then
            SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
            SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
            SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
            SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
        end
        if props.extras then
            for id,enabled in pairs(props.extras) do
                if enabled then
                    SetVehicleExtra(vehicle, tonumber(id), 0)
                else
                    SetVehicleExtra(vehicle, tonumber(id), 1)
                end
            end
        end
        if props.neonColor then
            SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
        end
        if props.modSmokeEnabled then
            ToggleVehicleMod(vehicle, 20, true)
        end
        if props.tyreSmokeColor then
            SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
        end
        if props.modSpoilers then
            SetVehicleMod(vehicle, 0, props.modSpoilers, false)
        end
        if props.modFrontBumper then
            SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
        end
        if props.modRearBumper then
            SetVehicleMod(vehicle, 2, props.modRearBumper, false)
        end
        if props.modSideSkirt then
            SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
        end
        if props.modExhaust then
            SetVehicleMod(vehicle, 4, props.modExhaust, false)
        end
        if props.modFrame then
            SetVehicleMod(vehicle, 5, props.modFrame, false)
        end
        if props.modGrille then
            SetVehicleMod(vehicle, 6, props.modGrille, false)
        end
        if props.modHood then
            SetVehicleMod(vehicle, 7, props.modHood, false)
        end
        if props.modFender then
            SetVehicleMod(vehicle, 8, props.modFender, false)
        end
        if props.modRightFender then
            SetVehicleMod(vehicle, 9, props.modRightFender, false)
        end
        if props.modRoof then
            SetVehicleMod(vehicle, 10, props.modRoof, false)
        end
        if props.modEngine then
            SetVehicleMod(vehicle, 11, props.modEngine, false)
        end
        if props.modBrakes then
            SetVehicleMod(vehicle, 12, props.modBrakes, false)
        end
        if props.modTransmission then
            SetVehicleMod(vehicle, 13, props.modTransmission, false)
        end
        if props.modHorns then
            SetVehicleMod(vehicle, 14, props.modHorns, false)
        end
        if props.modSuspension then
            SetVehicleMod(vehicle, 15, props.modSuspension, false)
        end
        if props.modArmor then
            SetVehicleMod(vehicle, 16, props.modArmor, false)
        end
        if props.modTurbo then
            ToggleVehicleMod(vehicle,  18, props.modTurbo)
        end
        if props.modXenon then
            ToggleVehicleMod(vehicle,  22, props.modXenon)
        end
        if props.modFrontWheels then
            SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
        end
        if props.modBackWheels then
            SetVehicleMod(vehicle, 24, props.modBackWheels, false)
        end
        if props.modPlateHolder then
            SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
        end
        if props.modVanityPlate then
            SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
        end
        if props.modTrimA then
            SetVehicleMod(vehicle, 27, props.modTrimA, false)
        end
        if props.modOrnaments then
            SetVehicleMod(vehicle, 28, props.modOrnaments, false)
        end
        if props.modDashboard then
            SetVehicleMod(vehicle, 29, props.modDashboard, false)
        end
        if props.modDial then
            SetVehicleMod(vehicle, 30, props.modDial, false)
        end
        if props.modDoorSpeaker then
            SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
        end
        if props.modSeats then
            SetVehicleMod(vehicle, 32, props.modSeats, false)
        end
        if props.modSteeringWheel then
            SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
        end
        if props.modShifterLeavers then
            SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
        end
        if props.modAPlate then
            SetVehicleMod(vehicle, 35, props.modAPlate, false)
        end
        if props.modSpeakers then
            SetVehicleMod(vehicle, 36, props.modSpeakers, false)
        end
        if props.modTrunk then
            SetVehicleMod(vehicle, 37, props.modTrunk, false)
        end
        if props.modHydrolic then
            SetVehicleMod(vehicle, 38, props.modHydrolic, false)
        end
        if props.modEngineBlock then
            SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
        end
        if props.modAirFilter then
            SetVehicleMod(vehicle, 40, props.modAirFilter, false)
        end
        if props.modStruts then
            SetVehicleMod(vehicle, 41, props.modStruts, false)
        end
        if props.modArchCover then
            SetVehicleMod(vehicle, 42, props.modArchCover, false)
        end
        if props.modAerials then
            SetVehicleMod(vehicle, 43, props.modAerials, false)
        end
        if props.modTrimB then
            SetVehicleMod(vehicle, 44, props.modTrimB, false)
        end
        if props.modTank then
            SetVehicleMod(vehicle, 45, props.modTank, false)
        end
        if props.modWindows then
            SetVehicleMod(vehicle, 46, props.modWindows, false)
        end
        if props.modLivery then
            SetVehicleMod(vehicle, 48, props.modLivery, false)
            SetVehicleLivery(vehicle, props.modLivery)
        end
        SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
        Citizen.Wait(10)
        SetVehRadioStation(vehicle, "OFF")
        SetVehicleEngineOn(vehicle, true, true, true)
        currentVehicle = vehicle
    end
end

RegisterNUICallback("close", function(data, cb)
    if handlingName then Citizen.CreateThread(function()CloneVehicle(currentVehicle)end) end
    SetNuiFocus(false, false)
    opened = false
    cb(true)
end)