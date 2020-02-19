function Pacify(Sim,duration)
	if BattleIsFighting(Sim) then
		BattleLeave(Sim)
	end
	AddImpact(Sim,"Peaceful",1,duration)

end


function Run()
	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)
	if not SimGetWorkingPlace("","Church") then
		StopMeasure()
	end
	SetRepeatTimer("Church", GetMeasureRepeatName(), TimeOut)
	SetMeasureRepeat(TimeOut)
	local Time = PlayAnimationNoWait("","sing_for_peace")
	local NumTargets = Find("","__F( (Object.GetObjectsByRadius(Sim) == 1000) )","target",-1)
	
	for i=0,NumTargets-1,1 do
		ms_092_singforpeacefulness_Pacify("target"..i,duration)
	end

	ms_092_singforpeacefulness_Pacify("",duration)
	GetPosition("","ParticleSpawnPosPrayer")
	StartSingleShotParticle("particles/pray_glow.nif","ParticleSpawnPosPrayer",2,Time)
	Sleep(Time)
	chr_GainXP("",GetData("BaseXP"))
	
end

function CleanUp()
	StopAnimation("")

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

