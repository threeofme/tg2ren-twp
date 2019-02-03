function Weight()
	aitwp_Log("Weight::ApplyForOffice", "dynasty")
	
	local time = math.mod(GetGametime(),24)
	
	if time >= 16 then
		return 0
	end
	
	if not dyn_GetIdleMember("dynasty", "SIM") then
		return 0
	end
	
	if not GetSettlement("SIM", "CITY_OF_OFFICE") then
		return 0
	end
	
	if SimIsAppliedForOffice("SIM") then
		-- application running already
		return 0
	end
	
	-- find good office to apply for
	local Level = SimGetMaxOfficeLevel("SIM")
	local MyLevel = SimGetOfficeLevel("SIM")
	local HighestLevel = CityGetHighestOfficeLevel("CITY_OF_OFFICE")
	
	-- insufficient nobility title
	if GetNobilityTitle("SIM") < 4 then
		return 0
	end

	-- insufficient nobility title to raise further	
	if GetNobilityTitle("SIM") < 5 and MyLevel >= 1 then
		return 0
	end
	
	local RetVal = 0
	local Ret
		
	local CityLevel = CityGetLevel("CITY_OF_OFFICE")
	local Choice1
	local Choice2
	local Preference
	local Officelevel
	local MyOffice = SimGetOfficeID("SIM")
	
	if CityLevel == 2 then -- small village
		if MyOffice ==-1 and Level<2 then
			--Check my choices. I have 2 choices because of citylevel
			Choice1 = 0 -- Weibel
			Choice2 = 1 -- Schlichtmann
			Officelevel = 1
			
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice1,"OFFICE1")
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice2,"OFFICE2")
			--Check if Office is currently unoccupied
			if not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")<4 then
				Preference =0
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice2,"Holder")) and OfficeGetApplicantCount("OFFICE2")<4 then
				Preference =1
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")==4 then
				Preference =1
			else
			-- All available offices have holders. Check the Applicant-Count

				if OfficeGetApplicantCount("OFFICE1") < OfficeGetApplicantCount("OFFICE2") then
					Preference = 0
				elseif OfficeGetApplicantCount("OFFICE1") > OfficeGetApplicantCount("OFFICE2") then
					Preference = 1
				else
				Preference =Rand(2)
				end
			end
		elseif (Level == 2 and MyLevel <2) or MyOffice == 1 or MyOffice == 2 then
			Preference = 0 -- Schultheiss
			Officelevel = 2
		else 
			return 0
		end
		
		SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Preference,"OFFICE")
		Ret = applyforoffice_CheckOffice("Office")
		if Ret=="Apply" then	
				CopyAlias("OFFICE", "APPLY_OFFICE")
				return 100
		elseif Ret=="Deposit" and RetVal==0 then
				CopyAlias("OFFICE", "APPLY_OFFICE")
				RetVal = 100
		end
		
	elseif CityLevel == 3 then -- village
		if MyOffice ==-1 and Level<2 then
			--Check my choices. I have 2 choices because of citylevel
			Choice1 = 0 -- Foltermeister
			Choice2 = 1 -- Gildenvertreter
			Officelevel = 1
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice1,"OFFICE1")
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice2,"OFFICE2")
			--Check if Office is currently unoccupied
			if not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")<4 then
				Preference =0
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice2,"Holder")) and OfficeGetApplicantCount("OFFICE2")<4 then
				Preference =1
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")==4 then
				Preference =1
			else
			-- All available offices have holders. Check the Applicant-Count

				if OfficeGetApplicantCount("OFFICE1") < OfficeGetApplicantCount("OFFICE2") then
					Preference = 0
				elseif OfficeGetApplicantCount("OFFICE1") > OfficeGetApplicantCount("OFFICE2") then
					Preference = 1
				else
				Preference =Rand(2)
				end
			end
		elseif (Level == 2 and MyLevel <2) or MyOffice == 4 or MyOffice == 5 then
		--Check my choices. I have 2 choices because of citylevel
			Choice1 = 0 -- Hauptmann
			Choice2 = 1 -- Dorfvogt
			Officelevel = 2
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice1,"OFFICE1")
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice2,"OFFICE2")
			--Check if Office is currently unoccupied
			if not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")<4 then
				Preference =0
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice2,"Holder")) and OfficeGetApplicantCount("OFFICE2")<4 then
				Preference =1
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")==4 then
				Preference =1
			else
			-- All available offices have holders. Check the Applicant-Count

				if OfficeGetApplicantCount("OFFICE1") < OfficeGetApplicantCount("OFFICE2") then
					Preference = 0
				elseif OfficeGetApplicantCount("OFFICE1") > OfficeGetApplicantCount("OFFICE2") then
					Preference = 1
				else
				Preference =Rand(2)
				end
			end
		elseif (Level == 3 and MyLevel <3) or MyOffice == 6 or MyOffice == 7 then
			Preference = 0 -- Dorfschulze
			Officelevel = 3
		else 
			return 0
		end
		
		SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Preference,"OFFICE")
		Ret = applyforoffice_CheckOffice("Office")
		if Ret=="Apply" then	
				CopyAlias("OFFICE", "APPLY_OFFICE")
				return 100
		elseif Ret=="Deposit" and RetVal==0 then
				CopyAlias("OFFICE", "APPLY_OFFICE")
				RetVal = 100
		end
		
	elseif CityLevel == 4 then -- small Town
		if MyOffice ==-1 and Level<2 then
			--Check my choices. I have 2 choices because of citylevel
			Choice1 = 0 -- Kerkermeister
			Choice2 = 1 -- Gildenmeister 
			Officelevel = 1
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice1,"OFFICE1")
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice2,"OFFICE2")
			--Check if Office is currently unoccupied
			if not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")<4 then
				Preference =0
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice2,"Holder")) and OfficeGetApplicantCount("OFFICE2")<4 then
				Preference =1
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")==4 then
				Preference =1
			else
			-- All available offices have holders. Check the Applicant-Count

				if OfficeGetApplicantCount("OFFICE1") < OfficeGetApplicantCount("OFFICE2") then
					Preference = 0
				elseif OfficeGetApplicantCount("OFFICE1") > OfficeGetApplicantCount("OFFICE2") then
					Preference = 1
				else
				Preference =Rand(2)
				end
			end
		elseif (Level == 2 and MyLevel <2) or MyOffice == 9 or MyOffice == 10 then
		--Check my choices. I have 2 choices because of citylevel
			Choice1 = 0 -- Inquisitor
			Choice2 = 1 -- Seneschall
			Officelevel = 2
			--Check if Office is currently unoccupied
			if not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) then
				Preference = 0
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice2,"Holder")) then
				Preference = 1
			else
			-- All available offices have holders. Check the Applicant-Count
				SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice1,"OFFICE1")
				SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice2,"OFFICE2")
				if OfficeGetApplicantCount("OFFICE1") < OfficeGetApplicantCount("OFFICE2") then
					Preference = 0
				elseif OfficeGetApplicantCount("OFFICE1") > OfficeGetApplicantCount("OFFICE2") then
					Preference = 1
				else
				Preference =Rand(2)
				end
			end
		elseif (Level == 3 and MyLevel <3) or MyOffice == 11 or MyOffice == 12 then
			--Check my choices. I have 2 choices because of citylevel
			Choice1 = 0 -- Obrist
			Choice2 = 1 -- Richter
			Officelevel = 3
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice1,"OFFICE1")
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice2,"OFFICE2")
			--Check if Office is currently unoccupied
			if not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")<4 then
				Preference =0
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice2,"Holder")) and OfficeGetApplicantCount("OFFICE2")<4 then
				Preference =1
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")==4 then
				Preference =1
			else
			-- All available offices have holders. Check the Applicant-Count

				if OfficeGetApplicantCount("OFFICE1") < OfficeGetApplicantCount("OFFICE2") then
					Preference = 0
				elseif OfficeGetApplicantCount("OFFICE1") > OfficeGetApplicantCount("OFFICE2") then
					Preference = 1
				else
				Preference =Rand(2)
				end
			end
		elseif (Level == 4 and MyLevel <4) or MyOffice == 13 or MyOffice == 14 then
			Preference = 0 -- Buergermeister
			Officelevel = 4
		else 
			return 0
		end
		
		SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Preference,"OFFICE")
		Ret = applyforoffice_CheckOffice("Office")
		if Ret=="Apply" then	
				CopyAlias("OFFICE", "APPLY_OFFICE")
				return 100
		elseif Ret=="Deposit" and RetVal==0 then
				CopyAlias("OFFICE", "APPLY_OFFICE")
				RetVal = 100
		end
	
	elseif CityLevel == 5 then -- Town
		if MyOffice ==-1 and Level<2 then
			--Check my choices. I have 2 choices because of citylevel
			Choice1 = 0 -- Henker
			Choice2 = 1 -- Pachtmeister
			Officelevel = 1
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice1,"OFFICE1")
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice2,"OFFICE2")
			--Check if Office is currently unoccupied
			if not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")<4 then
				Preference =0
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice2,"Holder")) and OfficeGetApplicantCount("OFFICE2")<4 then
				Preference =1
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")==4 then
				Preference =1
			else
			-- All available offices have holders. Check the Applicant-Count

				if OfficeGetApplicantCount("OFFICE1") < OfficeGetApplicantCount("OFFICE2") then
					Preference = 0
				elseif OfficeGetApplicantCount("OFFICE1") > OfficeGetApplicantCount("OFFICE2") then
					Preference = 1
				else
				Preference =Rand(2)
				end
			end
		elseif (Level == 2 and MyLevel <2) or MyOffice == 16 or MyOffice == 17 then
		--Check my choices. I have 2 choices because of citylevel
			Choice1 = 0 -- Kerkervogt
			Choice2 = 1 -- Gildenvorsteher
			Officelevel = 2
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice1,"OFFICE1")
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice2,"OFFICE2")
			--Check if Office is currently unoccupied
			if not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")<4 then
				Preference =0
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice2,"Holder")) and OfficeGetApplicantCount("OFFICE2")<4 then
				Preference =1
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")==4 then
				Preference =1
			else
			-- All available offices have holders. Check the Applicant-Count

				if OfficeGetApplicantCount("OFFICE1") < OfficeGetApplicantCount("OFFICE2") then
					Preference = 0
				elseif OfficeGetApplicantCount("OFFICE1") > OfficeGetApplicantCount("OFFICE2") then
					Preference = 1
				else
				Preference =Rand(2)
				end
			end
		elseif (Level == 3 and MyLevel <3) or MyOffice == 18 or MyOffice == 19 then
			--Check my choices. I have 2 choices because of citylevel
			Choice1 = 0 -- Bischof
			Choice2 = 1 -- Konsul
			Officelevel = 3
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice1,"OFFICE1")
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice2,"OFFICE2")
			--Check if Office is currently unoccupied
			if not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")<4 then
				Preference =0
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice2,"Holder")) and OfficeGetApplicantCount("OFFICE2")<4 then
				Preference =1
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")==4 then
				Preference =1
			else
			-- All available offices have holders. Check the Applicant-Count

				if OfficeGetApplicantCount("OFFICE1") < OfficeGetApplicantCount("OFFICE2") then
					Preference = 0
				elseif OfficeGetApplicantCount("OFFICE1") > OfficeGetApplicantCount("OFFICE2") then
					Preference = 1
				else
				Preference =Rand(2)
				end
			end
		elseif (Level == 4 and MyLevel <4) or MyOffice == 20 or MyOffice == 21 then
			--Check my choices. I have 2 choices because of citylevel
			Choice1 = 0 -- Marschall
			Choice2 = 1 -- ObersterRichter
			Officelevel = 4
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice1,"OFFICE1")
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice2,"OFFICE2")
			--Check if Office is currently unoccupied
			if not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")<4 then
				Preference =0
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice2,"Holder")) and OfficeGetApplicantCount("OFFICE2")<4 then
				Preference =1
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")==4 then
				Preference =1
			else
			-- All available offices have holders. Check the Applicant-Count

				if OfficeGetApplicantCount("OFFICE1") < OfficeGetApplicantCount("OFFICE2") then
					Preference = 0
				elseif OfficeGetApplicantCount("OFFICE1") > OfficeGetApplicantCount("OFFICE2") then
					Preference = 1
				else
				Preference =Rand(2)
				end
			end
		elseif (Level == 5 and MyLevel <5) or MyOffice == 22 or MyOffice == 23 then
			Preference = 0 -- Landesherr
			Officelevel = 5
		else 
			return 0
		end
		
		SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Preference,"OFFICE")
		Ret = applyforoffice_CheckOffice("Office")
		if Ret=="Apply" then	
				CopyAlias("OFFICE", "APPLY_OFFICE")
				return 100
		elseif Ret=="Deposit" and RetVal==0 then
				CopyAlias("OFFICE", "APPLY_OFFICE")
				RetVal = 100
		end
	elseif CityLevel == 6 then -- Captial City
		if MyOffice ==-1 and Level<2 then
			--Check my choices. I have 2 choices because of citylevel
			Choice1 = 0 -- CHenker
			Choice2 = 1 -- CPachtmeister
			Officelevel = 1
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice1,"OFFICE1")
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice2,"OFFICE2")
			--Check if Office is currently unoccupied
			if not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")<4 then
				Preference =0
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice2,"Holder")) and OfficeGetApplicantCount("OFFICE2")<4 then
				Preference =1
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")==4 then
				Preference =1
			else
			-- All available offices have holders. Check the Applicant-Count

				if OfficeGetApplicantCount("OFFICE1") < OfficeGetApplicantCount("OFFICE2") then
					Preference = 0
				elseif OfficeGetApplicantCount("OFFICE1") > OfficeGetApplicantCount("OFFICE2") then
					Preference = 1
				else
				Preference =Rand(2)
				end
			end
		elseif (Level == 2 and MyLevel <2) or MyOffice == 25 or MyOffice == 26 then
		--Check my choices. I have 2 choices because of citylevel
			Choice1 = 0 -- CKerkervogt
			Choice2 = 1 -- CGildenvorsteher
			Officelevel = 2
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice1,"OFFICE1")
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice2,"OFFICE2")
			--Check if Office is currently unoccupied
			if not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")<4 then
				Preference =0
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice2,"Holder")) and OfficeGetApplicantCount("OFFICE2")<4 then
				Preference =1
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")==4 then
				Preference =1
			else
			-- All available offices have holders. Check the Applicant-Count

				if OfficeGetApplicantCount("OFFICE1") < OfficeGetApplicantCount("OFFICE2") then
					Preference = 0
				elseif OfficeGetApplicantCount("OFFICE1") > OfficeGetApplicantCount("OFFICE2") then
					Preference = 1
				else
				Preference =Rand(2)
				end
			end
		elseif (Level == 3 and MyLevel <3) or MyOffice == 27 or MyOffice == 28 then
			--Check my choices. I have 2 choices because of citylevel
			Choice1 = 0 -- CBischof
			Choice2 = 1 -- CKonsul 
			Officelevel = 3
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice1,"OFFICE1")
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice2,"OFFICE2")
			--Check if Office is currently unoccupied
			if not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")<4 then
				Preference =0
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice2,"Holder")) and OfficeGetApplicantCount("OFFICE2")<4 then
				Preference =1
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")==4 then
				Preference =1
			else
			-- All available offices have holders. Check the Applicant-Count

				if OfficeGetApplicantCount("OFFICE1") < OfficeGetApplicantCount("OFFICE2") then
					Preference = 0
				elseif OfficeGetApplicantCount("OFFICE1") > OfficeGetApplicantCount("OFFICE2") then
					Preference = 1
				else
				Preference =Rand(2)
				end
			end
		elseif (Level == 4 and MyLevel <4) or MyOffice == 29 or MyOffice == 30 then
			--Check my choices. I have 2 choices because of citylevel
			Choice1 = 0 -- CMarschall
			Choice2 = 1 -- CObersterRichter
			Officelevel = 4
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice1,"OFFICE1")
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice2,"OFFICE2")
			--Check if Office is currently unoccupied
			if not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")<4 then
				Preference =0
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice2,"Holder")) and OfficeGetApplicantCount("OFFICE2")<4 then
				Preference =1
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")==4 then
				Preference =1
			else
			-- All available offices have holders. Check the Applicant-Count

				if OfficeGetApplicantCount("OFFICE1") < OfficeGetApplicantCount("OFFICE2") then
					Preference = 0
				elseif OfficeGetApplicantCount("OFFICE1") > OfficeGetApplicantCount("OFFICE2") then
					Preference = 1
				else
				Preference =Rand(2)
				end
			end
		elseif (Level == 5 and MyLevel <5) or MyOffice == 31 or MyOffice == 32 then
			Preference = 0 -- CLandesherr
			Officelevel = 5
		elseif (Level == 6 and MyLevel <6) or MyOffice == 33 then
			--Check my choices. I have 2 choices because of citylevel
			Choice1 = 0 -- Kardinal
			Choice2 = 1 -- Feldherr
			Officelevel = 6
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice1,"OFFICE1")
			SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Choice2,"OFFICE2")
			--Check if Office is currently unoccupied
			if not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")<4 then
				Preference =0
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice2,"Holder")) and OfficeGetApplicantCount("OFFICE2")<4 then
				Preference =1
			elseif not (SettlementGetOfficeHolder("CITY_OF_OFFICE",Officelevel,Choice1,"Holder")) and OfficeGetApplicantCount("OFFICE1")==4 then
				Preference =1
			else
			-- All available offices have holders. Check the Applicant-Count

				if OfficeGetApplicantCount("OFFICE1") < OfficeGetApplicantCount("OFFICE2") then
					Preference = 0
				elseif OfficeGetApplicantCount("OFFICE1") > OfficeGetApplicantCount("OFFICE2") then
					Preference = 1
				else
				Preference =Rand(2)
				end
			end
		elseif (Level == 7 and MyLevel <7) or MyOffice == 34 or MyOffice == 35 then
			Preference = 0
			Officelevel = 7
		else 
			return 0
		end
		
		SettlementGetOffice("CITY_OF_OFFICE",Officelevel,Preference,"OFFICE")
		Ret = applyforoffice_CheckOffice("Office")
		if Ret=="Apply" then	
				CopyAlias("OFFICE", "APPLY_OFFICE")
				return 100
		elseif Ret=="Deposit" and RetVal==0 then
				CopyAlias("OFFICE", "APPLY_OFFICE")
				RetVal = 100
		end
	end
			
	if RetVal>0 then
		if ai_IsDeploymentInProgress("DepositVictim") then
			return 0
		end
	end

	return RetVal
end

function CheckOffice(Alias)
	if not OfficeGetAccessRights("OFFICE","SIM", 8) then
		return 0
	end
	
	if OfficeGetHolder("OFFICE", "OfficeHolder") then
		-- check office with a holder
		if GetDynastyID("SIM") == GetDynastyID("OfficeHolder") then
			return 0
		end
		if DynastyGetDiplomacyState("SIM","OfficeHolder")==DIP_ALLIANCE then
			return 0
		end
	end
	
	if OfficeGetApplicantCount("OFFICE") > 3 then
		return 0
	end

	if DynastyIsShadow("SIM") then
		if OfficeGetShadowApplicantCount("OFFICE") >= 3 then
			return 0
		end
	end

	return "Apply"
end

function Execute()
	MeasureRun("SIM", "APPLY_OFFICE", "RunForAnOffice")
	return
end
