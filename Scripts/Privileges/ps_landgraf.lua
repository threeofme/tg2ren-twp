function GetPrivilegeList()
	return "BeFromNobleBlood"
end

function TakeTitle()
	gameplayformulas_StartHighPriorMusic(MUSIC_POSITIVE_EVENT)
	chr_SetNobilityImpactList("TitleHolder", ps_landgraf_GetPrivilegeList())

	local TitleLabel
	local PrivLabel
	
	TitleLabel = "_CHARACTERS_3_TITLES_NAME_+"..(11)
	PrivLabel = "_MEASURE_"..ps_landgraf_GetPrivilegeList().."_NAME_+0"

	feedback_MessageCharacter("",
		"@L_CHARACTERS_3_TITLES_AQUIRE_MESSAGES_NEW_PRIVILEGES_HEAD_+0",
		"@L_CHARACTERS_3_TITLES_AQUIRE_MESSAGES_NEW_PRIVILEGES_PRIV_BODY_+0", TitleLabel, PrivLabel)

end

function LooseTitle()
	chr_RemoveNobilityImpactList("TitleHolder", ps_landgraf_GetPrivilegeList())
end
 
