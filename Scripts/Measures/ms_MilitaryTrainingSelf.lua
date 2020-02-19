-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_MilitaryTraining"
----
----	With this measure the player can change its character class to chiseler
----	
----  1. Sich selbst zum Kämpfer ausbilden
----  2. Sim geht zum Training (Fightinganimationen in der Residenz, o.ä.)
----  3. Nach dem Training die Characterklasse auf Gauner ändern
----  4. Alle Erfahrungspunkte werden neu vergeben und auf Fighting getrimmt. Fähigkeiten bleiben erhalten.
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	if not GetSettlement("","City") then
		StopMeasure()
	end
	
	if not GetHomeBuilding("","Home") then
		StopMeasure()
	end
	
	if GetInsideBuilding("","InsideBuilding") then
		if GetID("Home") ~= GetID("InsideBuilding") then
			f_MoveTo("","Home",GL_MOVESPEED_RUN)
		end
	else
		f_MoveTo("","Home",GL_MOVESPEED_RUN)
	end
	
	if not GetLocatorByName("Home","Exit1","TrainerSpawnPos") then
		StopMeasure()
	end
	
	local TrainerID = 0
	if not SimCreate(724, "City", "TrainerSpawnPos", "PersonalTrainer") then
		StopMeasure()
	end
	
	AddItems("PersonalTrainer","Platemail",1,INVENTORY_EQUIPMENT)
	TrainerID = GetID("PersonalTrainer")
	
	-- Avert the executioner from anything else but his duty !
	SetState("PersonalTrainer", STATE_LOCKED, true)
	
	if GetLocatorByName("Home","Stroll1","StrollPos") then
		f_MoveTo("","StrollPos")
	end
	
	if not f_MoveTo("PersonalTrainer","Owner",GL_MOVESPEED_WALK,140) then
		StopMeasure()
	end
	local AnimTime = 0
	
	AlignTo("Owner","PersonalTrainer")
	AlignTo("PersonalTrainer","Owner")
	
	--do the anim stuff
	--do the progress bar stuff
	local Time = GetGametime()
	local EndTime = Time + 5
	SetData("Time",5)
	SetData("EndTime",EndTime)
	SetProcessMaxProgress("PersonalTrainer",5*10)
	SetProcessMaxProgress("",5*10)
	SendCommandNoWait("PersonalTrainer","Progress")
	SendCommandNoWait("","Progress")
	
	--start the training
	for i=0,1 do
		AnimTime = PlayAnimationNoWait("PersonalTrainer","talk")
		Sleep(4)
		PlayAnimationNoWait("","nod")
		Sleep(AnimTime-4)
		MoveSetActivity("PersonalTrainer","fightingunarmed")
		AnimTime = PlayAnimationNoWait("PersonalTrainer","fistfight_in")
		MoveSetActivity("","fightingunarmed")
		PlayAnimationNoWait("","fistfight_in")
		Sleep(AnimTime)
		
		PlayAnimationNoWait("PersonalTrainer","fistfight_punch_01")
		PlayAnimation("","fistfight_got_hit_01")
		
		MoveSetActivity("PersonalTrainer","")
		AnimTime = PlayAnimationNoWait("PersonalTrainer","fistfight_out")
		MoveSetActivity("","")
		PlayAnimationNoWait("","fistfight_out")
		Sleep(AnimTime)
		
		PlayAnimationNoWait("PersonalTrainer","shake_head")
		PlayAnimation("","cogitate")
		AnimTime = PlayAnimationNoWait("PersonalTrainer","talk")
		Sleep(4)
		PlayAnimationNoWait("","nod")
		Sleep(AnimTime-4)
		
		MoveSetActivity("PersonalTrainer","fightingunarmed")
		AnimTime = PlayAnimationNoWait("PersonalTrainer","fistfight_in")
		MoveSetActivity("","fightingunarmed")
		PlayAnimationNoWait("","fistfight_in")
		Sleep(AnimTime)
		
		PlayAnimationNoWait("PersonalTrainer","fistfight_punch_01")
		PlayAnimation("","fistfight_block_01")
		
		MoveSetActivity("PersonalTrainer","")
		AnimTime = PlayAnimationNoWait("PersonalTrainer","fistfight_out")
		MoveSetActivity("","")
		PlayAnimationNoWait("","fistfight_out")
		Sleep(AnimTime)
		
		AnimTime = PlayAnimationNoWait("PersonalTrainer","cheer_02")
		Sleep(2)
		PlayAnimationNoWait("","nod")
		Sleep(AnimTime-2)
		
		MoveSetActivity("PersonalTrainer","fightingunarmed")
		AnimTime = PlayAnimationNoWait("PersonalTrainer","fistfight_in")
		MoveSetActivity("","fightingunarmed")
		PlayAnimationNoWait("","fistfight_in")
		Sleep(AnimTime)
		
		AnimTime = PlayAnimationNoWait("PersonalTrainer","fistfight_punch_04")
		Sleep(0.4)
		MoveSetActivity("","unconscious")
		Sleep(AnimTime-0.4)
		
		MoveSetActivity("PersonalTrainer","")
		AnimTime = PlayAnimationNoWait("PersonalTrainer","fistfight_out")
		Sleep(AnimTime)
		PlayAnimation("PersonalTrainer","cogitate")
		PlayAnimation("PersonalTrainer","manipulate_bottom_r")
		AnimTime = MoveSetActivity("","")
		Sleep(AnimTime)
		
		AnimTime = PlayAnimationNoWait("PersonalTrainer","talk")
		Sleep(4)
		PlayAnimationNoWait("","nod")
		Sleep(AnimTime-4)
		
		MoveSetActivity("PersonalTrainer","fightingunarmed")
		AnimTime = PlayAnimationNoWait("PersonalTrainer","fistfight_in")
		MoveSetActivity("","fightingunarmed")
		PlayAnimationNoWait("","fistfight_in")
		Sleep(AnimTime)
		
		PlayAnimationNoWait("","fistfight_punch_01")
		PlayAnimation("PersonalTrainer","fistfight_got_hit_01")
		PlayAnimationNoWait("","fistfight_punch_02")
		PlayAnimation("PersonalTrainer","fistfight_got_hit_02")
		
		MoveSetActivity("PersonalTrainer","")
		AnimTime = PlayAnimationNoWait("PersonalTrainer","fistfight_out")
		MoveSetActivity("","")
		PlayAnimationNoWait("","fistfight_out")
		Sleep(AnimTime)
		
		PlayAnimation("PersonalTrainer","talk")
		
		MoveSetActivity("PersonalTrainer","fighting")
		PlayAnimationNoWait("PersonalTrainer","fight_draw_weapon")
		MoveSetActivity("","fighting")
		PlayAnimationNoWait("","fight_draw_weapon")
		Sleep(1.5)
		CarryObject("PersonalTrainer","weapons/sword_01.nif",false)
		CarryObject("","weapons/club_01.nif",false)
		Sleep(3)
		MoveSetActivity("PersonalTrainer","")
		AnimTime = PlayAnimationNoWait("PersonalTrainer","fight_store_weapon")
		MoveSetActivity("","")
		PlayAnimationNoWait("","fight_store_weapon")
		Sleep(1.5)
		CarryObject("PersonalTrainer","",false)
		CarryObject("","",false)
		Sleep(AnimTime-2)
		
		PlayAnimation("PersonalTrainer","shake_head")
		
		MoveSetActivity("PersonalTrainer","fighting")
		PlayAnimationNoWait("PersonalTrainer","fight_draw_weapon")
		MoveSetActivity("","fighting")
		PlayAnimationNoWait("","fight_draw_weapon")
		Sleep(1.5)
		CarryObject("PersonalTrainer","weapons/sword_01.nif",false)
		CarryObject("","weapons/sword_01.nif",false)
		Sleep(1)
		
		PlayAnimationNoWait("PersonalTrainer","attack_middle")
		PlayAnimation("","fight_got_hit_04")
		PlayAnimationNoWait("","attack_bottom")
		PlayAnimation("PersonalTrainer","fight_got_hit_05")
		
		MoveSetActivity("PersonalTrainer","")
		MoveSetActivity("","")
		AnimTime = PlayAnimationNoWait("PersonalTrainer","fight_store_weapon")
		PlayAnimationNoWait("","fight_store_weapon")
		Sleep(1.5)
		CarryObject("PersonalTrainer","",false)
		CarryObject("","",false)
		Sleep(AnimTime-2)	
		
		AnimTime = PlayAnimationNoWait("PersonalTrainer","propel")
		Sleep(2)
		PlayAnimationNoWait("","cheer_01")
		Sleep(AnimTime-2)
	end
	
	PlayAnimation("PersonalTrainer","point_at")
	AnimTime = MoveSetStance("",GL_STANCE_SITGROUND) 
	Sleep(AnimTime)
		
	MoveSetActivity("PersonalTrainer","fighting")
	PlayAnimationNoWait("PersonalTrainer","fight_draw_weapon")
	Sleep(1)
	CarryObject("PersonalTrainer","weapons/sword_01.nif",false)
	Sleep(2)
	PlayAnimation("PersonalTrainer","finishing_move_01")
	Sleep(1)
	PlayAnimation("PersonalTrainer","finishing_move_02")
	MoveSetActivity("PersonalTrainer","")
	AnimTime = PlayAnimationNoWait("PersonalTrainer","fight_store_weapon")
	Sleep(1)
	CarryObject("PersonalTrainer","",false)
	Sleep(AnimTime-1)
	AnimTime = MoveSetStance("",GL_STANCE_STAND)
	Sleep(AnimTime)
	PlayAnimation("PersonalTrainer","laud")
	
	SetMeasureRepeat(TimeOut)
	MeasureSetNotRestartable()
	ResetProcessProgress("PersonalTrainer")
	ResetProcessProgress("")
	GetPosition("","ParticleSpawnPos")
	PlaySound3D("","Effects/mystic_gift+0.wav", 1.0)
	StartSingleShotParticle("particles/change_effect.nif", "ParticleSpawnPos", 1, 2.0)
	
	
	
	
	
	SimSetClass("", GL_CLASS_CHISELER)
	ms_militarytrainingself_Terminate(TrainerID)
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
-- Terminate
-- -----------------------
function Terminate(TrainerID)
	
	-- Get rid of the Executioner
	GetAliasByID(TrainerID,"PersonalTrainer")
	if AliasExists("PersonalTrainer") then
		
		if GetInsideBuilding("PersonalTrainer","CurrentBuilding") then
			if GetLocatorByName("CurrentBuilding","Exit1","TrainerExitPos") then
				f_MoveTo("PersonalTrainer", "TrainerExitPos")
			end
		end
		InternalDie("PersonalTrainer")
		InternalRemove("PersonalTrainer")
	end
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	ResetProcessProgress("")
	StopAnimation("")
	MoveSetActivity("","")
	if AliasExists("PersonalTrainer") then
		local TrainerID = GetID("PersonalTrainer")
		ms_militarytrainingself_Terminate(TrainerID)
		MoveSetStance("PersonalTrainer","GL_STANCE_STAND") 
		ResetProcessProgress("PersonalTrainer")
		MoveSetActivity("PersonalTrainer","")
		StopAnimation("PersonalTrainer")
	end
end

-- -----------------------
-- GetOSHData
-- -----------------------
function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

