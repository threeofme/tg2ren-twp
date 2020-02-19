-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_EatBreakfast.lua"
----
----	Original Author: Fajeth
----
----	Eating Breakfast gives you XP, depending on how much items you eat and which rank. Default Cooldown: 6 hours.
---- 	You need to add entries into measures.dbt and MeasureToObject.dbt, text.dbt

----	entries may look like this:
----	measures.dbt:
----	12114        "ms_EatBreakfast.lua"   ""   "EatBreakfast"   35   "hud/buttons/btn_EatBreakfast.tga"   0   14   0   ""   ""   0   0   0   "none"   0   0   |
----
----	text.dbt:
--[[
16523        "_MEASURES_EATBREAKFAST_HEAD+0" "Frühstücken"                    "Eat Breakfast"                         | 
16524        "_MEASURES_EATBREAKFAST_BODY_+0" "Von welcher Qualität soll Euer Frühstück sein?" "Which quality shall your breakfast be?" | 
16525        "_MEASURES_EATBREAKFAST_SCREENPLAY_ACTOR_CHOICE_+0" "Bäuerlich"                          "peasant"                           | 
16526        "_MEASURES_EATBREAKFAST_SCREENPLAY_ACTOR_CHOICE_+1" "Bürgerlich"                          "civic"                           | 
16527        "_MEASURES_EATBREAKFAST_SCREENPLAY_ACTOR_CHOICE_+2" "Adelig"                          "noble"                           | 
16528	 "_MEASURES_EATBREAKFAST_FAIL_+0"                    "Du kannst nur zwischen 4 und 12 Uhr frühstücken!"                    "You can only eat breakfast between 4 and 12 o'clock."  |  
16529	 "_MEASURES_EATBREAKFAST_FAIL_+1"                    "Du hast die benötigten Items nicht im Inventar!"                    "You don't have the needed items in your inventory!"  |  
16530	 "_MEASURES_EATBREAKFAST_SPRUCH_+0"                    "Ohh, Gerstenbrot! Mhm ... ein bisschen hart ..."                    "Ohh, barleybread! Mhm ... It's a bit brawny ..."  |  
16531	 "_MEASURES_EATBREAKFAST_SPRUCH_+1"                    "Ein bisschen Öl darauf tröpfeln ... viel besser!"                    "Let's use some drops of oil ... Much better!"  |  
16532	 "_MEASURES_EATBREAKFAST_SPRUCH_+2"                    "Saft? Wunderbar!"                    "Juice? Great!"  |  
16533	 "_MEASURES_EATBREAKFAST_SPRUCH_+3"                    "Diesen Weizenbrot schmiegt sich ganz wunderbar an meinen Gaumen!"                    "This wheatbread huddles against my palate quite nicely!"  |  
16534	 "_MEASURES_EATBREAKFAST_SPRUCH_+4"                    "Käsetoast!"                    "Toast with cheese!"  |  
16535	 "_MEASURES_EATBREAKFAST_SPRUCH_+5"                    "Milch macht groß und stark!"                    "Milk makes you tall and strong!"  |  
16536	 "_MEASURES_EATBREAKFAST_SPRUCH_+6"                    "Weizenbrötchen! Ein Traum!"                    "This bread roll is like a dream!"  | 
16537	 "_MEASURES_EATBREAKFAST_SPRUCH_+7"                    "Ein schönes Stückchen Wurst ist dazu genau das Richtige."                    "A piece of this sausage is exactly what I need."  | 
16538	 "_MEASURES_EATBREAKFAST_SPRUCH_+8"                    "Zum Abschluss ein kräftiger Schluck Kräutertee, das hält gesund."                    "Finally, a mouthful of hearb tea, this keeps healthy."  | 
16539	 "_MEASURES_EATBREAKFAST_MSG_HEAD_+0"                    "Perfektes Frühstück"                    "Perfect Breakfast"  | 
16540	 "_MEASURES_EATBREAKFAST_MSG_BODY_+0"                    "Du hast ein ganz außergewöhnliches Frühstück zu dir genommen, gut gemacht!"                    "You ate an extrordinary breakfast, well done!"  | 
16541	 "_MEASURE_EatBreakfast_NAME_+0"                    "Frühstücken"                    "Eat Breakfast"   |
16542	 "_MEASURE_EatBreakfast_TOOLTIP_+0"                    "Ein gesundes und vollwertiges Frühstück lässt dich wachsen. Je höher dein Titel ist, desto orpulentere Mahlzeiten darfst du zu dir nehmen.$N$NEin Frühstück besteht aus einer Grundlage (Gerstenbrot, Weizenbrot, Weizenbrötchen), einer Beilage (Pflanzenöl, Käse, Wurst) und einem Getränk (Saft, Milch, Kräutertee)$N$NFür diese Maßnahme erhaltet Ihr Erfahrungspunkte."                    "Eating a healthy breakfast makes you grow. The higher your nobility title the better you may want to banquet.$N$NFor breakfast you need a basis (Barley Bread, Wheat Bread, Bread Roll), a side dish (Oil, Cheese, Sausage) and something for a drink (Juice, Milk, Herb Tea). $N$NFor this measure you get experience points."   |
16566	 "_MEASURES_EATBREAKFAST_SPRUCH_+9"                    "Ein knackiger Apfel ist da doch genau das Richtige"                    "A fresh and crisp apple is the right thing now."  | 

]]--
----
----	MeasureToObjects.dbt:
----	3264         12114               0                       0                      1523                   6                ""                     ()                 ""                      0                           0                              |
-------------------------------------------------------------------------------

