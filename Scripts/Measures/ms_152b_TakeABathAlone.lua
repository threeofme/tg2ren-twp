-- -----------------------
-- Run
-- -----------------------
function Run()

	if IsStateDriven() then
		local ItemName = "Phiole"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
		
		if not f_MoveTo("", "Destination", GL_MOVESPEED_RUN) then
			return
		end
		
		if GetInsideBuilding("", "Tavern") then
			if not (GetID("Destination")==GetID("Tavern")) then
				StopMeasure()
			end
		else
			StopMeasure()
		end
	end

	-- hier muss noch der Preis anhand der Taverne und dem Sozialstatus des sims berechnet werden
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	local OverallPrice = 350
	
	-- Stop a possibly following courtlover from following
	if SimGetCourtLover("", "CourtLover") then
		chr_StopFollowing("CourtLover", "")
	end
	
	local Money = GetMoney("")
	if Money < OverallPrice then
		MsgBox("", "", "","@L_GENERAL_ERROR_HEAD_+0", "@L_TAVERN_152_TAKEABATH_FAILURES_+1", OverallPrice)
		return false
	end
	
	if not GetInsideBuilding("", "Tavern") then
		return false
	end		
	
	-----------------------------------------
	------ Check bath free and reserve ------
	-----------------------------------------
	if not GetLocatorByName("Tavern", "Bath1", "BathPosition") then
		MsgQuick("", "_TAVERN_152_TAKEABATH_FAILURES_+0", GetID("Tavern"))
		return false
	end
	
	if HasProperty("Tavern", "BathInUse") then
		MsgQuick("", "_TAVERN_152_TAKEABATH_FAILURES_+0", GetID("Tavern"))
		return false
	else
		SetProperty("Tavern", "BathInUse", 1)
	end	

	-- Go to the bath
	f_MoveTo("", "BathPosition")
	if not f_BeginUseLocator("", "BathPosition", GL_STANCE_STAND, true) then
		return false
	end
	
	SetData("Bathing", 1)

	local MaxHP = GetMaxHP("")
	local ToHeal = 0.20 * MaxHP
	local Progress = 0
	
	SetMeasureRepeat(TimeOut)
	
	-- Pay if the tavern does not belong to the owners dynasty
	if GetDynastyID("Tavern") ~= GetDynastyID("") then
		if not SpendMoney("", OverallPrice, "CostSocial") then
			MsgQuick("", "_TAVERN_152_TAKEABATH_FAILURES_+0", GetID("Tavern"))
			return
		end
		CreditMoney("Tavern",OverallPrice,"Offering")
		economy_UpdateBalance("Tavern", "Service", OverallPrice)
	end

	-- Bathing
	GfxStartParticle("Steam", "particles/bath_steam.nif", "BathPosition", 3)
	
	PlaySound3DVariation("", "measures/takeabath_alone", 1)
	Sleep(2)
	
	while(Progress < 5) do
		PlaySound3DVariation("", "measures/takeabath_alone", 1)
		Sleep(1)
		if GetHP("")<MaxHP then
			ModifyHP("", ToHeal)
		end
		Progress = Progress +1
		Sleep(1)
	end
	GfxStopParticle("Steam")
	
	-- Cure cold in case you have phiole
	local PerfumeLevel = 3
	
	if RemoveItems("", "Phiole", 1, INVENTORY_STD)>0 then
	
		if GetImpactValue("","Cold")==1 then
			diseases_Cold("",false)
		end
		
		PerfumeLevel = 5
		
		chr_GainXP("",GetData("BaseXP"))
		
	end
	Sleep(1)
	
	-- Add resist
	if GetImpactValue("","Sickness")==0 then
		AddImpact("","Resist",1,12)
	end
	
	if GetImpactValue("","BadDream")>0 then
		if math.mod(GetGametime(),24)<GetProperty("","BadDreamTime") then
			duration = math.floor(GetProperty("","BadDreamTime")-math.mod(GetGametime(),24))
			AddImpact("","rhetoric",1,duration)
			AddImpact("","craftsmanship",1,duration)
			AddImpact("","charisma",1,duration)
			AddImpact("","constitution",1,duration)
			AddImpact("","dexterity",1,duration)
			AddImpact("","shadow_arts",1,duration)
			AddImpact("","fighting",1,duration)
			AddImpact("","secret_knowledge",1,duration)
			AddImpact("","bargaining",1,duration)
			AddImpact("","empathy",1,duration)
			RemoveImpact("","BadDream")
			RemoveProperty("","BadDreamTime")
		end
	end
	
	-- Perfumemod

	if GetImpactValue("", "perfume") > 0 then
		MsgBox("", "", "", "@L_GENERAL_ERROR_HEAD_+0", "@L_GENERAL_MEASURES_PERFUME_FAILURES_+0", GetID(""))
		StopMeasure()
	else
		AddImpact("", "perfume", 1, 6)
		SetState("", STATE_CONTAMINATED, true)
		SetProperty("", "perfume", PerfumeLevel)
	end
	-- mod end
	
	-- Satisfy the Need
	SatisfyNeed("",2,1)
	
	if GetFreeLocatorByName("Tavern", "Stroll", 1, 5, "EndPos") then
		f_MoveTo("", "EndPos")
	end
end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	if AliasExists("Tavern") then
		RemoveProperty("Tavern", "BathInUse")
	end
	if AliasExists("Steam") then
		GfxStopParticle("Steam")
	end
	StopAnimation("")
end

-- -----------------------
-- GetOSHData
-- -----------------------
function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	OSHSetMeasureCost("@L_INTERFACE_HEADER_+6",350)
end

