function Init()
end

function Decide()
	return "BTN1"
end

function Run()
	CreateCutscene("Duel","my_duel")
	CopyAliasToCutscene("Destination","my_duel","challenger")
	CopyAliasToCutscene("","my_duel","challenged")
	CutsceneCallUnscheduled("my_duel","Start")
	f_Stroll("",250.0,1.0)
end

function NoRun()

	CreateCutscene("chat","my_chat")

	GetInsideBuilding("","building")
	--BuildingLockForCutscene("building","my_chat")

	CutsceneAddSim("my_chat","")					-- doppelclick auf den sim läßt in die cutscene springen
	CutsceneAddSim("my_chat","destination")

	CutsceneCameraCreate("my_chat","")			
	CutsceneCameraSetRelativePosition("my_chat","CameraPortrait","")

	Sleep(5.0)
	--MsgSayInteraction("","destination",0,MB_YESNO,ms_mmdebug1_Decide,"Wollt ihr mich nerven?")
	local AccuserSentence = MsgSayInteraction("","destination",0,
			-- PanelParam
			"@B[BTN1,@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+1]"..
			"@B[BTN2,@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+2]"..
			"@B[BTN3,@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+3]"..
			"@B[BTN4,@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+4]"..
			"@B[BTN5,@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+5]"..
			"@B[BTN6,@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+6]",
			ms_mmdebug2_Decide, --AIFunc
			"@L_LAWSUIT_5_DEFENSE_A_SCREENPLAYER_ACCUSER_+0",GetID("")) --Message Text

		
	Sleep(20.0)

--	while true do
--		MsgSay("","Nerv!")
--		Sleep(5.0)
--	end
	--CutsceneCameraCreate("my_chat")					-- erzeugt eine cutscene camera die an der cutscene my_chat dranhängt


	--BuildingLockForCutscene("building",0)
	

	--	if CameraCheckLineOfSight("") then
	--	MoveSetStance("",GL_STANCE_SITGROUND)
	--	Sleep(1.0)	
	--	MoveSetStance("",GL_STANCE_STAND)
	--end
	--if not ai_StartInteraction("", "Destination", 350, 100) then
	--	return
	--end
	--MsgSay("","Armleuchter!")
	--MsgSay("Destination","Trottel")
	--SetAvoidanceGroup("","Destination")
	--	CreateCutscene("Festivity","my_festivity")
	--	CopyAliasToCutscene("","my_festivity","host")
	--	CutsceneCallUnscheduled("my_festivity","Start")
	--Sleep(1000000)
end

function CleanUp()
	DestroyCutscene("my_chat")	-- die cutscene camera wird dadurch mitzerstört
	--ReleaseAvoidanceGroup("")
end
