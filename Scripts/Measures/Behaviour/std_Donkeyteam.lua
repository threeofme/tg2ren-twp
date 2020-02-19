function Init()

  SetState("", STATE_LOCKED, true)
--	SimSetMortal("", false)
	
end

function Run()
	SetData("Donkeytime",math.mod(GetGametime(),24)+12)
	while (math.mod(GetGametime(),24)<GetData("Donkeytime")) do
	  local wesen = SimGetProfession("")
		
		if not HasProperty("","ZielOrt") then
			local i = ScenarioGetObjects("Settlement",15,"KontorStadt")
			local reiseZiel = {}
			local u = 0
			for k=0,i-1 do
				if AliasExists("KontorStadt"..k) == true then
					if not CityIsKontor("KontorStadt"..k) or CityGetRandomBuilding("KontorStadt"..k, -1, GL_BUILDING_TYPE_KONTOR, -1, -1, FILTER_IGNORE, "kontor") and not BuildingGetWaterPos("kontor", true, "WaterPos") then
						u = u + 1
						reiseZiel[u] = "KontorStadt"..k
					end
				end
			end	
			if u == 1 then
				return
			end
		
	    local wahl = (Rand(u)+1)
      local reise = reiseZiel[wahl]
	    CityGetRandomBuilding(reise, 5, -1, -1, -1, FILTER_IGNORE, "marktplatz")
			local zielID = GetID("marktplatz")
			SetProperty("","ZielOrt",zielID)
		end
		
		if wesen == 63 then
			std_donkeyteam_Esel()
		else
			std_donkeyteam_Eseltreiber()
		end
			
		Sleep(2)
	end
end

function Eseltreiber()
	if not AliasExists("#Packo") then
		worldambient_CreateTeamDonkey("")
		GetPosition("#Packo", "PackoPos")
		SimBeamMeUp("","PackoPos", false)
	end

  CarryObject("","Handheld_Device/ANIM_wood_rod.nif", false)

while (math.mod(GetGametime(),24)<GetData("Donkeytime")) do
		if not f_Follow("","#Packo", GL_MOVESPEED_WALK,50,true) then
			GetPosition("#Packo", "PackoPos")
			SimBeamMeUp("","PackoPos", false)
		end
		
	  local schimpfe = Rand(6)
		AlignTo("","#Packo")
		local noise = Rand(10)
		if noise <= 2 then
			PlaySound3DVariation("","Animals/donkey",1.0)
		end
		
    if schimpfe == 0 then
	    MsgSayNoWait("","@L_WORLDAMBIENT_DONKEYCHEF_TEXT_+1")
	    PlayAnimationNoWait("","attack_middle")
		Sleep(0.5)
	    PlaySound3DVariation("","ambient/HorseWhip",1.0)
    elseif schimpfe == 1 then
      PlayAnimationNoWait("","propel")
	    MsgSay("","@L_WORLDAMBIENT_DONKEYCHEF_TEXT_+2")
    elseif schimpfe == 2 then
      PlayAnimationNoWait("","propel")
	    MsgSay("","@L_WORLDAMBIENT_DONKEYCHEF_TEXT_+3")
		elseif schimpfe == 3 then
	    PlayAnimationNoWait("","propel")
		  MsgSay("","@L_WORLDAMBIENT_DONKEYCHEF_TEXT_+4")
		elseif schimpfe == 4 then
	    PlayAnimationNoWait("","propel")
		  MsgSay("","@L_WORLDAMBIENT_DONKEYCHEF_TEXT_+5")
		else
	    if Rand(5) == 1 and not HasProperty("#Packo","Tempo") then
	    	AlignTo("","#Packo")
        MsgSayNoWait("","@L_WORLDAMBIENT_DONKEYCHEF_TEXT_+0")
        PlayAnimationNoWait("","attack_middle")
		    Sleep(0.5)
	      PlaySound3DVariation("","ambient/HorseWhip",1.0)
		    SetProperty("#Packo","Tempo",1)
	    else
        MsgSayNoWait("","@L_WORLDAMBIENT_DONKEYCHEF_TEXT_+6")
        PlayAnimationNoWait("","attack_middle")
		    Sleep(0.5)
	      PlaySound3DVariation("","ambient/HorseWhip",1.0)
			end
	  end			

		if HasProperty("#Packo","WarteHier") then
			MoveSetStance("",GL_STANCE_SITGROUND)
		  while HasProperty("#Packo","WarteHier") do
				Sleep(5)
			end
			MoveSetStance("",GL_STANCE_STAND)
		end
		Sleep(0.3)
	end
	
	StopMeasure()

end

function Esel()

	if not AliasExists("#Eseltreiber") then
		worldambient_CreateTeamDonkey("")
		GetPosition("#Eseltreiber", "EseltreiberPos")
		SimBeamMeUp("","EseltreiberPos", false)
	end
while (math.mod(GetGametime(),24)<GetData("Donkeytime")) do
  GetAliasByID(GetProperty("#Packo","ZielOrt"),"WartePos")
	local abstand = GetDistance("","WartePos")
	local stand
  if not f_MoveToNoWait("","WartePos", GL_MOVESPEED_SNEAK,200) then
		f_WeakMoveToNoWait("","WartePos", GL_MOVESPEED_SNEAK,200)
		-- GetEvadePosition("",500,"RichtPos")
	    -- SimBeamMeUp("","RichtPos",false)
	    -- return
	end
	while (abstand > 230)  do
	  stand = GetDistance("","WartePos")
		LoopAnimation("","donkey_walk",1,1)
		if  HasProperty("","Tempo") then
		  local zahler = 0
			if not f_MoveToNoWait("","WartePos", GL_MOVESPEED_WALK,200) then
		    -- GetEvadePosition("",500,"RichtPos")
			  -- SimBeamMeUp("","RichtPos",false)
				f_WeakMoveToNoWait("","WartePos", GL_MOVESPEED_WALK,200)
			  --return
			end
			while zahler < 8 and abstand > 500 do
			  LoopAnimation("","donkey_run",1,1)
				zahler = zahler + 1
				abstand = GetDistance("","WartePos")
			end
			MoveStop("")
			StopAnimation("")
			RemoveProperty("","Tempo")
			RemoveProperty("","ZielOrt")
			return
		end
		abstand = GetDistance("","WartePos")
		if abstand == stand then
			MoveStop("")
		  -- GetEvadePosition("",500,"RichtPos")
			-- SimBeamMeUp("","RichtPos",false)
		  if not f_WeakMoveTo("","WartePos", GL_MOVESPEED_WALK,50) then
				return
			end
			StopAnimation("")
			RemoveProperty("","ZielOrt")
			return
		end
	end						

	SetProperty("","WarteHier",1)
	MoveStop("")
	LoopAnimation("","donkey_idle_01",20,1)
	RemoveProperty("","ZielOrt")
	RemoveProperty("","WarteHier")
	
	if math.mod(GetGametime(),24)<GetData("Donkeytime") then
		StopMeasure()
	else
		return
	end
	
	end
end

function CleanUp()
	SetState("#Packo", STATE_LOCKED, false)
	SetState("#Eseltreiber", STATE_LOCKED, false)
	SimSetBehavior("#Packo","")
	SimSetBehavior("#Eseltreiber","")
	InternalDie("#Packo")
	InternalDie("#Eseltreiber")
	InternalRemove("#Packo")
	InternalRemove("#Eseltreiber")
end
