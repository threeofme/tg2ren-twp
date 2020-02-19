function GetPrivilegeList()
	return "HaveImmunity", "Rage", "MilitaryTraining", "ConfiscateGoods", "CommandStructure", "CanApplyForEpicOffice"
end

function InitOffice()
	SetOfficePrivileges( "Office", ps_feldherr_GetPrivilegeList() )
end

function TakeOffice(Messages)
	if (Messages == 1) then
		gameplayformulas_StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
		feedback_MessageOffice("",
			ps_feldherr_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_GAIN_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_GAIN_BODY",GetID(""),GetSettlementID(""))
	end

	chr_SetOfficeImpactList( "Office", ps_feldherr_GetPrivilegeList() )
	RemoveImpact("","CanApplyForEpicOfficeTimed")
	-- Feldherr special case because the functionality can not be mapped via the impact-functionality
	CommandStructure("", true)
end

function LooseOffice(Messages)
	if (Messages == 1) then
		feedback_MessageOffice("",
			ps_feldherr_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_LOST_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_LOST_BODY",GetID(""),GetSettlementID(""))
	end

	RemoveAllObjectDependendImpacts( "", "Office" )
	RemoveImpact("","CanApplyForEpicOfficeTimed")
	AddImpact("","CanApplyForEpicOfficeTimed",1,24)
	-- Feldherr special case because the functionality can not be mapped via the impact-functionality
	CommandStructure("", false)
end
 
