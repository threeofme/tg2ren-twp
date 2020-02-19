function GetPrivilegeList()
	return "PoliticalAttention"
end

function GetCompletePrivilegeList()
	return ps_07_patrizier_GetPrivilegeList(), ps_06_freibuerger_GetCompletePrivilegeList()
end

function TakeTitle()
	gameplayformulas_StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
	chr_SetNobilityImpactList("TitleHolder", ps_07_patrizier_GetPrivilegeList())

	local currenttitle = GetNobilityTitle("TitleHolder") + 1
	local buildinglevel = GetDatabaseValue("NobilityTitle", currenttitle, "maxresidencelevel")
	local maxworkshops = GetDatabaseValue("NobilityTitle", currenttitle, "maxworkshops")
	local BuildLabel = "_BUILDING_Residence"..buildinglevel.."_NAME_+0"
	local TitleLabel = "_CHARACTERS_3_TITLES_NAME_+"..(currenttitle * 2) - 1
	local buildingcount = chr_DynastyGetWorkhopCount("TitleHolder")
  
	feedback_MessageCharacter("",
		"@L_CHARACTERS_3_TITLES_AQUIRE_MESSAGES_NEW_PRIVILEGES_HEAD_+0",
		"@L_CHARACTERS_3_TITLES_AQUIRE_MESSAGES_NEW_BODY_+0", TitleLabel, BuildLabel, maxworkshops, buildingcount, chr_GeneratePrivilegeListLabels(ps_07_patrizier_GetCompletePrivilegeList()))

end

function LooseTitle()
	chr_RemoveNobilityImpactList("TitleHolder", ps_07_patrizier_GetPrivilegeList())
end
 
