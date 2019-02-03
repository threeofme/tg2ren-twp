function Weight()

	if GetState("SHIP",STATE_FIGHTING) then
		return 0
	end
	
	local ShipFilter = "__F((Object.GetObjectsByRadius(Ship)==10000)AND NOT(Object.IsType(4))AND NOT(Object.BelongsToMe())AND NOT(Object.HasImpact(shipplunderedtoday)))"
	local NumDamagedShips = Find("SHIP",ShipFilter,"MyTarget",-1)
	local Found = 0
	if NumDamagedShips > 0 then
		Found = 1
	elseif ScenarioGetRandomObject("cl_Ship","MyTarget") then
		Found = 1
	end
	
	if Found == 0 then
		return 0
	end
	
	local Type = CartGetType("MyTarget")
	if Type == EN_CT_FISHERBOOT then
		return 0
	end
	
	local TargetID = GetDynastyID("MyTarget")
	
	if (TargetID == GetDynastyID("SHIP")) then
		return 0
	end

	if TargetID > 0 then
		if GetDynasty("MyTarget","TargetDynasty") then
			GetDynasty("SHIP","MyDynasty")
			if (GetFavorToDynasty("MyDynasty","TargetDynasty")>45) then
				return 0
			end
		end
	end
	if GetImpactValue("MyTarget","shipplunderedtoday")>0 then
		return 0
	end
	
	local Booty = chr_GetBootyCount("MyTarget",INVENTORY_STD)
	
	if Booty < 100 then
		if AliasExists("TargetDynasty") and DynastyIsPlayer("TargetDynasty") then
			return 0
		end 
		Booty = Rand(100)
	end
	
	local MenCnt = GetProperty("SHIP", "ShipMenCnt") * GetImpactValue("SHIP", "ShipMenMod")
	local OtherMenCnt = GetProperty("MyTarget", "ShipMenCnt") * GetImpactValue("MyTarget", "ShipMenMod")
	
	if GetHPRelative("")<0.8 then
		if GetImpactValue("","FullOfLove")==0 then
			SetData("GetSupplies",1)
			return -1
		elseif GetHPRelative("")<0.5 then
			SetData("GetSupplies",1)
			return -1
		end
	end
	
	if MenCnt < OtherMenCnt then
		SetData("GetSupplies",1)
		SetData("RaiseMenTo",OtherMenCnt)
	end
	
	return 30 + Booty
end

function Execute()
	MeasureCreate("Measure")
	if HasData("GetSupplies") then
		if HasData("RaiseMenTo") then
			MeasureAddData("Measure", "RaiseMenTo", GetData("RaiseMenTo"))
		end
		MeasureStart("Measure", "SHIP", "SHIP", "SailHomeAndRepair")
	end
	
	MeasureStart("Measure", "SHIP", "MyTarget", "PlunderShip")
end
