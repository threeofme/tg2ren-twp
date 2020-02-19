function Run()
	if DynastyIsPlayer("") == true then	
		local impiwert = GetImpactValue("Destination",391)
		local neuwert
		if SimGetClass("") == 2 then
			neuwert = impiwert + 2
			AddImpact("Destination",391,neuwert,-1)
		else
			neuwert = impiwert + 1
			AddImpact("Destination",391,neuwert,-1)
		end
		SetProperty("Destination","BauIntervall",neuwert)
		ms_bauarbeit_Arbeiter()
	else
		local impiwert = GetImpactValue("Destination",391)
		if not f_MoveTo("","Destination",GL_MOVESPEED_RUN,100) then
			AddImpact("Destination",391,impiwert+1,-1) -- fallback
			StopMeasure()
		end
		local baufast = 1 -- fallback
		if HasProperty("Destination", "baufast") then
			baufast = GetProperty("Destination", "baufast")
		end
		if impiwert < 1 then
			AddImpact("Destination",391,baufast,-1)
		end
		
		if SimGetProfession("") == 59 or SimGetProfession("") == 60 then
			ms_bauarbeit_Meister()
		else
			ms_bauarbeit_Arbeiter()
		end
	end
end

function Meister()

	local doWork = { ms_bauarbeit_MasterA }
	CarryObject("","Handheld_Device/Anim_scroll.nif",false)				 		 
	while GetImpactValue("Destination",391) > 2 do
		doWork[1]((Rand(5)+1),GL_MOVESPEED_RUN)
	end

	CarryObject("","", false)
	CarryObject("","", true)	
	ms_bauarbeit_GoHome()

end

function Arbeiter()

  local doWork = { ms_bauarbeit_WorkA,
                 		ms_bauarbeit_WorkB,
                 		ms_bauarbeit_WorkC,
                 		ms_bauarbeit_WorkD,
                 		ms_bauarbeit_WorkE }
	
	if AliasExists("Destination") then
		while GetImpactValue("Destination",391) >= 1 do
		  CarryObject("","", false)
		  CarryObject("","", true)
			local speed = GL_MOVESPEED_WALK
			if Rand(2) == 1 then
				speed = GL_MOVESPEED_RUN
			end
		  doWork[(Rand(5)+1)]((Rand(5)+1),speed)
		end
	end

	if not DynastyIsPlayer("") then
	  ms_bauarbeit_GoHome()
	end
	return

end

function MasterA(Pos,Stand)
	local platz
	if Pos == 5 then
		platz = "Entry1"
	else
		platz = "Walledge"..Pos
	end
	local Count = 0
	while not ms_bauarbeit_TryToReach(platz, Stand) do
		Count = Count + 1
		if Count > 10 then 
			break
		end
		platz = ms_bauarbeit_GetNextRandomPosition(platz)
		Sleep(1)
	end
	AlignTo("","Destination")
	if Rand(2) == 0 then
		PlayAnimationNoWait("","use_book_standing")
		Sleep(1)
		CarryObject("","Handheld_Device/Anim_openscroll.nif",false)
		Sleep(3)
		CarryObject("","Handheld_Device/Anim_scroll.nif",false)
	end
	
	local spruch = Rand(4)
	if SimGetProfession("") == 60 then
		if spruch == 0 then
			MsgSay("","@L_HPFZ_BAUARBEIT_SPRUCH_+0")
		elseif spruch == 1 then
		    MsgSay("","@L_HPFZ_BAUARBEIT_SPRUCH_+1")
		elseif spruch == 2 then
		    MsgSay("","@L_HPFZ_BAUARBEIT_SPRUCH_+2")
		elseif spruch == 3 then
		    MsgSay("","@L_HPFZ_BAUARBEIT_SPRUCH_+3")
		end
	else
		BuildingGetOwner("destination", "buildingowner")
		if spruch == 0 then
	      MsgSay("","@L_HPFZ_BAUARBEIT_SPRUCH_+4", GetID("buildingowner"))
		elseif spruch == 1 then
		    MsgSay("","@L_HPFZ_BAUARBEIT_SPRUCH_+5", GetID("buildingowner"))
		elseif spruch == 2 then
		    MsgSay("","@L_HPFZ_BAUARBEIT_SPRUCH_+6", GetID("buildingowner"))
		elseif spruch == 3 then
		    MsgSay("","@L_HPFZ_BAUARBEIT_SPRUCH_+7", GetID("buildingowner"))
		end
	end
	Sleep(1)
end	

function GetNextRandomPosition(CPos)
	local NPos = Rand(5)+1
	while NPos == CPos do
		NPos = Rand(5)+1
	end
	return NPos
