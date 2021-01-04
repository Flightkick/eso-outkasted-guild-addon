Outkasted = Outkasted or {}
Outkasted.name = "Outkasted"
Outkasted.version = "1.2"

function Outkasted.TeleportToGuildHall()
	local guildhall = { owner = "@Selegnar", houseId = 47 }
    -- Apparently JumpToSpecificHouse on the player's own house is not allowed. Something something cohesion...
	if guildhall.owner == GetDisplayName() then
        RequestJumpToHouse(guildhall.houseId)
	else
	    JumpToSpecificHouse(guildhall.owner, guildhall.houseId)
	end
end

function Outkasted.LeaveInstance(confirm)
	local LEAVE_DIALOG = "INSTANCE_LEAVE_DIALOG"

	if not IsUnitInDungeon("reticleover") then
		d("ZOS reports you're currently not inside a dungeon or trial but since this API seems unstable let me try to get you out anyway.")
	else
		d("Exiting instance")
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

function Outkasted.OnAddOnLoaded(_, addonName)
	if addonName ~= Outkasted.name then return end
	EVENT_MANAGER:UnregisterForEvent(Outkasted.name, EVENT_ADD_ON_LOADED)

	Outkasted.initMenu()

	ZO_CreateStringId("SI_BINDING_NAME_TP_OUTKASTED_GUILD_HALL", "Teleport to Outkasted guild house")
	SLASH_COMMANDS["/guildhall"] = function() Outkasted.TeleportToGuildHall() end

	ZO_CreateStringId("SI_BINDING_NAME_LEAVE_INSTANCE", "Leave instance")
	SLASH_COMMANDS["/out"] = function() Outkasted.LeaveInstance(false) end
end

EVENT_MANAGER:RegisterForEvent(Outkasted.name, EVENT_ADD_ON_LOADED, Outkasted.OnAddOnLoaded)
