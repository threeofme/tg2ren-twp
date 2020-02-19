-- -----------------------
-- Run
-- -----------------------
function Run()

	BuildingGetCity("","myCity")
	if (gameplayformulas_CheckPublicBuilding("myCity", GL_BUILDING_TYPE_BANK)[1]==0) then
		MsgBoxNoWait("dynasty",false,
			"@L_GUILDHOUSE_MASTERLIST_HEAD_+0",
			"@L_GUILDHOUSE_MASTERLIST_BODY_+3",
			GetID("myCity"))
		StopMeasure()
	elseif not CityGetRandomBuilding("myCity", -1, GL_BUILDING_TYPE_BANK, -1, -1, FILTER_IGNORE, "guildhouse") then
		MsgBoxNoWait("dynasty",false,
			"@L_GUILDHOUSE_MASTERLIST_HEAD_+0",
			"@L_GUILDHOUSE_MASTERLIST_BODY_+2",
			GetID("myCity"))
		StopMeasure()
	end
	
	local year = GetProperty("guildhouse", "year")

	if year~=nil then

		-- PatronLabel, PatronName, ArtisanLabel, ArtisanName, ScholarLabel, ScholarName, ChiselerLabel, ChiselerName, 
		local textArray = {"","","","","","","","","","","","","","",""}

		local PatronMaster = GetProperty("guildhouse", "PatronMaster")
		if PatronMaster~=nil and PatronMaster>0 then
			if GetAliasByID(PatronMaster,"Patron")==false or GetState("Patron", STATE_DEAD) then
				textArray[0] = "@L_GUILDHOUSE_MASTERLIST_PATRON_MALE_+0"
				textArray[1] = "@L_GUILDHOUSE_MASTERLIST_DEAD_+0"
			elseif SimGetGender("Patron")==GL_GENDER_MALE then
				textArray[0] = "@L_GUILDHOUSE_MASTERLIST_PATRON_MALE_+0"
				textArray[1] = GetName("Patron")
			else
				textArray[0] = "@L_GUILDHOUSE_MASTERLIST_PATRON_FEMALE_+0"
				textArray[1] = GetName("Patron")
			end
			if GetDynasty("Patron", "Dyn") and not DynastyIsShadow("Dyn") then
				local tmpflag = DynastyGetFlagNumber("Dyn") + 29
				textArray[8] = "@L$S[20"..tmpflag.."]"
			else
				textArray[8] = "@L$S[2008]"
			end
		else
				textArray[0] = "@L_GUILDHOUSE_MASTERLIST_PATRON_MALE_+0"
				textArray[1] = "@L_GUILDHOUSE_MASTERLIST_NO_ENTRY_+0"
				textArray[8] = "@L$S[2008]"
		end

		local ArtisanMaster = GetProperty("guildhouse", "ArtisanMaster")
		if ArtisanMaster~=nil and ArtisanMaster>0 then
			if GetAliasByID(ArtisanMaster,"Artisan")==false or GetState("Artisan", STATE_DEAD) then
				textArray[2] = "@L_GUILDHOUSE_MASTERLIST_ARTISAN_MALE_+0"
				textArray[3] = "@L_GUILDHOUSE_MASTERLIST_DEAD_+0"
			elseif SimGetGender("Artisan")==GL_GENDER_MALE then
				textArray[2] = "@L_GUILDHOUSE_MASTERLIST_ARTISAN_MALE_+0"
				textArray[3] = GetName("Artisan")
			else
				textArray[2] = "@L_GUILDHOUSE_MASTERLIST_ARTISAN_FEMALE_+0"
				textArray[3] = GetName("Artisan")
			end
			if GetDynasty("Artisan", "Dyn") and not DynastyIsShadow("Dyn") then
				local tmpflag = DynastyGetFlagNumber("Dyn") + 29
				textArray[9] = "@L$S[20"..tmpflag.."]"
			else
				textArray[9] = "@L$S[2008]"
			end
		else
				textArray[2] = "@L_GUILDHOUSE_MASTERLIST_ARTISAN_MALE_+0"
				textArray[3] = "@L_GUILDHOUSE_MASTERLIST_NO_ENTRY_+0"
				textArray[9] = "@L$S[2008]"
		end

		local ScholarMaster = GetProperty("guildhouse", "ScholarMaster")
		if ScholarMaster~=nil and ScholarMaster>0 then
			if GetAliasByID(ScholarMaster,"Scholar")==false or GetState("Scholar", STATE_DEAD) then
				textArray[4] = "@L_GUILDHOUSE_MASTERLIST_SCHOLAR_MALE_+0"
				textArray[5] = "@L_GUILDHOUSE_MASTERLIST_DEAD_+0"
			elseif SimGetGender("Scholar")==GL_GENDER_MALE then
				textArray[4] = "@L_GUILDHOUSE_MASTERLIST_SCHOLAR_MALE_+0"
				textArray[5] = GetName("Scholar")
			else
				textArray[4] = "@L_GUILDHOUSE_MASTERLIST_SCHOLAR_FEMALE_+0"
				textArray[5] = GetName("Scholar")
			end
			if GetDynasty("Scholar", "Dyn") and not DynastyIsShadow("Dyn") then
				local tmpflag = DynastyGetFlagNumber("Dyn") + 29
				textArray[10] = "@L$S[20"..tmpflag.."]"
			else
				textArray[10] = "@L$S[2008]"
			end
		else
				textArray[4] = "@L_GUILDHOUSE_MASTERLIST_SCHOLAR_MALE_+0"
				textArray[5] = "@L_GUILDHOUSE_MASTERLIST_NO_ENTRY_+0"
				textArray[10] = "@L$S[2008]"
		end

		local ChiselerMaster = GetProperty("guildhouse", "ChiselerMaster")
		if ChiselerMaster~=nil and ChiselerMaster>0 then
			if GetAliasByID(ChiselerMaster,"Chiseler")==false or GetState("Chiseler", STATE_DEAD) then
				textArray[6] = "@L_GUILDHOUSE_MASTERLIST_CHISELER_MALE_+0"
				textArray[7] = "@L_GUILDHOUSE_MASTERLIST_DEAD_+0"
			elseif SimGetGender("Chiseler")==GL_GENDER_MALE then
				textArray[6] = "@L_GUILDHOUSE_MASTERLIST_CHISELER_MALE_+0"
				textArray[7] = GetName("Chiseler")
			else
				textArray[6] = "@L_GUILDHOUSE_MASTERLIST_CHISELER_FEMALE_+0"
				textArray[7] = GetName("Chiseler")
			end
			if GetDynasty("Chiseler", "Dyn") and not DynastyIsShadow("Dyn") then
				local tmpflag = DynastyGetFlagNumber("Dyn") + 29
				textArray[11] = "@L$S[20"..tmpflag.."]"
			else
				textArray[11] = "@L$S[2008]"
			end
		else
				textArray[6] = "@L_GUILDHOUSE_MASTERLIST_CHISELER_MALE_+0"
				textArray[7] = "@L_GUILDHOUSE_MASTERLIST_NO_ENTRY_+0"
				textArray[11] = "@L$S[2008]"
		end

		local Alderman = chr_GetAlderman()
		if Alderman~=0 then
			if GetAliasByID(Alderman,"Alderman")==false or GetState("Alderman", STATE_DEAD) then
				textArray[12] = "@L_CHECKALDERMAN_ALDERMAN_MALE_+1"
				textArray[13] = "@L_GUILDHOUSE_MASTERLIST_DEAD_+0"
			elseif SimGetGender("Alderman")==GL_GENDER_MALE then
				textArray[12] = "@L_CHECKALDERMAN_ALDERMAN_MALE_+1"
				textArray[13] = GetName("Alderman")
			else
				textArray[12] = "@L_CHECKALDERMAN_ALDERMAN_FEMALE_+1"
				textArray[13] = GetName("Alderman")
			end
			if GetDynasty("Alderman", "Dyn") and not DynastyIsShadow("Dyn") then
				local tmpflag = DynastyGetFlagNumber("Dyn") + 29
				textArray[14] = "@L$S[20"..tmpflag.."]"
			else
				textArray[14] = "@L$S[2008]"
			end
		else
				textArray[12] = "@L_CHECKALDERMAN_ALDERMAN_MALE_+1"
				textArray[13] = "@L_GUILDHOUSE_MASTERLIST_NO_ENTRY_+0"
				textArray[14] = "@L$S[2008]"
		end

		MsgBoxNoWait("dynasty",false,
			"@L_GUILDHOUSE_MASTERLIST_HEAD_+0",
			"@L_GUILDHOUSE_MASTERLIST_BODY_+0",
			GetID("myCity"),year,textArray[0],textArray[1],textArray[2],textArray[3],textArray[4],textArray[5],textArray[6],textArray[7],textArray[8],textArray[9],textArray[10],textArray[11],textArray[12],textArray[13],textArray[14])

	else

		MsgBoxNoWait("dynasty",false,
			"@L_GUILDHOUSE_MASTERLIST_HEAD_+0",
			"@L_GUILDHOUSE_MASTERLIST_BODY_+1",
			GetID("myCity"))

	end

end
