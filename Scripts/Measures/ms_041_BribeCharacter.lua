-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_041_BribeCharacter"
----
----	with this measure the player can bribe another character to 
----	get a huge bonus for trials and office elections.
----
----	This measure has been greatly reworked by Fajeth
----
-------------------------------------------------------------------------------

function Init()
	
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	local Money = GetMoney("Destination") 

	GetDynasty("Destination", "dynasty")
	
	-- cancel this measure if Destination is in office and the session is about to begin
	local officetime = math.mod(GetGametime(),24)
	if SimGetOfficeLevel("Destination")>=1 then
		if officetime > 16.5 and officetime <= 17 then
			StopMeasure()
		end
	end
	
	if not DynastyIsPlayer("") and Money > 10000 then
		Money = 10000
	end
	
	if Money < 2000 then
		Money = 2000
	end
	
	local Button1 = "@B[1,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+0,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+0,Hud/Buttons/btn_Money_Small.tga]"
	local Button2 = "@B[2,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+1,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+1,Hud/Buttons/btn_Money_Medium.tga]"
	local Button3 = "@B[3,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+2,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_CHOICE_+2,Hud/Buttons/btn_Money_Large.tga]"
	
	if GetMoney("") < Money * 0.25 then
		MsgQuick("","@L_INTRIGUE_041_BRIBECHARACTER_FAILURES_+0")
		StopMeasure()
	elseif GetMoney("") < Money * 0.50 then
		Button2 = ""
		Button3 = ""
	elseif GetMoney("") < Money then
		Button3 = ""
	end
	
	local Skill = GetSkillValue("",BARGAINING)/100
	local Choice1 = (0.25 * Money)*(1-Skill*2)
	local Choice2 = (0.50 * Money)*(1-Skill*2)
	local Choice3 = (1.00 * Money)*(1-Skill*2)
	MsgMeasure("","")
	local result = InitData("@P"..
	Button1..
	Button2..
	Button3,
	ms_041_bribecharacter_AIInitBribe,
	"@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_HEAD_+0",
	"@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_ACTOR_BODY_+0",
	GetID("Destination"),Choice1,Choice2,Choice3)

	if result==1 then
		SetData("TFBribe", Choice1)
	elseif result==2 then
		SetData("TFBribe", Choice2)
	elseif result==3 then
		SetData("TFBribe", Choice3)
	end
end

function AIInitBribe()
	--AI decides how much money to spend
	local OwnerMoney = GetMoney("Owner")
	local Favor = GetFavorToSim("Destination","Owner")
	local SpendFactor = 0
	local OfficeRankOwner = SimGetOfficeLevel("Owner")
	local OfficeRankDestination = SimGetOfficeLevel("Destination")
	-- You are willing to pay higher amounts if you have lots of money
	if OwnerMoney > 15000 then
		SpendFactor = SpendFactor + 1
	end
	-- You are willing to pay higher amounts if the target doesn't like you
	if Favor < 50 then
		SpendFactor = SpendFactor + 1
	end
	-- You are willing to pay higher amounts if the target has an higher office
	if OfficeRankOwner < OfficeRankDestination then
		SpendFactor = SpendFactor +1
	end
	
	-- Make sure you don't pick the highest amounts if you haven't that much money 
	if OwnerMoney < 5000 then
		if SpendFactor > 2 then
			SpendFactor = 2
		end
	elseif OwnerMoney < 2500 then
		if SpendFactor > 1 then
			SpendFactor = 1
		end
	end
	
	
	if SpendFactor == 3 then
		return 3	
	elseif SpendFactor == 2 then
		return 2
	else
		return 1
	end
end

function AIDecision()
	--AI accept or decline money
	local Money = 0 + GetData("TFBribe")
	local Wealth = GetMoney("Destination")
	local Favor = GetFavorToSim("Destination","Owner")
	local RhetoricSkill = GetSkillValue("",RHETORIC)*2
	local Alignment = SimGetAlignment("Destination")
	local FavorFactor = ((Money*100)/Wealth) + Favor + RhetoricSkill+Alignment
	
	if FavorFactor < 100 then
		return 2 -- decline
	else
		return 1 -- accept
	end

end

function Run()
	if GetState("", STATE_CUTSCENE) then
		SetData("FromCutscene",1)
		ms_041_bribecharacter_Cutscene()
	else
		SetData("FromCutscene",0)
		ms_041_bribecharacter_Normal()
	end
end
  
