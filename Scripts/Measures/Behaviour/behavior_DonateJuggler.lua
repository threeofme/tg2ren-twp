function Run()

	if GetImpactValue("","HaveBeenPickpocketed")>0 then
		return
	end
	ai_GetWorkBuilding("Actor", 102, "Juggler")
	local begbonus = math.floor(GetImpactValue("Juggler",394))
	local spender = SimGetRank("")
	local spend
	local charm = GetSkillValue("Actor", CHARISMA)
	
	if spender == 0 or spender == 1 then
		spend = 3+Rand(4)
	elseif spender == 2 then
		spend = 5+Rand(6)
	elseif spender == 3 then
		spend = 8+Rand(9)
	elseif spender == 4 then
		spend = 10+Rand(11)
	elseif spender == 5 then
		spend = 12+Rand(13)
	end
	local getbeg = math.floor(spend + ((spend / 100) * begbonus))+Rand(5)*charm
	f_CreditMoney("Juggler",getbeg,"Offering")
	economy_UpdateBalance("Juggler", "Service", getbeg)
	IncrementXPQuiet("Actor",15)
	if dyn_IsLocalPlayer("Actor") then
		ShowOverheadSymbol("Actor",false,true,0,"%1t",getbeg)
	end
	AddImpact("Owner", "HaveBeenPickpocketed", 1, 4)
end

