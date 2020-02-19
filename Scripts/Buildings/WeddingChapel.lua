--
-- Run is called directly after the building is complete initialized.
-- this is a scheduled call, so you can loop an sleep
--
function Run()
end


function OnLevelUp()	
end

function Setup()
end

function PingHour()
	weddingchapel_CheckOrphans()
end


function CheckOrphans()
	if not HasProperty("","Sleeping") then
		SetProperty("","Sleeping", 0)
	end
	if GetProperty("", "Orphan1")==nil then
		GetLocatorByName("","OrphanSpawnPoint","SpawnPos1")
		SimCreate(605,"","SpawnPos1","Orphan1")
		if SimGetGender("Orphan1")==GL_GENDER_MALE then
			local name = GetName("Orphan1")
			local y,z = string.find(name, " ")
			local newlastname = string.sub(name, 1 , y)
			SimSetFirstname("Orphan1", "@L_WEDDING_CHAPEL_ORPHAN_MALE_+0")
			SimSetLastname("Orphan1", newlastname)
		else
			local name = GetName("Orphan1")
			local y,z = string.find(name, " ")
			local newlastname = string.sub(name, 1 , y)
			SimSetFirstname("Orphan1", "@L_WEDDING_CHAPEL_ORPHAN_FEMALE_+0")
			SimSetLastname("Orphan1", newlastname)
		end
		SimSetAge("Orphan1", 5)
		SetState("Orphan1",STATE_TOWNNPC,true)
		SimSetBehavior("Orphan1","Orphan")
		SetProperty("", "Orphan1", GetID("Orphan1"))
	end
	if GetProperty("", "Orphan2")==nil then
		GetLocatorByName("","OrphanSpawnPoint","SpawnPos2")
		SimCreate(605,"","SpawnPos2","Orphan2")
		if SimGetGender("Orphan2")==GL_GENDER_MALE then
			local name = GetName("Orphan2")
			local y,z = string.find(name, " ")
			local newlastname = string.sub(name, 1 , y)
			SimSetFirstname("Orphan2", "@L_WEDDING_CHAPEL_ORPHAN_MALE_+0")
			SimSetLastname("Orphan2", newlastname)
		else
			local name = GetName("Orphan2")
			local y,z = string.find(name, " ")
			local newlastname = string.sub(name, 1 , y)
			SimSetFirstname("Orphan2", "@L_WEDDING_CHAPEL_ORPHAN_FEMALE_+0")
			SimSetLastname("Orphan2", newlastname)
		end
		SimSetAge("Orphan2", 5)
		SetState("Orphan2",STATE_TOWNNPC,true)
		SimSetBehavior("Orphan2","Orphan")
		SetProperty("", "Orphan2", GetID("Orphan2"))
	end

	-- check for sleeping time
	local currentGameTime = math.mod(GetGametime(),24)
	if (currentGameTime < 6) or (currentGameTime > 20) then
		if GetProperty("", "Sleeping")==0 then
			SetProperty("", "Sleeping", 1)
		end
	else
		if GetProperty("", "Sleeping")==1 then
			-- RemoveProperty("", "Sleeping")
			SetProperty("", "Sleeping", 0)
		end
	end
end

