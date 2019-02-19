function Run()
	local warchooserid = GetData("#WarChooser")
	GetAliasByID(warchooserid,"WarChooser")
	GetSettlement("", "City")

	while true do
			if GetProperty("WarChooser","WarPhase")==1 and not HasProperty("", "prewar") then
				SetProperty("", "prewar", 1)
				state_global_event_PreWar()
			elseif GetProperty("WarChooser","WarPhase")==2 and HasProperty("", "prewar") then
				RemoveProperty("", "prewar")
				SetProperty("","waitingforresult",1)
--				state_global_event_OfficerPromotion()
			elseif GetProperty("WarChooser","WarPhase")==0 and HasProperty("", "waitingforresult") then
				RemoveProperty("","waitingforresult")
			
				if GetProperty("WarChooser","WarWon")==2 then
					if HasProperty("", "costs") then
						local profit = GetProperty("", "costs") * 2.5
						GetSettlement("", "City")
						f_CreditMoney("City", profit, "WarProfit")
						if HasProperty("City", "Warcosts") then
							profit = GetProperty("City", "Warcosts") - profit
						else
							profit = profit * (-1)
						end
						SetProperty("City", "Warcosts", profit)
					end
				else
					if HasProperty("", "costs") then
						local fine = GetProperty("", "costs") * 1.5
						GetSettlement("", "City")
						if GetMoney("City")<fine then
							fine = GetMoney("City")
						end
						f_SpendMoney("City", fine, "WarFine")
						if HasProperty("City", "Warcosts") then
							fine = GetProperty("City", "Warcosts") + fine
						end
						SetProperty("City", "Warcosts", fine)
					end
				end
			
				RemoveProperty("", "trooper")
				RemoveProperty("", "arkebusier")
				RemoveProperty("", "cannon")
				RemoveProperty("", "officers")
				RemoveProperty("", "officer1")
				RemoveProperty("", "officer2")
				RemoveProperty("", "officer3")
				RemoveProperty("", "officer4")
				RemoveProperty("", "officer5")
				RemoveProperty("", "captain")
				RemoveProperty("", "prewar")
				RemoveProperty("", "costs")
			end
		Sleep(20)
	end
end


