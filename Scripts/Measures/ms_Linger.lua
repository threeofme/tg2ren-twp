function Run()

	local Cure = (GetHPRelative("") < 0.96)

	if not AliasExists("Destination") then
		local Filter = "__F((Object.GetObjectsByRadius(Building) == 410) AND (Object.IsType(32)))"
		local result = Find("", Filter,"Destination", -1)
		if result <= 0 then
			return 
		end
	end
	if GetFreeLocatorByName("Destination","idle_Sit",1,5,"SitPos") then
		f_BeginUseLocator("","SitPos",GL_STANCE_SITBENCH,true)
		if GetLocatorByName("Destination","campfire","CampFirePos") then
			if GetImpactValue("Destination","torch")==0 then
				AddImpact("Destination","torch",1,1)
				GfxStartParticle("Campfire","particles/Campfire2.nif","CampFirePos",3)
				--GfxStartParticle("Camplight","Lights/candle_M_01.nif","CampFirePos",6)		
			end
		end
	elseif GetFreeLocatorByName("Destination","idle_SitGround",1,5,"SitPos") then
		f_BeginUseLocator("","SitPos",GL_STANCE_SITGROUND,true)
	elseif GetFreeLocatorByName("Destination","idle_Stand",1,5,"SitPos") then
		f_BeginUseLocator("","SitPos",GL_STANCE_STAND,true)
	end
	local HPGain = 0.01 * GetMaxHP("")
	if HPGain < 1 then
		HPGain = 1
	end
	while true do
		if GetHP("") < GetMaxHP("") then
			if SimGetProfession("")==GL_PROFESSION_CITYGUARD or SimGetProfession("")==GL_PROFESSION_ELITEGUARD then
				ModifyHP("", 50,false)
				if GetHP("") >= GetMaxHP("") then
					break
				end
			else
				ModifyHP("", HPGain,false)
				if Cure and GetHP("") >= GetMaxHP("") then
					break
				end
			end
		elseif not IsPartyMember("") then
			StopMeasure()
		end
		Sleep(5)
	end
end

function CleanUp()
	if AliasExists("SitPos") then
		f_EndUseLocator("","SitPos",GL_STANCE_STAND)
	end
end


