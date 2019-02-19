function Weight()
	
	if SimGetAge("SIM") < 18 then
		return 0
	end
	
	if SimGetSpouse("SIM", "Spouse") then
		return 0
	end

	if SimGetCourtLover("SIM", "Beloved") then
		if GetStateImpact("Beloved", "no_control") then
			return 0
		end
		
		if SimGetBehavior("Beloved")=="CheckPresession" or SimGetBehavior("Beloved")=="CheckTrial" then
			return 0
		end
		
		if GetHP("Beloved")==0 or GetState("Beloved", STATE_DEAD) or GetState("Beloved",STATE_UNCONSCIOUS) or GetState("Beloved",STATE_WORKING) then
			return 0
		end
	end
	
	if not AliasExists("Beloved") then
	
		if not ReadyToRepeat("SIM", "AI_CourtLover_Start") then
			return 0
		end
		
		SetData("aicl_todo", "Start")
		return 100
	end
	
	local	Progress = SimGetProgress("SIM")
	if Progress>98 then
		SetData("aicl_todo", "Marry")
		return 100
	end
	
	local	M = {}
	local Count
	
	Count , M[0], M[1], M[2] = SimGetFavourableCourtingAction("SIM")

	local	Value0
	local	Value1

	if HasProperty("", "_ai_cl_0") then
		Value0 = GetProperty("", "_ai_cl_0", 0)
	end

	if HasProperty("", "_ai_cl_1") then
		Value1 = GetProperty("", "_ai_cl_1", 0)
	end
	
	local	MeasureName

	for l=0,Count-1 do
		MeasureName = exp_courtlover_CheckCourtMeasure(M[l], Value0, Value1)
		if MeasureName then
			SetData("aicl_todo", "Court")
			SetData("aicl_measure", MeasureName)
			return 100
		end
	end

	return 0
end

function Execute()

	local	ToDo = GetData("aicl_todo")
	
	if ToDo=="Start" then
		SetRepeatTimer("SIM", "AI_CourtLover_Start", 1)
		MeasureRun("SIM", nil, "CourtLover")
		return
	end
	
	if ToDo=="Marry" then
		MeasureRun("SIM", "Beloved", "Marry")
		return
	end
	
	if ToDo=="Court" then

		Measure= GetData("aicl_measure")
		exp_courtlover_RunCourtMeasure(Measure)

		if HasProperty("", "_ai_cl_0") then
			SetProperty("", "_ai_cl_1", GetProperty("", "_ai_cl_0", ""))
		end
		SetProperty("", "_ai_cl_0", Measure)
		return
	end
	
	return
end

function CheckCourtMeasure(BestMeasureId, Forbidden0, Forbidden1)

	if not BestMeasureId or BestMeasureId==-1 then
		return
	end
	
	local MeasureName = CourtingId2Measure(BestMeasureId)
	if not MeasureName then
		return
	end

	if MeasureName==Forbidden0 or MeasureName==Forbidden1 then
		return
	end

	if GetMeasureRepeat("SIM", MeasureName)>0 then
		return
	end
	
	return MeasureName
end

function RunCourtMeasure(MeasureName)
	local Success = MeasureRun("SIM", "Beloved", MeasureName)
	return Success
end
