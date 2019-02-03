function Run()

	local Button1 = "@B[B,@L_HPFZ_EINSTELLEN_+0]"
	local Button2 = "@B[N,@L_HPFZ_EINSTELLEN_+1]"
	local Button3 = "@B[M,@L_HPFZ_EINSTELLEN_+2]"
	
	local Worker2Exists = FindWorker("","worker",3)
	if Worker2Exists ~= "" then
		Button2 = ""
	end
	
	local Worker3Exists = FindWorker("","worker",5)   -- the level is the minimum level.
	if Worker3Exists ~= "" then                      
		Button3 = ""
	end		

	local auswahl = MsgNews("","","@P"..
					Button1..
					Button2..
					Button3,
					ms_048_hireemployeebuildingrandom_DecideFirst,
					"intrigue",
					-1,
					"@L_GENERAL_MEASURES_HIRE_HEAD_+0",
					"@L_HPFZ_MEASURES_HIRE_ZUSATZ_+0")

	-- added by FH:
	-- prevents game from freezing
	if auswahl == "C" then
		return
	end
	
	if GetMoney("") < 500 then
		MsgBoxNoWait("dynasty","", "@L_GENERAL_ERROR_HEAD_+0","@L_MEASURES_HIRERANDOM_NOMONEY_+0")
	end
	
	local DesiredLevel = 1
	if auswahl == "N" then
		DesiredLevel = 3
	elseif auswahl == "M" then
		DesiredLevel = 5
	end
	
	local arbeiter = FindWorker("", "RandWorker",DesiredLevel)
	if arbeiter~="" then
		chr_OutputHireError("RandWorker", "", arbeiter)
		return
	end
	
	if not AliasExists("RandWorker") then
		StopMeasure()
	end
	
	if HasProperty("RandWorker", "courted") then
		MsgQuick("","@L_HIRE_ERROR_COURTED",GetID("RandWorker"))
		AddImpact("RandWorker", "NoRandomHire", 1, 12)
		StopMeasure()
	end
	
	local Handsel = SimGetHandsel("RandWorker", "")
	if BuildingHasUpgrade("",716) == true then
		Handsel = Handsel + 4900
	
	elseif BuildingHasUpgrade("",604) == true then
		Handsel = Handsel + 2400
	end
	
	if BuildingGetType("") == 111 then
		Handsel = Handsel + 4900
	end
	
	SetData("Hands",Handsel)
	local Level		= SimGetLevel("RandWorker")
	SetData("Lvl",Level)
	local Salary	= SimGetWage("RandWorker")
	SetData("Saly",Salary)
	local XP        = GetDatabaseValue("CharLevels", Level-1, "xp")  -- XP which was needed for the current level
	SetData("XPP",XP)
	
	ms_048_hireemployeebuildingrandom_DecideYou()
	
	-- Remove Items
	ms_048_hireemployeebuildingrandom_CheckInventory("RandWorker")
	
	if BuildingGetType("") == 2 then
		ms_048_hireemployeebuildingrandom_CheckSoeldner("", "RandWorker")
	elseif BuildingGetType("") == 111 then
		ms_048_hireemployeebuildingrandom_CheckLeibwache("RandWorker")
	end	
	
end
		
function DecideYou()

	SetData("Entscheid",0)
	local handsels = GetData("Hands")
	local levels = GetData("Lvl")
	local salarys = GetData("Saly")
	local xp = GetData("XPP")
	
	if BuildingGetOwner("","BOwner") then
		if GetMoney("BOwner")<handsels then
			MsgQuick("", "@L_GENERAL_MEASURES_FAILURES_+14", handsels, GetID("RandWorker"))
				StopMeasure()
		end
	end
	
	local result = MsgNews("","RandWorker","@P"..
					"@B[O,@LJa_+0]"..
					"@B[C,@LNein_+0]",
					ms_048_hireemployeebuildingrandom_Decide,
					"intrigue",
					-1,
					"@L_GENERAL_MEASURES_HIRE_HEAD_+0",
					"@L_GENERAL_MEASURES_HIRE_BODY_+0",
					GetID("RandWorker"), handsels, levels, salarys)
					
	if result == "C" then
		AddImpact("RandWorker", "NoRandomHire", 1, 4)
		return
	end