end

function TryToReach(Pos, Speed)
	GetLocatorByName("Destination",Pos,"dest")
	if not f_WeakMoveTo("","dest",-1,Speed) then
		return false
	end
	return true
end
	
function WorkA(Pos,Stand)
	local alternative
	local platz
	if Pos == 5 then
		platz = "Entry1"
	else
		platz = "Walledge"..Pos
	end
	
	local Count = 0
	while not ms_bauarbeit_TryToReach(platz, Stand) do
		Count = Count + 1
		if Count > 10 then 
			break
		end
		platz = ms_bauarbeit_GetNextRandomPosition(platz)
		Sleep(1)
	end
	SetContext("","rangerhut")
	CarryObject("","Handheld_Device/Anim_Hammer.nif", false)
	AlignTo("","Destination")
	Sleep(1)
	PlayAnimation("","hammer_in")
	LoopAnimation("","hammer_loop",(Rand(16)+10))
	PlayAnimation("","hammer_out")
end

function WorkB(Pos,Stand)
	local alternative
	local platz
	if Pos == 5 then
		platz = "Entry1"
	else
		platz = "Walledge"..Pos
	end

	local Count = 0
	while not ms_bauarbeit_TryToReach(platz, Stand) do
		Count = Count + 1
		if Count > 10 then 
			break
		end
		platz = ms_bauarbeit_GetNextRandomPosition(platz)
		Sleep(2)
	end
	CarryObject("","Handheld_Device/ANIM_Chisel.nif", false)
	AlignTo("","Destination")
	Sleep(1)
	PlayAnimation("","knee_work_in")
	LoopAnimation("","knee_work_loop",(Rand(16)+10))
	PlayAnimation("","knee_work_out")
	
end

function WorkC(Pos,Stand)
	local alternative
	local platz
	if Pos == 5 then	
		platz = "Entry1"
	else
		platz = "Walledge"..Pos
	end

	local Count = 0
	while not ms_bauarbeit_TryToReach(platz, Stand) do
		Count = Count + 1
		if Count > 10 then 
			break
		end
		platz = ms_bauarbeit_GetNextRandomPosition(platz)
		Sleep(1)
	end
	SetContext("","rangerhut")
	CarryObject("","Handheld_Device/Anim_Hammer.nif", false)
	AlignTo("","Destination")
	Sleep(1)
	PlayAnimation("","chop_in")
	LoopAnimation("","chop_loop",(Rand(16)+10))
	PlayAnimation("","chop_out")

end

function WorkD(Pos,Stand)
	local alternative
	local platz
	if Pos == 5 then
		platz = "Entry1"
	else
		platz = "Walledge"..Pos
	end

	local Count = 0
	while not ms_bauarbeit_TryToReach(platz, Stand) do
		Count = Count + 1
		if Count > 10 then 
			break
		end
		platz = ms_bauarbeit_GetNextRandomPosition(platz)
		Sleep(1)
	end
	CarryObject("","Handheld_Device/ANIM_Chisel.nif", false)
	AlignTo("","Destination")
	Sleep(1)
	PlayAnimation("","manipulate_top_r")
end

function WorkE(Pos,Stand)
	local alternative
	local platz
	if Pos == 5 then
		platz = "Entry1"
	else
		platz = "Walledge"..Pos
	end

	local Count = 0
	while not ms_bauarbeit_TryToReach(platz, Stand) do
		Count = Count + 1
		if Count > 10 then 
			break
		end
		platz = ms_bauarbeit_GetNextRandomPosition(platz)
		Sleep(1)
	end
	CarryObject("","Handheld_Device/ANIM_Chisel.nif", false)
	AlignTo("","Destination")
	Sleep(1)
	PlayAnimation("","manipulate_middle_up_l")
	
end

function GoHome()
	CarryObject("","", false)
	CarryObject("","", true)
	
	if AliasExists("Destination") then
		FindNearestBuilding("Destination",1,1,-1,false,"Haia")
		f_WeakMoveTo("","Haia",GL_MOVESPEED_RUN,20)
	end
	
	if not DynastyIsPlayer("") then
		InternalDie("")
		InternalRemove("")
	end
end

function CleanUp()
	if AliasExists("Destination") then
		if GetState("Destination",STATE_BUILDING) == true then
	    if SimGetClass("") == 2 then
		    AddImpact("Destination",391,-2,-1)
	    else
		    AddImpact("Destination",391,-1,-1)
	    end
		end
	end
	
	if AliasExists("") then
		if not DynastyIsPlayer("") then
			InternalDie("")
			InternalRemove("")
		end
	end
end