function PreWar()

	GetSettlement("", "City")
	local CityLevel = CityGetLevel("City")
	local trooper
	local arkebusier
	local cannons
	local officers
	local costs

	if CityLevel==2 then
		trooper = 10
		arkebusier = 0
		cannons = 0
		officers = 1
	elseif CityLevel==3 then
		trooper = 20
		arkebusier = 5
		cannons = 0
		officers = 2
	elseif CityLevel==4 then
		trooper = 30
		arkebusier = 10
		cannons = 2
		officers = 3
	elseif CityLevel==5 then
		trooper = 50
		arkebusier = 20
		cannons = 5
		officers = 5
	else
		trooper = 70
		arkebusier = 30
		cannons = 10
		officers = 5
	end
	
	costs = (trooper*50)+(arkebusier*120)+(cannons*400)+(officers*600)
		
	SetProperty("", "trooper", trooper)
	SetProperty("", "arkebusier", arkebusier)
	SetProperty("", "cannon", cannons)
	SetProperty("", "officers", officers)
	SetProperty("", "captain", 0)

	if GetMoney("City")<costs then
		costs = GetMoney("City")
	end

	SetProperty("", "costs", costs)

	f_SpendMoney("City",costs,"Warcosts")
	if HasProperty("City", "Warcosts") then
		costs = costs + GetProperty("City", "Warcosts")
	end
	SetProperty("City", "Warcosts", costs)
	
	GetLocatorByName("", "Entry1", "MercSpawnPos")

	if trooper > 0 then
		trooper = math.ceil(trooper / 10)
		for i=0,trooper-1 do
			SimCreate(50, "", "MercSpawnPos", "merctrooper"..i)
			SetProperty("merctrooper"..i, "trooper", 1)
			ForbidMeasure("merctrooper"..i, "ToggleInventory", EN_BOTH)
			SetState("merctrooper"..i,STATE_LOCKED,true)
			SetState("merctrooper"..i,STATE_GLOBALTRAVELLING,true)
			if SimGetGender("merctrooper"..i)==GL_GENDER_MALE then
				local name = GetName("merctrooper"..i)
				local y,z = string.find(name, " ")
				local newlastname = string.sub(name, 1 , y)
				SimSetFirstname("merctrooper"..i, "@L_WAR_MERC_TROOPER_MALE_+0")
				SimSetLastname("merctrooper"..i, newlastname)
			else
				local name = GetName("merctrooper"..i)
				local y,z = string.find(name, " ")
				local newlastname = string.sub(name, 1 , y)
				SimSetFirstname("merctrooper"..i, "@L_WAR_MERC_TROOPER_FEMALE_+0")
				SimSetLastname("merctrooper"..i, newlastname)
			end
		end
	end

	if arkebusier > 0 then
		arkebusier = math.ceil(arkebusier / 5)
		for i=0,arkebusier-1 do
			SimCreate(50, "", "MercSpawnPos", "mercarkebusier"..i)
			SetProperty("mercarkebusier"..i, "arkebusier", 1)
			ForbidMeasure("mercarkebusier"..i, "ToggleInventory", EN_BOTH)
			SetState("mercarkebusier"..i,STATE_LOCKED,true)
			SetState("mercarkebusier"..i,STATE_GLOBALTRAVELLING,true)
			if SimGetGender("mercarkebusier"..i)==GL_GENDER_MALE then
				local name = GetName("mercarkebusier"..i)
				local y,z = string.find(name, " ")
				local newlastname = string.sub(name, 1 , y)
				SimSetFirstname("mercarkebusier"..i, "@L_WAR_MERC_ARKEBUSIER_MALE_+0")
				SimSetLastname("mercarkebusier"..i, newlastname)
			else
				local name = GetName("mercarkebusier"..i)
				local y,z = string.find(name, " ")
				local newlastname = string.sub(name, 1 , y)
				SimSetFirstname("mercarkebusier"..i, "@L_WAR_MERC_ARKEBUSIER_FEMALE_+0")
				SimSetLastname("mercarkebusier"..i, newlastname)
			end
		end
	end
	
	if cannons > 0 then
		cannons = math.ceil(cannons / 3)
		for i=0,cannons-1 do
			SimCreate(50, "", "MercSpawnPos", "merccannons"..i)
			SetProperty("merccannons"..i, "cannon", 1)
			ForbidMeasure("merccannons"..i, "ToggleInventory", EN_BOTH)
			SetState("merccannons"..i,STATE_LOCKED,true)
			SetState("merccannons"..i,STATE_GLOBALTRAVELLING,true)
			if SimGetGender("merccannons"..i)==GL_GENDER_MALE then
				local name = GetName("merccannons"..i)
				local y,z = string.find(name, " ")
				local newlastname = string.sub(name, 1 , y)
				SimSetFirstname("merccannons"..i, "@L_WAR_MERC_CANNON_MALE_+0")
				SimSetLastname("merccannons"..i, newlastname)
			else
				local name = GetName("merccannons"..i)
				local y,z = string.find(name, " ")
				local newlastname = string.sub(name, 1 , y)
				SimSetFirstname("merccannons"..i, "@L_WAR_MERC_CANNON_FEMALE_+0")
				SimSetLastname("merccannons"..i, newlastname)
			end
		end
	end
end

function OfficerPromotion()
local CombatValue
local bestCombatValue = 0
local newCaptain = 0
local alias
	if not HasProperty("", "captain") then
		for i=1,5 do
			if HasProperty("", "officer"..i) then
				alias = GetProperty("", "officer"..i)
				GetAliasByID(alias,"Officer")
				CombatValue = GetSkillValue("Officer", FIGHTING) + SimGetLevel("Officer")
				if CombatValue > bestCombatValue then
					bestCombatValue = CombatValue
					newCaptain = alias
				end
			end
			if newCaptain > 0 then
				GetAliasByID(newCaptain,"Officer")
				RemoveProperty("Officer", "officer")
				SetProperty("Officer", "captain", 1)
				SetProperty("", "captain", newCaptain)
				if SimGetGender("Officer")==GL_GENDER_MALE then

					feedback_MessageCharacter(newCaptain,"@L_WAR_OFFICER_PROMOTION_HEAD_+0","@L_WAR_OFFICER_PROMOTION_BODY_+0",GetID("Officer"), GetSettlementID("Officer"))

				else

					feedback_MessageCharacter(newCaptain,"@L_WAR_OFFICER_PROMOTION_HEAD_+0","@L_WAR_OFFICER_PROMOTION_BODY_+1",GetID("Officer"), GetSettlementID("Officer"))

				end
			end
		end
	end
end

function CleanUp()

	RemoveProperty("", "trooper")
	RemoveProperty("", "arkebusier")
	RemoveProperty("", "cannon")
	RemoveProperty("", "officers")
	RemoveProperty("", "officer1")
	RemoveProperty("", "officer2")
	RemoveProperty("", "officer3")
	RemoveProperty("", "officer4")
	RemoveProperty("", "officer5")
	RemoveProperty("", "captain")
	RemoveProperty("", "prewar")
	RemoveProperty("", "costs")

end
