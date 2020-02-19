function Run()

        if GetImpactValue("Destination",391) >= 5 then
	        local k = 3
			if GetImpactValue("Destination",391) >= 8 then
			    k = 4
			end
		    MsgNewsNoWait("Owner","Destination","","default",-1,"@L_HPFZ_STATE_GEBBAU_FEHLER_+2",
	                    "@L_HPFZ_STATE_GEBBAU_FEHLER_+"..k)
            StopMeasure()						
		else
           MeasureRun("Owner","Destination","BauArbeitMeasure",true)
		end

end