--	if GetDynastyID("RandWorker")>0 then
--		chr_OutputHireError("RandWorker", "", "NoWorker")
--	end

	Error = SimHire("RandWorker", "", true)
	chr_OutputHireError("RandWorker", "", Error)
	if SimGetLevel("RandWorker") == 1 then  -- sometimes the level is not reduced to 1 (I guess because he already had the right clothes)
		IncrementXPQuiet("RandWorker",xp)	      -- XP back to previous value
	end
	if Error == "" then
		-- stop courting
		if SimGetCourtLover("RandWorker", "WorkerLover") then
			SimReleaseCourtLover("RandWorker")
		end
		PlaySound3D("", "Effects/moneybag_to_hand+0.wav", 1.0)
		if BuildingHasUpgrade("",716) == true then
			f_SpendMoney("BOwner",4900,"misc")
		elseif BuildingHasUpgrade("",604) then
			f_SpendMoney("BOwner",2400,"misc")
		end
		if BuildingGetType("")==111 then
			f_SpendMoney("BOwner",4900,"misc")
		end
		SetData("Entscheid",1)
		if DynastyIsShadow("") == true or DynastyIsAI("") == true then
			if BuildingGetLevel("") == 1 then  
				local lvlset = (Rand(2)+1)   -- 1 or 2
				SetProperty("RandWorker","Level",lvlset)
			elseif BuildingGetLevel("") == 2 then
				local lvlset = (Rand(2)+3) -- 3 or 4
				SetProperty("RandWorker","Level",lvlset)
			else
				local lvlset = (Rand(2)+5)  -- 5 or 6
				SetProperty("RandWorker","Level",lvlset)
			end
		end
	end
	if GetImpactValue("RandWorker","Sickness")>0 then
		diseases_Sprain("RandWorker",false)
		diseases_Cold("RandWorker",false)
		diseases_Influenza("RandWorker",false)
		diseases_BurnWound("RandWorker",false)
		diseases_Pox("RandWorker",false)
		diseases_Pneumonia("RandWorker",false)
		diseases_Blackdeath("RandWorker",false)
		diseases_Fracture("RandWorker",false)
		diseases_Caries("RandWorker",false)
	end
	
	MoveSetActivity("","")
	SimGetWorkingPlace("RandWorker", "workbuilding")
	chr_CalculateBuildingBonus("RandWorker","","hire")
end

function DecideFirst()
	if BuildingGetLevel("") == 1 then
		return "B"
	elseif BuildingGetLevel("") == 2 then
		return "N"
	else
		return "M"
	end
end

function Decide()
	return "O"
end

function CheckInventory(Alias)
	-- remove armor
	if GetItemCount(Alias,"LeatherArmor",INVENTORY_EQUIPMENT)>0 then
		RemoveItems(Alias, "LeatherArmor", 1, INVENTORY_EQUIPMENT)
	elseif GetItemCount(Alias, "Chainmail",INVENTORY_EQUIPMENT)>0 then
		RemoveItems(Alias, "Chainmail", 1, INVENTORY_EQUIPMENT)
	elseif GetItemCount(Alias,"Platemail",INVENTORY_EQUIPMENT)>0 then
		RemoveItems(Alias, "Platemail", 1, INVENTORY_EQUIPMENT)
	end
	
	-- remove weapon
	if GetItemCount(Alias,"Mace",INVENTORY_EQUIPMENT)>0 then
		RemoveItems(Alias, "Mace", 1, INVENTORY_EQUIPMENT)
	elseif GetItemCount(Alias,"Shortsword",INVENTORY_EQUIPMENT)>0 then
		RemoveItems(Alias, "Shortsword", 1, INVENTORY_EQUIPMENT)
	elseif GetItemCount(Alias,"Longsword",INVENTORY_EQUIPMENT)>0 then
		RemoveItems(Alias, "Longsword", 1, INVENTORY_EQUIPMENT)
	elseif GetItemCount(Alias,"Axe", INVENTORY_EQUIPMENT)>0 then
		RemoveItems(Alias, "Axe", 1, INVENTORY_EQUIPMENT)
	end
	
	AddItems(Alias, "Dagger", 1, INVENTORY_EQUIPMENT)
end

function CheckSoeldner(Alias,Worker)
	if BuildingHasUpgrade(Alias, 716) == true then
		RemoveItems(Worker, "Dagger",1,INVENTORY_EQUIPMENT)
		AddItems(Worker, "FullHelmet",1,INVENTORY_EQUIPMENT)
		AddItems(Worker, "Platemail",1,INVENTORY_EQUIPMENT)
		AddItems(Worker, "Axe",1,INVENTORY_EQUIPMENT)	
	elseif BuildingHasUpgrade(Alias, 604) == true then
		RemoveItems(Worker, "Dagger",1,INVENTORY_EQUIPMENT)
		AddItems(Worker, "IronCap",1,INVENTORY_EQUIPMENT)
		AddItems(Worker, "Chainmail",1,INVENTORY_EQUIPMENT)
		AddItems(Worker, "Longsword",1,INVENTORY_EQUIPMENT)
	end
end

function CheckLeibwache(Alias)
	RemoveItems(Alias, "Dagger",1,INVENTORY_EQUIPMENT)
	AddItems(Alias, "FullHelmet",1,INVENTORY_EQUIPMENT)
	AddItems(Alias, "Platemail",1,INVENTORY_EQUIPMENT)
	AddItems(Alias, "Longsword",1,INVENTORY_EQUIPMENT)	
end