function Run()
end

function OnLevelUp()
end

function Setup()
	-- create ambient animals
	if Rand(2)==0 then
		worldambient_CreateAnimal("Cat", "" ,1)
	else
		worldambient_CreateAnimal("Dog", "" ,1)
	end
end

function PingHour()
	--LogMessage("::TOM::Thief Ping hour...")
	
	-- Check every worker (only once) for illness and equipment 
	if not HasProperty("", "CheckDefaultWorkers") then
		bld_ResetWorkers("")
		SetProperty("", "CheckDefaultWorkers", 1)
	end
	
	-- Only for AI
	--LogMessage("::TOM::Thief AI-Setting Enabled = " .. BuildingGetAISetting("", "Enable"))
	if BuildingGetAISetting("", "Enable") > 0 then
		-- moved to idlelib and AI folder
		--thief_ManageWorkers()
	end
	
	if BuildingGetOwner("", "MyBoss") then
		if GetHomeBuilding("MyBoss", "MyHome") then
			if DynastyIsShadow("MyHome") then -- shadows shall only have 1 cart
				bld_RemoveCart("")
			end
			
			if DynastyIsAI("MyHome") then
				bld_CheckRivals("")
				bld_ForceLevelUp("")
			end
		end
	end
end

function ManageWorkers()
	local Time = math.mod(GetGametime(), 24)
	local NumWorkers = BuildingGetWorkerCount("")
	--LogMessage("::TOM::Thief Manage workers, Time = " ..  Time .. " and WorkerCount = " .. NumWorkers)
	local CurrentMeasure
	for i=0 , NumWorkers - 1 do
		BuildingGetWorker("", i, "Worker")
		--LogMessage("::TOM::Thief Worker Nr. "..i)
		--LogMessage("::TOM::Thief Worker Nr. measure: "..GetCurrentMeasureID("Worker"))
		CurrentMeasure = GetCurrentMeasureID("Worker")
		if not (660 <= CurrentMeasure and CurrentMeasure <= 700) then
			if GetHPRelative("Worker") < 0.7 then
				roguelib_Heal("Worker")
			elseif 7 <= Time and Time <= 21 then
				-- pickpocket or look for sales counters during the day
				if Rand(10) < 7 then
					roguelib_Pickpocket("Worker")
				else
					roguelib_StealFromCounter("Worker")
				end
			else
				-- TODO team up (two thieves each) and burgle some building, i.e. by saving current targets in bld property
				roguelib_BurgleBuilding("Worker")
			end 
		end
	end
end


