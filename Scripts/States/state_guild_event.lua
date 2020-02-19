function Run()
	local Count = GetData("#GuildEventCount")
	if not Count then
		Count = 0
	end
	SetData("#GuildEventCount", Count+1)

	state_guild_event_Contract()
end


function Contract()

	local event = Rand(4) + 1
	local orderer = Rand(10)
	local moneymod = Rand(5) + 1
	local type
	local Needed
	local	Item
	local money
	local ItemLabel
	local Duration
	if BuildingGetLevel("")==1 then
		type = 1
		Needed = Rand(3) + 1
		Item = state_guild_event_FindItem(event)
		ItemLabel	= ItemGetLabel(Item, false)
		money = (ItemGetBasePrice(Item))*2 + (moneymod * 200)
	else
		local chance
		local currentRound = GetRound()
		if currentRound > 1 then
			chance = Rand(10) + 1
		else
			chance = 1
		end
		if chance < 8 then
			type = 1
			Needed = Rand(4) + 2
			Item = state_guild_event_FindItem(event)
			ItemLabel	= ItemGetLabel(Item, false)
			money = (ItemGetBasePrice(Item))*2 + (moneymod * 300)
		else
			type = 2
			Needed = 1
			Item = Rand(4)
			money = 2000 + (moneymod * 500)
			Duration = Rand(6)+8
			SetProperty("", "ContractFame", 7)
		end
	end
	money = math.ceil(money)
	
	SetProperty("", "Contract", type)
	SetProperty("", "ContractClass", event)
	SetProperty("", "ContractItem", Item)
	SetProperty("", "ContractCount", Needed)
	SetProperty("", "ContractOrderer", orderer)
	SetProperty("", "ContractMoney", money)
	SetProperty("", "ContractDuration", Duration)
	
	local CurrentTime = GetGametime()
	local Gametime	= Rand(6)+6
	local DestTime  = CurrentTime + Gametime
	local	ToDo	= Gametime2Realtime(Gametime)
	local	Count
	local	Success 	= false
	local ID = "Event"..GetID("")

	GetSettlement("", "City")

	if (type == 1) then
		MsgNewsNoWait("All","","@C[@L_GUILDHOUSE_MISSIONS_ITEMS_COOLDOWN_+0,%8i,%9l]","economie",-1,
				       "@L_GUILDHOUSE_MISSIONS_ITEMS_HEAD_+0",
				       "@L_GUILDHOUSE_MISSIONS_ITEMS_TEXT_+0",
				       "@L_GUILDHOUSE_GUILDS_+"..event-1,GetID("City"),"@L_GUILDHOUSE_MISSIONS_ITEMS_ORDERER_TEXT_+"..orderer, Needed, ItemLabel, money, Gametime, DestTime,ID)
	else

		local eventstring
		if (event == 1) then
			eventstring = "@L_GUILDHOUSE_MISSIONS_TASK_PATRON_TEXT_+"..Item
		elseif (event == 2) then
			eventstring = "@L_GUILDHOUSE_MISSIONS_TASK_ARTISAN_TEXT_+"..Item
		elseif (event == 3) then
			eventstring = "@L_GUILDHOUSE_MISSIONS_TASK_SCHOLAR_TEXT_+"..Item
		else
			eventstring = "@L_GUILDHOUSE_MISSIONS_TASK_CHISELER_TEXT_+"..Item
		end
		MsgNewsNoWait("All","","@C[@L_GUILDHOUSE_MISSIONS_TASK_COOLDOWN_+0,%8i,%9l]","economie",-1,
				       "@L_GUILDHOUSE_MISSIONS_TASK_HEAD_+0",
				       "@L_GUILDHOUSE_MISSIONS_TASK_TEXT_+0",
				       "@L_GUILDHOUSE_GUILDS_+"..event-1,GetID("City"),eventstring, "@L_GUILDHOUSE_MISSIONS_TASK_ORDERER_TEXT_+"..orderer, Duration, money, Gametime, DestTime,ID)
	end

	while ToDo>0 do
		Count = GetProperty("", "ContractCount")
		if Count < 1 then
			Success = true
			break
		end
		ToDo = ToDo - 2
		Sleep(2)
	end
	
end


function FindItem(event)

	if event == 1 then
		SetProperty("", "ContractFame", 3)
		return "BarrelBrewerBeer"
	elseif event == 2 then
		SetProperty("", "ContractFame", 3)
		return "ChurchBell"
	elseif event == 3 then
		SetProperty("", "ContractFame", 3)
		return "Almanac"
	else
		SetProperty("", "ContractFame", 3)
		return "PoisonDagger"
	end
	
end


function CleanUp()
	local Count = GetData("#GuildEventCount")
	if Count and Count>0 then
		SetData("#GuildEventCount", Count-1)
	end

	RemoveProperty("", "Contract")
	RemoveProperty("", "ContractType")
	RemoveProperty("", "ContractItem")
	RemoveProperty("", "ContractCount")
	RemoveProperty("", "ContractOrderer")
	RemoveProperty("", "ContractMoney")
	RemoveProperty("", "ContractFame")
	RemoveProperty("", "ContractDuration")

	local ID = "Event"..GetID("")
	HudRemoveCountdown(ID,false)
	
	Sleep(10)
end
