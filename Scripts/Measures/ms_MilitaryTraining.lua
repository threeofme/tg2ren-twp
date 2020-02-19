-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_MilitaryTraining"
----
----	With this measure the player can change the character class of one of his
----  dynasty members to chiseler
----  
----  1. Einen Sim seiner Dynastie zum Kämpfer ausbilden
----  2. Sim geht zum Training (Fightinganimationen in der Residenz, o.ä.)
----  3. Nach dem Training die Characterklasse auf Gauner ändern
----  4. Alle Erfahrungspunkte werden neu vergeben und auf Fighting getrimmt. Fähigkeiten bleiben erhalten.
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	--do the init stuff
	if not AliasExists("Destination") then
		StopMeasure()
	end
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if not ai_StartInteraction("", "Destination", 1000, 100) then
		StopMeasure()
	end
	
	--do the progress bar stuff
	local Time = GetGametime()
	local EndTime = Time + 5
	SetData("Time",5)
	SetData("EndTime",EndTime)
	SetProcessMaxProgress("",5*10)
	SetProcessMaxProgress("Destination",5*10)
	SendCommandNoWait("","Progress")
	SendCommandNoWait("Destination","Progress")
	local AnimTime = 0
	--start the training
	for i=0,1 do
		AnimTime = PlayAnimationNoWait("","talk")
		Sleep(4)
		PlayAnimationNoWait("Destination","nod")
		Sleep(AnimTime-4)
		MoveSetActivity("","fightingunarmed")
		AnimTime = PlayAnimationNoWait("","fistfight_in")
		MoveSetActivity("Destination","fightingunarmed")
		PlayAnimationNoWait("Destination","fistfight_in")
		Sleep(AnimTime)
		
		PlayAnimationNoWait("","fistfight_punch_01")
		PlayAnimation("Destination","fistfight_got_hit_01")
		
		MoveSetActivity("","")
		AnimTime = PlayAnimationNoWait("","fistfight_out")
		MoveSetActivity("Destination","")
		PlayAnimationNoWait("Destination","fistfight_out")
		Sleep(AnimTime)
		
		PlayAnimationNoWait("","shake_head")
		PlayAnimation("Destination","cogitate")
		AnimTime = PlayAnimationNoWait("","talk")
		Sleep(4)
		PlayAnimationNoWait("Destination","nod")
		Sleep(AnimTime-4)
		
		MoveSetActivity("","fightingunarmed")
		AnimTime = PlayAnimationNoWait("","fistfight_in")
		MoveSetActivity("Destination","fightingunarmed")
		PlayAnimationNoWait("Destination","fistfight_in")
		Sleep(AnimTime)
		
		PlayAnimationNoWait("","fistfight_punch_01")
		PlayAnimation("Destination","fistfight_block_01")
		
		MoveSetActivity("","")
		AnimTime = PlayAnimationNoWait("","fistfight_out")
		MoveSetActivity("Destination","")
		PlayAnimationNoWait("Destination","fistfight_out")
		Sleep(AnimTime)
		
		AnimTime = PlayAnimationNoWait("","cheer_02")
		Sleep(2)
		PlayAnimationNoWait("Destination","nod")
		Sleep(AnimTime-2)
		
		MoveSetActivity("","fightingunarmed")
		AnimTime = PlayAnimationNoWait("","fistfight_in")
		MoveSetActivity("Destination","fightingunarmed")
		PlayAnimationNoWait("Destination","fistfight_in")
		Sleep(AnimTime)
		
		AnimTime = PlayAnimationNoWait("","fistfight_punch_04")
		Sleep(0.4)
		MoveSetActivity("Destination","unconscious")
		Sleep(AnimTime-0.4)
		
		MoveSetActivity("","")
		AnimTime = PlayAnimationNoWait("","fistfight_out")
		Sleep(AnimTime)
		PlayAnimation("","cogitate")
		PlayAnimation("","manipulate_bottom_r")
		AnimTime = MoveSetActivity("Destination","")
		Sleep(AnimTime)
		
		AnimTime = PlayAnimationNoWait("","talk")
		Sleep(4)
		PlayAnimationNoWait("Destination","nod")
		Sleep(AnimTime-4)
		
		MoveSetActivity("","fightingunarmed")
		AnimTime = PlayAnimationNoWait("","fistfight_in")
		MoveSetActivity("Destination","fightingunarmed")
		PlayAnimationNoWait("Destination","fistfight_in")
		Sleep(AnimTime)
		
		PlayAnimationNoWait("Destination","fistfight_punch_01")
		PlayAnimation("","fistfight_got_hit_01")
		PlayAnimationNoWait("Destination","fistfight_punch_02")
		PlayAnimation("","fistfight_got_hit_02")
		
		MoveSetActivity("","")
		AnimTime = PlayAnimationNoWait("","fistfight_out")
		MoveSetActivity("Destination","")
		PlayAnimationNoWait("Destination","fistfight_out")
		Sleep(AnimTime)
		
		PlayAnimation("","talk")
		
		MoveSetActivity("","fighting")
		PlayAnimationNoWait("","fight_draw_weapon")
		MoveSetActivity("Destination","fighting")
		PlayAnimationNoWait("Destination","fight_draw_weapon")
		Sleep(1.5)
		CarryObject("","weapons/sword_01.nif",false)
		CarryObject("Destination","weapons/club_01.nif",false)
		Sleep(3)
		MoveSetActivity("","")
		AnimTime = PlayAnimationNoWait("","fight_store_weapon")
		MoveSetActivity("Destination","")
		PlayAnimationNoWait("Destination","fight_store_weapon")
		Sleep(1.5)
		CarryObject("","",false)
		CarryObject("Destination","",false)
		Sleep(AnimTime-2)
		
		PlayAnimation("","shake_head")
		
		MoveSetActivity("","fighting")
		PlayAnimationNoWait("","fight_draw_weapon")
		MoveSetActivity("Destination","fighting")
		PlayAnimationNoWait("Destination","fight_draw_weapon")
		Sleep(1.5)
		CarryObject("","weapons/sword_01.nif",false)
		CarryObject("Destination","weapons/sword_01.nif",false)
		Sleep(1)
		
		PlayAnimationNoWait("","attack_middle")
		PlayAnimation("Destination","fight_got_hit_04")
		PlayAnimationNoWait("Destination","attack_bottom")
		PlayAnimation("","fight_got_hit_05")
		
		MoveSetActivity("","")
		MoveSetActivity("Destination","")
		AnimTime = PlayAnimationNoWait("","fight_store_weapon")
		PlayAnimationNoWait("Destination","fight_store_weapon")
		Sleep(1.5)
		CarryObject("","",false)
		CarryObject("Destination","",false)
		Sleep(AnimTime-2)	
		
		AnimTime = PlayAnimationNoWait("","propel")
		Sleep(2)
		PlayAnimationNoWait("Destination","cheer_01")
		Sleep(AnimTime-2)
	end
	
	PlayAnimation("","point_at")
	AnimTime = MoveSetStance("Destination",GL_STANCE_SITGROUND) 
	Sleep(AnimTime)
		
	MoveSetActivity("","fighting")
	PlayAnimationNoWait("","fight_draw_weapon")
	Sleep(1)
	CarryObject("","weapons/sword_01.nif",false)
	Sleep(2)
	PlayAnimation("","finishing_move_01")
	Sleep(1)
	PlayAnimation("","finishing_move_02")
	MoveSetActivity("","")
	AnimTime = PlayAnimationNoWait("","fight_store_weapon")
	Sleep(1)
	CarryObject("","",false)
	Sleep(AnimTime-1)
	AnimTime = MoveSetStance("Destination",GL_STANCE_STAND)
	Sleep(AnimTime)
	PlayAnimation("","laud")
	
	SetMeasureRepeat(TimeOut)
	MeasureSetNotRestartable()
	ResetProcessProgress("")
	ResetProcessProgress("Destination")
	GetPosition("Destination","ParticleSpawnPos")
	PlaySound3D("Destination","Effects/mystic_gift+0.wav", 1.0)
	StartSingleShotParticle("particles/change_effect.nif", "ParticleSpawnPos", 1, 2.0)
	SimSetClass("Destination", GL_CLASS_CHISELER)
	chr_GainXP("",GetData("BaseXP"))
	StopMeasure()
	
end

-- -----------------------
-- Progress
-- -----------------------
function Progress()
	while true do
		local Time = GetData("Time")
		local EndTime = GetData("EndTime") 
		local CurrentTime = GetGametime() 
		CurrentTime = EndTime - CurrentTime 
		CurrentTime = Time - CurrentTime 
		SetProcessProgress("",CurrentTime*10)
		Sleep(3)
	end
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	ResetProcessProgress("")
	StopAnimation("")
	MoveSetActivity("","")
	if AliasExists("Destination") then
		MoveSetStance("Destination","GL_STANCE_STAND") 
		ResetProcessProgress("Destination")
		MoveSetActivity("Destination","")
		StopAnimation("Destination")
	end
end

-- -----------------------
-- GetOSHData
-- -----------------------
function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

