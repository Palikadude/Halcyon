require 'common'
PartnerEssentials = {}


--This function is called to move partner to a specific marker on loading a new map
function PartnerEssentials.InitializePartnerSpawn(dir)
	--FYI: Each map has an initial point where the partner spawns. 
	--Set the PartnerSpawn variable to default to let the partner spawn there
	--My nomenclature, to keep things consistent, is to just copy the player's spawn marker's name,
	--add _Partner to the end for the partner's marker.
	--You can specify the dir parameter for a custom direction to spawn as if you want.
	--This function also assigns ground partner AI to the partner so they actually follow you.
	if SV.partner.Spawn ~= 'Default' then
		local player = CH('PLAYER')
		local partner = CH('Teammate1')
		local marker = MRKR(SV.partner.Spawn)
		dir = dir or marker.Direction or partner.Direction
		
		
		GROUND:TeleportTo(partner, marker.Position.X, marker.Position.Y, dir)
	end	
	

	local chara = CH('Teammate1')
	AI:SetCharacterAI(chara, "ai.ground_partner", CH('PLAYER'), chara.Position)
    chara.CollisionDisabled = true
	
end





--[[
partner's dialogue can be changed by walking over markers that indicate where in a map you're standing. This gives you the ability
to have the partner's dialogue be much more dynamic than the normal PMD games. This command is basically just going to a giant
case statement methinks.
]]--
function PartnerEssentials.GetPartnerDialogue(partner)
	UI:SetSpeaker(partner)
	if SV.partner.Dialogue ~= 'Default' then
		UI:WaitShowDialogue("Placeholder.")
	else--generic dialogue 
	    UI:WaitShowDialogue("Partner Dialogue script is being called. Let Palika know if this message doesn't appear when you talk to me.")
	end

end