function Normal()

	if not HasData("TFBribe") then
		if IsStateDriven() then
			ms_041_bribecharacter_Init();
		end
		if not HasData("TFBribe") then
			StopMeasure()
		end
	end

	--how far the Destination can be to start this action
	local MaxDistance = 1000
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 80
	--how much favor from destination to owner is modified. max value
	local MaxModifyFavor = 20
	--how long message for destination will be displayed
	local MsgTimeOut = 0.25 --15 sekunden
	
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)

	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
		StopMeasure()
	end
	
	--get money 
	local Money = 0 + GetData("TFBribe")
	local ModifyFavor
	--calc the favor
	local DestMoney = GetMoney("Destination") / 10
	local FavorFactor = (Money / DestMoney) * 100
	
	if FavorFactor < 35 then
		ModifyFavor = math.floor(0.3 * MaxModifyFavor)
	elseif FavorFactor < 65 then
		ModifyFavor = math.floor(0.65 * MaxModifyFavor)
	else
		ModifyFavor = MaxModifyFavor
	end
	
	if not DynastyIsPlayer("Destination") then
		CreateCutscene("default","cutscene")
		CutsceneAddSim("cutscene","")
		CutsceneAddSim("cutscene","Destination")
		CutsceneCameraCreate("cutscene","")		
		camera_CutsceneBothLock("cutscene", "")
	end
	
	--do visual stuff
	--CommitAction("bribe","Owner","Owner","Destination")
	--PlayAnimationNoWait("Destination","cogitate")
	PlayAnimation("", "watch_for_guard")
	
	local time1
	local time2
	time1 = PlayAnimationNoWait("Owner", "use_object_standing")
	time2 = PlayAnimationNoWait("Destination","cogitate")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","Handheld_Device/ANIM_Smallsack.nif",false)
	
	Sleep(1)
	CarryObject("","",false)
	CarryObject("Destination","Handheld_Device/ANIM_Smallsack.nif",false)
	time2 = PlayAnimationNoWait("Destination","fetch_store_obj_R")
	Sleep(1)
	StopAnimation("")
	PlaySound3D("Destination","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("Destination","",false)	
	
	--set measure repat time
	SetRepeatTimer("", GetMeasureRepeatName2("BribeCharacter"), TimeOut)
	
	
	
	--display decision message for destination
	local Result = MsgNews("Destination","",
				"@B[1,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_VICTIM_BUTTON_+0]"..
				"@B[2,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_VICTIM_BUTTON_+1]",
				ms_041_bribecharacter_AIDecision,  --AIFunc
				"intrigue", --MessageClass
				MsgTimeOut, --TimeOut
				"@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_VICTIM_HEAD_+0",
				"@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_VICTIM_BODY_+0",
				GetID(""),Money)
	local Index
	local ReplacementLabel
	if not DynastyIsPlayer("Destination") then
		camera_CutsceneBothLock("cutscene", "Destination")
	end
	if Result == 1 then --accept money
		Index = MsgSay("Destination","@L_INTRIGUE_041_BRIBECHARACTER_SPEAK_SUCCESS")
		ReplacementLabel = "_INTRIGUE_041_BRIBECHARACTER_SPEAK_SUCCESS_+"..Index
		--do the financial stuff
		if not f_SpendMoney("",Money,"CostBribes") then
			MsgQuick("","@L_INTRIGUE_041_BRIBECHARACTER_FAILURES_+0")
			StopMeasure()
		end
		Sleep(1)
		chr_RecieveMoney("Destination", Money, "IncomeBribes")
		
		-- make destination an evil person
		CommitAction("acceptbribe","Destination","Destination","Destination")
		
		--for the mission
		mission_ScoreCrime("Destination",Money)
		
		PlaySound3D("","Effects/coins_to_moneybag+0.wav", 1.0)
		Sleep(1)
		--do the favor stuff
		chr_ModifyFavor("Destination","",ModifyFavor)
		--show message
		chr_GainXP("",GetData("BaseXP"))
		MsgNewsNoWait("","Destination","","intrigue",-1,
			"@L_INTRIGUE_041_BRIBECHARACTER_MSG_SUCCESS_HEAD_+0",
			"@L_INTRIGUE_041_BRIBECHARACTER_MSG_SUCCESS_BODY_+0",ReplacementLabel,GetID("Destination"))
		-- stop action
		StopAction("acceptbribe","Destination")
		
	else	--decline money
		Index = MsgSay("Destination","@L_INTRIGUE_041_BRIBECHARACTER_SPEAK_FAILED")
		ReplacementLabel = "_INTRIGUE_041_BRIBECHARACTER_SPEAK_FAILED_+"..Index
		--do the favor stuff
		chr_ModifyFavor("Destination","",-(5+(MaxModifyFavor-ModifyFavor)))
		
		-- make a good person
		CommitAction("church","Destination","Destination","Destination")
		-- evidence
		CommitAction("bribe","Owner","Owner","Destination")
		--show message
		MsgNewsNoWait("","Destination","","intrigue",-1,
			"@L_INTRIGUE_041_BRIBECHARACTER_MSG_FAILED_HEAD_+0",
			"@L_INTRIGUE_041_BRIBECHARACTER_MSG_FAILED_BODY_+0",ReplacementLabel,GetID("Destination"))
		
		-- stop actions
		StopAction("bribe", "Owner")
		StopAction("church","Destination")
	end
	DestroyCutscene("cutscene")
	StopMeasure()
end

function Cutscene()

	if not HasData("TFBribe") then
		if IsStateDriven() then
			ms_041_bribecharacter_Init();
		end
		if not HasData("TFBribe") then
			StopMeasure()
		end
	end

	if SimGetCutscene("","cutscene") then
		CutsceneSetMeasureLockTime("cutscene", 2.0)
	end

	--how far the Destination can be to start this action
	local MaxDistance = 1000
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 80
	--how much favor from destination to owner is modified. max value
	local MaxModifyFavor = 20
	--how long message for destination will be displayed
	local MsgTimeOut = 0.25 --15 sekunden
	--time before measure can be used again on this destination, in hours
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)

	--run to destination and start action at MaxDistance
