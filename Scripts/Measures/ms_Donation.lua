--- Raise your favor by making a donation to the poor people.

function Init()

	local SimMoney = GetMoney("")
	local SimTitle = GetNobilityTitle("")
	local SimAlignment = SimGetAlignment("")

	if SimTitle <3 then
		MsgBox("","","","@L_GENERAL_ERROR_HEAD_+0","@L_MEASURES_DONATION_FAIL_+0")
		StopMeasure()
	end

	local TitleMoney
	if SimTitle ==3 then
		TitleMoney = 5000
	elseif SimTitle ==4 then
		TitleMoney = 7500
	elseif SimTitle ==5 then 
		TitleMoney = 10000
	elseif SimTitle ==6 then
		TitleMoney = 15000
	elseif SimTitle ==7 then
		TitleMoney = 20000
	elseif SimTitle ==8 then
		TitleMoney = 30000
	elseif SimTitle ==9 then
		TitleMoney = 50000
	else
		TitleMoney = 100000
	end


	if SimMoney <TitleMoney then
		MsgBox("","","","@L_GENERAL_ERROR_HEAD_+0","@L_MEASURES_DONATION_FAIL_+1")
		StopMeasure()
	end
	
	local Choice1 = (0.10 * SimMoney)*(1+(SimAlignment/100))
	local Choice2 = (0.25 * SimMoney)*(1+(SimAlignment/100))
	local Choice3 = (0.50 * SimMoney)*(1+(SimAlignment/100))
	
	local Button1 = "@B[1,@L%1t,@L_MEASURES_DONATION_SCREENPLAY_ACTOR_CHOICE_+0,Hud/Buttons/btn_Money_Small.tga]"
	local Button2 = "@B[2,@L%2t,@L_MEASURES_DONATION_SCREENPLAY_ACTOR_CHOICE_+1,Hud/Buttons/btn_Money_Medium.tga]"
	local Button3 = "@B[3,@L%3t,@L_MEASURES_DONATION_SCREENPLAY_ACTOR_CHOICE_+2,Hud/Buttons/btn_Money_Large.tga]"

	MsgMeasure("","")
	local result = InitData("@P"..
	Button1..
	Button2..
	Button3,
	ms_donation_InitDonation,
	"@L_MEASURES_DONATION_HEAD_+0","@L_MEASURES_DONATION_BODY_+0",Choice1,Choice2,Choice3)
	
	if result==1 then
		SetData("DMoney", Choice1)
		SetData("DFavor", 3)
	elseif result==2 then
		SetData("DMoney", Choice2)
		SetData("DFavor", 6)
	elseif result==3 then
		SetData("DMoney", Choice3)
		SetData("DFavor", 12)
	end

end

function InitDonation()
	return "1"
end

function Run()

	local MeasureID = GetCurrentMeasureID("")
	local TimeOut	= mdata_GetTimeOut(MeasureID)

	if not HasData("DMoney") then
		StopMeasure()
	end

	local Donation = 0 + GetData("DMoney")

	if GetMoney("") < Donation then
		MsgBox("","","","@L_GENERAL_ERROR_HEAD_+0","@L_MEASURES_DONATION_FAIL_+1")
		return
	end	
	
	if(f_SpendMoney("",Donation,"misc")) then
	
		local ModifyFavor = 0 + GetData("DFavor")
		
		MeasureSetNotRestartable()
		SetMeasureRepeat(TimeOut)
		CommitAction("donation","","","")

		GetDynasty("", "dynasty")
		local iCount = ScenarioGetObjects("Dynasty", 50, "Dynasties")
		
		if iCount==0 then
			return
		end
	
		for dyn=0, iCount-1 do
			Alias = "Dynasties"..dyn
			if not (GetID(Alias)==GetID("dynasty")) then
				if GetFavorToDynasty("dynasty",Alias)>10 and GetFavorToDynasty("dynasty",Alias)<70 then
					ModifyFavorToDynasty("dynasty",Alias,ModifyFavor)
				end
			end
		end
	
		MsgBoxNoWait("","",
		"@L_MEASURES_Donation_MSG_HEAD_+0",
		"@L_MEASURES_Donation_MSG_BODY_+0",Donation)
		
		chr_GainXP("",GetData("BaseXP"))
		StopAction("donation","")
	end
end

function CleanUp()
	StopAction("donation","")
	StopMeasure()
end
	
function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end