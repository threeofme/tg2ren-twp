function GetPrivilegeList()
	return "HaveImmunity", "CommandInquisitor", "LeadCrusade", "WorkWonders", "CanApplyForEpicOffice"
end

function InitOffice()
	SetOfficePrivileges( "Office", ps_kardinal_GetPrivilegeList() )
	SetOfficeServants("Office", "Inquisitor", 1, GL_PROFESSION_INQUISITOR)
end

function TakeOffice(Messages)
	if (Messages == 1) then
		gameplayformulas_StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
		feedback_MessageOffice("",
			ps_kardinal_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_GAIN_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_GAIN_BODY",GetID(""),GetSettlementID(""))
	end

	chr_SetOfficeImpactList( "Office", ps_kardinal_GetPrivilegeList() )
	RemoveImpact("","CanApplyForEpicOfficeTimed")
end

function LooseOffice(Messages)
	if (Messages == 1) then
		feedback_MessageOffice("",
			ps_kardinal_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_LOST_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_LOST_BODY",GetID(""),GetSettlementID(""))
	end

	RemoveAllObjectDependendImpacts( "", "Office" )
	RemoveImpact("","CanApplyForEpicOfficeTimed")
	AddImpact("","CanApplyForEpicOfficeTimed",1,24)
end
 
