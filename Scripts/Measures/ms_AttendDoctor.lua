function Run()
	if GetInsideBuilding("","CurrentBuilding") then
		GetSettlement("CurrentBuilding","City")
		if BuildingGetType("CurrentBuilding")==GL_BUILDING_TYPE_HOSPITAL then
			CopyAlias("CurrentBuilding","Destination")
		end
	end
	if not AliasExists("City") then
		if not GetNearestSettlement("", "City") then
			StopMeasure()
		end
	end
	
	if GetState("",STATE_TOWNNPC) then
		StopMeasure()
	elseif GetState("",STATE_NPC) then
		StopMeasure()
	end
	
	MeasureSetNotRestartable()
	
	if not AliasExists("Destination") then
		economy_GetRandomBuildingByRanking("City", "Destination", 0, GL_BUILDING_TYPE_HOSPITAL)
		if not AliasExists("Destination") then
			MsgQuick("","@L_MEDICUS_FAILURES_+1")
			StopMeasure()
		end
	end
	
	if (GetDynastyID("Destination")~=GetID("dynasty")) then
		local Costs = 0
		if GetImpactValue("","Sprain")==1 then
			Costs = diseases_GetTreatmentCost("Sprain")
		elseif GetImpactValue("","Cold")==1 then
			Costs = diseases_GetTreatmentCost("Cold")
		elseif GetImpactValue("","Influenza")==1 then
			Costs = diseases_GetTreatmentCost("Influenza")
		elseif GetImpactValue("","BurnWound")==1 then
			Costs = diseases_GetTreatmentCost("BurnWound")
		elseif GetImpactValue("","Pox")==1 then
			Costs = diseases_GetTreatmentCost("Pox")
		elseif GetImpactValue("","Pneumonia")==1 then
			Costs = diseases_GetTreatmentCost("Pneumonia")
		elseif GetImpactValue("","Blackdeath")==1 then
			Costs = diseases_GetTreatmentCost("Blackdeath")
		elseif GetImpactValue("","Fracture")==1 then
			Costs = diseases_GetTreatmentCost("Fracture")
		elseif GetImpactValue("","Caries")==1 then
			Costs = diseases_GetTreatmentCost("Caries")
		elseif GetHPRelative("") < 0.99 then
			Costs = GetMaxHP("")-GetHP("")
		else
			StopMeasure()
		end
		
		local Money = GetMoney("")
		if Costs > Money then
			MsgQuick("", "@L_MEDICUS_FAILURES_+2",GetID(""))	
			StopMeasure()
		end
	end
	local HospitalID = GetID("Destination")
	idlelib_VisitDoc(HospitalID)
end

function AIDecide()
	return "O"
end

function CleanUp()
end

-- -----------------------
-- GetOSHData
-- -----------------------
function GetOSHData(MeasureID)
	local Costs = 0
	if GetImpactValue("","Sprain")==1 then
		Costs = diseases_GetTreatmentCost("Sprain")
	elseif GetImpactValue("","Cold")==1 then
		Costs = diseases_GetTreatmentCost("Cold")
	elseif GetImpactValue("","Influenza")==1 then
		Costs = diseases_GetTreatmentCost("Influenza")
	elseif GetImpactValue("","BurnWound")==1 then
		Costs = diseases_GetTreatmentCost("BurnWound")
	elseif GetImpactValue("","Pox")==1 then
		Costs = diseases_GetTreatmentCost("Pox")
	elseif GetImpactValue("","Pneumonia")==1 then
		Costs = diseases_GetTreatmentCost("Pneumonia")
	elseif GetImpactValue("","Blackdeath")==1 then
		Costs = diseases_GetTreatmentCost("Blackdeath")
	elseif GetImpactValue("","Fracture")==1 then
		Costs = diseases_GetTreatmentCost("Fracture")
	elseif GetImpactValue("","Caries")==1 then
		Costs = diseases_GetTreatmentCost("Caries")
	elseif GetHPRelative("") < 0.99 then
		Costs = GetMaxHP("")-GetHP("")
	end
	OSHSetMeasureCost("@L_INTERFACE_HEADER_+6",Costs)
end


