---------------------------------------------------------------------------------
----	FACIAL EXPRESSIONS
----	Table Of Contents
----
----	1.	Talk Expressions
----	 1.1.	Letter emphasis
----	 1.2.	TalkIdle
----
----	2.	Emotions
----	 2.1.	NEUTRAL EMOTIONS
----	 2.2.	HAPPY EMOTIONS
----	 2.3.	SAD EMOTIONS
----	 2.4.	LOVE EMOTIONS
----	 2.5.	AGGRESSIVE EMOTIONS
----	 2.6.	DEFENSIVE EMOTIONS
----
----	3.	Different stuff
---------------------------------------------------------------------------------

-------------------------------------------
----	 1.1.	Letter emphasis
-------------------------------------------
function Phon_E(Sim)
	if Sim then
		FadeInFE(Sim, "phon_E", 1.0, 0.2, 1)
		Sleep(0.2)
		FadeOutFE(Sim, "phon_E", 0.2, 1)
		Sleep(0.2)
	elseif AliasExists("") then
		FadeInFE("", "phon_E", 1.0, 0.2, 1)
		Sleep(0.2)
		FadeOutFE("", "phon_E", 0.2, 1)
		Sleep(0.2)
	else
		Sleep(0.1)
	end
end

function Phon_M(Sim)
	if Sim then
		FadeInFE(Sim, "phon_M", 1.0, 0.2, 1)
		Sleep(0.2)
		FadeOutFE(Sim, "phon_M", 0.2, 1)
		Sleep(0.2)
	elseif AliasExists("") then
		FadeInFE("", "phon_M", 1.0, 0.2, 1)
		Sleep(0.2)
		FadeOutFE("", "phon_M", 0.2, 1)
		Sleep(0.2)
	else
		Sleep(0.1)
	end
end

function Phon_A(Sim)
	if Sim then
		FadeInFE(Sim, "phon_A", 1.0, 0.2, 1)
		Sleep(0.2)
		FadeOutFE(Sim, "phon_A", 0.2, 1)
		Sleep(0.2)
	elseif AliasExists("") then
		FadeInFE("", "phon_A", 1.0, 0.2, 1)
		Sleep(0.2)
		FadeOutFE("", "phon_A", 0.2, 1)
		Sleep(0.2)
	else
		Sleep(0.1)
	end
end

function Phon_R(Sim)
	if Sim then
		FadeInFE(Sim, "phon_R", 1.0, 0.1, 1)
		Sleep(0.1)
		FadeOutFE(Sim, "phon_R", 0.2, 1)
		Sleep(0.2)
	elseif AliasExists("") then
		FadeInFE("", "phon_R", 1.0, 0.1, 1)
		Sleep(0.1)
		FadeOutFE("", "phon_R", 0.2, 1)
		Sleep(0.2)
	else
		Sleep(0.1)
	end
end

function Phon_P(Sim)
	if Sim then
		FadeInFE(Sim, "phon_P", 1.0, 0.1, 1)
		Sleep(0.1)
		FadeOutFE(Sim, "phon_P", 0.2, 1)
		Sleep(0.2)
	elseif AliasExists("") then
		FadeInFE("", "phon_P", 1.0, 0.1, 1)
		Sleep(0.1)
		FadeOutFE("", "phon_P", 0.2, 1)
		Sleep(0.2)
	else
		Sleep(0.1)
	end
end

function Phon_O(Sim)
	if Sim then
		FadeInFE(Sim, "phon_O", 1.0, 0.2, 1)
		Sleep(0.3)
		FadeOutFE(Sim, "phon_O", 0.2, 1)
		Sleep(0.2)
	elseif AliasExists("") then
		FadeInFE("", "phon_O", 1.0, 0.2, 1)
		Sleep(0.3)
		FadeOutFE("", "phon_O", 0.2, 1)
		Sleep(0.2)
	else
		Sleep(0.1)
	end
end

-------------------------------------------
----	 1.2.	TalkIdle
----	        play a random voice emote
-------------------------------------------
function TalkIdle()
	local random = math.random(6)-1
	if random == 0 then
		emotes_Phon_M()
	elseif random == 1 then
		emotes_Phon_E()
	elseif random == 2 then
		emotes_Phon_R()
	elseif random == 3 then
		emotes_Phon_O()
	elseif random == 4 then
		emotes_Phon_P()
	else
		emotes_Phon_A()
	end
