function Init()
	
end

function Run()
	
	local InviteStop = 17 
	local PartyStart = 23
	
	
	local day = math.floor(GetGametime()/24)
	local time = math.mod(GetGametime(),24)
	--debug
	--day+1 in final version
	local festivity_date = (day+1)*24 + PartyStart	 -- am nächsten tag um 20h
	local invitestop_date = (day+1)*24 + InviteStop	 -- am nächsten tag um 14h
	--local festivity_date = GetGametime()+2 -- 6
	festivity_date = festivity_date*60
	SetProperty("","PartyDate",festivity_date)
	local TimeToWait = Gametime2Realtime((24 - time)+InviteStop)
	--debug
	--local TimeToWait = Gametime2Realtime(InviteStop - time)
	
	
	
	
	local Datebooktime = Gametime2Total(GetGametime()+TimeToWait)
	if not BuildingGetOwner("","BuildingOwner") then
		StopMeasure()
	end
	if not GetSettlement("","Settlement") then
		StopMeasure()
	end
	local SimsInvited = 6 - GetProperty("","InvitationsLeft")
	SimAddDatebookEntry("BuildingOwner", festivity_date, "", "@L_FEAST_5_TIMEPLANNERENTRY_INVITER_+0",
								"@L_FEAST_5_TIMEPLANNERENTRY_INVITER_+1",
								GetID("BuildingOwner"),SimsInvited,GetID("Settlement"))
	local TimeToCall = (festivity_date/60)-2
	if CreateScriptcall("CallToFeast",TimeToCall-GetGametime(),"Measures/ms_160_GiveAFeast.lua","CallToFeast","BuildingOwner","") then
		--MsgQuick("BuildingOwner","Attend Script 2h before %1c",festivity_date)
	end
	
	Sleep(TimeToWait)
	
	--time end for invitations
	if not BuildingGetOwner("","BuildingOwner") then
		StopMeasure()
	end
	SetProperty("","InvitationsLeft",0)
	SetProperty("","GuestsReady",0)
	if GetProperty("","InvitationsLeft")==6 then		--no one invited
		feedback_MessageWorkshop("","@L_FEAST_2_INVITE_NOONEINVITED_HEADER_+0",
						"@L_FEAST_2_INVITE_NOONEINVITED_BODY_+0",GetID("BuildingOwner"))
		StopMeasure()
	else
		feedback_MessageWorkshop("","@L_FEAST_2_INVITE_TIMEOUT_HEADER_+0",
						"@L_FEAST_2_INVITE_TIMEOUT_BODY_+0",GetID("BuildingOwner"))
	end
	TimeToWait = Gametime2Realtime(PartyStart-InviteStop)
	Sleep(TimeToWait)
	
	--feast start
	if not BuildingGetOwner("","BuildingOwner") then
		StopMeasure()
	end
	
	GetLocatorByName("","HostWelcome","SearchPos")
	local HostID = GetID("BuildingOwner")
	local GuestFilter = "__F((Object.GetObjectsByRadius(Sim)==20000) AND(Object.Property.InvitedBy=="..HostID..")) )"
	local NumGuests = Find("SearchPos",GuestFilter,"Guest",-1)
	
	if NumGuests <= 0 then
		StopMeasure()
	end
	
	--spawn the musicians
	if not GetLocatorByName("","Stroll1","MusicianSpawnPos") then
		StopMeasure()
	end
	
	if SimCreate(720, "", "MusicianSpawnPos", "Musician1") then
		SetProperty("Musician1","Musician1",1)
		SimSetBehavior("Musician1","Feast")
	end
	local Musicians = GetProperty("","MusicLevel")
	if Musicians ~= 3 then --only one musician
		if SimCreate(721, "", "MusicianSpawnPos", "Musician2") then
			SetProperty("Musician2","Musician2",1)
			SimSetBehavior("Musician2","Feast")
		end
		if SimCreate(722, "", "MusicianSpawnPos", "Musician3") then
			SetProperty("Musician3","Musician3",1)
			SimSetBehavior("Musician3","Feast")
		end
		
	end
	
	
	if not GetInsideBuilding("BuildingOwner","CurrentBuilding") then
		SetProperty("","NoHost",1)
		
	end
	if GetID("CurrentBuilding") ~= GetID("") then
		SetProperty("","NoHost",1)
	end
	
	if GetInsideBuilding("BuildingOwner","CurrentBuilding") then
		if GetID("CurrentBuilding") == GetID("") then
			if not HasProperty("BuildingOwner","Host") then
				SetProperty("BuildingOwner","Host")
			end
			SimSetBehavior("BuildingOwner","Feast")
		end
	end
	
	while GetProperty("","GuestsReady") < NumGuests do
		Sleep(1)
		if GetGametime() > (festivity_date / 60)+1 then
			--MsgQuick("","PROBLEM - Gäste lassen zu lange auf sich warten")
			--StopMeasure()
		end
	end
	
	SetProperty("","AllGuestsThere",1)
		
	
	while true do
		Sleep(3)
		if not GetInsideBuilding("BuildingOwner","CurrentBuilding") then
			StopMeasure()
		end
	end
end

function SitDown()
	if GetFreeLocatorByName("Owner","couch",1,2,"CouchPos") then
		f_BeginUseLocator("","CouchPos",GL_STANCE_SITBENCH,true)
	else
		f_MoveTo("","CouchPos",GL_MOVESPEED_WALK,200)
		PlayAnimationNoWait("Guest"..i,"cogitate")
	end
	
end

function CleanUp()
	local festivity_date = GetProperty("","PartyDate")
	SimAddDatebookEntry("BuildingOwner", festivity_date, "", "@L_FEAST_5_TIMEPLANNERENTRY_INVITER_+0", "")
	
	if AliasExists("Musician1") then
		InternalDie("Musician1")
		InternalRemove("Musician1")
	end
	if AliasExists("Musician2") then
		InternalDie("Musician2")
		InternalRemove("Musician2")
	end
	if AliasExists("Musician3") then
		InternalDie("Musician3")
		InternalRemove("Musician3")
	end
	RemoveProperty("","PartyDate")
	RemoveProperty("","GuestsReady")
	RemoveProperty("","InvitationsLeft")
	RemoveProperty("","CanInvite")
	RemoveProperty("","MusicLevel")
	RemoveProperty("","FoodLevel")
	RemoveProperty("","BaseMoney")
	RemoveProperty("","PriceForInvite")
	RemoveProperty("","NoHost")
	RemoveProperty("","AllGuestsThere")
	for i=1,6 do
		if HasProperty("","Guest"..i) then
			local GuestID = GetProperty("","Guest"..i)
			if GetAliasByID(GuestID,"Guest") then
				local MeasureName = GetCurrentMeasureName("Guest") 
				if MeasureName == "AttendFestivity" or MeasureName == "Feast" then
					SimStopMeasure("Guest")
				end
			end
			RemoveProperty("","Guest"..i)
		end		
	end
end
