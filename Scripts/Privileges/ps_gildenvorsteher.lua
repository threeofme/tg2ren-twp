function GetPrivilegeList()
	return "InspectBusiness","HaveUnrestrictedTradingRights","ImposeASalesFreeze", "CommandInspector"
end

function InitOffice()
	SetOfficePrivileges( "Office", ps_gildenvorsteher_GetPrivilegeList() )
	SetOfficeServants("Office", "Inspector", 3, GL_PROFESSION_INSPECTOR)
end

function TakeOffice(Messages)
	if (Messages == 1) then
		gameplayformulas_StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
		feedback_MessageOffice("",
			ps_gildenvorsteher_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_GAIN_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_GAIN_BODY",GetID(""),GetSettlementID(""))
	end

	chr_SetOfficeImpactList( "Office", ps_gildenvorsteher_GetPrivilegeList() )
end

function LooseOffice(Messages)
	if (Messages == 1) then
		feedback_MessageOffice("",
			ps_gildenvorsteher_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_LOST_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_LOST_BODY",GetID(""),GetSettlementID(""))
	end

	RemoveAllObjectDependendImpacts( "", "Office" )
end
 
