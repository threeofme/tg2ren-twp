
function Run()
	if IsStateDriven() then
		if (HasProperty("","HaveCutscene") == true) then
			return
		end		
		local ItemName = "TarotCards"
		if GetItemCount("", ItemName, INVENTORY_STD)==0 then
			if not ai_BuyItem("", ItemName, 1, INVENTORY_STD) then
				return
			end
		end
	end

	local MeasureID = GetCurrentMeasureID("")
	local duration = mdata_GetDuration(MeasureID)
	local TimeOut = mdata_GetTimeOut(MeasureID)

	--play animation
	local Time
	Time = PlayAnimationNoWait("","use_object_standing")
	Sleep(1)
	PlaySound3D("","Locations/wear_clothes/wear_clothes+1.wav", 1.0)
	Sleep(1)
	
	if RemoveItems("","TarotCards",1)>0 then	
		SetRepeatTimer("", GetMeasureRepeatName2("UseTarotCards"), TimeOut)

		local fate
		local tarot = Rand(3)
		local getxp = 0
		local skill = GetSkillValue("",SECRET_KNOWLEDGE) + 1
		if skill < 3 then
			fate = Rand(9)+2
		elseif skill < 7 then
			fate = Rand(8)+3
		else
			fate = Rand(7)+4
		end
		
		if fate<6 then
			if tarot==0 then
			  MsgNewsNoWait("","","","default",-1,
			  	"@L_RANDOM_EVENT_NEGATIV_MESSAGE_HEAD_+2",
			    "@L_TAROTCARDS_FATE_NEGATIV_+0")
				local fame = chr_SimGetFameLevel("")
				chr_SimRemoveFame("",fame)
			elseif tarot==1 then
			  MsgNewsNoWait("","","","default",-1,
			  	"@L_RANDOM_EVENT_NEGATIV_MESSAGE_HEAD_+2",
			    "@L_TAROTCARDS_FATE_NEGATIV_+1")
				local fame = chr_SimGetImperialFameLevel("")
				chr_SimRemoveImperialFame("",fame)
			else
				local cash = GetMoney("") / 25
			  MsgNewsNoWait("","","","default",-1,
			  	"@L_RANDOM_EVENT_NEGATIV_MESSAGE_HEAD_+2",
			    "@L_TAROTCARDS_FATE_NEGATIV_+3",cash)
				f_SpendMoney("", cash, "CostSocial")	
			end
		else
			if tarot==0 then
			  MsgNewsNoWait("","","","default",-1,
			  	"@L_RANDOM_EVENT_POSITIV_MESSAGE_HEAD_+2",
			    "@L_TAROTCARDS_FATE_POSITIV_+0")
				local fame = 6 - chr_SimGetFameLevel("")
				chr_SimAddFame("",fame)
			elseif tarot==1 then
			  MsgNewsNoWait("","","","default",-1,
			  	"@L_RANDOM_EVENT_POSITIV_MESSAGE_HEAD_+2",
			    "@L_TAROTCARDS_FATE_POSITIV_+1")
				local fame = 6 - chr_SimGetImperialFameLevel("")
				chr_SimAddImperialFame("",fame)
			else
			  MsgNewsNoWait("","","","default",-1,
			  	"@L_RANDOM_EVENT_POSITIV_MESSAGE_HEAD_+2",
			    "@L_TAROTCARDS_FATE_POSITIV_+2",GetID(""))
			  getxp = (Rand(200) + 1) - (SimGetLevel("") * 10)
			end
		end
		
		chr_GainXP("",GetData("BaseXP")+getxp)
	end
	StopMeasure()
end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
	--active time:
	--OSHSetMeasureRuntime("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+0",Gametime2Total(mdata_GetDuration(MeasureID)))
end

function CleanUp()
	
end
