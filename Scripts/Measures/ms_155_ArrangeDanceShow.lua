-------------------------------------------------------------------------------
----
----	OVERVIEW "ms_155_ArrangeDanceShow"
----
----	with this measure the player can let the worker at the tavern dance
----
-------------------------------------------------------------------------------

-- -----------------------
-- Run
-- -----------------------
function Run()
	if not SimGetWorkingPlace("","Tavern") then
		if IsPartyMember("") then
			--if SimGetGender("") == GENDER_FEMALE then
				if not GetInsideBuilding("","CurrentBuilding") then
					StopMeasure()
				end
				if BuildingGetType("CurrentBuilding")==GL_BUILDING_TYPE_TAVERN then
					CopyAlias("CurrentBuilding","Tavern")
				else
					StopMeasure()
				end
		--	else 
			--	MsgQuick("","@L_DANCE_FAILURE_+0")
			--	StopMeasure()
				
			--end
		else
			StopMeasure()
		end
	end

	if HasProperty("Tavern", "DanceShow") then
		MsgQuick("", "@L_TAVERN_155_ARRANGEDANCESHOW_FAILURES_+0",GetID(""))
		return
	end
	
	-- Set this property so that the filter for the measure can check if a dance show is in progress so that only one worker will dance
	GetInsideBuilding("", "Tavern")

	SetData("RemoveProperty", 1)
	SetProperty("Tavern", "DanceShow", 1)
	
	local MeasureID = GetCurrentMeasureID("")
	-- Duration of the danceshow
	local DurationInGameHours = mdata_GetDuration(MeasureID)
	-- The time in gametime-hours until the measure can be repeated
	local TimeUntilRepeat = mdata_GetTimeOut(MeasureID)
	
	-- Set (in gametime minutes) how often the guests will probably consume additional drinks due to the amusement
	local GuestComsumePeriod = 20
	
	-- Set the chance for guests which have the same sex as the dancer for buying a drink every "GuestComsumePeriod"
	local ConsumeChanceSameSex = 50
	
	-- Set the chance for guests which have the different sex than the dancer for buying a drink every "GuestComsumePeriod"
	local ConsumeChanceDifferentSex = 80
	
	-- The gender of the dancer
	local DancerGender = SimGetGender("")
	
	local ConsumePeriodStartTime = 0
	local TimeStep = 1
	
	-- Look out for the dance position
	if not GetLocatorByName("Tavern", "Dance1", "DancingPosition") then
		return
	end
	
	SetData("IsProductionMeasure", 1)
	MeasureSetStopMode(STOP_CANCEL)
	-- move to dance position
	f_BeginUseLocator("", "DancingPosition", GL_STANCE_STAND, true)
	SetData("DanceLocatorInUse", 1)
	
	-- Indicates if a dance animation is played
	local IsDancing = false
	
	-- Number of guests during dance show
	local guests = 0
	
	-- Number of turns the script is running
	local turns = 0
	
	local CurrentTime = GetGametime()
	local EndTime = CurrentTime + DurationInGameHours
	local GameTimeStep = Realtime2Gametime(TimeStep)	
	local AnimationEndTime = 0
	local DanceName = ""
	ConsumePeriodStartTime = CurrentTime
	
	-- Get the gender of the dancer
	local Gender = 0
	if SimGetGender("") == GL_GENDER_MALE then
		Gender = 1
	end
	
	PlaySound3D("","Locations/tavern/tavern_aah_01.wav",1)
	
	-- dance loop
	while CurrentTime < EndTime do
	
		turns = turns + 1
	
		CurrentTime = GetGametime()

		-- start a new dance animation if not dancing
		if IsDancing == false then
			
			-- Start the next dance
			if Gender == 0 then
				DanceName = "dance_female_"..Rand(2)+1
			else
				DanceName = "dance_male_"..Rand(2)+1
			end
		
			AnimationLength = Realtime2Gametime(GetAnimationLength("", DanceName))
			AnimationEndTime = CurrentTime + AnimationLength

			if AnimationEndTime > EndTime then
				-- the next dance anim would last longer than the measure. Do nothing or play a bow-animation.
				PlayAnimationNoWait("", "bow")
				IsDancing = true
			else
				PlayAnimationNoWait("", DanceName)
				IsDancing = true
			end
		end

		-- check if the dance animation still lasts
		if CurrentTime >= AnimationEndTime then
			IsDancing = false
		end

		-- Do timing corrections if the next timestep would be longer than the dance show should last
		if (CurrentTime + GameTimeStep) > EndTime then
			TimeStep = EndTime - CurrentTime
			CurrentTime = CurrentTime + 1
		end
		
		-- Increase the amusement if the period is over
		if CurrentTime >= ConsumePeriodStartTime  then
			Count = BuildingGetSimCount("Tavern")
			
			for l=0,Count do
				if BuildingGetSim("Tavern", l, "Guest") then
			
						-- consume drinks by chance				
						if not (GetDynastyID("Tavern") == GetDynastyID("Guest")) then
							guests = guests + 1
			
							if DancerGender == SimGetGender("Guest") then
								if Rand(100) < ConsumeChanceSameSex then
									SimConsumeGoods("Guest", true, 0)
									ms_155_arrangedanceshow_CommentSameGender("Guest")
								end
							else
								if Rand(100) < ConsumeChanceDifferentSex then								
									SimConsumeGoods("Guest", true, 0)
									ms_155_arrangedanceshow_CommentDifferentGender("Guest")
								end
							end
							
						end
											
					--end
				end
			end
			
			ConsumePeriodStartTime = CurrentTime + (GuestComsumePeriod / 60)
		end
		
		Sleep(TimeStep)
		
	end

	if guests == 0 then
		feedback_MessageWorkshop("Owner", 
			"@L_TAVERN_155_ARRANGEDANCESHOW_MSG_SUCCESS_HEAD_+0", 
			"@L_TAVERN_155_ARRANGEDANCESHOW_MSG_SUCCESS_BODY_+0", GetID("Owner"), GetID("Tavern"))
	else
		feedback_MessageWorkshop("Owner", 
			"@L_TAVERN_155_ARRANGEDANCESHOW_MSG_FAILED_HEAD_+0", 
			"@L_TAVERN_155_ARRANGEDANCESHOW_MSG_FAILED_BODY_+0", GetID("Owner"), GetID("Tavern"), guests)
	end
	
	SetMeasureRepeat(TimeUntilRepeat)
		
end

-- -----------------------
-- The comment during the dance show if the character has the same gender as the dancer
-- -----------------------
function CommentSameGender(Guest)
	local random = Rand(2)

	if random == 1 then
--		feedback_OverheadComment(Guest, "nice show", false, true)
	else
--		feedback_OverheadComment(Guest, "the show is nice", false, true)
	end

end

-- -----------------------
-- The comment during the dance show if the character has the same gender as the dancer
-- -----------------------
function CommentDifferentGender(Guest)
	local random = Rand(2)

	if random == 1 then
--		feedback_OverheadComment(Guest, "great show", false, true)
	else
--		feedback_OverheadComment(Guest, "the show is great", false, true)
	end

end

-- -----------------------
-- CleanUp
-- -----------------------
function CleanUp()
	StopAnimation("")
	if HasData("RemoveProperty") then
		-- Remove the property so that another worker will now be able to start a new dance
		RemoveProperty("Tavern", "DanceShow")
	end
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end