Outkasted = Outkasted or {}
Outkasted.name = "Outkasted"
Outkasted.version = "1.1"

function Outkasted.TeleportToGuildHall()
	local guildhall = { owner = "@Selegnar", houseId = 47 }
    -- Apparently JumpToSpecificHouse on the player's own house is not allowed. Something something cohesion...
	if guildhall.owner == GetDisplayName() then
        RequestJumpToHouse(guildhall.houseId)
	else
	    JumpToSpecificHouse(guildhall.owner, guildhall.houseId)
	end
end

function Outkasted.OnAddOnLoaded(_, addonName)
	if addonName ~= Outkasted.name then return end

	Outkasted.initMenu()

	ZO_CreateStringId("SI_BINDING_NAME_TP_OUTKASTED_GUILD_HALL", "Teleport to Outkasted guild house.")
	SLASH_COMMANDS["/guildhall"] = function() Outkasted.TeleportToGuildHall() end
end

EVENT_MANAGER:RegisterForEvent(Outkasted.name, EVENT_ADD_ON_LOADED, Outkasted.OnAddOnLoaded)
