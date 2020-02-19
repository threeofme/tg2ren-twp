function Run()
	if GetImpactValue("","spying") == 1 then
		return ""
	end
	
	if GetDynastyID("") == GetDynastyID("Actor") then
		return ""
	end
	
	local Distance = CalcDistance("", "Actor")
	if Distance < 0 then
		return ""
	end
	
	local Radius = 100*(4 + GetSkillValue("", 8))	-- 8 = "empathy"
	if Radius < Distance then
		return ""
	end
	
	local	Var = (100 - 10*GetSkillValue("Actor", 6) + 4*GetSkillValue("", 8))	-- 6 = "shadow arts"
	if Var < 5 then
		Var = 5
	end
	local	Rot1 	= ObjectGetRotationY("")
	local	Rot2	= 270 - GetRotation("Actor", "")
	local Diff = math.abs(Rot1 - Rot2)
	Diff = math.mod(Diff, 360)
	if Diff > 180 then
		Diff = 360-Diff
	end

	if Diff < 30 then
		Diff = 30
	end
	
	Var 	= (Var*10 / Diff)
	
	--half as easy as planned
	Var	= Var*0.5
	
	if Rand(10000) < Var*100 then
		SetState("actor", STATE_HIDDEN, false)
		return "DetectHidden"
	end
	return ""
end

