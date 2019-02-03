-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_GetDivorced"
----
----	with this measure the player can divorce from the spouse
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	
	-- Get the spouse
	if not SimGetSpouse("", "Spouse") then
		StopMeasure()
		return
	end

	-- Perhaps the spouse is just following me
	if HasProperty("Spouse", "Follows") then
		if GetID("") == GetProperty("Spouse", "Follows") then
			SimStopMeasure("Spouse")
		end
	end	
	
	-- Go to the spouse
	if not ai_StartInteraction("", "Spouse", 800, 128) then
		StopMeasure()
		return false
	end

	----------
	-- Divorce
	----------
	
	local Wealth = SimGetWealth("")
	local LooseMoney = math.ceil(Wealth*0.05)
	
	local result = MsgNews("",0, "@B[A, @L_REPLACEMENTS_BUTTONS_JA]@B[C, @L_REPLACEMENTS_BUTTONS_NEIN]@P",  ms_GetDivorced_AI, "default", -1,"@L_GENERAL_MEASURES_GETDIVORCED_HEAD_+0","@L_GENERAL_MEASURES_GETDIVORCED_BODY_+0",GetID("Spouse"),LooseMoney)
	
	if (result ~= "A") then
		return false
	end
	
	
	MsgSay("", "@L_FAMILY_5_DIVORCE_TALK_1", GetID("Spouse"))
	MsgSay("Spouse", "@L_FAMILY_5_DIVORCE_TALK_2")
	MsgSay("", "@L_FAMILY_5_DIVORCE_TALK_3")	
	
	
	
	-- Massive favor loss from the ex-spouse
	local FavorLossPercent = GL_PERCENT_FAVOR_LOSS_AFTER_DIVORCE
	local CurrentFavor = GetFavorToSim("Spouse", "")
	local Factor = (100 - FavorLossPercent) * 0.01
	SetFavorToSim("Spouse", "", Factor * CurrentFavor)
	
	-- Weiter muss dem Geschiedenen eine Abfindung gezahlt werden
	f_SpendMoney("", LooseMoney, "CostAdministration",true)
		
	-- Ex-spouse leaves the building
	f_ExitCurrentBuilding("Spouse")

	SimGetDivorced("", "Spouse")
	
	StopMeasure()
	
end



function ms_GetDivorced_AI()
	return "A"
end


