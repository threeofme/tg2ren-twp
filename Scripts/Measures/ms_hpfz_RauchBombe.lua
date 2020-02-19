function Init()
end

function Run()

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	SetMeasureRepeat(TimeOut)
	
	GetPosition("","rauchPos")
    StartSingleShotParticle("particles/Explosion.nif", "rauchPos", 0.2,5)
	PlaySound3D("","fire/Explosion_s_07.wav", 1.0)
	Sleep(2)
	GfxStartParticle("SchleierRauch", "particles/build.nif", "rauchPos", 3.5)
	Sleep(1)
	BattleLeave("")
	MoveStop("")
	StopAnimation("")
	SetState("", STATE_FIGHTING, false)
	SetState("", STATE_LOCKED, true)
	MoveSetStance("",GL_STANCE_CROUCH)
	local filter ="__F((Object.GetObjectsByRadius(Sim)==1000)AND(Object.GetState(fighting)))"
	local k = Find("",filter,"Feinde",15)
	for l=0, k-1 do
	    if BattleIsFighting("Feinde"..l) == true then
	        BattleLeave("Feinde"..l)
			MoveStop("Feinde"..l)
			StopAnimation("Feinde"..l)
			SetState("Feinde"..l, STATE_FIGHTING, false)
			PlayAnimationNoWait("Feinde"..l,"cough")
	    end
	end
	PlayAnimationNoWait("","crouch_down")
	Sleep(1)
	local filter ="__F((Object.GetObjectsByRadius(Building)==1000))"
	local k = Find("",filter,"Umgebung",15)
	if k > 0 then
	    GfxAttachObject("tarn","Handheld_Device/barrel_new.nif")
	else
	    GfxAttachObject("tarn","Outdoor/Bushes/bush_08_big.nif")
	end
	GfxSetPositionTo("tarn","rauchPos")
	SetData("Clean",1)
	SetState("", STATE_INVISIBLE, true)
	Sleep(4)
	GfxStopParticle("SchleierRauch")
	Sleep(10)
	SimBeamMeUp("","rauchPos",false)
    SetState("", STATE_INVISIBLE, false)
	SetData("Clean",0)
	GfxDetachAllObjects()
	MoveSetStance("",GL_STANCE_STAND)
	SetState("", STATE_LOCKED, false)
	BattleLeave("")
	MoveStop("")
	StopAnimation("")
	SetState("", STATE_FIGHTING, false)
	chr_GainXP("",GetData("BaseXP"))
	
end

function CleanUp()

    if GetData("Clean") == 1 then
	    SimBeamMeUp("","rauchPos",false)
        SetState("", STATE_INVISIBLE, false)
	end
	MoveSetStance("",GL_STANCE_STAND)
	SetState("", STATE_LOCKED, false)
	GfxDetachAllObjects()

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end
