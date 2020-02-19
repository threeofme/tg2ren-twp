Include ("campaign/DefaultCampaign.lua")

function GetWorld()
	local WorldName
	WorldName = GetSettingString("ENDLESS", "World", "")
	return WorldName
end

function Prepare()
	local	Time = 6
	local StartSeason	= EN_SEASON_SPRING -- 1 ansonsten Winterbäume beim Start
	local StartYear	= GetSettingNumber("ENDLESS", "StartYear", 1400)
	SetTime(StartSeason, StartYear, Time, 0)

	-- set world animals
	WorldAnimals = 0

	-- Vorbereitung der KarrenSpeicher
	hpfzFreierHandelKarrenID = 0

	return true
end

function CreatePlayerDynasty(ID, SpawnPoint, PeerID, PlayerDesc)

	local PlayerDynasty = GetSettingNumber("ENDLESS", "PlayerDynasty", 1)
	if PlayerDynasty == 0 then
		return ""
	end
	
	local Error = defaultcampaign_CreateDynasty(ID, SpawnPoint, true, PeerID, PlayerDesc)
	if Error ~= "" then
		return Error
	end
	
	local CityAlias = "City"
	if not GetSettlement("boss", CityAlias) then
		return
	end
	
	local	Building
	local	Number = 1

	while true do
	
		Building = GetSettingString("ENDLESS", "Building"..Number, "")
		if Building=="" then
			break
		end
		
		local BuildingType
		BuildingType = Name2BuildingType(Building )
		
		if BuildingType~=0 then
			if CityGetRandomBuilding(CityAlias, nil, BuildingType, -1, -1, FILTER_IS_BUYABLE, "Building") then
				BuildingBuy("Building", "boss", BM_STARTUP)
			else
				local Proto = ScenarioFindBuildingProto(nil, BuildingType, 1, -1)
				if Proto and Proto~=-1 then
					if CityBuildNewBuilding(CityAlias, Proto, nil, "Workshop") then
						BuildingBuy("Workshop", "boss", BM_STARTUP)
					end
				end
			end
		end
		Number = Number + 1
	end
	
end

