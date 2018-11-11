EN_OFFICETYPE_JAILER = 5

function Run()

	if not GetSettlement("", "Settlement") then
		Sleep(10)
		return
	end

	if not CityGetRandomBuilding("Settlement", GL_BUILDING_CLASS_PUBLICBUILDING, GL_BUILDING_TYPE_PRISON, -1, -1, FILTER_IGNORE, "Prison") then
		Sleep(10)
		return
	end

	local Name = ""
	
	if GetOutdoorMovePosition("Owner", "Prison", "MoveToPosition") then
		Name = GetName("MoveToPosition")
		f_MoveTo("","MoveToPosition",GL_MOVESPEED_WALK, 500)
	end
	
	Sleep(10)
	
	while(true) do
	
		if f_ExitCurrentBuilding("Owner","ExitPosition") then
			GetFleePosition("Owner","Prison",500,"FleePos")
			f_MoveTo("Owner","FleePos",GL_MOVESPEED_WALK,120)
			PlayAnimation("Owner","sentinel_idle")
			f_Stroll("",500,10)
		end	
		
		Sleep(5)
		
		if GetLocatorByName("Prison","Stroll1","MoveResult") then
			f_MoveTo("","MoveResult")
			Sleep(2)
			
			local Prisoners = Find("","__F( (Object.GetObjectsByRadius(Sim)==1000)AND(Object.GetState(imprisoned)))", "FindResult",1)
			if Prisoners ~= 0 then
				for i=0,3 do
					if (Rand(2)==0) then
						if GetFreeLocatorByName("Prison","Cell1Door",-1,-1,"Cell1DoorPos") then
							f_BeginUseLocator("","Cell1DoorPos",GL_STANCE_STAND,true)
							Sleep(1)
							PlayAnimation("","sentinel_idle")
							PlayAnimationNoWait("","talk")
							MsgSay("","@L_PRISON_2_GUARD_TALK")
							Sleep(1)
							f_EndUseLocator("","Cell1DoorPos",GL_STANCE_STAND)
						end
					end
					if (Rand(2)==1) then
						if GetFreeLocatorByName("Prison","Cell2Door",-1,-1,"Cell2DoorPos") then
							f_BeginUseLocator("","Cell2DoorPos",GL_STANCE_STAND,true)
							Sleep(1)
							PlayAnimationNoWait("","sentinel_idle")
							Sleep(5)
							MsgSay("","@L_PRISON_2_GUARD_TALK")
							Sleep(1)
							f_EndUseLocator("","Cell2DoorPos",GL_STANCE_STAND)
						end
					end
					if (Rand(3)==2) then
						if GetFreeLocatorByName("Prison","Stand01",-1,-1,"Stand01Pos") then
							f_BeginUseLocator("","Stand01Pos",GL_STANCE_STAND,true)
							Sleep(1)
							PlayAnimationNoWait("","insult_character")
							MsgSay("","@L_PRISON_2_GUARD_VERBAL_AGGRO")
							Sleep(1)
							f_EndUseLocator("","Stand01Pos",GL_STANCE_STAND)
						end
					end
				end
			else
				for i=0,3 do
					if (Rand(2)==0) then
						if GetFreeLocatorByName("Prison","Stroll",-1,-1,"MoveResult") then
							f_BeginUseLocator("","MoveResult",GL_STANCE_STAND,true)
							PlayAnimation("","cogitate")
							PlayAnimationNoWait("","talk")
							MsgSay("","@L_PRISON_2_GUARD_MONOLOGUE")
							Sleep(5)
							f_EndUseLocator("","MoveResult",GL_STANCE_STAND)
						end
					end
					if (Rand(2)==1) then
						if GetFreeLocatorByName("Prison","Chair02",-1,-1,"Chair02Pos") then
							f_BeginUseLocator("","Chair02Pos",GL_STANCE_SIT,true)
							Sleep(1)
							MsgSay("","@L_PRISON_2_GUARD_MONOLOGUE")
							Sleep(10)
							MsgSay("","@L_PRISON_2_GUARD_MONOLOGUE")
							f_EndUseLocator("","Chair02Pos",GL_STANCE_STAND)
						end
					end
				end
			end
			
		end
		Sleep(2)
	end
	
end

function CleanUp()
	ReleaseLocator("")
end

