-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_EatDinner.lua"
----
----	Original Author: Fajeth
----
----	Eating Dinner gives you XP, depending on how much items you eat and which rank. Default Cooldown: 6 hours.
---- 	You need to add entries into measures.dbt and MeasureToObject.dbt, text.dbt

----	entries may look like this:
----	measures.dbt:
----	12115        "ms_EatDinner.lua"   ""   "EatDinner"   35   "hud/buttons/btn_EatDinner.tga"   0   14   0   ""   ""   0   0   0   "none"   0   0   |
----
----	text.dbt:
--[[
16543        "_MEASURES_EATDINNER_HEAD+0" "Abendessen"                    "Eat Dinner"                         | 
16544        "_MEASURES_EATDINNER_BODY_+0" "Wie wollt Ihr essen?" "Which kind of dinner?" | 
16545        "_MEASURES_EATDINNER_SCREENPLAY_ACTOR_CHOICE_+0" "Bäuerlich"                          "peasant"                           | 
16546        "_MEASURES_EATDINNER_SCREENPLAY_ACTOR_CHOICE_+1" "Bürgerlich"                          "civic"                           | 
16547        "_MEASURES_EATDINNER_SCREENPLAY_ACTOR_CHOICE_+2" "Adelig"                          "noble"                           | 
16548	 "_MEASURES_EATDINNER_FAIL_+0"                    "Du kannst nur zwischen 18 und 24 Uhr zu Abend essen"                    "You can only eat dinner between 6 and 12 pm."  |  
16549	 "_MEASURES_EATDINNER_FAIL_+1"                    "Du hast die benötigten Items nicht im Inventar!"                    "You don't have the needed items in your inventory!"  |  
16550	 "_MEASURES_EATDINNER_SPRUCH_+0"                    "Schon wieder Gerstenbrot? Na gut ..."                    "Again barley bread? Well, okay ... "  |  
16551	 "_MEASURES_EATDINNER_SPRUCH_+1"                    "Frittierter Hering, großartig!"                    "Fried Herring! This is great!"  |  
16552	 "_MEASURES_EATDINNER_SPRUCH_+2"                    "Körnerbrei, jeden Tag Körnerbrei ..."                    "Grain porrage, everyday grain porrage ..."  |  
16553	 "_MEASURES_EATDINNER_SPRUCH_+3"                    "Dieses Bier schmeckt wie Wasser ..."                    "This beer tastes like water ..."  |  
16554	 "_MEASURES_EATDINNER_SPRUCH_+4"                    "Frischer Salat, lecker!"                    "Fresh salad, yummy!"  |  
16555	 "_MEASURES_EATDINNER_SPRUCH_+5"                    "Räucherlachs, hervorragend!"                    "Smoked Salmon, delicious!"  |  
16556	 "_MEASURES_EATDINNER_SPRUCH_+6"                    "So zart und nicht eine Gräte in diesem Lachsfilet!"                    "So delicate and not even one fishbone in this salmon fillet!"  | 
16557	 "_MEASURES_EATDINNER_SPRUCH_+7"                    "Genau so muss ein Weizenbier schmecken."                    "This is exactly how a wheat beer has to taste."  | 
16558	 "_MEASURES_EATDINNER_SPRUCH_+8"                    "Diese Muschelsuppe schmeckt wie zuhause bei Mutter!"                    "This shell soup really does taste homelike."  |
16559	 "_MEASURES_EATDINNER_SPRUCH_+9"                    "Ein leckeres Weizenbrötchen als Vorspeise? Warum nicht!"                    "A fine wheat bread roll for starters? Why not!"  |
16560	 "_MEASURES_EATDINNER_SPRUCH_+10"                    "Rinderbraten! Das könnte ich jeden Abend essen!"                    "Roast beef! I could eat that every evening."  |
16561	 "_MEASURES_EATDINNER_SPRUCH_+11"                    "Dieser Tropfen ist weich im Mund und hervorragend im Abgang."                    "This drop is really gentle and the final note just wonderful."  |
16562	 "_MEASURES_EATDINNER_MSG_HEAD_+0"                    "Perfektes Abendessen"                    "Perfect Dinner"  | 
16563	 "_MEASURES_EATDINNER_MSG_BODY_+0"                    "Du hast ein ganz außergewöhnliches Abendessen zu dir genommen, gut gemacht!"                    "You ate an extrordinary dinner, well done!"  | 
16564	 "_MEASURE_EatDinner_NAME_+0"                    "Abendessen"                    "Eat Dinner"   |
16565	 "_MEASURE_EatDinner_TOOLTIP_+0"                    "Ein gesundes und vollwertiges Abendessen lässt dich wachsen. Je höher dein Titel ist, desto orpulentere Mahlzeiten darfst du zu dir nehmen.$N$NEin Abendessen besteht aus einem Hauptgang (Körnerbrei/Frittierter Hering, Lachsfilet/Geräucherter Lachs, Rinderbraten), einer Vorspeise (Gerstenbrot, Salat, Muschelsuppe) und einem Getränk (Dünnbier, Weizenbier, Wein)$N$NFür diese Maßnahme erhaltet Ihr Erfahrungspunkte."                    "Eating a healthy dinner makes you grow. The higher your nobility title the better you may want to banquet.$N$NFor dinner you need a main dish (Fried Herring/Grain Porrage, Salmon Fillet/Smoked Salmon, Roast Beef), an appetizer (Barley Bread, Salad, Shellsoup) and something for a drink (Weak Beer, Wheat Beer, Wine). $N$NFor this measure you get experience points."   |

]]--
----
----	MeasureToObjects.dbt:
----	3265         12115               0                       0                      1523                   6                ""                     ()                 ""                      0                           0                              |
-------------------------------------------------------------------------------

