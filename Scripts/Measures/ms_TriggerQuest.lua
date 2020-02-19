function Run()
	MsgDebugMeasure("TriggerQuest")
	if (BlockChar("Destination")) then
	  SetProperty("Destination","InTalk",1)
	  SetProperty("Owner","InTalk",1)
	  AlignTo("Destination", "Owner")
		if f_MoveTo("","Destination",GL_MOVESPEED_WALK, Rand(10)) then
			AlignTo("Owner", "Destination")
			Sleep(0.5)
		
			local	time1, time2
		
			-- Quest talk?
			QuestTalk("","Destination")
		end
	end
end

function CleanUp()
	if(AliasExists("Destination")) then
	 RemoveProperty("Destination","InTalk")
	 StopAnimation("Destination")
	end
	
	RemoveProperty("Owner","InTalk")
	StopAnimation("Owner")
end









