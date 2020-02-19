function Init()
	local Type = CartGetType("")
	 
	-- crew
	AddImpact("","ShipMenMod",1,-1) -- 1 for normal, 1.50 for  cutlass, 2.00 for muskets

	-- armament
	AddImpact("","ShipCannonMod",1,-1) -- 1 for none, 1.25 for light, 1.50 for medium, 2.00 for heavy
	AddImpact("","ShipHitpointMod",1,-1) -- 1 for none, 1.25 for light, 1.50 for medium, 2.00 for heavy

	-- further properties
	AddObjectDependendImpact("","-667","MoveSpeed",1) -- 1 for none, 1.15 for sails
	AddObjectDependendImpact("","-1498712347","RotSpeed",1) -- 1 for none, 1.15 for compass
	
	SetProperty("","ShipMenCnt", 0)  -- 0 usual, up to ShipMenCntMax

	if Type==EN_CT_FISHERBOOT then
		initship_Fisherboot()
	elseif Type==EN_CT_MERCHANTMAN_SMALL then
		initship_MerchmantmanSmall()
	elseif Type==EN_CT_MERCHANTMAN_BIG then
		initship_MerchmantmanBig()
	elseif Type==EN_CT_WARSHIP then
		initship_Warship()
	elseif Type==EN_CT_CORSAIR then
		initship_Corsair()
	end

end

function Fisherboot()

	-- crew
	SetProperty("","ShipMenCntMax", 0)

	-- armament
	SetProperty("","ShipCannonCntBase", 0)
	SetProperty("","ShipHitpointBase", 100)
	
	-- store capacity
	AddImpact("","BonusSlot",1,-1)
	AddImpact("","BonusSpace",10,-1)
end

function MerchmantmanSmall()
	-- crew
	SetProperty("","ShipMenCntMax", 40)
	SetProperty("","ShipMenCnt",10)
	-- armament
	SetProperty("","ShipCannonCntBase", 10)
	SetProperty("","ShipHitpointBase", 250)
	
	-- store capacity
	AddImpact("","BonusSlot",5,-1)
	AddImpact("","BonusSpace",30,-1)
end


function MerchmantmanBig()
	-- crew
	SetProperty("","ShipMenCntMax", 60)
	SetProperty("","ShipMenCnt",10)
	-- armament
	SetProperty("","ShipCannonCntBase", 15)
	SetProperty("","ShipHitpointBase", 500)
	
	-- store capacity
	AddImpact("","BonusSlot",6,-1)
	AddImpact("","BonusSpace",40,-1)
end

function Warship()
	-- crew
	SetProperty("","ShipMenCntMax", 150)
	SetProperty("","ShipMenCnt",10)
	-- armament
	SetProperty("","ShipCannonCntBase", 30)
	SetProperty("","ShipHitpointBase", 1000)
	
	-- store capacity
	AddImpact("","BonusSlot",1,-1)
	AddImpact("","BonusSpace",10,-1)
end

function Corsair()
	-- crew
	SetProperty("","ShipMenCntMax", 120)
	SetProperty("","ShipMenCnt",10)
	-- armament
	SetProperty("","ShipCannonCntBase", 25)
	SetProperty("","ShipHitpointBase", 1000)
	
	-- store capacity
	AddImpact("","BonusSlot",2,-1)
	AddImpact("","BonusSpace",10,-1)
end



