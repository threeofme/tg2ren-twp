function Init()
	InitData("SayPanel",0,"SayHeader","SayBody")
end

function Run()
	local label = GetData("TF0")
	if (string.len(label) > 0 ) then
		
		local animNameCut = ""
		
--ANIM PARSE
--		if(string.find(string.lower(label),":anim:")) then
--			local animCut = string.sub(label, 7,-1)
--			local animNameEnd = string.find(string.lower(animCut),":")
--			animNameCut = string.sub(animCut, 1,animNameEnd-1)
--			label = string.sub(animCut, animNameEnd+1,-1)
--		end

--FACIAL PARSE

		local foundFacial = false
		local facialString = "#E[NT_NEUTRAL]"
		local animationToPlay = ""
		if GetState("",STATE_SITAROUND) then
			animationToPlay = "sit_talk"
		else
			animationToPlay = "talk_short"
			if(SimGetGender("") == GL_GENDER_FEMALE) then
				animationToPlay = "talk_female_"..(Rand(2)+1)
			end
		end

--		LAUGHNG

		local face_tags = {"lol","rofl","haha","hehe","hihi",":d",":%-d"}
		local face_nums = 7
		for i=1,face_nums do
			local tofind = face_tags[i]
			if(string.find(string.lower(label),face_tags[i])) then
				local found = face_tags[i]
				facialString = "#E[HP_HAPPY]"
				if GetState("",STATE_SITAROUND) then
					animationToPlay = "sit_laugh"
				else
					animationToPlay = "talk_2"
				end
				foundFacial = true
				break
			end
		end
		
--		SAD

		if(foundFacial == false) then
			local face_tags = {"hmpf",":%(",";%(",":%-%(",";%-%("}
			local face_nums = 5
			for i=1,face_nums do
				local toFind = face_tags[i]
				if(string.find(string.lower(label),toFind)) then
					facialString = "#E[SD_SAD]"
					if GetState("",STATE_SITAROUND) then
						animationToPlay = "sit_no"	
					end						
					foundFacial = true
					break
				end
			end
		end
		
--		SMILE

		if(foundFacial == false) then
			local face_tags = {":%)",";%)",":%_%)",";%-%)"}
			local face_nums = 4
			for i=1,face_nums do
				local toFind = face_tags[i]
				if(string.find(string.lower(label),toFind)) then
					facialString = "#E[HP_SMILING]"
					if GetState("",STATE_SITAROUND) then
						animationToPlay = "sit_yes"	
					else
						animationToPlay = "talk_positive"
					end					
					foundFacial = true
					break
				end
			end
		end		

--		SCREAMING

		if(foundFacial == false) then
			local face_tags = {"!","d:","d="}
			local face_nums = 3
			for i=1,face_nums do
				if(string.find(string.lower(label),face_tags[i])) then
					facialString = "#E[AG_ENRAGED]"
					if GetState("",STATE_SITAROUND) then
						animationToPlay = "sit_talk_02"	
					else
						animationToPlay = "talk_negative"
					end
					foundFacial = true
					break
				end
			end
		end
		

		label = facialString .. label
		
		if(animNameCut ~= "") then
			animationToPlay = animNameCut
		end
		PlayAnimationNoWait("",animationToPlay)
		
  		MsgSay("",label)

	end
end


