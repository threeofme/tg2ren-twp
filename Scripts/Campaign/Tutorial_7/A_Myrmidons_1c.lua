-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_5\A_Myrmidons_1b"
----
----	OPEN CHAR OVERVIEW
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

--	AllowMeasure("#Player", "AttackEnemy", EN_BOTH)
--	AllowMeasure("#Player", "Rob", EN_BOTH)
--	AllowMeasure("#Player", "Kill", EN_BOTH)
	SetExclusiveMeasure("#MyMyrmidon", "AttackEnemy", EN_BOTH)
	
	AddItems("#MyMyrmidon","Shortsword",1)
	AddItems("#Victim","Shortsword",1)
	
	SimSetMortal("#Victim", true)
	
	SetState("#Victim", STATE_NPC, false)
	
	AddImpact("#Victim","FinnishQuest",1,-1)	

	while true do
		local HP = GetHP("#MyMyrmidon")
		local MaxHP = GetMaxHP("#MyMyrmidon")
		if (HP < 50) then
			ModifyHP("#MyMyrmidon",MaxHP,false)		
		end
		local HP = GetHP("#Player")
		local MaxHP = GetMaxHP("#Player")
		if (HP < 50) then
			ModifyHP("#Player",MaxHP,false)		
		end		
		if BattleIsFighting("#MyMyrmidon") and BattleIsFighting("#Victim") then
			RemoveImpact("#Victim","FinnishQuest")	
			break
		end
		Sleep(1)
	end
	
	ShowTutorialBoxNoWait(100, 630, 450, 135, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_7_COMBAT_NAME",  "@L_TUTORIAL_CHAPTER_7_COMBAT_PROCESS",  "")
	
	while true do
		local HP = GetHP("#MyMyrmidon")
		local MaxHP = GetMaxHP("#MyMyrmidon")
		if (HP < 50) then
			ModifyHP("#MyMyrmidon",MaxHP,false)		
		end
		local HP = GetHP("#Player")
		local MaxHP = GetMaxHP("#Player")
		if (HP < 50) then
			ModifyHP("#Player",MaxHP,false)		
		end	
		if GetState("#Victim",STATE_UNCONSCIOUS) == true  then
			SetState("#Victim",STATE_DEAD,true)
		end
		if IsDead("#Victim") then
			ResetGamespeed()
			break
		end
		Sleep(1)
	end	
	
	HideTutorialBox()
	
	Sleep(3)
	
	MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_7_COMBAT_NAME","@L_TUTORIAL_CHAPTER_7_COMBAT_SUCCESS")
	
	StartQuest("C_GoodEvil_1","#Player","",false)
	
	KillQuest("A_Myrmidons_1b")
	
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




