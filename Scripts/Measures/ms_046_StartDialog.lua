-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_046_StartDialog"
----
----	with this measure the player can start a dialog with another sim
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------

function Run()
	
	if not AliasExists("Destination") then

		local TalkPartners = Find("", "__F((Object.GetObjectsByRadius(Sim)==1500)AND(Object.IsDynastySim())AND NOT(Object.GetState(npc))AND NOT(Object.GetState(animal))AND NOT(Object.GetStateImpact(no_idle))AND(Object.CanBeInterrupted(StartDialog)))","Destination", -1)
		if (TalkPartners == 0) then
			StopMeasure()
			return
		end
		CopyAlias("Destination"..Rand(TalkPartners), "Destination")

	end
	
	-- Fajeth_timeout fix
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	-- the action number for the courting

	local CourtingActionNumber = 0

	if not(AliasExists("Destination")) then
		StopMeasure()
	end

	if not ai_StartInteraction("", "Destination", 350, 100) then
		StopMeasure()
		return
	end

	-- for tutorial
	-- only a player should be able to start a quests
	if GetLocalPlayerDynasty("LocalPlayer") then
		if GetID("LocalPlayer") == GetID("dynasty") then
			if (QuestTalk("","Destination")) then
				StopMeasure()
				return
			end		
		elseif GetState("Destination", STATE_NPC) then
			StopMeasure()
			return
		end
	end
	
	local owntitle = 10
	if IsDynastySim("") then
		owntitle = GetNobilityTitle("")
	end
	local desttitle = GetNobilityTitle("Destination")
	local TitleDiffMod = owntitle - 1
	local TitleFactor = owntitle - desttitle
	local Age = SimGetAge("Destination")
	local MinFavor = 20 

	SetProperty("","InTalk",1)
	SetProperty("Destination","InTalk",1)

	local Favor = GetFavorToSim("Destination", "")

	if SimGetGender("Destination")==GL_GENDER_MALE then

		if Age < 16 then
			MsgSay("","@L_STARTDIALOG_START_YOUNG_MALE")
		else
			MsgSay("","@L_STARTDIALOG_START_ADULT_MALE")
		end

	else

		if Age < 16 then
			MsgSay("","@L_STARTDIALOG_START_YOUNG_FEMALE")
		else
			MsgSay("","@L_STARTDIALOG_START_ADULT_FEMALE")
		end
	end

	-- Niemand will etwas mit dem Char zu tun haben

	if (GetFavorToSim("Destination", "") < MinFavor) then
		-- prevent cheating timeout moved by Fajeth
		SetMeasureRepeat(TimeOut)
		MsgSay("Destination","@L_STARTDIALOG_NO")
		local favormodify = (Rand(5) + desttitle)
		chr_ModifyFavor("Destination","",-favormodify)
		Sleep(0.5)
		MsgSay("","@L_STARTDIALOG_SORRY")
		StopMeasure()
	end

	SetAvoidanceGroup("", "Destination")
	feedback_OverheadActionName("Owner")
	feedback_OverheadActionName("Destination")
	AlignTo("Owner", "Destination")
	AlignTo("Destination", "Owner")
	SetMeasureRepeat(TimeOut)
	Sleep(1)

	if SimGetGender("")==GL_GENDER_MALE then
		if(Favor >= 65) then
			PlaySound3DVariation("", "CharacterFX/male_friendly", 0.5)
		else
			PlaySound3DVariation("", "CharacterFX/male_neutral", 0.5)
		end
	else
		if(Favor >= 65)	then
			PlaySound3DVariation("", "CharacterFX/female_friendly",0.5)
		else
			PlaySound3DVariation("", "CharacterFX/female_neutral", 0.5)
		end
	end
	if SimGetGender("Destination")==GL_GENDER_MALE then
  		if(Favor >= 65) then
			PlaySound3DVariation("Destination", "CharacterFX/male_friendly", 0.5)
		else
			PlaySound3DVariation("Destination", "CharacterFX/male_neutral", 0.5)
		end
	else
  		if(Favor >= 65)	then
			PlaySound3DVariation("Destination", "CharacterFX/female_friendly",0.5)
		else
			PlaySound3DVariation("Destination", "CharacterFX/female_neutral", 0.5)
		end
	end

	time1 = PlayAnimationNoWait("Owner", "talk")
	Sleep(0.7)
	time2 = PlayAnimation("Destination", "talk")

	Talk("", "Destination",true)
	SatisfyNeed("", 3, 1.0)
	SatisfyNeed("Destination", 3, 1.0)

	-------------------------
	------ Court Lover ------
	-------------------------

	if SimGetCourtLover("", "CourtLover") then
		if GetID("CourtLover")==GetID("Destination") then

			MoveSetActivity("", "converse")
			MoveSetActivity("Destination", "converse")

	--		camera_CutscenePlayerLock("cutscene", "Destination")

			EnoughVariation, CourtingProgress = SimDoCourtingAction("", CourtingActionNumber)
			if (EnoughVariation == false) then
				feedback_OverheadCourtProgress("Destination", CourtingProgress)
				MsgSay("Destination", chr_AnswerMissingVariation(SimGetGender("Destination"), GetSkillValue("Destination", RHETORIC)));
			else
				feedback_OverheadCourtProgress("Destination", CourtingProgress)
				MsgSay("Destination", chr_AnswerCourtingMeasure("TALK", GetSkillValue("Destination", RHETORIC), SimGetGender("Destination"), CourtingProgress));
			end

			Sleep(3.0)
			
			-- Add the archieved progress
			SimAddCourtingProgress("")
		end
	StopMeasure()
	end

	if (TitleDiffMod < 0) then
		TitleDiffMod = 0
	end
	
	TitleDiffMod = TitleDiffMod + Rand(4)

	-- Postiv, Gunst steigt

	if ((GetSkillValue("", RHETORIC)) + TitleDiffMod >= (GetSkillValue("Destination", RHETORIC) + desttitle)) then
		local favormodify = (GetSkillValue("", RHETORIC)+Rand(5))
		chr_ModifyFavor("Destination","",favormodify)

        	if Age < 16 then
			MsgSay("Destination", "@L_STARTDIALOG_FAVOR_POS_YOUNG")
		else
			MsgSay("Destination","@L_STARTDIALOG_FAVOR_POS_ADULT")
		end

		-- Zufällige Person aus der Umgebung auswählen
		if IsDynastySim("") and IsDynastySim("Destination") then
			local NumOfObjects = Find("","__F((Object.GetObjectsByRadius(Sim)==1000)AND(Object.IsDynastySim())AND NOT(Object.GetState(child))AND NOT(Object.GetState(npc))AND NOT(Object.GetState(animal)))","Sims",-1)

			if NumOfObjects > 0 then
				local DestAlias = "Sims"..Rand(NumOfObjects)
				local Check = true

				if not IsDynastySim(DestAlias) then
					Check = false
				end

				if GetState(DestAlias, STATE_NPC) then
					Check = false
				end

				if GetState(DestAlias, STATE_DEAD) then
					Check = false
				end

			-- Gesprächspartner mag die zufällige Person nicht und übergibt einen (gefälschten!) Beweis

				if Check then

					if GetFavorToSim("Destination", DestAlias) < 25 or GetFavorToSim("", DestAlias) < 25 then
						
						MsgSay("Destination", "@L_STARTDIALOG_EVIDENCE")

						local Random = Rand(11)
						if Random == 0 then
							Evidence = 1
						elseif Random == 1 then
							Evidence = 4
						elseif Random == 2 then
							Evidence = 7
						elseif Random == 3 then
							Evidence = 10
						elseif Random == 4 then
							Evidence = 11
						elseif Random == 5 then
							Evidence = 12
						elseif Random == 6 then
							Evidence = 13
						elseif Random == 7 then
							Evidence = 14
						elseif Random == 8 then
							Evidence = 15
						else
							Evidence = 18
						end

						-- zufällige Dynastie auswählen
						while true do
							ScenarioGetRandomObject("cl_Sim","CurrentRandomSim")
							if GetDynasty("CurrentRandomSim","CDynasty") then
								CopyAlias("CurrentRandomSim","EvidenceVictim")
								break
							end
						end

						AddEvidence("", DestAlias, "EvidenceVictim", Evidence)
						MsgSay("", "@L_STARTDIALOG_THX")
					end
				end
			end
		end
	else

	  -- Negativ, Gunst sinkt

		local favormodify = (Rand(5) + desttitle)
		chr_ModifyFavor("Destination","",-favormodify)

		if Age < 16 then
			MsgSay("Destination", "@L_STARTDIALOG_FAVOR_NEG_YOUNG")
		else
 			MsgSay("Destination","@L_STARTDIALOG_FAVOR_NEG_ADULT")
		end

	end

	SatisfyNeed("", 3, 1.0)
	SatisfyNeed("Destination", 3, 1.0)
	StopMeasure()
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	ReleaseAvoidanceGroup("")
	if(AliasExists("Destination")) then
		RemoveProperty("Destination","InTalk")
	end
	RemoveProperty("", "InTalk")
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
