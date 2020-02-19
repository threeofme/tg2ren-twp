function Run()

	local Name
	local	Settlement
	 
	local SongArray1 = {
		"Wohlan, ",1.5,"talk",
		"nun sollt Ihr's",1,"",
		"alle wissen,",3,"",
		"gebettet",2,"",
		"- ach -",2,"",
		"auf seid'nen Kissen",3,"",
		"ein Dieb",1,"",
		"nun nimmer",1,"",
		"ich bin mehr",1,"",
		"von And'rer Münzen",1,"",
		"- jetzo zehr'.",5,"",
	nil}

	local SongArray2 = {
		"Ich stifte Mißgunst,",2,"talk",
		"hab' mein' Freud',",4,"",
		"zieh' Steuern ein",2,"",
		"und lass' hinrichten.",4,"",
		"Nicht kümmert mich -",2,"",
		"der and'ren Leid,",4,"",
		"noch kümmert's mich,",2,"",
		"was meine Pflichten.",6,"",
	nil}

	local SongArray3 = {
		"Ich pred'ge Wasser -",1,"talk",
		"trinke Wein,",3,"",
		"mein' Schäflein nicht -",1,"",
		"sich's leisten können.",3,"",
		"Als Pred'ger, ach! -",1,"",
		"ist's Leben fein,",3,"",
		"dank Ablaß -",1,"",
		"kann ich mir das gönnen.",5,"",
	nil}

	local SongArray4 = {
		"Oh' grausam Schicksal,",2,"talk",
		"das mir steht bevor,",3,"",
		"heirat' 'nen alten,",2,"",
		"reichen Schecken.",3,"",
		"Der Alchimist,",2,"",
		"auf DIESES Gift,",2,"",
		"er schwor,",3,"",
		"es wirkt nicht,",2,"",
		"soll ich nun",2,"",
		"VOR ihr verrecken",5,"",
	nil}
	
	local SongStart = {
	"Kommet her",1,"talk",
	"Ihr Leut'",5,"",
	"Kommet her",1,"",
	"Ihr Leut'",5,"",
	"Nun lauschet",1,"talk",
	"was ich euch",1,"",
	"zu berichten habe",5,"",
	nil}
	
	local SongEnd = {
	"Nun nehmet euch",1,"talk",
	"dieses zu Herzen",3,"",
	"und geht nun",1,"",
	"in Frieden Heim",5,"",
	nil}
	
	while true do
	
		std_bard_CheckSleep()
		
		if not ScenarioGetRandomObject("cl_Settlement", "RandomCity") then
			break
		end
		
		if not CityGetRandomBuilding("RandomCity", GL_BUILDING_CLASS_MARKET, -1, -1, -1, FILTER_IGNORE, "SingingPos") then
			break
		end
		
		if GetOutdoorMovePosition("Owner", "SingingPos", "MoveToPosition") then
			f_MoveTo("","MoveToPosition",GL_MOVESPEED_WALK, 500)
			std_bard_CheckSleep()
		end

		CommitAction("bard", "", "")
		
		std_bard_PlaySong(SongStart)
		local Val = Rand(4)
		if Val==0 then
			std_bard_PlaySong(SongArray1)
		elseif Val==1 then
			std_bard_PlaySong(SongArray2)
		elseif Val==2 then
			std_bard_PlaySong(SongArray3)
		elseif Val==3 then
			std_bard_PlaySong(SongArray4)
		end
		std_bard_PlaySong(SongEnd)

		StopAction( "bard", "")
	end
	
	Sleep(5)
	
end

function PlaySong(Song)
	local	Position = 1
	while Song[Position] do

	if Song[Position+2] ~= "" then
		PlayAnimationNoWait("", Song[Position+2])
	end

	ShowOverheadSymbol("", false, true,0, Song[Position])
	Sleep(Song[Position+1]*1.5)
	Position = Position + 3
	end
end

function CheckSleep()

-- Nachts nicht singen, sondern schlafen gehen in einer Taverne

	local time = math.mod(GetGametime(),24)
	if time < 21 and time > 7 then
		return
	end
	
	if time > 20 then
		time = time - 24
	end
	
	if FindNearestBuilding("", -1, GL_BUILDING_TYPE_TAVERN, -1, false, "Tavern") then
		if f_MoveTo("", "Tavern") then
			MeasureRun("", nil, "RentSleepingBerth")
			return
		end
	end

	SleepTime = 8 - time
	SleepTime = Gametime2Realtime(SleepTime)
	Sleep(SleepTime)
	return


end

function CleanUp()
		StopAction( "bard", "")
end

