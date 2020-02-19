-------------------------------------------------------------------------------
----
----	OVERVIEW "_Tutorial_1\C_Hud_5_b"
----
----
----
----	1. function Bind
----
----	2. Bind / Start the next Quest(s)
----
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
----	1. function Bind
-------------------------------------------------------------------------------
function Bind()
	return true
end

function CheckStart()
	return true
end

function Start()
	SetMainQuest("TheHUD")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_1_HUD_MAP_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_1_HUD_MAP_QUESTBOOK",true)
	
	StartQuest("C_Hud_5","#Player","",false)
end

function CheckEnd()
	return false
end


function Run()
end

-------------------------------------------------------------------------------
----	2. Bind / Start Quest(s)
----		Bind / Start the next Quest(s) and kill the former Quest(s)
-------------------------------------------------------------------------------
function End()
end




