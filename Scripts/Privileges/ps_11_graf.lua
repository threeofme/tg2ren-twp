function GetPrivilegeList()
	return "CanApplyForEpicOffice"
end

function GetCompletePrivilegeList()
	return ps_11_graf_GetPrivilegeList(), ps_10_baron_GetCompletePrivilegeList()
end

function TakeTitle()
	gameplayformulas_StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
	chr_SetNobilityImpactList("TitleHolder", ps_11_graf_GetPrivilegeList())

	local currenttitle = GetNobilityTitle("TitleHolder") + 1
	local buildinglevel = GetDatabaseValue("NobilityTitle", currenttitle, "maxresidencelevel")
	local maxworkshops = GetDatabaseValue("NobilityTitle", currenttitle, "maxworkshops")
	local BuildLabel = "_BUILDING_Residence"..buildinglevel.."_NAME_+0"
	local TitleLabel = "_CHARACTERS_3_TITLES_NAME_+"..(currenttitle * 2) - 1
	local buildingcount = chr_DynastyGetWorkhopCount("TitleHolder")

	feedback_MessageCharacter("",
		"@L_CHARACTERS_3_TITLES_AQUIRE_MESSAGES_NEW_PRIVILEGES_HEAD_+0",
		"@L_CHARACTERS_3_TITLES_AQUIRE_MESSAGES_NEW_BODY_+0", TitleLabel, BuildLabel, maxworkshops, buildingcount, chr_GeneratePrivilegeListLabels(ps_11_graf_GetCompletePrivilegeList()))

end

function LooseTitle()
	chr_RemoveNobilityImpactList("TitleHolder", ps_11_graf_GetPrivilegeList())
end
 
