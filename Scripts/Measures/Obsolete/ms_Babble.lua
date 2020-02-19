-- -----------------------
-- alles für die Needs: Labern was das Zeug hält - 
-- -----------------------
function Run()
	if not AliasExists("Destination") then

		local TalkPartners = Find("", "__F((Object.GetObjectsByRadius(Sim)==2000)AND NOT(Object.GetStateImpact(no_idle))AND(Object.CanBeInterrupted(Babble))AND NOT(Object.HasDynasty()))","Destination", -1)
		if (TalkPartners == 0) then
			return
		end
		CopyAlias("Destination"..Rand(TalkPartners), "Destination")

	end

	if not ai_StartInteraction("", "Destination", 350, 90) then
		StopMeasure()
	end
	
	SetAvoidanceGroup("", "Destination")
	SetData("StartAnim", 1)
	if SimGetGender("")==GL_GENDER_MALE then
		PlaySound3DVariation("","CharacterFX/male_neutral",1)
	else
		PlaySound3DVariation("","CharacterFX/female_neutral",1)
	end
	PlayAnimationNoWait("", "talk")
	Sleep(1.0)
	if SimGetGender("Destination")==GL_GENDER_MALE then
		PlaySound3DVariation("Destination","CharacterFX/male_neutral",1)
	else
		PlaySound3DVariation("Destination","CharacterFX/female_neutral",1)
	end
	PlayAnimation("Destination", "talk")

--	if not IsDynastySim("") and not IsDynastySim("Destination") then
--		local TalkPartners = Find("", "__F( (Object.GetObjectsByRadius(Sim) == 400)","Destination", -1)
--		if TalkPartners == 0 then
--			return
--		end
--		local i
--		for i=0,TalkPartners-1 do
--			Alias = "Destination"..i
--			Talk("", Alias)
--			Talk(Alias, "")
--		end
--	else
--		Talk("", "Destination")
--	end

	SatisfyNeed("", 3, 1.0)
	SatisfyNeed("Destination", 3, 1.0)

end

function CleanUp()
	if GetData("StartAnim")==1 then
		if AliasExists("Destination") then
			StopAnimation("Destination")
		end
		StopAnimation("")
	end
	
	ReleaseAvoidanceGroup("")
end

