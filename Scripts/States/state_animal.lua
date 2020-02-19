function Init()
	SetStateImpact("no_idle")
	SetStateImpact("no_hire")
	SetStateImpact("no_control")
	SetStateImpact("no_attackable")
	SetStateImpact("no_measure_start")
	SetStateImpact("no_measure_attach")
	SetStateImpact("no_action")
	SetStateImpact("no_cancel_button")
	SetStateImpact("NoCameraJump")
end

function Run()
	SimSetMortal("", false)

	local TierArt = SimGetProfession("")
	if TierArt == 43 then
		SetData("Art","dog")
		state_animal_HausVieh()
	elseif TierArt == 44 then
		SetData("Art","cat")
		state_animal_HausVieh()
	elseif TierArt == 45 then
		SetData("Art","chicken")
		state_animal_KleinVieh()
	elseif TierArt == 46 then
		SetData("Art","cock")
		state_animal_KleinVieh()
	elseif TierArt == 47 then
		SetData("Art","duck")
		state_animal_KleinVieh()
	elseif TierArt == 48 then
		SetData("Art","goose")
		state_animal_KleinVieh()
	elseif TierArt == 49 then
		SetData("Art","wolf")
		state_animal_WaldVieh()
	elseif TierArt == 50 then
		SetData("Art","deer")
		state_animal_WaldVieh()
	elseif TierArt == 51 then
		SetData("Art","Stag")
		state_animal_WaldVieh()
	elseif TierArt == 55 then
		SetData("Art","Sheep")
		state_animal_PflegeVieh()
	elseif TierArt == 57 then
		SetData("Art","Cow")
		state_animal_PflegeVieh()
	elseif TierArt == 58 then
		SetData("Art","Pig")
		state_animal_PflegeVieh()
	end
end
	
function PflegeVieh()
	local dasTier = GetData("Art")
	local range = 315
	
	GetPosition("","TierPosX")
	GetPosition("","TierPosY")	
	
	while true do
		GetPosition("TierPosY","TierPosX")
		local x,y,z = PositionGetVector("TierPosX")
		x = x + ((Rand(range)*2)-range)
		z = z + ((Rand(range)*2)-range)
		PositionModify("TierPosX",x,y,z)
		SetPosition("TierPosX",x,y,z)
		
		local abstand = GetDistance("Owner","TierPosX")
		local abstand2
		
		if f_MoveToNoWait("","TierPosX",GL_MOVESPEED_SNEAK,50) then
			while abstand > 40 do
				abstand2 = GetDistance("Owner","TierPosX")
				LoopAnimation("",""..dasTier.."_walk",1,1)
				abstand = GetDistance("Owner","TierPosX")
				if abstand == abstand2 then
					break
				end
			end
		end
		
		local idleArt = Rand(4)
		local idleWart = Rand(20)+5
		if idleArt == 0 then
			-- weiter gehts
		elseif idleArt == 1 then
			LoopAnimation("",""..dasTier.."_idle_01",idleWart,1)
			PlayAnimation("",""..dasTier.."_idle_02",1)
		elseif idleArt == 2 then
			LoopAnimation("",""..dasTier.."_idle_01",idleWart,1)
		elseif idleArt == 3 then
			PlayAnimation("",""..dasTier.."_idle_02",1)
		end
		
		if Rand(6) == 4 then
			if dasTier == "Sheep" then
				PlaySound3DVariation("","Locations/sheep_baa",1.0)
			elseif dasTier == "Pig" then
				PlaySound3DVariation("","Locations/pigs_grunt",1.0)
			elseif dasTier == "Cow" then
				PlaySound3DVariation("","Locations/cow_low",1.0)
			end
		end
		Sleep(10 + Rand(10))
	end
	RemoveAlias("TierPosX")
	Sleep(25)
end