end

-------------------------------------------
----	 1.3.	SimTalk
----	        play a random voice emote
-------------------------------------------
function SimTalk(Sim)
	for i=1,15 do
		local random = math.random(6)-1
		if random == 0 then
			emotes_Phon_M(Sim)
		elseif random == 1 then
			emotes_Phon_E(Sim)
		elseif random == 2 then
			emotes_Phon_R()
		elseif random == 3 then
			emotes_Phon_O()
		elseif random == 4 then
			emotes_Phon_P()
		else
			emotes_Phon_A(Sim)
		end
	end
end

-------------------------------------------
----	2.1.	NEUTRAL EMOTIONS
-------------------------------------------
function NT_NEUTRAL()
	FadeOutAllFE("", 0)
	while true do
		emotes_TalkIdle()
	end
end

function NT_FRIENDLY()
	FadeOutAllFE("", 0)
	FadeInFE("", "smile", 0.5, 0.3, 0)
	-- BaseFE("", "smile", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function NT_UNFRIENDLY()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyelids_down", 0.3, 0.3, 1)
	FadeInFE("", "eyebrows_down", 0.3, 0.3, 1)
	FadeInFE("", "anger", 0.5, 0.4, 0)
	FadeInFE("", "angry scream", 0.2, 0.5, 0)
	-- BaseFE("", "anger", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function NT_CONFIDENT()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_down", 0.2, 0.2, 1)
	FadeInFE("", "eyelids_down", 0.2, 0.2, 1)
	FadeInFE("", "confident", 1.0, 0.3, 0)
	-- BaseFE("", "confident", 1.0, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function NT_SEVERE()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_down", 0.3, 0.2, 1)
	FadeInFE("", "eyelids_down", 0.3, 0.2, 1)
	FadeInFE("", "confident", 0.5, 0.3, 0)
	FadeInFE("", "anger", 0.2, 0.3, 0)
--	-- BaseFE("", "anger", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function NT_UNAWARE()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_up", 0.3, 0.2, 1)
	FadeInFE("", "eyelids_up", 0.3, 0.2, 1)
	FadeInFE("", "appalled", 0.3, 0.3, 0)
--	-- BaseFE("", "anger", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function NT_PRAYING()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_down", 0.4, 0.3, 1)
	FadeInFE("", "eyelids_down", 1.0, 0.3, 1)
	FadeInFE("", "smile", 0.3, 0.4, 0)
--	-- BaseFE("", "smile", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function NT_PREACHING()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_up", 0.3, 0.3, 1)
	FadeInFE("", "eyelids_up", 0.3, 0.3, 1)
	FadeInFE("", "anger", 0.3, 0.4, 0)
	FadeInFE("", "cry", 0.3, 0.4, 0)
--	-- BaseFE("", "anger", 0.3, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function NT_AMAZED()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_up", 0.7, 0.2, 1)
	FadeInFE("", "eyelids_up", 0.5, 0.2, 1)
	FadeInFE("", "appalled", 0.3, 0.4, 0)
	FadeInFE("", "horrified", 0.3, 0.4, 0)
	-- BaseFE("", "anger", 0.3, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function NT_NO()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_down", 0.7, 0.2, 1)
	FadeInFE("", "eyelids_down", 0.3, 0.2, 1)
	FadeInFE("", "anger", 0.4, 0.3, 0)
	FadeInFE("", "bored", 0.4, 0.3, 0)
	-- BaseFE("", "none", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function NT_BORED()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_down", 0.4, 0.2, 1)
	FadeInFE("", "eyelids_down", 0.4, 0.2, 1)
	FadeInFE("", "bored", 1.0, 0.3, 0)
--	-- BaseFE("", "bored", 1.0, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

-------------------------------------------
----	2.2.	HAPPY EMOTIONS
-------------------------------------------
function HP_HAPPY()
	FadeOutAllFE("", 0)
	FadeInFE("", "happy", 1.0, 0.3, 0)
	-- BaseFE("", "smile", 1.0, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function HP_SMILING()
	FadeOutAllFE("", 0)
	FadeInFE("", "smile", 1.0, 0.4, 0)
--	-- BaseFE("", "smile", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function HP_TRIUMPHANT()
	FadeOutAllFE("", 0)
	FadeInFE("", "laugh", 0.7, 0.3, 0)
	FadeInFE("", "strike", 0.3, 0.3, 0)
--	-- BaseFE("", "smile", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function HP_CHEERING()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_up", 0.4, 0.2, 1)
	FadeInFE("", "eyelids_up", 0.4, 0.2, 1)
	FadeInFE("", "laugh", 0.4, 0.3, 0)
	FadeInFE("", "happy", 0.6, 0.3, 0)
	-- BaseFE("", "smile", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

-------------------------------------------
----	2.3.	SAD EMOTIONS
-------------------------------------------
function SD_SAD()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_down", 0.3, 0.3, 1)
	FadeInFE("", "eyelids_down", 0.1, 0.3, 1)
	FadeInFE("", "sad", 1.0, 0.4, 0)
--	-- BaseFE("", "sad", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function SD_DEPRESSED()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_down", 0.4, 0.3, 1)
	FadeInFE("", "eyelids_down", 0.2, 0.3, 1)
	FadeInFE("", "depresssed", 1.0, 0.4, 0)
--	-- BaseFE("", "sad", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function SD_WAILING()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_up", 0.4, 0.3, 1)
	FadeInFE("", "eyelids_up", 0.7, 0.3, 1)
	FadeInFE("", "cry", 0.5, 0.4, 0)
	FadeInFE("", "ache", 1.0, 0.4, 0)
	-- BaseFE("", "sad", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function SD_WORRIED()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_down", 0.3, 0.3, 1)
	FadeInFE("", "eyelids_down", 0.2, 0.3, 1)
	FadeInFE("", "fear", 0.5, 0.4, 0)
	FadeInFE("", "sad", 0.5, 0.4, 0)
--	-- BaseFE("", "sad", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function SD_FRUSTRATED()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_down", 0.6, 0.3, 1)
	FadeInFE("", "eyelids_down", 0.3, 0.3, 1)
	FadeInFE("", "anger", 0.7, 0.4, 0)
	FadeInFE("", "sad", 0.3, 0.4, 0)
--	-- BaseFE("", "sad", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

-------------------------------------------
----	2.4.	LOVE EMOTIONS
-------------------------------------------
function LV_FONDLY()
	FadeOutAllFE("", 0)
	FadeInFE("", "happy", 0.4, 0.3, 0)
	FadeInFE("", "smile", 0.6, 0.4, 0)
--	-- BaseFE("", "smile", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

-- bashful, unsure, 
function LV_BASHFUL()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_up", 0.7, 0.3, 1)
	FadeInFE("", "eyelids_up", 0.7, 0.3, 1)
	FadeInFE("", "smile", 0.4, 0.4, 0)
--	-- BaseFE("", "smile", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

-- in love
function LV_LOVING()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyelids_up", 0.4, 0.3, 1)
	FadeInFE("", "smile", 0.6, 0.4, 0)
--	-- BaseFE("", "smile", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function LV_ALLAYING()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyelids_up", 0.3, 0.3, 1)
	FadeInFE("", "sad", 0.4, 0.4, 0)
	FadeInFE("", "smile", 0.4, 0.4, 0)
--	-- BaseFE("", "smile", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end


-------------------------------------------
----	2.5.	AGGRESSIVE EMOTIONS
-------------------------------------------

-- in rage
function AG_ENRAGED()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_down", 1.0, 0.2, 1)
	FadeInFE("", "eyelids_up", 0.7, 0.2, 1)
	FadeInFE("", "angry scream", 1.0, 0.3, 0)
	BaseFE("", "anger", 1.0, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

-- to tell bad words to s.o.
function AG_RANTING()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_down", 1.0, 0.2, 1)
	FadeInFE("", "eyelids_up", 0.7, 0.2, 1)
	FadeInFE("", "anger", 1.0, 0.3, 0)
--	-- BaseFE("", "anger", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function AG_THREATENING()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_down", 0.8, 0.2, 1)
	FadeInFE("", "eyelids_down", 0.4, 0.2, 1)
	FadeInFE("", "angry scream", 0.4, 0.3, 0)
	FadeInFE("", "anger", 0.6, 0.3, 0)
	BaseFE("", "anger", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function AG_CYNICAL()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_down", 0.4, 0.2, 1)
	FadeInFE("", "smile", 0.5, 0.3, 0)
--	-- BaseFE("", "smile", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function AG_SCREAM()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_up", 0.5, 0.1, 1)
	FadeInFE("", "eyelids_up", 0.8, 0.1, 1)
	FadeInFE("", "angry scream", 0.8, 0.2, 0)
	FadeInFE("", "cry", 0.2, 0.2, 0)
	BaseFE("", "anger", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

-------------------------------------------
----	2.6.	DEFENSIVE EMOTIONS
-------------------------------------------
function DF_APPALLED()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_up", 1.0, 0.2, 1)
	FadeInFE("", "eyelids_up", 1.0, 0.2, 1)
	FadeInFE("", "appalled", 1.0, 0.3, 0)
--	-- BaseFE("", "anger", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function DF_DISGUSTED()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_up", 0.7, 0.2, 1)
	FadeInFE("", "eyelids_up", 0.7, 0.2, 1)
	FadeInFE("", "cry", 0.2, 0.3, 0)
	FadeInFE("", "anger", 0.8, 0.3, 0)
--	-- BaseFE("", "anger", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function DF_FRIGHTENED()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_up", 0.7, 0.2, 1)
	FadeInFE("", "eyelids_up", 0.7, 0.2, 1)
	FadeInFE("", "fear", 1.0, 0.3, 0)
	FadeInFE("", "pain", 0.3, 0.3, 0)
	-- BaseFE("", "anger", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end

function DF_SCARED()
	FadeOutAllFE("", 0)
	FadeInFE("", "eyebrows_up", 1.0, 0.2, 1)
	FadeInFE("", "eyelids_up", 1.0, 0.2, 1)
	FadeInFE("", "fear", 0.8, 0.3, 0)
	FadeInFE("", "cry", 0.2, 0.3, 0)
	-- BaseFE("", "anger", 0.5, 0.3)

	while true do
		emotes_TalkIdle()
	end
end



-------------------------------------------
----	3.	Different Stuff
-------------------------------------------

function TALK()
	while true do
		emotes_TalkIdle()
	end
end

function SMILE()
	FadeOutAllFE("", 0)
	FadeInFE("", "happy", 1.0, 0.4, 0)
	-- BaseFE("", "smile", 0.5, 0.3)
	Sleep(10000)
end

function NERVOUS()
	FadeOutAllFE("", 0)
	FadeInFE("", "nervous", 1.0, 0.4, 0)
--	-- BaseFE("", "nervous", 0.5, 0.3)
	Sleep(10000)
end

function ANGRYTALK()
	FadeOutAllFE("", 0)
	FadeInFE("", "angry scream", 0.6, 0.4, 0)
	BaseFE("", "anger", 0.6, 0.4)
	while true do
		emotes_TalkIdle()
	end
	Sleep(10000)
end

function ANGRYPOINTAT()
	FadeOutAllFE("", 0)
	FadeInFE("", "angry scream", 0.5, 0.4, 0)
	BaseFE("", "anger", 0.5, 0.4)
	Sleep(10000)
end



-- ***********************************
function TEST()
	FadeOutAllFE("", 0)
	FadeInFE("", "smile", 1.0, 0.4, 0)
--	FadeInFE("", "phon_O", 1.0, 0.4, 1)
--	FadeInFE("", "phon_E", 1.0, 0.5, 1)
--	FadeInFE("", "phon_A", 1.0, 0.7, 1)
--	-- BaseFE("", "none", 1.0, 0.3)
--	emotes_TalkIdle()
--	emotes_TalkIdle()
--	emotes_TalkIdle()

	while true do
		emotes_TalkIdle()
	end
end

function TEST2()
	FadeOutAllFE("", 0)
	FadeInFE("", "sad", 1.0, 0.4, 0)
	Sleep(0.5)
	FadeOutFE("", "sad", 1.0, 0.3)
end
-- ***********************************
