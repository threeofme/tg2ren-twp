-- -----------------------
-- Run
-- -----------------------
function Run()
	-- divide into God-Measure and Character-Measure
	if IsType("", "Building") then
		if BuildingGetType("")==GL_BUILDING_TYPE_TOWNHALL then
			GetLocalPlayerDynasty("LocalPlayerDynasty")
			if not GetID("LocalPlayerDynasty") == GetID("Actor") then
				StopMeasure()
			end
			local BossID = dyn_GetValidMember("LocalPlayerDynasty")
			GetAliasByID(BossID, "boss")
			if GetNobilityTitle("boss", true) == true then
				MsgQuick("boss", "@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_GODM_+0")
				StopMeasure()
			else
				local currenttitle = GetNobilityTitle("boss")

				local cost = GetDatabaseValue("NobilityTitle", currenttitle+1, "price")
				if cost=="" then
					MsgQuick("boss", "@L_PRIVILEGES_BUYNOBILITYTITLE_FAILURES_+2")
					StopMeasure()
				end
				
				if GetSkillValue("boss", BARGAINING)>4 then
					cost=cost*(1-GetSkillValue("boss", BARGAINING)*0.02)
				end

				local money = GetMoney("boss")
				local newtitle = "@L_CHARACTERS_3_TITLES_NAME_+" .. (2 * (currenttitle) + SimGetGender("boss"))

				if (currenttitle == GL_HIGHEST_NOBILITY_TITLE) then
					MsgQuick("boss", "@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_GODM_+1")
					StopMeasure()
					return
				end
				local famelvl = GetDatabaseValue("NobilityTitle", currenttitle+1, "minimperialfame")
				if chr_DynastyGetImperialFameLevel("boss") < famelvl then
					local impfameleveldyn = "@L_IMPERIAL_FAME_DYNASTY_+"..famelvl
					MsgBox("boss", "", "@P@B[0,@L_BUYTITLE_IMPERIALFAME_NO_BUTTON_+0]", "@L_MEASURE_BuyNobilityTitle_NAME_+0",
										"@L_BUYTITLE_IMPERIALFAME_NO_TALK_+0",
										newtitle, impfameleveldyn, chr_GetImperialFameLevelPoints(famelvl))
					StopMeasure()
					return	
				end
				if cost > money then
					MsgBox("boss", "", "@P@B[A, @L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE_MENU_+1]"..
										"@B[B, @L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE_MENU_+2]", "@L_MEASURE_BuyNobilityTitle_NAME_+0",
										"@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE",
										GetID("boss"), newtitle, cost)
					StopMeasure()
					return	
				else

					local BYesNo = MsgBox("boss", "", "@P@B[A, @L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE_MENU_+0]"..
										"@B[B, @L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE_MENU_+2]", "@L_MEASURE_BuyNobilityTitle_NAME_+0",
										"@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE",
										GetID("boss"), newtitle, cost)
											
					if (BYesNo == "A") then
						if (f_SpendMoney("boss", cost, "CostAdministration")) then
							GetSettlement("", "Set")
							cost = math.floor(cost*0.2)
														
							CreditMoney("Set", cost, "title")
							
							if not HasProperty("Set", "NobilityMoney") then
								SetProperty("Set", "NobilityMoney", cost)
							else
								local NobilityMoney = GetProperty("Set", "NobilityMoney") + cost
								SetProperty("Set", "NobilityMoney", NobilityMoney)
							end

							SetNobilityTitle("boss", currenttitle+1, false)

							MsgQuick("boss", "@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_4", GetID("boss"))
							StopMeasure()
							return
						else
							MsgQuick("boss", "@L_PRIVILEGES_BUYNOBILITYTITLE_FAILURES_+1")
							StopMeasure()
							return
						end
					else
						StopMeasure()
						return
					end
				end
			end
		
		else
			StopMeasure()
			return
		end
	end
	
	if not IsGUIDriven() and DynastyIsShadow("") then
		if GetNobilityTitle("", true) == true then
			StopMeasure()
		else
			local currenttitle = GetNobilityTitle("")

			local cost = GetDatabaseValue("NobilityTitle", currenttitle+1, "price")
			if cost=="" then
				MsgQuick("", "@L_PRIVILEGES_BUYNOBILITYTITLE_FAILURES_+2")
				StopMeasure()
			end
			
			if GetSkillValue("", BARGAINING)>4 then
				cost=cost*(1-GetSkillValue("", BARGAINING)*0.02)
			end

			local famelvl = GetDatabaseValue("NobilityTitle", currenttitle+1, "minimperialfame")

			if not (chr_DynastyGetImperialFameLevel("") < famelvl) then			

				if (SpendMoney("", cost, "CostAdministration")) then
					SetNobilityTitle("", currenttitle+1, false)
				else
					StopMeasure()
				end
			else
				StopMeasure()
			end
		end
	else
		
		if not ai_GoInsideBuilding("", "", -1, GL_BUILDING_TYPE_TOWNHALL) then
			return
		end

		local MsgTimeOut = 1
		-- Check if the sim is inside the townhall
		if not GetInsideBuilding("", "councilbuilding") then
			StopMeasure()
			return
		end
	
		-- Check if the desk is busy
		if not GetLocatorByName("councilbuilding", "ApproachUsherPos", "destpos") then
			MsgQuick("", "@L_PRIVILEGES_BUYNOBILITYTITLE_FAILURES_+0")
			StopMeasure()
			return
		end
		
		while true do
			if f_BeginUseLocator("","destpos", GL_STANCE_STAND, true) then
				break
			end
		
			if not HasProperty("", "WaitBench") then
				if GetFreeLocatorByName("councilbuilding","Wait",1,8,"SitPos") then
					if f_BeginUseLocator("","SitPos",GL_STANCE_SITBENCH,true) then
						SetProperty("", "WaitBench", 1)
					end
				end
			end
			
			Sleep(3)
		end
		
		if HasProperty("", "WaitBench") then
			RemoveProperty("", "WaitBench")
		end
		
		SetData("CutsceneCleared", 0)
		SetData("ReleaseLocator", 1)
		
		-- Get the Usher
		if not BuildingFindSimByProperty("councilbuilding","BUILDING_NPC", 1,"Usher") then
			StopMeasure()
		end
		
		-- Check if the usher is busy
		if GetProperty("Usher", "UsherBusy") == 1 then
			StopMeasure()
			return
		end
		
		SetProperty("Usher", "UsherBusy", 1)
		
		-- Check if a grant is in progress
		if GetNobilityTitle("", true) == true then
		
			PlayAnimationNoWait("Usher", ms_buynobilitytitle_getRandomTalk())
			MsgSay("Usher", "@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_0")
			StopAnimation("Usher")
			
		else
			CreateCutscene("default","cutscene")
			CutsceneAddSim("cutscene","")
			CutsceneAddSim("cutscene","Usher")
			CutsceneCameraCreate("cutscene","")		
			camera_CutsceneBothLockCam("cutscene", "Usher", "Far_HUpYRight")
			-- Get the season and time
			local season = GetSeason()
			local time = math.mod(GetGametime(), 24)
			
			PlayAnimationNoWait("Usher",ms_buynobilitytitle_getRandomTalk())
			
			if (time < 11) then
				if (season == EN_SEASON_SPRING) then
					MsgSay("Usher", "@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_1_+0", GetID(""))
				elseif (season == EN_SEASON_SUMMER) then
					MsgSay("Usher", "@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_1_+1", GetID(""))
				elseif (season == EN_SEASON_AUTUMN) then
					MsgSay("Usher", "@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_1_+2", GetID(""))
				else
					MsgSay("Usher", "@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_1_+3", GetID(""))
				end
			elseif (time < 17) then
				if (season == EN_SEASON_SPRING) then
					MsgSay("Usher", "@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_1_+4", GetID(""))
				elseif (season == EN_SEASON_SUMMER) then
					MsgSay("Usher", "@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_1_+5", GetID(""))
				elseif (season == EN_SEASON_AUTUMN) then
					MsgSay("Usher", "@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_1_+6", GetID(""))
				else
					MsgSay("Usher", "@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_1_+7", GetID(""))
				end
			else
				if (season == EN_SEASON_SPRING) then
					MsgSay("Usher", "@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_1_+8", GetID(""))
				elseif (season == EN_SEASON_SUMMER) then
					MsgSay("Usher", "@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_1_+9", GetID(""))
				elseif (season == EN_SEASON_AUTUMN) then
					MsgSay("Usher", "@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_1_+10", GetID(""))
				else
					MsgSay("Usher", "@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_1_+11", GetID(""))
				end
			end
			
			StopAnimation("Usher")
			
			PlayAnimationNoWait("Usher",ms_buynobilitytitle_getRandomTalk())
			camera_CutsceneBothLockCam("cutscene", "Usher", "Far_HUpYRight")
			MsgSay("Usher", "@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_2")
			StopAnimation("Usher")
			
			-- Check if the highest title is reached
			local currenttitle = GetNobilityTitle("")
			if (currenttitle == GL_HIGHEST_NOBILITY_TITLE) then
			
				PlayAnimationNoWait("Usher",ms_buynobilitytitle_getRandomTalk())
				MsgSay("Usher", "@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_IMPOSSIBLE")
				StopMeasure()
				return
				
			else
				-- Check if the sim has enough money
				local money = GetMoney("")

				local cost = GetDatabaseValue("NobilityTitle", currenttitle+1, "price")
				if cost=="" then
					MsgQuick("", "@L_PRIVILEGES_BUYNOBILITYTITLE_FAILURES_+2")
					StopMeasure()
				end
				
				if GetSkillValue("", BARGAINING)>4 then
					cost=cost*(1-GetSkillValue("", BARGAINING)*0.02)
				end

				local famelvl = GetDatabaseValue("NobilityTitle", currenttitle+1, "minimperialfame")

				local newtitle = GetNobilityTitleLabel(currenttitle+1)
				local buy = 0
				local Icant = false
				
				PlayAnimationNoWait("Usher",ms_buynobilitytitle_getRandomTalk())
									
				if chr_DynastyGetImperialFameLevel("") < famelvl then

					local impfameleveldyn = "@L_IMPERIAL_FAME_DYNASTY_+"..famelvl

					MsgSayInteraction("","Usher","",
						"@B[A, @L_BUYTITLE_IMPERIALFAME_NO_BUTTON_+0]",
						ms_buynobilitytitle_AIDecide,  --AIFunc
						"@L_BUYTITLE_IMPERIALFAME_NO_TALK_+0",
						newtitle, impfameleveldyn, chr_GetImperialFameLevelPoints(famelvl))
						
						Icant = true

				elseif cost > money then
					
					MsgSayInteraction("","Usher","",
						"@B[A, @L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE_MENU_+1]"..
						"@B[B, @L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE_MENU_+2]",
						ms_buynobilitytitle_AIDecide,  --AIFunc
						"@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE",
						GetID(""), newtitle, cost)
						
						Icant = true
					
				else
					local BYesNo = MsgSayInteraction("","Usher","",
							"@B[A, @L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE_MENU_+0]"..
							"@B[B, @L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE_MENU_+2]",
							ms_buynobilitytitle_AIDecide,  --AIFunc
							"@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE",
							GetID(""), newtitle, cost)
											
					if (BYesNo == "A") then
						buy = 1
					end
					
				end

				camera_CutsceneBothLockCam("cutscene", "Usher", "Far_HUpYRight")
				StopAnimation("Usher")
				
				if (buy == 1) then	
					camera_CutsceneBothLockCam("cutscene", "Usher", "Far_HUpYRight")		
					if (f_SpendMoney("", cost, "CostAdministration")) then
					
						GetSettlement("Usher", "Set")
						CreditMoney("Set", cost, "title")

						if not HasProperty("Set", "NobilityMoney") then
							SetProperty("Set", "NobilityMoney", cost)
						else
							local NobilityMoney = GetProperty("Set", "NobilityMoney") + cost
							SetProperty("Set", "NobilityMoney", NobilityMoney)
						end

						SetNobilityTitle("", currenttitle+1, false)
