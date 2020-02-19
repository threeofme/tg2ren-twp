function Run()
	if GetImpactValue("","spying") == 1 then
		return ""
	end
	
--	if not GetState("", STATE_IDLE) then
--		return ""
--	end
	
	if GetState("",STATE_ROBBERGUARD) then
		return ""
	end
	
	if SimGetProfession("")==GL_PROFESSION_MYRMIDON then
		return ""
	end

	if not ReadyToRepeat("", "Listen2Preacher") then
		return ""
	end

	return "ListenPreachBible"
end

