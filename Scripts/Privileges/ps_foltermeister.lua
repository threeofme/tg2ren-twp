function GetPrivilegeList()
	return	"TortureCharacter", "CommandPrisonGuard"
end

function InitOffice()
	SetOfficePrivileges( "Office", ps_foltermeister_GetPrivilegeList() )
	SetOfficeServants("Office", "PrisonGuard", 1, GL_PROFESSION_PRISONGUARD)
end

function TakeOffice(Messages)
	if (Messages == 1) then
		gameplayformulas_StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
		feedback_MessageOffice("",
			ps_foltermeister_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_GAIN_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_GAIN_BODY",GetID(""),GetSettlementID(""))
	end

	chr_SetOfficeImpactList( "Office", ps_foltermeister_GetPrivilegeList() )
end

function LooseOffice(Messages)
	if (Messages == 1) then
		feedback_MessageOffice("",
			ps_foltermeister_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_LOST_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_LOST_BODY",GetID(""),GetSettlementID(""))
	end

	RemoveAllObjectDependendImpacts( "", "Office" )
end
 
