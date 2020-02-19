-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_RepealImmunity"
----
----	With this measure the player can repeal the immunity of a sim
----  
----  1. Amtsimmunität des selektierten Ratsmitgliedes kartenweit aufheben
----  2. Nach einer Zeit verjährt das Aufheben der Immunität (soll als Impact angezeigt werden)
----  
----  Selektiert werden kann ein "DynastySim", der den folgenden Filter "besteht":
----  
----  (Object.HasImpact(HaveImmunity)) //Check, ob der Sim Immunität hat
----  AND NOT(Object.BelongsToMe())
----  AND NOT(Object.HasImpact(Set_SeverityOfLaw)) //Check, ob der Sim das Richteramt innehat
----  AND NOT(Object.HasImpact(HasRepealedImmunity)) //Check, ob der Sim schon eine aufgehobene Immunität hat
----  
----  Ausserdem wird in den Privilegien-Scripten "ps_schlichtmann.lua", "ps_dorfvogt.lua", "ps_obersterrichter.lua" und
----  "ps_richter.lua" der Impact entfernt, sollte der Sim das Richteramt aufnehmen. Zusätzlich wird im Privilegienscript
----  "ps_koenig.lua" der Impact entfernt, sollte der König, der diesen Impact vergeben hat, aus seinem Amt ausscheiden oder sterben
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	SetMeasureRepeat(TimeOut)
			
	-- Remove the probably earlier given impact
	if HasProperty("", "RepealedImmunity") then
		local SimID = GetProperty("", "RepealedImmunity")
		if GetAliasByID(SimID, "AffectedSim") then
			RemoveImpact("AffectedSim", 345)
			RemoveProperty("", "RepealedImmunity")
			feedback_MessageCharacter("AffectedSim","@L_PRIVILEGES_REPEALIMMUNITY_MSG_LOOSE_HEAD_+0",
								 "@L_PRIVILEGES_REPEALIMMUNITY_MSG_LOOSE_BODY_+0",GetID("AffectedSim"))
		end
	end
	
	-- Add the impact and remember to whose immunity was repealed in order to reset it if the sim looses the kings office or a new sim is given this impact
	if AddImpact("Destination", "HasRepealedImmunity", 1, -1) then
		SetProperty("", "RepealedImmunity", GetID("Destination"))
		feedback_MessageCharacter("","@L_PRIVILEGES_REPEALIMMUNITY_MSG_ACTOR_HEAD_+0",
						"@L_PRIVILEGES_REPEALIMMUNITY_MSG_ACTOR_BODY_+0", GetID("Destination"))
		feedback_MessageCharacter("Destination", "@L_PRIVILEGES_REPEALIMMUNITY_MSG_VICTIM_HEAD_+0",
						"@L_PRIVILEGES_REPEALIMMUNITY_MSG_VICTIM_BODY_+0", GetID("Owner"),GetID("Destination"))
	end

	chr_GainXP("",GetData("BaseXP"))
	Sleep(0.5)
	chr_ModifyFavor("Destination","",-10)
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

