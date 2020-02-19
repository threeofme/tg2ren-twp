function GetWorld()
	local WorldName
	WorldName = GetSettingString("NETWORK", "World", "")
	return WorldName
end

function CreatePlayerDynasty(ID, SpawnPoint, PeerID, PlayerDesc)
	local Error = defaultcampaign_CreateDynasty(ID, SpawnPoint, true, PeerID, PlayerDesc)
	if Error ~= "" then
		return Error
	end
end


