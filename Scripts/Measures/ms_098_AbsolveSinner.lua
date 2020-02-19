-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_098_AbsolveSinner"
----
----	with this privilege the office bearer can remove all evidences against
----	the destination
----
-------------------------------------------------------------------------------

function Run()
	
	BlockChar("Destination")
	--how much the favor of the Destination to the owner is decreased
	local favormodify = 10
	--how far the Destination can be to start this action
	local MaxDistance = 1000
	--how far from the destination, the owner should stand while reading the letter from rome
	local ActionDistance = 150
	--time before privilege can be used again
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	
	MeasureSetNotRestartable()
	--run to destination and start action at MaxDistance
	if not ai_StartInteraction("", "Destination", MaxDistance, ActionDistance, nil) then
		StopMeasure()
	end
	
	--look at each other
	feedback_OverheadActionName("Destination")
	AlignTo("", "Destination")
	AlignTo("Destination", "")
	Sleep(0.5)
	
	--do the visual stuff
	MoveSetStance("Destination",GL_STANCE_KNEEL)
	PlayAnimationNoWait("","absolve_sinner")
	MsgSay("","@L_PRIVILEGES_098_ABSOLVESINNER_SPEAK_+0")
	GetPosition("Destination", "ParticleSpawnPos")
	StartSingleShotParticle("particles/absolvesinner.nif", "ParticleSpawnPos",1.4,4)
	MoveSetStance("Destination",GL_STANCE_STAND)
	PlayAnimation("Destination","devotion")
	
	
	
	--modify the favor
	chr_ModifyFavor("Destination","",favormodify)
	
	MsgNewsNoWait("Destination","","","intrigue",-1,
		"@L_PRIVILEGES_098_ABSOLVESINNER_MESSAGES_VICTIM_HEAD_+0",
		"@L_PRIVILEGES_098_ABSOLVESINNER_MESSAGES_VICTIM_TEXT_+0",GetID("Destination"),GetID(""))
	
	
	SetMeasureRepeat(TimeOut)
	chr_GainXP("",GetData("BaseXP"))
	-- Remove All Evidences against Destination
	SimGetCrimeList("destination","my_crimes")
	local i
	local NumCrimes = ListSize("my_crimes")
	for i=0,NumCrimes-1 do
		ListGetElement("my_crimes",i,"crime")
		CrimeForfeit("crime",2)		-- 2 = forgiven by church
	end
	StopMeasure()
end

function CleanUp()

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

