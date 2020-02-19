function Run()
	if GetCurrentMeasureName("") == "AddPamphlet" then
		return ""
	end
	
	if GetImpactValue("","spying") == 1 then
		return ""
	end
	
	if GetImpactValue("","BlackboardVisited") == 1 then
		return ""
	else
		AddImpact("","BlackboardVisited",1,6)
	end
	
	if GetState("",STATE_IMPRISONED) or GetState("",STATE_CAPTURED) then
		return ""
	end
	
	if GetState("",STATE_ROBBERGUARD) then
		return ""
	end
	
	if GetState("",STATE_WORKING) then
		return ""
	end
	
	if SimGetProfession("")==GL_PROFESSION_MYRMIDON then
		return ""
	end

	return "CheerBlackBoard"
	
end

