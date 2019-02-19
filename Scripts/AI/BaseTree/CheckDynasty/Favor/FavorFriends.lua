function Weight()

	if not ReadyToRepeat("SIM", "AI_FavorFriends") then
		return 0
	end
	
	local AlliesCount = f_DynastyGetNumOfAllies("SIM")
	if AlliesCount < 1 then
		return 0
	end
	
	local AlliesTotal = 0
	if HasProperty("dynasty","Allies_Total") then
		AlliesTotal = GetProperty("dynasty","Allies_Total")
	end
		
	if AlliesTotal > 0 then
		for i=0, AlliesTotal-1 do
			if HasProperty("dynasty","Ally_"..i) then
				local FoundID = GetProperty("dynasty","Ally_"..i)
				GetAliasByID(FoundID, "Ally_"..i)
				if ReadyToRepeat("dynasty", "AI_Favor"..FoundID) then
					local BestState = ai_DynastyGetBestDiplomacyState("dynasty", "Ally_"..i)
					if BestState == "CurrentState" and GetFavorToDynasty("dynasty", "Ally_"..i) < 95 then
						local BossID = dyn_GetValidMember("Ally_"..i)
						GetAliasByID(BossID, "TargetBoss")
						if AliasExists("TargetBoss") then
							if f_SimIsValid("TargetBoss") then
								CopyAlias("TargetBoss", "Target")
								break
							end
						end
					end
				end
			end
		end
	end
	
	if not AliasExists("Target") then
		return 0
	end
	
	return 100
end

function Execute()
	SetRepeatTimer("SIM", "AI_FavorFriends", 1)
	local ID = GetDynastyID("Target")
	SetRepeatTimer("dynasty", "AI_Favor"..ID, 12)
end