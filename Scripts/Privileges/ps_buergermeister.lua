function GetPrivilegeList()
	return	"HaveImmunity","BanCharacter","CanApplyForEpicOffice", "LevelUpCity"
end

function InitOffice()
	SetOfficePrivileges( "Office", ps_buergermeister_GetPrivilegeList() )
end


function TakeOffice(Messages)
	if (Messages == 1) then
		gameplayformulas_StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
		feedback_MessageOffice("",
			ps_buergermeister_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_GAIN_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_GAIN_BODY",GetID(""),GetSettlementID(""))
	end

	chr_SetOfficeImpactList( "Office", ps_buergermeister_GetPrivilegeList() )
	RemoveImpact("","CanApplyForEpicOfficeTimed")
end

function LooseOffice(Messages)
	if (Messages == 1) then
		feedback_MessageOffice("",
			ps_buergermeister_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_LOST_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_LOST_BODY",GetID(""),GetSettlementID(""))
	end

	RemoveAllObjectDependendImpacts( "", "Office" )
	AddImpact("","CanApplyForEpicOfficeTimed",1,24)
end
 