function WaldVieh()
  local dasTier = GetData("Art")
	GetPosition("","StartPlatz")
	local range = 1000		
  
  while true do
	  GetPosition("StartPlatz","GehHin")
    local x,y,z = PositionGetVector("GehHin")
    x = x + ((Rand(range)*2)-range)
    z = z + ((Rand(range)*2)-range)
    PositionModify("GehHin",x,y,z)
	  SetPosition("GehHin",x,y,z)
		local moveArt = Rand(3)
    local abstand = GetDistance("Owner","GehHin")
    local abstand2
			
		if moveArt == 1 then
	    if f_MoveToNoWait("","GehHin",GL_MOVESPEED_RUN) then
	      while abstand > 100 do
		      abstand2 = GetDistance("Owner","GehHin")
		      LoopAnimation("",""..dasTier.."_run",1,1)
		      abstand = GetDistance("Owner","GehHin")
		      if abstand == abstand2 then
		        break
		      end
	      end
			end
		else
		  if f_MoveToNoWait("","GehHin",GL_MOVESPEED_WALK) then
		    while abstand > 100 do
		      abstand2 = GetDistance("Owner","GehHin")
		      LoopAnimation("",""..dasTier.."_walk",1,1)
		      abstand = GetDistance("Owner","GehHin")
		      if abstand == abstand2 then
		        break
		      end
		    end
			end
		end

    local idleArt = Rand(4)
    local idleWart = Rand(12)+6
		local heulZeit = math.mod(GetGametime(),24)
		if heulZeit > 22 and heulZeit < 24 or heulZeit > 0 and heulZeit < 4 then
			if Rand(3) == 0 then
		 		PlaySound3DVariation("","ambient/wolf_howl",1.0)
			end
		end
    if idleArt == 0 then
      -- weiter gehts
    elseif idleArt == 1 then
      LoopAnimation("",""..dasTier.."_idle_01",idleWart,1)
      PlayAnimation("",""..dasTier.."_idle_02",1)
    elseif idleArt == 2 then
      LoopAnimation("",""..dasTier.."_idle_01",idleWart,1)
    elseif idleArt == 3 then
      PlayAnimation("",""..dasTier.."_idle_02",1)
    end
    RemoveAlias("GehHin")
		Sleep(10+Rand(6))
	end
end

function KleinVieh()
  local dasTier = GetData("Art")
	local range = 500
	if dasTier == "duck" then
		range = 200
	elseif dasTier == "goose" then
		range = 400
  end
	
	GetPosition("","TierPosX")
	GetPosition("","TierPosY")	
	
	while true do	
		GetPosition("TierPosY","TierPosX")
    local x,y,z = PositionGetVector("TierPosX")
    x = x + ((Rand(range)*2)-range)
    z = z + ((Rand(range)*2)-range)
    PositionModify("TierPosX",x,y,z)
    SetPosition("TierPosX",x,y,z)

    local abstand = GetDistance("Owner","TierPosX")
    local abstand2

    if f_MoveToNoWait("","TierPosX",GL_MOVESPEED_SNEAK) then
	    while abstand > 100 do
	    	abstand2 = GetDistance("Owner","TierPosX")
				LoopAnimation("",""..dasTier.."_walk",1,1)
				abstand = GetDistance("Owner","TierPosX")
				if abstand == abstand2 then
					break
				end
			end
	
	    local idleArt = Rand(3)
	    local idleWart = Rand(10)+5
	
	    if idleArt == 0 then
	      -- weiter gehts
	    elseif idleArt == 1 then
	      LoopAnimation("",""..dasTier.."_idle_01",idleWart,1)
	    elseif idleArt == 2 then
	      LoopAnimation("",""..dasTier.."_idle_01",idleWart,1)
	    end
	
	    if Rand(5) == 4 then
		    if dasTier == "duck" then
		       PlaySound3DVariation("","Animals/duck",1.0)
		    elseif dasTier == "chicken" then
		       PlaySound3DVariation("","Animals/hen",1.0)
		    elseif dasTier == "cock" then
		      local morgen = math.mod(GetGametime(),24)
		      if morgen >= 5 and morgen <= 9 then
		      	PlaySound3DVariation("","Animals/rooster",1.0)
		      end
	      end
	    end
		  RemoveAlias("GehHin")
			Sleep(5+Rand(10))
		end
	end
