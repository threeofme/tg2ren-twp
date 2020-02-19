-------------------------------------------------------------------------------
----
----	OVERVIEW "_Tutorial_1\C_Hud_2"
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

--	STEP 2 MESSAGEBAR

	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_1_HUD_STEP_2_NAME","@L_TUTORIAL_CHAPTER_1_HUD_STEP_2_QUESTBOOK")

	ShowTutorialBoxNoWait(60, 600, 500, 135, 1, LEFTUPPER, "@L_TUTORIAL_CHAPTER_1_HUD_STEP_2_NAME",  "@L_TUTORIAL_CHAPTER_1_HUD_STEP_2_TASK",  "")
	
	while true do
		local result = MsgNews("#Player",0,"MB_OK","","default",-1,"@L_TUTORIAL_CHAPTER_1_HUD_STEP_2_NAME","@L_TUTORIAL_CHAPTER_1_HUD_STEP_2_SUCCESS")
		if result ~= "C" then
			HideTutorialBox()
			break
		end
	end
	
	StartQuest("C_Hud_3_b","#Player","",false)

	KillQuest("C_Hud_2_b")
	KillQuest()	
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




