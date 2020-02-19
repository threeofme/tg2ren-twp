function Run()
	local RatBoyFilter = "__F( (Object.GetObjectsByRadius(Sim)==3000)AND(Object.HasProperty(ImYourDestiny)))"
	local NumRatBoys = Find("",RatBoyFilter,"RatBoy",-1)
	if NumRatBoys>0 then
		f_FollowNoWait("","RatBoy",GL_MOVESPEED_RUN,Rand(200)+200,false,false)
	end
	
	while AliasExists("RatBoy") and HasProperty("RatBoy","ImYourDestiny") do
		if HasProperty("RatBoy","LetsGo") then
			-- move to the map exit
			GetOutdoorLocator("MapExit1",1,"MapExit")
			if not AliasExists("MapExit") then
				GetOutdoorLocator("MapExit2",1,"MapExit")
				if not AliasExists("MapExit") then
					GetOutdoorLocator("MapExit3",1,"MapExit")
					if not AliasExists("MapExit") then
						break
					end
				end
			end
			
			-- check if RatBoy still is alive before we go
			if not AliasExists("RatBoy") then
				break
			end
			
			f_MoveTo("","MapExit",GL_MOVESPEED_WALK)
			
			-- check if RatBoy still is alive after we reached our destination
			if not AliasExists("RatBoy") then
				break
			end
			
			-- kill the poor children if the time has come
			if HasProperty("RatBoy","KillingTime") then
				local Age = SimGetAge("")
				local SettlementId = GetSettlementID("")
				feedback_MessageCharacter("", "@L_FAMILY_6_DEATH_MSG_DEAD_OWNER_HEAD", "@L_FAMILY_6_DEATH_MSG_DEAD_OWNER_BODY_MALE", GetID(""), Age, SettlementId)
				log_death("", " was killed by the ratboy. (ms_FollowRatBoy)")				
				ModifyHP("",-GetMaxHP(""))
			end
		end
		Sleep(2)
	end
end

function CleanUp()
end

