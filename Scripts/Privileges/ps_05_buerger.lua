function GetPrivilegeList()
	return "RunForAnOffice"
end

function GetCompletePrivilegeList()
	-- the beisasse privileges are commented out because the canapplyforlowestoffice-privilegue mustn't copied
	return ps_05_buerger_GetPrivilegeList() -- , ps_04_beisasse_GetCompletePrivilegeList() 
end

function TakeTitle()
	gameplayformulas_StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
	chr_SetNobilityImpactList("TitleHolder", ps_05_buerger_GetPrivilegeList())

	local currenttitle = GetNobilityTitle("TitleHolder") + 1
	local buildinglevel = GetDatabaseValue("NobilityTitle", currenttitle, "maxresidencelevel")
	local maxworkshops = GetDatabaseValue("NobilityTitle", currenttitle, "maxworkshops")
	local BuildLabel = "_BUILDING_Residence"..buildinglevel.."_NAME_+0"
	local TitleLabel = "_CHARACTERS_3_TITLES_NAME_+"..(currenttitle * 2) - 1
	local buildingcount = chr_DynastyGetWorkhopCount("TitleHolder")
	
	RemoveImpact("TitleHolder", "CanApplyForLowestOffice") -- remove the canapplyforlowestoffice-impact

	feedback_MessageCharacter("",
		"@L_CHARACTERS_3_TITLES_AQUIRE_MESSAGES_NEW_PRIVILEGES_HEAD_+0",
		"@L_CHARACTERS_3_TITLES_AQUIRE_MESSAGES_NEW_BODY_+0", TitleLabel, BuildLabel, maxworkshops, buildingcount, chr_GeneratePrivilegeListLabels(ps_05_buerger_GetCompletePrivilegeList()))

end

function LooseTitle()
	chr_RemoveNobilityImpactList("TitleHolder", ps_05_buerger_GetPrivilegeList())
	AddImpact("TitleHolder", "CanApplyForLowestOffice", 1, -1) -- if the title is lost the impact has to be set again
end
 
