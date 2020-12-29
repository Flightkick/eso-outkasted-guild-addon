Outkasted = Outkasted or {}
Outkasted.name = "Outkasted"
Outkasted.version = "1.0"

function Outkasted.TeleportToGuildHall()
	JumpToSpecificHouse("@Selegnar", 47)
end

function Outkasted.OnAddOnLoaded(_, addonName)
	if addonName ~= Outkasted.name then return end
	
	Outkasted.initMenu()

	ZO_CreateStringId("SI_BINDING_NAME_TP_OUTKASTED_GUILD_HALL", "Teleport to Outkasted guild house.")
	SLASH_COMMANDS["/guildhall"] = function() Outkasted.TeleportToGuildHall() end
end

EVENT_MANAGER:RegisterForEvent(Outkasted.name, EVENT_ADD_ON_LOADED, Outkasted.OnAddOnLoaded)
