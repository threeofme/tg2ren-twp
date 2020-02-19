function Init()
end

function Run()
	GetInsideBuilding("","Estate")
	--[[for i=1,8 do
		GetLocatorByName("Estate","ServicePos"..i,"ServicePos"..i) 
		f_BeginUseLocator("","ServicePos"..i,GL_STANCE_SIT,true)
		MsgSay("","ServicePos"..i)
		Sleep(1)
	end	
	for i=1,12 do
		GetLocatorByName("Estate","Sit"..i,"SitPos"..i) 
		f_BeginUseLocator("","SitPos"..i,GL_STANCE_SIT,true)
		MsgSay("","Sit"..i)
		Sleep(1)
	end
	for i=1,4 do
		GetLocatorByName("Estate","GuardPos"..i,"GuardPos"..i) 
		f_BeginUseLocator("","GuardPos"..i,GL_STANCE_STAND,true)
		MsgSay("","GuardPos"..i)
		Sleep(1)
	end]]
	GetLocatorByName("Estate","SpecPos1","SpecPos1") 
	f_BeginUseLocator("","SpecPos1",GL_STANCE_SIT,true)	
	for i=2,4 do 
		GetLocatorByName("Estate","SpecPos"..i,"SpecPos"..i) 
		f_BeginUseLocator("","SpecPos"..i,GL_STANCE_STAND,true)
		MsgSay("","SpecPos"..i)
		Sleep(1)
	end
end

function CleanUp()

end