function Run()

local MeasureID = GetCurrentMeasureID("")
local TimeOut = mdata_GetTimeOut(MeasureID)
local rank = GetNobilityTitle("")
local time = math.mod(GetGametime(),24)
local xp = 0
	
if (time <18) then
MsgQuick("","@L_MEASURES_EATDINNER_FAIL_+0")
StopMeasure()
else

	local Button1 = "@B[1,@L_MEASURES_EATDINNER_SCREENPLAY_ACTOR_CHOICE_+0,@L_MEASURES_EATDINNER_SCREENPLAY_ACTOR_CHOICE_+0,Hud/Items/item_GrainPap.tga]"
	local Button2 = "@B[2,@L_MEASURES_EATDINNER_SCREENPLAY_ACTOR_CHOICE_+1,@L_MEASURES_EATDINNER_SCREENPLAY_ACTOR_CHOICE_+1,Hud/Items/item_SalmonFilet.tga]"
	local Button3 = "@B[3,@L_MEASURES_EATDINNER_SCREENPLAY_ACTOR_CHOICE_+2,@L_MEASURES_EATDINNER_SCREENPLAY_ACTOR_CHOICE_+2,Hud/Items/item_RoastBeef.tga]"
	-- Only show buttons if Sim has a high title
	if rank <4 then
	Button2 = ""
	Button3 = ""
	elseif rank <6 then
	Button3 = ""
	end
	
	local result
	result = InitData("@P"..Button1..Button2..Button3,"@L_MEASURES_EATDINNER_HEAD_+0","@L_MEASURES_EATDINNER_BODY_+0")
		
		if result==1 then
		SetData("Wahl",1)
		elseif result==2 then
		SetData("Wahl",2)
		elseif result==3 then
		SetData("Wahl",3)
		end
	
	local wahl = GetData("Wahl")
	
