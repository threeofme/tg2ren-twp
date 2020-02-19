-- ******** THANKS TO KINVER ********
function Init()
	InitAlias("Idx","_PamphletSheet","__F((Object.HasProperty(NoOneHasThisProperty)))","_MEASURE_RemovePamphlet_TARGET_+0",0)
end

function Run()
	-- get the blackboard
	if DynastyIsAI("") then
		GetSettlement("","BlackBoardCity")
		CityGetRandomBuilding("BlackBoardCity",-1,41,-1,-1,FILTER_IGNORE,"BlackBoard")
	elseif not AliasExists("BlackBoard") then
		local Filter = "__F((Object.GetObjectsByRadius(Building) == 410) AND (Object.IsType(41)))"
		local result = Find("", Filter,"BlackBoard", -1)
		if result <= 0 then
			return 
		end
	end
	
	if IsStateDriven() then
		for i=0,3 do
			if HasProperty("BlackBoard","Pamphlet_"..i) then
				local PamphletID = GetProperty("BlackBoard","Pamphlet_"..i)
				if GetAliasByID(PamphletID,"PamphletVictim") then
					if (GetDynastyID("PamphletVictim") == GetDynastyID("")) then
						SetData("PamphletIdx",i)
					end
				end
			end
		end
	end

	local Idx
	if HasData("PamphletIdx") then
		Idx = GetData("PamphletIdx")
	else
		return
	end
	if not HasProperty("BlackBoard","Pamphlet_"..Idx) then
		return		
	end
	GetLocatorByName("BlackBoard","entry1","MovePos")
	f_MoveTo("","MovePos",GL_MOVESPEED_RUN)
	AlignTo("","BlackBoard")
	Sleep(1)
	PlayAnimation("","manipulate_middle_up_r")
--local message = "@L Getdata is %1t"
--MsgSay("",message, Idx)
	Sleep(1)
	if not HasProperty("BlackBoard","Pamphlet_"..Idx) then
		return		
	end
	if BlackBoardRemovePamphlet("BlackBoard",Idx) then
		if HasProperty("BlackBoard","Pamphlet_"..Idx) then
			RemoveProperty("BlackBoard","Pamphlet_"..Idx)
		end
		if HasProperty("BlackBoard","Pamphlet_"..Idx.."Dur") then
			RemoveProperty("BlackBoard","Pamphlet_"..Idx.."Dur")
		end
		local MeasureID = GetCurrentMeasureID("")
		local TimeOut = mdata_GetTimeOut(MeasureID)
		SetMeasureRepeat(TimeOut)
		chr_GainXP("",GetData("BaseXP"))
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

