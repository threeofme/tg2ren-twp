-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_1\C_Hud_1_b"
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
	SetMainQuestTitle("TheHUD", "@L_TUTORIAL_CHAPTER_1_HUD_NAME")
	SetMainQuestDescription("TheHUD","@L_TUTORIAL_CHAPTER_1_HUD_QUESTBOOK")	
	
	SetMainQuest("TheHUD")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_1_HUD_STEP_1_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_1_HUD_STEP_1_QUESTBOOK",true)
	
	StartQuest("C_Hud_1","#Player","",false)
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




