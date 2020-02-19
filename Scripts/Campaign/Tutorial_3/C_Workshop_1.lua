-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_3\C_Workshop_1"
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

	SetMainQuestTitle("Workshop", "@L_TUTORIAL_CHAPTER_3_WORKSHOP_NAME")
	SetMainQuestDescription("Workshop","@L_TUTORIAL_CHAPTER_3_WORKSHOP_QUESTBOOK")	
	
	SetMainQuest("Workshop")
	SetQuestTitle("@L_TUTORIAL_CHAPTER_3_WORKSHOP_NAME")
	SetQuestDescription("@L_TUTORIAL_CHAPTER_3_WORKSHOP_QUESTBOOK",true)
	
	if not (HasProperty("#Player","SkipIntro")) then
		MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_3_WORKSHOP_NAME","@L_TUTORIAL_CHAPTER_3_WORKSHOP_QUESTBOOK")
	else
		RemoveProperty("#Player","SkipIntro")
	end
	
	ShowTutorialBoxNoWait(100, 690, 450, 135, 1, LEFTLOWER_NOARROW, "@L_TUTORIAL_CHAPTER_3_WORKSHOP_NAME",  "@L_TUTORIAL_CHAPTER_3_WORKSHOP_TASK",  "")

end

function CheckEnd()
	local Count = CityGetBuildings("#Capital", GL_BUILDING_CLASS_WORKSHOP,GL_BUILDING_TYPE_SMITHY, -1, -1, FILTER_IGNORE, "CitySmithys")
	
	local l
	for l=0,Count-1 do
		Alias	= "CitySmithys"..l
		if BuildingGetOwner(Alias,"BuildingOwner") then
			if GetID("BuildingOwner") == GetID("#Player") then
				if CameraIndoorGetBuilding("CameraBuilding") then
					if GetID(Alias) == GetID("CameraBuilding") then
						SetProperty("#Player","Smithy",Alias)
						HideTutorialBox()
						return true
					end
				end
			end
		end
	end

	return false
end


function Run()
end

-------------------------------------------------------------------------------
----	2. Bind / Start Quest(s)
----		Bind / Start the next Quest(s) and kill the former Quest(s)
-------------------------------------------------------------------------------
function End()
	StartQuest("C_Workshop_2","#Player","",false)

	KillQuest()
end




