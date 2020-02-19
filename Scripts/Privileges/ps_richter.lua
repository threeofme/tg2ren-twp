function GetPrivilegeList()
	return "HaveImmunity","Set_SeverityOfLaw","BeVenerability"
end

function InitOffice()
	SetOfficePrivileges( "Office", ps_richter_GetPrivilegeList() )
end


function TakeOffice(Messages)
	if (Messages == 1) then
		gameplayformulas_StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
		feedback_MessageOffice("",
			ps_richter_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_GAIN_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_GAIN_BODY",GetID(""),GetSettlementID(""))
	end
	
	-- Remove the "HasRepealedImmunity" impact
	if GetImpactValue("", 345) ~= 0 then
		RemoveImpact("", 345)
	end
	
	chr_SetOfficeImpactList( "Office", ps_richter_GetPrivilegeList() )
end

function LooseOffice(Messages)
	if (Messages == 1) then
		feedback_MessageOffice("",
			ps_richter_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_LOST_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_LOST_BODY",GetID(""),GetSettlementID(""))
	end

	RemoveAllObjectDependendImpacts( "", "Office" )
end
 
