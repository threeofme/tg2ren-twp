function GetPrivilegeList()
	return ""
end

function GetCompletePrivilegeList()
	return ps_13_fuerst_GetPrivilegeList(), ps_12_markgraf_GetCompletePrivilegeList()
end

function TakeTitle()
	gameplayformulas_StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
	chr_SetNobilityImpactList("TitleHolder", ps_13_fuerst_GetPrivilegeList())

	local currenttitle = GetNobilityTitle("TitleHolder") + 1
	local buildinglevel = GetDatabaseValue("NobilityTitle", currenttitle, "maxresidencelevel")
	local maxworkshops = GetDatabaseValue("NobilityTitle", currenttitle, "maxworkshops")
	local BuildLabel = "_BUILDING_Residence"..buildinglevel.."_NAME_+0"
	local TitleLabel = "_CHARACTERS_3_TITLES_NAME_+"..(currenttitle * 2) - 1
	local buildingcount = chr_DynastyGetWorkhopCount("TitleHolder")

	feedback_MessageCharacter("",
		"@L_CHARACTERS_3_TITLES_AQUIRE_MESSAGES_NEW_PRIVILEGES_HEAD_+0",
		"@L_CHARACTERS_3_TITLES_AQUIRE_MESSAGES_NEW_BODY_+0", TitleLabel, BuildLabel, maxworkshops, buildingcount,chr_GeneratePrivilegeListLabels(ps_13_fuerst_GetCompletePrivilegeList()))

end

function LooseTitle()
	chr_RemoveNobilityImpactList("TitleHolder", ps_13_fuerst_GetPrivilegeList())
end
 
