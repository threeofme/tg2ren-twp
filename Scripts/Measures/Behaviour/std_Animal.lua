function Init()
end

function Run()
	SetState("",STATE_ANIMAL,true)

  local TierArt = SimGetProfession("")
	if TierArt == 43 then
    SetData("Art","dog")
    std_animal_HausVieh()
	elseif TierArt == 44 then
    SetData("Art","cat")
    std_animal_HausVieh()
	elseif TierArt == 45 then
    SetData("Art","chicken")
    std_animal_HofVieh()
	elseif TierArt == 46 then
    SetData("Art","cock")
    std_animal_HofVieh()
	elseif TierArt == 47 then
	  SetData("Art","duck")
		std_animal_KleinVieh()
	elseif TierArt == 48 then
	  SetData("Art","goose")
		std_animal_KleinVieh()
	elseif TierArt == 49 then
	  SetData("Art","wolf")
		std_animal_WaldVieh()
	elseif TierArt == 50 then
	  SetData("Art","deer")
		std_animal_WaldVieh()
	elseif TierArt == 51 then
	  SetData("Art","Stag")
		std_animal_WaldVieh()
	elseif TierArt == 55 then
	  SetData("Art","Sheep")
		std_animal_PflegeVieh()
	elseif TierArt == 57 then
	  SetData("Art","Cow")
		std_animal_PflegeVieh()
	elseif TierArt == 58 then
	  SetData("Art","Pig")
		std_animal_PflegeVieh()
	end
end
	
function PflegeVieh()
  local dasTier = GetData("Art")
	local range = 300
	
  GetPosition("","TierPosX")
	GetPosition("","TierPosY")	
	
  while GetImpactValue("",380)==1 do

    GetPosition("TierPosY","TierPosX")
    local x,y,z = PositionGetVector("TierPosX")
    x = x + ((Rand(range)*2)-range)
    z = z + ((Rand(range)*2)-range)
    PositionModify("TierPosX",x,y,z)
		SetPosition("TierPosX",x,y,z)
		local abstand = GetDistance("Owner","TierPosX")
		local abstand2
		f_MoveToNoWait("","TierPosX",GL_MOVESPEED_SNEAK)				
		while abstand > 40 do
		  abstand2 = GetDistance("Owner","TierPosX")
			LoopAnimation("",""..dasTier.."_walk",1,1)
			abstand = GetDistance("Owner","TierPosX")
			if abstand == abstand2 then
				break
			end
		end
	
    local idleArt = Rand(4)
    local idleWart = Rand(14)+5
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
		if Rand(5) == 4 then
	    if dasTier == "Sheep" then
	      PlaySound3DVariation("","Locations/sheep_baa",1.0)
	    elseif dasTier == "Pig" then
	      PlaySound3DVariation("","Locations/pigs_grunt",1.0)
	    elseif dasTier == "Cow" then
	      PlaySound3DVariation("","Locations/cow_low",1.0)
	    end
		end
	end
	RemoveAlias("TierPosX")
	
end

function WaldVieh()
	local dasTier = GetData("Art")
	GetPosition("","StartPlatz")
	local range = 1000		
	while true do
  
		-- look for humans
		local NumOfObjects = 0
		local moveArt = Rand(3)
		local x,y,z

		if SimGetProfession("")==49 then
			NumOfObjects = Find("","__F( (Object.GetObjectsByRadius(Sim)==100) AND NOT((Object.GetProfession() == 44)OR (Object.GetProfession() == 45)OR (Object.GetProfession() == 46)OR (Object.GetProfession() == 47)OR (Object.GetProfession() == 48)OR (Object.GetProfession() == 49)OR (Object.GetProfession() == 50)OR (Object.GetProfession() == 51)OR (Object.GetProfession() == 55)OR (Object.GetProfession() == 57)OR (Object.GetProfession() == 58)))","Sims",-1)
		else
			NumOfObjects = Find("","__F( (Object.GetObjectsByRadius(Sim)==100) AND NOT((Object.GetProfession() == 44)OR (Object.GetProfession() == 45)OR (Object.GetProfession() == 46)OR (Object.GetProfession() == 47)OR (Object.GetProfession() == 48)OR (Object.GetProfession() == 50)OR (Object.GetProfession() == 51)OR (Object.GetProfession() == 55)OR (Object.GetProfession() == 57)OR (Object.GetProfession() == 58)))","Sims",-1)
		end
	
		if NumOfObjects > 0 then
			GetFleePosition("", "Sims"..0, Rand(range)+250, "GehHin")
			x,y,z = PositionGetVector("GehHin")
			moveArt = 1
		else
			GetPosition("StartPlatz","GehHin")
			x,y,z = PositionGetVector("GehHin")
			x = x + ((Rand(range)*2)-range)
			z = z + ((Rand(range)*2)-range)
		end
	  
		PositionModify("GehHin",x,y,z)
		SetPosition("GehHin",x,y,z)
		local abstand = GetDistance("Owner","GehHin")
		local abstand2
		if moveArt == 1 then
			f_MoveToNoWait("","GehHin",GL_MOVESPEED_RUN)				
			while abstand > 100 do
				abstand2 = GetDistance("Owner","GehHin")
				LoopAnimation("",""..dasTier.."_run",1,1)
				abstand = GetDistance("Owner","GehHin")
				if abstand == abstand2 then
					break
				end
			end
		else
			f_MoveToNoWait("","GehHin",GL_MOVESPEED_WALK)				
			while abstand > 100 do
				abstand2 = GetDistance("Owner","GehHin")
				LoopAnimation("",""..dasTier.."_walk",1,1)
				abstand = GetDistance("Owner","GehHin")
				if abstand == abstand2 then
					break
				end
			end
		end

		local idleArt = Rand(4)
		local idleWart = Rand(10)+5
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
		Sleep(5)
	end
end

function HofVieh()
  local dasTier = GetData("Art")
	local range = 600
	GetNearestSettlement("","AnimalTown")
	CityGetNearestBuilding("AnimalTown","",2,3,-1,-1,FILTER_IGNORE,"TierPosY")
	
  while GetImpactValue("TierPosY",380)==1 do
  	GetPosition("TierPosY","TierPosX")
    local x,y,z = PositionGetVector("TierPosX")
    x = x + ((Rand(range)*2)-range)
    z = z + ((Rand(range)*2)-range)
    PositionModify("TierPosX",x,y,z)
    SetPosition("TierPosX",x,y,z)
    local abstand = GetDistance("Owner","TierPosX")
    local abstand2
    f_MoveToNoWait("","TierPosX",GL_MOVESPEED_SNEAK)				
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
    RemoveAlias("GehHin")
	end
end

function KleinVieh()
	local dasTier = GetData("Art")
	local range
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
		        f_MoveToNoWait("","TierPosX",GL_MOVESPEED_SNEAK)				
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
	            RemoveAlias("GehHin")
				Sleep(2)
			end
end

function HausVieh()
    local firstTime = 1
    local dasTier = GetData("Art")
	GetSettlement("","AnimalTown")
	while true do
        local offset 	= math.mod(GetID("Owner"), 30) * 0.1
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
		        PlaySound3D("","ambient/dog_growl/dog_bark_+0",1.0)
		    end			
	    end
		Sleep(5)
    end
end

function CleanUp()

  --local CleanVieh = GetData("Art")
	--if CleanVieh == "chicken" or CleanVieh == "cock" then
	  InternalDie("")
	  InternalRemove("")
	--end
	
end
