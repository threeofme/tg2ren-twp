-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_230_MakeAPresent"
----
----	with this measure the player can make a present to another sim
----
-------------------------------------------------------------------------------
function AIDecide()
--	NumItems = GetData("NumItems")
--	return "A"..NumItems
	return "A0"
end

function Run()

	-- The time in hours until the measure can be repeated
	local MeasureID = GetCurrentMeasureID("")
	local TimeUntilRepeat = mdata_GetTimeOut(MeasureID)

	local	Slots = InventoryGetSlotCount("", INVENTORY_STD)
	local	Number
	local	ItemId
	local	ItemCount
	local	NumItems = 0
	local	ItemName = {}
	local	ItemLabel = {}
	local	ItemTexture
	local 	btn = ""
	local	added = {}
	--count all items, remove duplicates
	for Number = 0, Slots-1 do
		ItemId, ItemCount = InventoryGetSlotInfo("", Number, InventoryType)
		if ItemId and ItemId>0 and ItemCount then
			if ItemGetType(ItemId) >= 3 and ItemGetType(ItemId) <= 5 then
				if not added[ItemId] then

					added[ItemId] = true

					--create labels for replacements
					ItemName[NumItems] = ItemId
					ItemTextureName = ItemGetName(ItemId)
					ItemTexture = "Hud/Items/Item_"..ItemTextureName..".tga"
					btn = btn.."@B[A"..NumItems..",,%"..1+NumItems.."l,"..ItemTexture.."]"
					ItemLabel[NumItems] = ""..ItemGetLabel(ItemName[NumItems],true)
					NumItems = NumItems + 1
				end
			end
		end
	end
	SetData("NumItems",NumItems)

	local Result
	if Slots > 0 and NumItems > 0 then
		Result = InitData("@P"..btn,
				ms_230_makeapresent_AIDecide,  --AIFunc
				"@L_INTERFACE_PRESENTTEXT_+0",
				"",
				ItemLabel[0],ItemLabel[1],
				ItemLabel[2],ItemLabel[3],
				ItemLabel[4],ItemLabel[5])

	else
		MsgQuick("","@L_REPLACEMENTS_FAILURE_MSG_NOITEM_+0")
		StopMeasure()
	end

	if Result == "C" then
		return
	end

	--check the item
	local ItemIndex
	if Result == "A0" then
		ItemIndex = 0
	elseif Result == "A1" then
		ItemIndex = 1
	elseif Result == "A2" then
		ItemIndex = 2
	elseif Result == "A3" then
		ItemIndex = 3
	elseif Result == "A4" then
		ItemIndex = 4
	else
		ItemIndex = 5
	end
	local ItemValue = 0
	local ProgressModify = 0
	local FavorModify = 0
	if not ItemName[ItemIndex] then
		StopMeasure()
	end
	if ItemGetProductionTime(ItemName[ItemIndex])==-1 then
		StopMeasure()
	end
	

	local ItemTime = ItemGetProductionTime(ItemName[ItemIndex])
	if ItemTime < 2 then
		--crap
		ProgressModify = -10
		FavorModify = -15
		ItemValue = 0
	elseif ItemTime < 3 then
		--cheap
		ProgressModify = -5
		FavorModify = -10
		ItemValue = 0
	elseif ItemTime < 4 then
		--hmm
		ProgressModify = -2
		FavorModify = -4
		ItemValue = 1
	elseif ItemTime < 7 then
		--ok
		ProgressModify = 5
		FavorModify = 2
		ItemValue = 1
	elseif ItemTime < 10 then
		--better
		ProgressModify = 8
		FavorModify = 5
		ItemValue = 2
	elseif ItemTime < 15 then
		--good
		ProgressModify = 10
		FavorModify = 10
		ItemValue = 3
	elseif ItemTime < 20 then
		--great
		ProgressModify = 12
		FavorModify = 15
		ItemValue = 4
	else
		--damn .......... great
		ProgressModify = 20
		FavorModify = 20
		ItemValue = 5
	end
	
	
	--special items
	local PresentName = ItemGetName(ItemName[ItemIndex])
	local DestGender = SimGetGender("Destination")
	local OfficeMan = SimGetOfficeLevel("Destination")
	
	if PresentName == "Diamond" then
		if OfficeMan>0 then
			ProgressModify = 15
			FavorModify = 40
			ItemValue = 5
		end
	end
	-- Mod end
	
	--female special presents
	if DestGender == GL_GENDER_FEMALE then
		if PresentName == "SilverRing" then
			ProgressModify = 15
			FavorModify = 10
			ItemValue = 3
		elseif PresentName == "GemRing" then
			ProgressModify = 25
			FavorModify = 20
			ItemValue = 5
		elseif PresentName == "GoldChain" then
			ProgressModify = 20
			FavorModify = 15
			ItemValue = 4
		elseif PresentName == "Schnitzi" then
			ProgressModify = 8
			FavorModify = 5
			ItemValue = 3
		elseif PresentName == "RubinStaff" then	
			ProgressModify = 25
			FavorModify = 20
			ItemValue = 5
		elseif PresentName == "Perfume" then
			ProgressModify = 20
			FavorModify = 15
			ItemValue = 4
		elseif PresentName == "Pearlchain" then
			ProgressModify = 25
			FavorModify = 25
			ItemValue = 4
		elseif PresentName == "JanesRing" then
			ProgressModify = 35
			FavorModify = 5
			ItemValue = 5
		end
	--male special presents	
	else
		if PresentName == "Axe" then
			ProgressModify = 25
			FavorModify = 20
			ItemValue = 5
		elseif PresentName == "Chainmail" then
			ProgressModify = 25
			FavorModify = 20
			ItemValue = 5
		elseif PresentName == "BoozyBreathBeer" then
			ProgressModify = 25
			FavorModify = 20
			ItemValue = 4
		elseif PresentName == "FullHelmet" then
			ProgressModify = 15
			FavorModify = 10
			ItemValue = 5
		elseif PresentName == "LeatherArmor" then
			ProgressModify = 15
			FavorModify = 10
			ItemValue = 4
		elseif PresentName == "Longsword" then
			ProgressModify = 20
			FavorModify = 15
			ItemValue = 5
		elseif PresentName == "Mace" then
			ProgressModify = 10
			FavorModify = 5
			ItemValue = 4
		elseif PresentName == "SmallBeer" then
			ProgressModify = 8
			FavorModify = 5
			ItemValue = 3
		elseif PresentName == "WheatBeer" then
			ProgressModify = 12
			FavorModify = 7
			ItemValue = 4
		elseif PresentName == "RoastBeef" then
			ProgressModify = 18
			FavorModify = 12
			ItemValue = 4
		elseif PresentName == "Shortsword" then
			ProgressModify = 10
			FavorModify = 7
			ItemValue = 4
		elseif PresentName == "IronCap" then
			ProgressModify = 10
			FavorModify = 7
			ItemValue = 4
		elseif PresentName == "Platemail" then
			ProgressModify = 25
			FavorModify = 20
			ItemValue = 5
		elseif PresentName == "Tool" then
			ProgressModify = 10
			FavorModify = 5
			ItemValue = 3
		elseif PresentName == "JanesRing" then
			ProgressModify = 35
			FavorModify = 5
			ItemValue = 5
		end
	end
	

	-- The time in hours until the measure can be repeated
	local MeasureID = GetCurrentMeasureID("")
	local TimeUntilRepeat = mdata_GetTimeOut(MeasureID)
	
	-- The minimum favor for this action to success
	local TitleDifference = (GetNobilityTitle("Destination") - GetNobilityTitle(""))*2
	local CharismaBonus = GetSkillValue("",CHARISMA)*2
	local MinimumFavor = 30+TitleDifference-CharismaBonus

	-- The action number for the courting
	local CourtingActionNumber = 3

	-- The distance between both sims to interact with each other
	local InteractionDistance = 80

	if not ai_StartInteraction("", "Destination", 500, InteractionDistance) then
		StopMeasure()
		return
	end

	SetAvoidanceGroup("", "Destination")
	MoveSetActivity("", "converse")
	MoveSetActivity("Destination", "converse")

	feedback_OverheadActionName("Destination")

	chr_AlignExact("", "Destination", InteractionDistance)

	CreateCutscene("default","cutscene")
	CutsceneAddSim("cutscene","")
	CutsceneAddSim("cutscene","destination")
	CutsceneCameraCreate("cutscene","")

	camera_CutscenePlayerLock("cutscene", "")

	local time1
	local time2
	time1 = PlayAnimationNoWait("Owner", "use_object_standing")
	time2 = PlayAnimationNoWait("Destination","cogitate")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("","Handheld_Device/ANIM_Smallsack.nif",false)
	
	Sleep(0.5)
	CarryObject("","",false)
	CarryObject("Destination","Handheld_Device/ANIM_Smallsack.nif",false)
	time2 = PlayAnimationNoWait("Destination","fetch_store_obj_R")
	Sleep(1)	
	StopAnimation("")
	PlaySound3D("Destination","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	CarryObject("Destination","",false)	

	if RemoveItems("",ItemName[ItemIndex],1,INVENTORY_STD) == 0 then
		StopMeasure()
	end
	if IsPartyMember("Destination") and not PresentName == "JanesRing" then
		if DynastyIsPlayer("Destination") then
			if GetRemainingInventorySpace("Destination",ItemName[ItemIndex],INVENTORY_STD) then
				AddItems("Destination",ItemName[ItemIndex],1,INVENTORY_STD)
			end
		end
	end

	chr_AlignExact("", "Destination", InteractionDistance)

	local WasCourtLover = 0

	-------------------------
	------ Court Lover ------
	-------------------------
	if (SimGetCourtLover("", "CourtLover")) then
		if GetID("CourtLover")==GetID("Destination") then

			WasCourtLover = 1
			local ModifyFavor = FavorModify

			EnoughVariation, CourtingProgress = SimDoCourtingAction("", CourtingActionNumber,ProgressModify)
			CourtingProgress = CourtingProgress + ProgressModify
			if (EnoughVariation == false) then

				camera_CutscenePlayerLock("cutscene", "Destination")

				local DestinationAnimationLength = PlayAnimationNoWait("Destination", "cheer_01")
				Sleep(DestinationAnimationLength * 0.4)

				feedback_OverheadCourtProgress("Destination", CourtingProgress)

				MsgSay("Destination", chr_AnswerMissingVariation(SimGetGender("Destination"), GetSkillValue("Destination", RHETORIC)));
				Sleep(DestinationAnimationLength * 0.2)

			else

				chr_AlignExact("", "Destination", InteractionDistance)

				if (CourtingProgress < -5) then
					camera_CutsceneBothLock("cutscene", "Destination")
					PlayAnimationNoWait("", "got_a_slap")
					DestinationAnimationLength = PlayAnimationNoWait("Destination", "give_a_slap")
					Sleep(DestinationAnimationLength * 0.4)
					ModifyFavor = FavorModify
				elseif (CourtingProgress < 1) then
					camera_CutscenePlayerLock("cutscene", "Destination")
					PlayAnimationNoWait("", "talk")
					DestinationAnimationLength = PlayAnimationNoWait("Destination", "cheer_01")
					Sleep(DestinationAnimationLength * 0.4)
					ModifyFavor = FavorModify
				else
					camera_CutscenePlayerLock("cutscene", "Destination")
				end

				feedback_OverheadCourtProgress("Destination", CourtingProgress)

				MsgSay("Destination", chr_AnswerCourtingMeasure("MAKE_A_PRESENT", GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), CourtingProgress));

			end

			-- Add the archieved progress
			chr_ModifyFavor("Destination", "", ModifyFavor)
			SimAddCourtingProgress("")

		end
	end

	----------------------------
	------ No Court Lover ------
	----------------------------
	if (WasCourtLover==0) then

		local IsMale = (SimGetGender("Destination") == GL_GENDER_MALE)
		local DestinationRank = SimGetRank("Destination")
		
		if (GetFavorToSim("Destination", "") < MinimumFavor) or (DestinationRank > ItemValue) then

			-- Set the repeat timer and the favor loss prior to the animations so that the player cannot cancel the measure and try it instantly again
			SetMeasureRepeat(TimeUntilRepeat)
			--chr_ModifyFavor("Destination", "", FavorModify)

			if (IsMale) then
				camera_CutscenePlayerLock("cutscene", "Destination")
				PlayAnimationNoWait("Destination", "shake_head")
			else
				camera_CutsceneBothLock("cutscene", "Destination")
				PlayAnimationNoWait("", "got_a_slap")
				PlayAnimationNoWait("Destination", "give_a_slap")
				chr_AlignExact("", "Destination", InteractionDistance)
				
			end
			--MsgSay("Destination", chr_AnswerCourtingMeasure("MAKE_A_PRESENT", GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), -10));

		else

			camera_CutscenePlayerLock("cutscene", "Destination")

			if (IsMale) then
				PlayAnimationNoWait("Destination", "bow")
			else
				PlayAnimationNoWait("Destination", "giggle")
			end
			--MsgSay("Destination", chr_AnswerCourtingMeasure("MAKE_A_PRESENT", GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), 10));

			-- Set the repeat timer and the favor won after the animation so that the player will not be able to cancel the measure if he recognizes the success in order to save time (cheat)
			SetRepeatTimer("", "MakeAPresent"..GetID("Destination"), TimeUntilRepeat)
			chr_ModifyFavor("Destination", "", FavorModify)

		end

	end

	StopMeasure()

end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()

	DestroyCutscene("cutscene")
	ReleaseAvoidanceGroup("")
	MoveSetActivity("")
	StopAnimation("")
	AlignTo("","")

	if AliasExists("Destination") then
		AlignTo("Destination","")
		MoveSetActivity("Destination")
		SimLock("Destination", 0.4)
	end

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

