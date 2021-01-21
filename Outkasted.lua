Outkasted = Outkasted or {}
Outkasted.name = "Outkasted"
Outkasted.abbreviation = "Outk"
Outkasted.version = "1.3"
Outkasted.website = "https://outkastedguild.com"
Outkasted.discord = "https://outkastedguild.com/discord"
Outkasted.guildId = 425252

local log = LibDebugLogger:Create(Outkasted.name)
local chat = LibChatMessage:Create(Outkasted.name, Outkasted.abbreviation)

function Outkasted.TeleportToGuildHall()
	local guildhall = { owner = "@Selegnar", houseId = 47 }

    -- Apparently JumpToSpecificHouse on the player's own house is not allowed. Something something cohesion...
	log:Debug("Teleporting to " .. guildhall.owner .. "'s home with house ID " .. guildhall.houseId)
	if guildhall.owner == GetDisplayName() then
        RequestJumpToHouse(guildhall.houseId)
	else
	    JumpToSpecificHouse(guildhall.owner, guildhall.houseId)
	end
end

function Outkasted.LeaveInstance(confirm)
	local LEAVE_DIALOG = "INSTANCE_LEAVE_DIALOG"

	log:Debug("Instance exit requested")
	if not IsUnitInDungeon("reticleover") then
		chat:Print(GetString(OUTK_LEAVEINSTANCE_ZOS_REPORTS_NOT_IN_TRIAL))
	else
		chat:Print(GetString(OUTK_LEAVEINSTANCE_EXITING_INSTANCE))
	end

	if confirm == false then
		ExitInstanceImmediately()
	else
		if IsInGamepadPreferredMode() then
			ZO_Dialogs_ShowGamepadDialog(LEAVE_DIALOG)
		else
			ZO_Dialogs_ShowDialog(LEAVE_DIALOG)
		end
	end
end

function Outkasted.SetupLibHistCallback()
	log:Debug("OUTKASTED >> Initializing LibHistoire Callback")
	LibHistoire:RegisterCallback(LibHistoire.callback.INITIALIZED, function()
		log:Debug("OUTKASTED >> LibHistoire Initialized callback received")
		local function SetUpListener(guildId, category)
			log:Debug("OUTKASTED >> Setting up listener for guild " .. guildId .. " with category " .. category)
			local listener = LibHistoire:CreateGuildHistoryListener(guildId, category)
			local key = listener:GetKey()
			log:Debug("OUTKASTED >> Key: " .. key)
			listener:SetAfterEventId(StringToId64(saveData.lastEventId[key]))

			listener:SetNextEventCallback(function(eventType, eventId, eventTime, param1, param2, param3, param4, param5, param6)
				-- the events received by this callback are in the correct historic order
				log:Debug("OUTKASTED >> NEC >> eventType: " .. eventType)
				log:Debug("OUTKASTED >> NEC >> eventId: " .. eventId)
				log:Debug("OUTKASTED >> NEC >> eventTime: " .. eventTime)
				log:Debug("OUTKASTED >> NEC >> param1: " .. param1)
				log:Debug("OUTKASTED >> NEC >> param2: " .. param2)
				log:Debug("OUTKASTED >> NEC >> param3: " .. param3)
				log:Debug("OUTKASTED >> NEC >> param4: " .. param4)
				log:Debug("OUTKASTED >> NEC >> param5: " .. param5)
				log:Debug("OUTKASTED >> NEC >> param6: " .. param6)
				saveData.lastEventId[key] = Id64ToString(eventId)
			end)

			listener:SetMissedEventCallback(function(eventType, eventId, eventTime, param1, param2, param3, param4, param5, param6)
				log:Debug("OUTKASTED >> MEC >> eventType: " .. eventType)
				log:Debug("OUTKASTED >> MEC >> eventId: " .. eventId)
				log:Debug("OUTKASTED >> MEC >> eventTime: " .. eventTime)
				log:Debug("OUTKASTED >> MEC >> param1: " .. param1)
				log:Debug("OUTKASTED >> MEC >> param2: " .. param2)
				log:Debug("OUTKASTED >> MEC >> param3: " .. param3)
				log:Debug("OUTKASTED >> MEC >> param4: " .. param4)
				log:Debug("OUTKASTED >> MEC >> param5: " .. param5)
				log:Debug("OUTKASTED >> MEC >> param6: " .. param6)
				-- events in this callback are out of order compared to what has been received by the next event callback and can even have an eventId smaller than what has been specified via SetAfterEventId.
			end)
			listener:Start()
		end

		SetUpListener(Outkasted.guildId, GUILD_HISTORY_GENERAL)
	end)
end

function Outkasted.OnAddOnLoaded(_, addonName)
	if addonName ~= Outkasted.name then return end
	EVENT_MANAGER:UnregisterForEvent(Outkasted.name, EVENT_ADD_ON_LOADED)
	log:Debug("Outkasted Add-On ready!")

	Outkasted.initMenu()

	ZO_CreateStringId("SI_BINDING_NAME_TP_OUTKASTED_GUILD_HALL", GetString(OUTK_CONTROLS_TP_OUTKASTED_GUILD_HALL))
	SLASH_COMMANDS["/guildhall"] = function() Outkasted.TeleportToGuildHall() end

	ZO_CreateStringId("SI_BINDING_NAME_LEAVE_INSTANCE", GetString(OUTK_CONTROLS_LEAVE_INSTANCE))
	SLASH_COMMANDS["/out"] = function() Outkasted.LeaveInstance(false) end

	SLASH_COMMANDS["/website"] = function() RequestOpenUnsafeURL(Outkasted.website) end
	SLASH_COMMANDS["/discord"] = function() RequestOpenUnsafeURL(Outkasted.discord) end
end

EVENT_MANAGER:RegisterForEvent(Outkasted.name, EVENT_ADD_ON_LOADED, Outkasted.OnAddOnLoaded)
Outkasted.SetupLibHistCallback()
