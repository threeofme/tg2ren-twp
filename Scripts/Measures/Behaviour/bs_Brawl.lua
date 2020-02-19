function Run()
	if GetState("",STATE_FIGHTING) then
		return
	end
	
	if GetHPRelative("")>0.3 then
		--if Rand(100)>50 then
			local FightPartners = Find("", "__F((Object.GetObjectsByRadius(Sim)==1000)AND NOT(Object.HasDynasty())AND NOT(Object.GetState(unconscious))AND NOT(Object.GetState(fighting))AND NOT(Object.GetState(dead))AND(Object.CompareHP()>30))","FightPartner", -1)
			if FightPartners>0 then
				idlelib_ForceAFight("FightPartner")
				return
			end
		--else
		--	local FightPartners = Find("", "__F((Object.GetObjectsByRadius(Building)==3000)AND)","FightPartner", -1)
		--	if FightPartners>0 then
		--		BattleJoin("","FightPartner",false)
		--		return
		--	end
		--end
	end
	return
end

