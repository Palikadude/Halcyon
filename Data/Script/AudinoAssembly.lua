require 'common'
AudinoAssembly = {}
local MapStrings = {}


function AudinoAssembly.Assembly(owner)
	MapStrings = COMMON.AutoLoadLocalizedStrings()
	local state = 0
	local repeated = false
	UI:SetSpeaker(owner)--owner is a parameter as this script can be reused (3rd floor, metano town's bell sign, etc)
	UI:SetSpeakerEmotion("Normal")


	while state > -1 do
		local msg = STRINGS:Format(MapStrings['Assembly_Intro'])
		if repeated then 
			msg = STRINGS:Format(MapStrings['Assembly_Intro_Return'])
		end
		local assembly_options = {STRINGS:Format(MapStrings['Assembly_Option_Members']),
								  STRINGS:FormatKey("MENU_INFO"),
								  STRINGS:FormatKey("MENU_EXIT")}
		UI:BeginChoiceMenu(msg, assembly_options, 1, 3)
		UI:WaitForChoice()
		local result = UI:ChoiceResult()
		repeated = true
		if result == 1 then
			local old_party = GAME:GetPlayerPartyTable()
			local old_leader_index = GAME:GetTeamLeaderIndex()
			UI:AssemblyMenu()
			UI:WaitForChoice()
			local assembly_result = UI:ChoiceResult()
			if assembly_result then
				local new_party = GAME:GetPlayerPartyTable()
				local new_leader_index = GAME:GetTeamLeaderIndex()
				local added = AudinoAssembly.MemberDifference(new_party, old_party)
				local removed = AudinoAssembly.MemberDifference(old_party, new_party)
				local message = 1--tracks which message to use. Messages go Ok, (text)...; ...(text)...; ... And (text).  
				local message_count = 0--how many messages do we have? Important because we need to know how to structure the prefix of a sentence based on what number this message is
				local newLeader = (old_party[old_leader_index] ~= new_party[new_leader_index])
				local addedMembers = (#added > 0)
				local removedMembers = (#removed > 0)
				
				
				if newLeader then 
					message_count = message_count + 1
				end
				if addedMembers then 
					message_count = message_count + 1
				end
				if removedMembers then
					message_count = message_count + 1
				end
				
				--if #added > 0 then print('shart') end
				
				--if message count is 0, then the player swapped members around without
				--actually doing something noteworthy (the above conditions). In that case player
				--a unique message
				--prefixes and suffixes are going to be hard written into the script because it kinda verbose to use map strings given the nature of how these messages need to be created...
				if message_count == 0 then 
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Assembly_Members_Shuffled']))
				else 
					local prefix, suffix = "", ""
					local charList = ""
					if newLeader then
						local leader = GAME:GetPlayerPartyMember(new_leader_index):GetDisplayName(true)
						prefix, suffix = AudinoAssembly.GetPrefixSuffix(message, message_count)
						message = message + 1
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Assembly_Leader_Changed'], prefix, leader, suffix))
					end
					if addedMembers then 
						prefix, suffix = AudinoAssembly.GetPrefixSuffix(message, message_count)
						charList = AudinoAssembly.WriteContents(added)
						message = message + 1
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Assembly_Members_Added'], prefix, charList, suffix))
					end
					if removedMembers then
						prefix, suffix = AudinoAssembly.GetPrefixSuffix(message, message_count)
						charList = AudinoAssembly.WriteContents(removed)
						UI:WaitShowDialogue(STRINGS:Format(MapStrings['Assembly_Members_Removed'], prefix, charList, suffix))
					end
					
					--audino rings the bell and makes the changes
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Assembly_Make_Changes']))
					GAME:WaitFrames(10)
					SOUND:PlayBattleSE("EVT_Assembly_Bell")
					GROUND:CharSetAction(owner, RogueEssence.Ground.PoseGroundAction(owner.Position, owner.Direction, RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose")))
					GAME:WaitFrames(100)
					--commented out as Halcyon itself won't need to call respawn allies ever when using the assembly
					--GAME:FadeOut(false, 40)
					--COMMON.RespawnAllies()
					--GAME:FadeIn(40)
					--GAME:WaitFrames(10)
					GROUND:CharSetAnim(owner, "None", true)
					UI:WaitShowDialogue(STRINGS:Format(MapStrings['Assembly_Make_Changes_Done']))
				end
			end
		elseif result == 2 then --info
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Assembly_Info_001']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Assembly_Info_002']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Assembly_Info_003']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Assembly_Info_004']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Assembly_Info_005']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Assembly_Info_006']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Assembly_Info_007']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Assembly_Info_008']))
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Assembly_Info_009']))
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Assembly_Info_010']))
			UI:SetSpeakerEmotion("Normal")
		else
			UI:SetSpeakerEmotion("Happy")
			UI:WaitShowDialogue(STRINGS:Format(MapStrings['Assembly_Goodbye']))
			state = -1
		end
	end
end


function AudinoAssembly.GetPrefixSuffix(messageNum, totalMessages)
	local prefix, suffix = "", ""
	
	if messageNum == 1 then 
		prefix = "Okay![pause=0] "
	elseif messageNum == 2 and totalMessages ~= messageNum then --3 messages, 2nd one in list being said
		prefix = '...'
	else
		prefix = '...And '
	end
	
	if messageNum == totalMessages then suffix = '!' else suffix = '...' end
	
	return prefix, suffix

end

function AudinoAssembly.MemberDifference(a, b)
	local list = {} 
	a = a or {}
	b = b or {}
	--print(#a)
	--print(#b)
	local found = false
	for i = 1, #a, 1 do
		for j = 1, #b, 1 do
			--print(a[i].Name)
			--print(b[j]:GetDisplayName(true))
			if a[i].Name == b[j].Name and a[i].BaseForm.Species == b[j].BaseForm.Species then found = true break end
		end
		if found then found = false else list[#list + 1] = a[i] end 
	end
	--print(#list)
	--for i,v in ipairs(list) do print(v) end
	return list
end

--write the contents of the character list with proper english.
function AudinoAssembly.WriteContents(list)
	local length = #list
	if length == 0 then return "null"
	elseif length == 1 then return list[1]:GetDisplayName(true)
	elseif length == 2 then return list[1]:GetDisplayName(true) .. " and " .. list[2]:GetDisplayName(true)
	else
		local retString = ""
		for i = 1, length - 1, 1 do--length of list - 1 as last character is a special case and this is a nicer way of doing it
			retString = retString .. list[i]:GetDisplayName(true) .. ", "
		end
		retString = retString .. " and " .. list[length]:GetDisplayName(true)
		return retString
	end
end


