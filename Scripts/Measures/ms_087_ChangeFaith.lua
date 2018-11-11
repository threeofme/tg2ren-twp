function AIDecide()
	return 1
end

function Run()
	if GetInsideBuilding("","church") then
		local ChurchReligion = BuildingGetReligion("church")
		local SimReligion = SimGetReligion("")
		local Prefix
		local MeasureID = GetCurrentMeasureID("")
		local TimeOut = mdata_GetTimeOut(MeasureID)
		local Church = GetDynastyID("church")
		local Infidel = GetDynastyID("")
		
		--if inquisition is running, changing faith is not possible because of exploit
		if HasProperty("","InquisitionRunning") then
			--@T text todo: failure message: Glaubenswechsel nicht moeglich. Ihr führt gerade eine Inquisition durch
			StopMeasure()
		end
		
		if (ChurchReligion==0) then
			Prefix = "@L_CHURCH_087_CHANGEFAITH_".."CATHOLIC_"
		elseif (ChurchReligion==1) then
			Prefix = "@L_CHURCH_087_CHANGEFAITH_".."PROTESTANT_"
		else 
			return
		end
	
		local Cost = 100
	 	
		if not (Church == Infidel) then
			if IsPartyMember("") then
				local Result = MsgNews("","","@P"..
					"@B[1,"..Prefix.."BTN_+0]"..
					"@B[2,"..Prefix.."BTN_+1]",
					ms_087_ChangeFaith_AIDecide,
					"default",0,
					"@L_CHURCH_087_CHANGEFAITH_+0",
					""..Prefix.."DESCRIPTION",Cost)
		
				else if (Result==2) or (Result=="C") then
					return
				end
			end
		
		else local Result = MsgNews("", "", "@P"..
					"@B[1,"..Prefix.."BTN_+0]"..
					"@B[2,"..Prefix.."BTN_+1]",
					ms_087_ChangeFaith_AIDecide,
					"default", 0,
					"@L_CHURCH_087_CHANGEFAITH_+0",
					""..Prefix.."DESCRIPTIONFAMILY")
				if (Result==2) or (Result=="C") then
					return
				end
			
		end
		-- Do the visual Stuff
		if GetFreeLocatorByName("church","ChangeFaith",-1,-1,"ChangeFaithPos") then
			f_BeginUseLocator("","ChangeFaithPos",GL_STANCE_STAND,true)
			SetData("Blocked",1)
			PlayAnimation("","manipulate_middle_twohand")
			f_EndUseLocator("","ChangeFaithPos",GL_STANCE_STAND)
			SetData("Blocked",0)
		end

		if (ChurchReligion~=SimReligion) then
			if Church ~= Infidel then
				if DynastyIsPlayer("") then
					if not SpendMoney("",100,"Credit") then
						MsgQuick("","@L_GENERAL_INFORMATION_INVENTORY_NOT_ENOUGH_MONEY")
						StopMeasure()
					else
						CreditMoney("church",100,"misc")
						economy_UpdateBalance("church", "Service", 100)
						feedback_MessagePolitics("",""..Prefix.."MSG_HEAD",""..Prefix.."MSG_BODY",GetID(""),GetID("church"))
						SetMeasureRepeat(TimeOut)
						chr_GainXP("",GetData("BaseXP"))
					end
				end
			end
			Sleep(0.8)
			SimSetReligion("",ChurchReligion)
			SimSetFaith("",50)
			GetPosition("","ParticleSpawnPos")
			StartSingleShotParticle("particles/pray_glow.nif","ParticleSpawnPos",1,4)
			if ChurchReligion == 0 then
				ShowOverheadSymbol("Owner",false,true,0,"@L$S[2015]")
			else
				ShowOverheadSymbol("Owner",false,true,0,"@L$S[2014]")
			end
		else
			MsgDebugMeasure("Wrong Religion - this measure should not be accessible !!!")
		end

		
	end
	StopMeasure()
end

function CleanUp()
	StopAnimation("")
	if GetData("Blocked")==1 then
		f_EndUseLocator("","ChangeFaithPos",GL_STANCE_STAND)
	end

end

function GetOSHData(MeasureID)
	--can be used again in:
	OSHSetMeasureRepeat("@L_ONSCREENHELP_7_MEASURES_TIMEINFOS_+2",Gametime2Total(mdata_GetTimeOut(MeasureID)))
end