if wahl == 1 then --peasant
	local Item1 = "SmallBeer"
	local Item2 = "FriedHerring"
	local Item3 = "GrainPap"
	local Item4 = "WheatBread"
	if GetItemCount("", Item2, INVENTORY_STD)==0 and GetItemCount("", Item3, INVENTORY_STD)==0 then
	MsgQuick("","@L_MEASURES_EATDINNER_FAIL_+1")
	StopMeasure()
	else
		if RemoveItems("", Item4,1)>0 then
		-- Anim stuff
		local anym = PlayAnimationNoWait("","eat_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_Pretzel.nif", false)
		PlaySound3D("","CharacterFX/eating/eating+1.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)
		MsgSay("","_MEASURES_EATDINNER_SPRUCH_+0")
		xp = xp + 25
		Sleep(1)
		end
		
		if RemoveItems("", Item2,1)>0 then
		-- Anim stuff
		local anym = PlayAnimationNoWait("","eat_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_cake.nif", false)
		PlaySound3D("","CharacterFX/eating/eating+2.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)
		MsgSay("","_MEASURES_EATDINNER_SPRUCH_+1")
		xp = xp + 25
		Sleep(1)
		elseif RemoveItems("", Item3,1)>0 then
		-- Anim stuff
		local anym = PlayAnimationNoWait("","eat_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_cake.nif", false)
		PlaySound3D("","CharacterFX/eating/eating+3.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)
		MsgSay("","_MEASURES_EATDINNER_SPRUCH_+2")
		xp = xp + 25
		Sleep(1)
		end
		if RemoveItems("", Item1,1)>0 then
		-- Anim stuff
		local anym = PlayAnimationNoWait("","use_potion_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_beaker.nif", false)
		PlaySound3D("","CharacterFX/drinking/drinking+2.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)
		MsgSay("","_MEASURES_EATDINNER_SPRUCH_+3")
		xp = xp + 25
		Sleep(1)
		end
	SetMeasureRepeat(TimeOut)
	chr_GainXP("",xp)
	
	if xp == 75 then
	PlayAnimationNoWait("", "cheer_01")
	PlaySound3D("","Locations/tavern_burp/tavern_burp_04.wav",1.0)
	MsgNewsNoWait("","","","default",-1,
	"@L_MEASURES_EATDINNER_MSG_HEAD_+0",
	"@L_MEASURES_EATDINNER_MSG_BODY_+0")
	end
end
elseif wahl == 2 then -- civic
	local Item1 = "WheatBeer"
	local Item2 = "SmokedSalmon"
	local Item3 = "SalmonFilet"
	local Item4 = "Salat"
	if GetItemCount("", Item2, INVENTORY_STD)==0 and GetItemCount("", Item3, INVENTORY_STD)==0 then
	MsgQuick("","@L_MEASURES_EATDINNER_FAIL_+1")
	StopMeasure()
	else
		if RemoveItems("", Item4,1)>0 then
		-- Anim stuff
		local anym = PlayAnimationNoWait("","eat_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_carrot.nif", false)
		PlaySound3D("","CharacterFX/eating/eating+1.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)
		MsgSay("","_MEASURES_EATDINNER_SPRUCH_+4")
		xp = xp + 50
		Sleep(1)
		end
		
		if RemoveItems("", Item2,1)>0 then
		-- Anim stuff
		local anym = PlayAnimationNoWait("","eat_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_cake.nif", false)
		PlaySound3D("","CharacterFX/eating/eating+2.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)
		MsgSay("","_MEASURES_EATDINNER_SPRUCH_+5")
		xp = xp + 50
		Sleep(1)
		elseif RemoveItems("", Item3,1)>0 then
		-- Anim stuff
		local anym = PlayAnimationNoWait("","eat_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_cake.nif", false)
		PlaySound3D("","CharacterFX/eating/eating+2.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)
		MsgSay("","_MEASURES_EATDINNER_SPRUCH_+6")
		xp = xp + 50
		Sleep(1)
		end
		if RemoveItems("", Item1,1)>0 then
		-- Anim stuff
		local anym = PlayAnimationNoWait("","use_potion_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_beaker.nif", false)
		PlaySound3D("","CharacterFX/drinking/drinking+2.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)
		MsgSay("","_MEASURES_EATDINNER_SPRUCH_+7")
		xp = xp + 50
		Sleep(1)
		end
	SetMeasureRepeat(TimeOut)
	chr_GainXP("",xp)
	
	if xp == 150 then
	PlayAnimationNoWait("", "cheer_01")
	PlaySound3D("","Locations/tavern_burp/tavern_burp_04.wav",1.0)
	MsgNewsNoWait("","","","default",-1,
	"@L_MEASURES_EATDINNER_MSG_HEAD_+0",
	"@L_MEASURES_EATDINNER_MSG_BODY_+0")
	end
end
elseif wahl == 3 then -- noble
	local Item1 = "Wein"
	local Item2 = "RoastBeef"
	local Item3 = "Shellsoup"
	local Item4 = "BreadRoll"
	if GetItemCount("", Item2, INVENTORY_STD)==0 then
	MsgQuick("","@L_MEASURES_EATDINNER_FAIL_+1")
	StopMeasure()
	else
		if RemoveItems("", Item3,1)>0 then
		-- Anim stuff
		local anym = PlayAnimationNoWait("","eat_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_cake.nif", false)
		PlaySound3D("","CharacterFX/eating/eating+4.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)
		MsgSay("","_MEASURES_EATDINNER_SPRUCH_+8")
		xp = xp + 75
		Sleep(1)
		elseif RemoveItems("", Item4,1)>0 then
		-- Anim stuff
		local anym = PlayAnimationNoWait("","eat_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_Pretzel.nif", false)
		PlaySound3D("","CharacterFX/eating/eating+1.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)
		MsgSay("","_MEASURES_EATDINNER_SPRUCH_+9")
		xp = xp + 75
		Sleep(1)
		end
		
		if RemoveItems("", Item2,1)>0 then
		-- Anim stuff
		local anym = PlayAnimationNoWait("","eat_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_cake.nif", false)
		PlaySound3D("","CharacterFX/eating/eating+2.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)
		MsgSay("","_MEASURES_EATDINNER_SPRUCH_+10")
		xp = xp + 75
		Sleep(1)
		end
		if RemoveItems("", Item1,1)>0 then
		-- Anim stuff
		local anym = PlayAnimationNoWait("","use_potion_standing")
		Sleep(1)
		CarryObject("", "Handheld_Device/ANIM_beaker.nif", false)
		PlaySound3D("","CharacterFX/drinking/drinking+3.ogg",1.0)
		Sleep(anym-1)
		CarryObject("","",false)
		MsgSay("","_MEASURES_EATDINNER_SPRUCH_+11")
		xp = xp + 75
		Sleep(1)
		end
	SetMeasureRepeat(TimeOut)
	chr_GainXP("",xp)
	
	if xp == 225 then
	PlayAnimationNoWait("", "cheer_01")
	PlaySound3D("","Locations/tavern_burp/tavern_burp_04.wav",1.0)
	MsgNewsNoWait("","","","default",-1,
	"@L_MEASURES_EATDINNER_MSG_HEAD_+0",
	"@L_MEASURES_EATDINNER_MSG_BODY_+0")
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