function Run()

local MeasureID = GetCurrentMeasureID("")
local TimeOut = mdata_GetTimeOut(MeasureID)
local rank = GetNobilityTitle("")
local time = math.mod(GetGametime(),24)
local xp = 0
	
if (time >10) or (time <4) then
MsgQuick("","@L_MEASURES_EATBREAKFAST_FAIL_+0")
StopMeasure()
else

	local Button1 = "@B[1,@L_MEASURES_EATBREAKFAST_SCREENPLAY_ACTOR_CHOICE_+0,@L_MEASURES_EATBREAKFAST_SCREENPLAY_ACTOR_CHOICE_+0,Hud/Items/item_BarleyBread.tga]"
	local Button2 = "@B[2,@L_MEASURES_EATBREAKFAST_SCREENPLAY_ACTOR_CHOICE_+1,@L_MEASURES_EATBREAKFAST_SCREENPLAY_ACTOR_CHOICE_+1,Hud/Items/item_WheatBread.tga]"
	local Button3 = "@B[3,@L_MEASURES_EATBREAKFAST_SCREENPLAY_ACTOR_CHOICE_+2,@L_MEASURES_EATBREAKFAST_SCREENPLAY_ACTOR_CHOICE_+2,Hud/Items/item_BreadRoll.tga]"
	-- Only show buttons if Sim has a high title
	if rank <4 then
	Button2 = ""
	Button3 = ""
	elseif rank <6 then
	Button3 = ""
	end
	
	local result
	result = InitData("@P"..Button1..Button2..Button3,"@L_MEASURES_EATBREAKFAST_HEAD_+0","@L_MEASURES_EATBREAKFAST_BODY_+0")
		
		if result==1 then
		SetData("Wahl",1)
		elseif result==2 then
		SetData("Wahl",2)
		elseif result==3 then
		SetData("Wahl",3)
		end
	
	local wahl = GetData("Wahl")
	
