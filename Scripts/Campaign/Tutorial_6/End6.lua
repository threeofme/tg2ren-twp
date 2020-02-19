-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_6\Intro1"
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
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_FAILED_NAME","@L_TUTORIAL_FAILED_TEXT")
	CampaignExit(false)
end

function Run()
end

function CheckEnd()
	return true
end

-------------------------------------------------------------------------------
----	2. Bind / Start Quest(s)
----		Bind / Start the next Quest(s) and kill the former Quest(s)
-------------------------------------------------------------------------------
function End()

	StartQuest("A_Title_1","#Player","",false)

	KillQuest()	
end