--						local XP = 10 + ((currenttitle+1) * 2)
--						IncrementXP("", XP)

						PlayAnimationNoWait("Usher",ms_buynobilitytitle_getRandomTalk())
						MsgSay("Usher", "@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_4", GetID(""))
						GetDynasty("","dyn")
						if HasProperty("dyn", "Priority1") then
							SetProperty("dyn", "Priority1", "none")
						end						
					else
						
						PlayAnimationNoWait("Usher",ms_buynobilitytitle_getRandomTalk())
						MsgQuick("", "@L_PRIVILEGES_BUYNOBILITYTITLE_FAILURES_+1")
						
					end
				else
				
					if (Icant == false) then
						camera_CutsceneBothLockCam("cutscene", "Usher", "Far_HUpYRight")
						PlayAnimationNoWait("Usher",ms_buynobilitytitle_getRandomTalk())
						MsgSay("Usher", "@L_CHARACTERS_3_TITLES_AQUIRE_TOWNHALL_3_POSSIBLE_NO")
					end

				end
				
			end
			
		end
		StopAnimation("Usher")
		DestroyCutscene("cutscene")
		SetData("CutsceneCleared", 1)
	
		StopAnimation("")

		if(GetLocatorByName("councilbuilding", "LookAtBoardPos", "LookAtBoardPos")) then
			f_MoveTo("","LookAtBoardPos")
		end			
		f_StrollNoWait("", 350, 2)
	end
end

function AIDecide()
	return "A"
end

function getRandomTalk()	
	local TargetArray = {"sit_talk_short","sit_talk","sit_talk_02"}
	local TargetCount = 3
	return TargetArray[Rand(TargetCount)+1]
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	if GetData("CutsceneCleared")~=1 then
		DestroyCutscene("cutscene")
	end
	StopAnimation("Owner")
	
	-- "free" the usher
	if AliasExists("Usher") then
		if GetProperty("Usher", "UsherBusy") == 1 then
			StopAnimation("Usher")
			RemoveProperty("Usher", "UsherBusy")
		end
	end

	if GetData("ReleaseLocator")==1 then
		f_EndUseLocatorNoWait("","destpos", GL_STANCE_STAND)
	end
end

