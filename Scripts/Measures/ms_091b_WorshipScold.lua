function Run()
	if not AliasExists("Destination") then
		StopMeasure()
	end
	local MeasureID = GetCurrentMeasureID("")
	local TimeOut = mdata_GetTimeOut(MeasureID)
	SetRepeatTimer("", GetMeasureRepeatName2("WorshipPraise"), TimeOut)
	SetRepeatTimer("", GetMeasureRepeatName2("WorshipScold"), TimeOut)
	
	if (GetInsideBuilding("","church")) then
		if GetImpactValue("church","MassInProgress")==0 then
			AddImpact("church","MassInProgress",1,1)
		end
		SetProperty("church", "MassInProgress", GetID(""))
		PlayAnimationNoWait("","threat")
		MsgSay("","@L_CHURCH_091_PREPAREWORSHIP_WORSHIPPING_DENUNCIATE_INTRO")
		PlayAnimationNoWait("","propel")
		MsgSay("","@L_CHURCH_091_PREPAREWORSHIP_WORSHIPPING_DENUNCIATE_MAINPART",GetID("Destination"))
		BuildingGetOwner("church","MrChurch")
		BuildingGetInsideSimList("church","sims_in_church")
		ListRemove("sims_in_church", "")
		ListRemove("sims_in_church", "MrChurch")
		feedback_MessageCharacter("Destination","@L_CHURCH_091_PREPAREWORSHIP_SCOLD_HEAD_+0",
							"@L_CHURCH_091_PREPAREWORSHIP_SCOLD_BODY_+0",GetID("Destination"),GetID("church"),GetID("MrChurch"))
		local PreacherSkill = GetSkillValue("",RHETORIC)
		for i=0,ListSize("sims_in_church")-1,1 do
			ListGetElement("sims_in_church",i,"receiver")
			
--			if GetID("destination")~=GetID("receiver") then
--			
--				if CheckSkill("",7,GetSkillValue("",7,GetFavorToSim("receiver","")/10)) then
			chr_ModifyFavor("receiver","MrChurch",(-2-PreacherSkill))
--					chr_ModifyFavor("receiver","destination",-10)
--				else
--					chr_ModifyFavor("receiver","MrChurch",-5)
--				end
				
--			else
--			end
		end
		chr_ModifyFavor("destination","MrChurch",(-4-PreacherSkill))
	end
end

function CleanUp()
	StopAnimation("")
	if GetID("church")~=-1 then
		RemoveProperty("church", "MassInProgress")
		RemoveImpact("church","MassInProgress")
	end
	MeasureRun("", 0, "PrepareWorship",true)
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

