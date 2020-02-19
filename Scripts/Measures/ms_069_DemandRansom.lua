function Init()

	if not SimGetWorkingPlace("", "Base") then
		return
	end

	if not BuildingGetPrisoner("Base", "Victim") then
		return
	end
	
	if not GetDynasty("Victim", "VictimDyn") then
		return
	end
	
	local iRanking = GetNobilityTitle("VictimDyn")
	local fMoney = math.floor(GetMoney("Victim")/2)
	if fMoney<100 then
		fMoney=100
	elseif fMoney > 33333.5 then
		fMoney = 33333.5
	end
	
	local Sum1 = math.floor(fMoney * 0.5)
	local Sum2 = math.floor(fMoney * 0.75)
	local Sum3 = fMoney
	local Sum4 = math.floor(fMoney * 1.25)
	local Sum5 = math.floor(fMoney * 1.5)
	local OutTime = GetProperty("Victim","HijackedEndTime")
	OutTime = Gametime2Total(OutTime)

	local result = InitData("@P"..
	"@B[1,,@L_THIEF_069_DEMANDRANSOM_ACTION_BTN_+0,Hud/Buttons/btn_Money_Small.tga]"..
	"@B[2,,@L_THIEF_069_DEMANDRANSOM_ACTION_BTN_+1,Hud/Buttons/btn_Money_SmallLarge.tga]"..
	"@B[3,,@L_THIEF_069_DEMANDRANSOM_ACTION_BTN_+2,Hud/Buttons/btn_Money_Medium.tga]"..
	"@B[4,,@L_THIEF_069_DEMANDRANSOM_ACTION_BTN_+3,Hud/Buttons/btn_Money_MediumLarge.tga]"..
	"@B[5,,@L_THIEF_069_DEMANDRANSOM_ACTION_BTN_+4,Hud/Buttons/btn_Money_Large.tga]",
	ms_069_demandransom_AIInitDemandRansom,
	"@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_VICTIM_HEAD_+0",
	"@L_THIEF_069_DEMANDRANSOM_ACTION_TEXT_+0",
	Sum1,Sum2,Sum3,Sum4,Sum5,GetID("Victim"),OutTime)


	if result==1 then
		fMoney = Sum1
	elseif result==2 then
		fMoney = Sum2
	elseif result==3 then
		fMoney = Sum3
	elseif result==4 then
		fMoney = Sum4
	elseif result==5 then
		fMoney = Sum5
	elseif result=="C" then
		return
	end
	SetData("TFRansom", fMoney)
end 

function AIInitDemandRansom()
	return (Rand(5)+1)
end

function AIInitDemandRansomAnswer()
	local MyMoney = GetMoney("")
	if MyMoney > 10000 or GetData("TFRansom") < 3000 then
		if GetData("TFRansom") < 20000 then
			return "O"
		end
	else
		if Rand(10) == 0 then
			return "O"
		end
	end
	
	return "C"
end


function Run()
	
	SetRepeatTimer("Base", GetMeasureRepeatName2("DemandRansom"), 6)
	
	local fMoney = GetData("TFRansom")

	if fMoney == nil or fMoney<100 then
		if not DynastyIsAI("") or not AliasExists("Victim") then
			return
		end

		fMoney = math.floor(GetMoney("Victim")/2)
		if fMoney<100 then
			fMoney=100
		end
		
		SetData("TFRansom", fMoney)
	end
	
	if not SimGetWorkingPlace("", "Base") then
		return
	end	
	
	--ask again for prisoner to avoid exploit
	if not BuildingGetPrisoner("Base", "Victim") then
		StopMeasure()
	end
	
	local result = MsgNews("Victim","","@P"..
				"@B[O,@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_VICTIM_BTN_+0]"..
				"@B[C,@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_VICTIM_BTN_+1]",
				ms_069_demandransom_AIInitDemandRansomAnswer,"default",8,
				"@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_VICTIM_HEAD_+0",
				"@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_VICTIM_BODY_+0",
				 GetID("Victim"),fMoney)
				 
	if result=="O" then
		--wants to pay
		if f_SpendMoney("Victim", fMoney, "CostRobbers") then
			chr_RecieveMoney("", fMoney, "IncomeRobbers")
			--for the mission
			mission_ScoreCrime("",fMoney)
			feedback_MessageCharacter("",
				"@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_ACTOR_SUCCESS_HEAD_+0",
				"@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_ACTOR_SUCCESS_BODY_+0",GetID("Victim"), fMoney)
			if not MeasureRun("Base", NIL, "LetAbducteeFree",false) then
				SetProperty("Victim","ForceFree",1)
			end
		else
			--can't pay
			feedback_MessageCharacter("",
				"@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_ACTOR_TIMEOUT_HEAD_+0",
				"@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_ACTOR_TIMEOUT_BODY_+0",GetID("Victim"),GetID("Victim"))		
		end
	else
		--doesnt wanna pay
		feedback_MessageCharacter("",
			"@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_ACTOR_TIMEOUT_HEAD_+0",
			"@L_THIEF_069_DEMANDRANSOM_RANSOMDEMAND_ACTOR_TIMEOUT_BODY_+0",GetID("Victim"),GetID("Victim"))		
	end
end

function CleanUp()

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

