function Run()
--	for i=100, 672 do
--		local Testname = GetDatabaseValue("BuildingToItems", i, "name")
--		if Testname and Testname ~= "" then
--			hottea_PrintRequiredItems(i)
--		end		
--	end


	local Target = ""
	if AliasExists("Destination") then
		Target = "Destination"
	end
	
	local result = InitData("@P"..
	"@B[1,@L%1l,@L%1l,Hud/Buttons/btn_playtarot.tga]"..
	"@B[2,@L%2l,@L%2l,Hud/Items/Item_AldermanChain.tga]"..
	"@B[3,@L%3l,@L%3l,Hud/Items/item_diamanten.tga]"..
	"@B[4,@L%4l,@L%4l,Hud/Items/Item_Stonerotary.tga]"..
	"@B[5,@L%5l,@L%5l,Hud/Items/Item_goldhigh.tga]"..
	"@B[6,@L%6l,@L%6l,Hud/Items/Item_Empfehlung.tga]"..
	"@B[7,@L%7l,@L%7l,Hud/Items/Item_MiracleCure.tga]"..
	"@B[8,@L%8l,@L%8l,Hud/Items/Item_HexerdokumentII.tga]",
	-1,
	"@L_MEASURE_HotTea_TITLE_+0","",
	"Unsterblichkeit","Titel","Politik","Erfahrung","Geld","Ruhm","Economy","AIs-Zeit")

	if result==1 then
		if SimIsMortal(Target) then
			SimSetMortal(Target, false)
			MsgQuick("", "Ahh, diese Kraft! Ich fühle mich unsterblich!",GetID(Target))
		else
			SimSetMortal(Target, true)
			MsgQuick("", "Lieber ein sterbliches Leben mit dir, als die Ewigkeit ohne dich!",GetID(Target))
		end
 
	elseif result==2 then
		if GetNobilityTitle(Target)<7 then
			SetNobilityTitle(Target, 7, true)
		end
	
	elseif result==3 then
		GetHomeBuilding(Target,"myhome")
		BuildingGetCity("myhome","city")
		local citylvl = CityGetLevel("city")
		local highestlvl = CityGetHighestOfficeLevel("city")
		CityGetOffice("city", highestlvl, 0, "office")
		SimSetOffice(Target, "office")
	elseif result==4 then
		chr_GainXP(Target,4000)
		MsgQuick("", "Ach, sag das doch gleich!",GetID(Target))
		LogMessage("1 < 2 but "..result.."2 > 1")
		LogMessage("3 %< 4 but "..result.."5 %> 3")
		LogMessage("1 < 2 but ".."2 > 1")
		LogMessage("3 %< 4 but ".."5 %> 3")
	elseif result==5 then
		f_CreditMoney(Target, 120000, "HotTea")
		MsgQuick("", "Geld, Geld, Geld!",GetID(Target))
	elseif result==6 then
		chr_SimAddFame(Target,25)
		chr_SimAddImperialFame(Target,25)
	elseif result==7 then
		-- best used on target
--		GetDynasty("", "MyDyn")
--		local targetId = GetID(Target)
--		local buildingType = GL_BUILDING_TYPE_MINE
--		LogMessage("AITWP::HotTea buildingType = "..buildingType)
--	    SetProperty("MyDyn", "BUILD_TargetSimId", targetId)
--		SetProperty("MyDyn", "BUILD_BuildingType", buildingType)
		if GetInsideBuilding(Target, "Hospital") then
			local TreatmentNeed = bld_CalcTreatmentNeed("Hospital", Target)
			MsgBox("", Target, "", "TreatmentNeed", "TreatmendNeed = "..TreatmentNeed)
		end
	elseif result == 8 then
		local freeze = MsgBox("","Owner",
				"@P@B[1,@L%1l,]@B[0,@L%2l,]",
				"AIs-Zeit","AI einfrieren?", "Ja", "Nein")
		if freeze == 1 then
			ScenarioPauseAI(true)
		elseif freeze == 0 then
			ScenarioPauseAI(false)
		end
	end
end

function PrintRequiredItems(BldId)
	local ItemsString = GetDatabaseValue("BuildingToItems", BldId, "produceditems")
	local ProducedItems = {}
	local ProducedItemsCount = 0
	for Id in string.gfind(ItemsString, "%d+") do
		ProducedItemsCount = ProducedItemsCount + 1
		ProducedItems[ProducedItemsCount] = ItemGetID(Id)
	end
	
	local RequiredItems = {}
	local RequiredItemsBaseUsages = {}
	local RequiredItemsCount = 0
	
	local ItemId
	local Amount, Buildtime
	for i=1, ProducedItemsCount do
		ItemId = ProducedItems[i]
		Buildtime = GetDatabaseValue("Items", ItemId, "buildtime")
		for j=1, 3 do
			local Prod = GetDatabaseValue("Items", ItemId, "prod"..j)
			if Prod and Prod > 0 then
				Amount = GetDatabaseValue("Items", ItemId, "nr"..j)
				-- only add prod if it isn't in the list yet, otherwise increase usage
				local IndexOfProd =	hottea_IndexOf(RequiredItems, RequiredItemsCount, Prod)
				if not IndexOfProd then
					RequiredItemsCount = RequiredItemsCount + 1
					IndexOfProd = RequiredItemsCount
					RequiredItems[IndexOfProd] = Prod
					RequiredItemsBaseUsages[IndexOfProd] = 0
				end
				-- base usage is defined as the maximum of units of this items that can be used up by one worker during a day 
				RequiredItemsBaseUsages[IndexOfProd] = math.max(math.ceil(24/Buildtime) * Amount, RequiredItemsBaseUsages[IndexOfProd])				
			end
		end
	end
	-- 100  "Farm1"  4                 "1   2   4   5"                                         | 
	local DbEntry = BldId .. "   "
	DbEntry = DbEntry .. "\"" .. GetDatabaseValue("BuildingToItems", BldId, "name") .. "\"   "
	DbEntry = DbEntry .. "\"" .. GetDatabaseValue("BuildingToItems", BldId, "produceditems") .. "\"   "
	DbEntry = DbEntry .. "\"" .. helpfuncs_IdListToString(RequiredItems, RequiredItemsCount) .. "\"   \"" .. helpfuncs_IdListToString(RequiredItemsBaseUsages, RequiredItemsCount) .. "\"   |"
	LogMessage(DbEntry)
end

function PrintTextvalues(TextId)
	local Label = GetDatabaseValue("TextDeUtf8", TextId, "label")
	local German = GetDatabaseValue("TextDeUtf8", TextId, "german")
	local English = GetDatabaseValue("TextEnUtf8", TextId, "english")

	local DbEntry = TextId .. "   "
	DbEntry = DbEntry .. "\"" .. Label .. "\"   "
	DbEntry = DbEntry .. "\"" .. German .. "\"   "
	DbEntry = DbEntry .. "\"" .. English .. "\"   "
	DbEntry = DbEntry .. " |"
	LogMessage(DbEntry)
end

function IndexOf(List, ListSize, Item)
	for x=1, ListSize do
		if List[x] and List[x] == Item then
			return x
		end
	end
	return nil
end

function CleanUp()
	SetState("", STATE_LOCKED, false)
end