--	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
--		StopMeasure()
--	end
	
	--get money 
	local Money = 0 + GetData("TFBribe")
	local ModifyFavor
	--calc the favor
	local DestMoney = GetMoney("Destination") / 10
	local FavorFactor = (Money / DestMoney) * 100
	
	if FavorFactor < 35 then
		ModifyFavor = 0.3 * MaxModifyFavor
	elseif FavorFactor < 65 then
		ModifyFavor = 0.6 * MaxModifyFavor
	else
		ModifyFavor = MaxModifyFavor
	end
	
	--do visual stuff
	--CommitAction("bribe","Owner","Owner","Destination")
	
	--set measure repat time
	SetRepeatTimer("", GetMeasureRepeatName2("BribeCharacter"), TimeOut)
	
	--SLeep because of the "Ok i do it Soeech of your char"
	Sleep(1)
	
	--display decision message for destination
	local Result = MsgNews("Destination","","@P"..
				"@B[1,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_VICTIM_BUTTON_+0]"..
				"@B[2,@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_VICTIM_BUTTON_+1]",
				ms_041_bribecharacter_AIDecision,  --AIFunc
				"intrigue", --MessageClass
				MsgTimeOut, --TimeOut
				"@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_VICTIM_HEAD_+0",
				"@L_INTRIGUE_041_BRIBECHARACTER_SCREENPLAY_VICTIM_BODY_+0",
				GetID(""),Money)
	local ReplacementLabel
	if Result == 1 then --accept money
		
--		SetProperty to Check after the Voting if the Destination had voted for the one he had the Money from
		SetProperty("Destination","BribedBy",GetID(""))
		
		--do the financial stuff
		f_SpendMoney("",Money,"CostBribes")
		chr_RecieveMoney("Destination", Money, "IncomeBribes")
		--for the mission
		mission_ScoreCrime("Destination",Money)
		--do the favor stuff
		Sleep(1)
		chr_ModifyFavor("Destination","",ModifyFavor)
				
		Index = MsgSay("Destination","@L_INTRIGUE_041_BRIBECHARACTER_SPEAK_SUCCESS")
		ReplacementLabel = "_INTRIGUE_041_BRIBECHARACTER_SPEAK_SUCCESS_+"..Index
		
		Sleep(1)
				
		--show message
		MsgNewsNoWait("","Destination","","intrigue",-1,
			"@L_INTRIGUE_041_BRIBECHARACTER_MSG_SUCCESS_HEAD_+0",
			"@L_INTRIGUE_041_BRIBECHARACTER_MSG_SUCCESS_BODY_+0",ReplacementLabel,GetID("Destination"))
		
	else	--decline money
		--do the favor stuff
		chr_ModifyFavor("Destination","",-(5+(MaxModifyFavor-ModifyFavor)))	
		CommitAction("bribe","Owner","Owner","Destination")		
		Index = MsgSay("Destination","@L_INTRIGUE_041_BRIBECHARACTER_SPEAK_FAILED")
		ReplacementLabel = "_INTRIGUE_041_BRIBECHARACTER_SPEAK_FAILED_+"..Index
		--show message
		MsgNewsNoWait("","Destination","","intrigue",-1,
			"@L_INTRIGUE_041_BRIBECHARACTER_MSG_FAILED_HEAD_+0",
			"@L_INTRIGUE_041_BRIBECHARACTER_MSG_FAILED_BODY_+0",ReplacementLabel,GetID("Destination"))
	end
	
	if SimGetCutscene("","cutscene") then
		CutsceneCallUnscheduled("cutscene", "UpdatePanel")
		Sleep(0.1)
	end		
	
	StopMeasure()
end

function CleanUp()
	if GetData("FromCutscene") == 0 then
		DestroyCutscene("cutscene")
		if GetState("", STATE_CUTSCENE) == false then
			StopAnimation("")
			if AliasExists("Destination") then
				StopAnimation("Destination")
			end
		end
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