if wahl == 1 then --peasant
	local Item1 = "Saft"
	local Item2 = "WheatBread"
	local Item3 = "Oil"
	local Item4 = "Fruit"
	if GetItemCount("", Item2, INVENTORY_STD)==0 then
	MsgQuick("","@L_MEASURES_EATBREAKFAST_FAIL_+1")
	StopMeasure()
	else
		if RemoveItems("", Item2,1)>0 then
		-- Anim stuff
		local anym = PlayAnimationNoWait("","eat_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_Pretzel.nif", false)
		PlaySound3D("","CharacterFX/eating/eating+2.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)
		MsgSay("","_MEASURES_EATBREAKFAST_SPRUCH_+0")
		xp = xp + 25
		Sleep(1)
		
			if RemoveItems("", Item3,1)>0 then
			MsgSay("","_MEASURES_EATBREAKFAST_SPRUCH_+1")
			xp = xp + 25
			Sleep(1)
			elseif RemoveItems("", Item4,1)>0 then
			-- Anim stuff
			local anym = PlayAnimationNoWait("","eat_standing")
			Sleep(1)
			CarryObject("", "Handheld_Device/ANIM_praline.nif", false)
			PlaySound3D("","CharacterFX/eating/eating+1.ogg",1.0)
			Sleep(anym-1)
			CarryObject("","",false)
			MsgSay("","_MEASURES_EATBREAKFAST_SPRUCH_+9")
			xp = xp +25
			end
		end
		if RemoveItems("", Item1,1)>0 then
		-- Anim stuff
		local anym = PlayAnimationNoWait("","use_potion_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_beaker.nif", false)
		PlaySound3D("","CharacterFX/drinking/drinking+2.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)
		MsgSay("","_MEASURES_EATBREAKFAST_SPRUCH_+2")
		xp = xp + 25
		Sleep(1)
		end
	SetMeasureRepeat(TimeOut)
	chr_GainXP("",xp)
	
	if xp == 75 then
	PlayAnimationNoWait("", "cheer_01")
	PlaySound3D("","Locations/tavern_burp/tavern_burp_04.wav",1.0)
	MsgNewsNoWait("","","","default",-1,
	"@L_MEASURES_EATBREAKFAST_MSG_HEAD_+0",
	"@L_MEASURES_EATBREAKFAST_MSG_BODY_+0")
	end
end
elseif wahl == 2 then -- civic
	local Item1 = "Milch"
	local Item2 = "Wheatbread"
	local Item3 = "Cheese"
	if GetItemCount("", Item2, INVENTORY_STD)==0 then
	MsgQuick("","@L_MEASURES_EATBREAKFAST_FAIL_+1")
	StopMeasure()
	else
		if RemoveItems("", Item2,1)>0 then
		-- Anim stuff
		local anym = PlayAnimationNoWait("","eat_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_Pretzel.nif", false)
		PlaySound3D("","CharacterFX/eating/eating+2.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)
		MsgSay("","_MEASURES_EATBREAKFAST_SPRUCH_+3")
		xp = xp + 50
		Sleep(1)
		
			if RemoveItems("", Item3,1)>0 then
			MsgSay("","_MEASURES_EATBREAKFAST_SPRUCH_+4")
			xp = xp + 50
			Sleep(1)
			end
		end
		if RemoveItems("", Item1,1)>0 then
		-- Anim stuff
		local anym = PlayAnimationNoWait("","use_potion_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_beaker.nif", false)
		PlaySound3D("","CharacterFX/drinking/drinking+2.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)
		MsgSay("","_MEASURES_EATBREAKFAST_SPRUCH_+5")
		xp = xp + 50
		Sleep(1)
		end
	SetMeasureRepeat(TimeOut)
	chr_GainXP("",xp)
	
	if xp == 150 then
	PlayAnimationNoWait("", "cheer_01")
	PlaySound3D("","Locations/tavern_burp/tavern_burp_04.wav",1.0)
	MsgNewsNoWait("","","","default",-1,
	"@L_MEASURES_EATBREAKFAST_MSG_HEAD_+0",
	"@L_MEASURES_EATBREAKFAST_MSG_BODY_+0")
	end
end
elseif wahl == 3 then -- noble
	local Item1 = "HerbTea"
	local Item2 = "BreadRoll"
	local Item3 = "Wurst"
	if GetItemCount("", Item2, INVENTORY_STD)==0 then
	MsgQuick("","@L_MEASURES_EATBREAKFAST_FAIL_+1")
	StopMeasure()
	else
		if RemoveItems("", Item2,1)>0 then
		-- Anim stuff
		local anym = PlayAnimationNoWait("","eat_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_cake.nif", false)
		PlaySound3D("","CharacterFX/eating/eating+2.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)
		MsgSay("","_MEASURES_EATBREAKFAST_SPRUCH_+6")
		xp = xp + 75
		Sleep(1)
		
			if RemoveItems("", Item3,1)>0 then
			MsgSay("","_MEASURES_EATBREAKFAST_SPRUCH_+7")
			xp = xp + 75
			Sleep(1)
			end
		end
		if RemoveItems("", Item1,1)>0 then
		-- Anim stuff
		local anym = PlayAnimationNoWait("","use_potion_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_beaker.nif", false)
		PlaySound3D("","CharacterFX/drinking/drinking+2.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)
		MsgSay("","_MEASURES_EATBREAKFAST_SPRUCH_+8")
		xp = xp + 75
		Sleep(1)
		end
	SetMeasureRepeat(TimeOut)
	chr_GainXP("",xp)
	
	if xp == 225 then
	PlayAnimationNoWait("", "cheer_01")
	PlaySound3D("","Locations/tavern_burp/tavern_burp_04.wav",1.0)
	MsgNewsNoWait("","","","default",-1,
	"@L_MEASURES_EATBREAKFAST_MSG_HEAD_+0",
	"@L_MEASURES_EATBREAKFAST_MSG_BODY_+0")
	end
		end
	end
end

end

function CleanUp()
	StopAnimation("")
	StopMeasure()
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end