end

function HausVieh()
  local firstTime = 1
  local dasTier = GetData("Art")
	GetSettlement("","AnimalTown")
	while true do
  	local offset = math.mod(GetID("Owner"), 30) * 0.1
	  local class
	  if GetNearestSettlement("","AnimalTown") then
	    local	RandVal = Rand(7)
	    if RandVal<2 then
	      if firstTime == 2 then
		      class = GL_BUILDING_CLASS_MARKET
		    else
		      class = GL_BUILDING_CLASS_WORKSHOP
		      firstTime = 2
		    end
	    elseif RandVal<4 then
		    class = GL_BUILDING_CLASS_PUBLIC
	    else
		    class = GL_BUILDING_CLASS_WORKSHOP
	    end
		
		  if CityGetRandomBuilding("AnimalTown", class, -1, -1, -1, FILTER_IGNORE, "Destination") then
				if GetOutdoorMovePosition("", "Destination", "MoveToPosition") then
			  	local moveArt = Rand(5)
				  local abstand = GetDistance("Owner","MoveToPosition")
					local abstand2
				  if moveArt <= 3 then
						if dasTier == "cat" then -- Katzen Extra
				    	f_MoveToNoWait("","MoveToPosition", GL_MOVESPEED_SNEAK, 400+offset*15) -- Katzen Extra
					  else -- Katzen Extra
				      f_MoveToNoWait("","MoveToPosition", GL_MOVESPEED_WALK, 400+offset*15)
					  end -- Katzen Extra
					  
					  while abstand > 400+offset*15+100 do
							abstand2 = GetDistance("Owner","MoveToPosition")
				   	  LoopAnimation("",""..dasTier.."_walk",1,1)
					    abstand = GetDistance("Owner","MoveToPosition")
							if abstand == abstand2 then
				      	break
				      end
					  end
				    
				  else
				    if dasTier == "cat" then -- Katzen Extra
				    	f_MoveToNoWait("","MoveToPosition", GL_MOVESPEED_WALK, 400+offset*15) -- Katzen Extra
				    else -- Katzen Extra
			        f_MoveToNoWait("","MoveToPosition", GL_MOVESPEED_RUN, 400+offset*15)
				    end -- Katzen Extra
				    
				    while abstand > 400+offset*15+100 do
					    abstand2 = GetDistance("Owner","MoveToPosition")
			   	    LoopAnimation("",""..dasTier.."_run",1,1)
					    abstand = GetDistance("Owner","MoveToPosition")
							if abstand == abstand2 then
			        	break
			        end
				    end
			    end
			  end
		  end
	    local idleArt = Rand(4)
	    local idleWart = Rand(10)+5
	    if idleArt == 0 then
	    -- weiter gehts
	    elseif idleArt == 1 then
		    LoopAnimation("",""..dasTier.."_idle_01",idleWart,1)
		    PlayAnimation("",""..dasTier.."_idle_02",1)
	    elseif idleArt == 2 then
	      LoopAnimation("",""..dasTier.."_idle_01",idleWart,1)
	    elseif idleArt == 3 then
	      PlayAnimation("",""..dasTier.."_idle_02",1)
	    end
	    
	    if dasTier == "dog" then
				PlaySound3DVariation("","ambient/dog_bark",1.0)
	    end
         
      if dasTier == "cat" and Rand(3) == 1 then
 				PlaySound3DVariation("","Animals/cat",1.0)
			end
	  end
		Sleep(12)
  end
end

function CleanUp()

	  InternalDie("")
	  InternalRemove("")
	
end
