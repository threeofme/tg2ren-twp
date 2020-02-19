function GetPrivilegeList()
	return "PurchaseForLowerPricesAtPrimaryProducers"
end

function InitOffice()
	SetOfficePrivileges( "Office", ps_pachtmeister_GetPrivilegeList() )
end


function TakeOffice(Messages)
	if (Messages == 1) then
		gameplayformulas_StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
		feedback_MessageOffice("",
			ps_pachtmeister_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_GAIN_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_GAIN_BODY",GetID(""),GetSettlementID(""))
	end
	chr_SetOfficeImpactList( "Office", ps_pachtmeister_GetPrivilegeList() )
	AddObjectDependendImpact("",GetID("Office"),"bargaining",2)
end

function LooseOffice(Messages)
	if (Messages == 1) then
		feedback_MessageOffice("",
			ps_pachtmeister_GetPrivilegeList,
			"@L_PRIVILEGES_OFFICE_LOST_HEAD_+0",
			"@L_PRIVILEGES_OFFICE_LOST_BODY",GetID(""),GetSettlementID(""))
	end

	RemoveAllObjectDependendImpacts( "", "Office" )
end
 
