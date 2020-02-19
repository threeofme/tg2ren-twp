function Run()
	if SimGetAge("") <= 16 then
		return "Flee"
	end

	if GetImpactValue("","spying") == 1 then 
		return ""
	end
	
	-- mine guards ignore fire
	if HasProperty("","Guarding") then 
		return ""
	end
	
	if (SimGetProfession("")==GL_PROFESSION_CITYGUARD or SimGetProfession("")==GL_PROFESSION_ELITEGUARD) then
		return "PutoutFire"
	end
	
	if GetCurrentMeasureName("")=="SquadHijackMember"  then
		return ""
	end
	
	if SimGetWorkingPlaceID("Owner")==GetID("Actor") then
		if BuildingGetOwner("Actor", "BuildingOwner") then
			if GetFavorToSim("Owner", "BuildingOwner") > 40 then
				return "PutoutFire"
			else
				return "Gape"
			end
		end
	end
	
	if GetHomeBuildingId("")==GetID("Actor") then
		return "PutoutFire"
	end
	
	if DynastyIsPlayer("") then
		if GetHomeBuildingId("")==GetID("Actor") then
			return "PutoutFire"
		elseif BuildingGetOwner("Actor", "BuildingOwner") then
			if GetFavorToSim("Owner", "BuildingOwner") > 80 then
				return "PutoutFire"
			end
		else
			return ""
		end
	end
	
	local DynID = GetDynastyID("")
	if SimGetProfession("")==GL_PROFESSION_MYRMIDON then
		if GetImpactValue("Actor","buildingbombedby")==DynID then
			return ""
		end
	end
	
	if GetState("",STATE_ROBBERGUARD) then
		return ""
	end
	
	local State
	State = DynastyGetDiplomacyState("", "Actor")

	if State >= DIP_ALLIANCE then
		-- alliierter oder von der selber dynasty
		return "PutoutFire"
	end
	
	if State < DIP_NEUTRAL then
		SetData("Distance", 1000)
		return "Gape"
	end
	
	if SimGetAlignment("")<50 then
		return "PutoutFire"
	end
	
	SetData("Distance", 1500)
	return "Flee"
end

