function Run()

	local NeedEat = SimGetNeed("Destination",1)
	local NeedPleasure = SimGetNeed("Destination",2)
	local NeedTalk = SimGetNeed("Destination",3)
	local NeedFaith = SimGetNeed("Destination",4)
	local NeedCuriosity = SimGetNeed("Destination",5)
	local NeedIllness = SimGetNeed("Destination",6)
	local NeedKonsum = SimGetNeed("Destination",7)
	local NeedDrinking = SimGetNeed("Destination",8)
	local NeedFinancial = SimGetNeed("Destination",9)
	
--	MsgNewsNoWait("","Destination","","intrigue",-1,"@L_MEASURE_ASKNEEDS_HEAD_+0", "@L_MEASURE_ASKNEEDS_BODY_+0",GetID("Destination"),
--	NeedEat, NeedPleasure, NeedTalk, NeedFaith, NeedCuriosity, NeedIllness, NeedKonsum, NeedDrinking, NeedFinancial)

	MsgBoxNoWait("","Destination","@L_MEASURE_ASKNEEDS_HEAD_+0", "Need Eat: "..
	NeedEat.."$NNeed Pleasure: "..NeedPleasure.."$N Need Talk: "..NeedTalk.."$N Need Faith: "..NeedFaith.."$N Need Curiosity: "..NeedCuriosity.."$N Need Illness: "..NeedIllness.."$N Need Konsum: "..NeedKonsum.."$N Need Drinking: "..NeedDrinking.."$N Need Financial: "..NeedFinancial)

end
