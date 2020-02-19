function GetPrivilegeList()
	return "HaveImmunity", "RoyalGuard", "Disappropriate", "FlamingSpeech", "RepealImmunity", "CanApplyForEpicOffice"
end

function InitOffice()
	SetOfficePrivileges( "Office", ps_koenig_GetPrivilegeList() )
end

function TakeOffice(Messages)
	if (Messages == 1) then
		gameplayformulas_StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
		feedback_MessageOffice("",
			ps_koenig_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_GAIN_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_GAIN_BODY",GetID(""),GetSettlementID(""))
	end

	local oldimperialofficer = chr_GetImperialOfficer()
	if oldimperialofficer==GetID("") then
		MsgQuick("","@L_IMPERIALOFFICER_LOOSE_+0")
		RemoveProperty("", "ImperialOfficer")
		SetData("#ImperialOfficer",0)
	end						

	chr_SetOfficeImpactList( "Office", ps_koenig_GetPrivilegeList() )
	RemoveImpact("","CanApplyForEpicOfficeTimed")

	gameplayformulas_CheckImperialOfficer()

end

function LooseOffice(Messages)
	if (Messages == 1) then
		feedback_MessageOffice("",
			ps_koenig_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_LOST_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_LOST_BODY",GetID(""),GetSettlementID(""))
	end
	
	-- Remove the probably earlier given "RepealImmunity" impact
	if HasProperty("", "RepealedImmunity") then
		local SimID = GetProperty("", "RepealedImmunity")
		if GetAliasByID(SimID, "AffectedSim") then
			RemoveImpact("AffectedSim", 345)
			RemoveProperty("", "RepealedImmunity")
			feedback_MessageCharacter("AffectedSim", "@L_PRIVILEGES_REPEALIMMUNITY_MSG_LOOSE_HEAD_+0", "@L_PRIVILEGES_REPEALIMMUNITY_MSG_LOOSE_BODY_+0")
		end		
	end

	RemoveAllObjectDependendImpacts( "", "Office" )
	RemoveImpact("","CanApplyForEpicOfficeTimed")
	AddImpact("","CanApplyForEpicOfficeTimed",1,24)
end
 
