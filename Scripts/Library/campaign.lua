------------------------------------------------------------------------
---- This library offers a number of special functions for the campaign
------------------------------------------------------------------------
function Init()

end


---- check all inventories for if there is any item left
function CheckStock()

	local ObjCount = 0

	for i=1, 249 do
		ObjCount = ObjCount + GetItemCount("#Duncan",i) + GetItemCount("#Residence",i) + GetItemCount("#Smithy",i)
	end

	local CartCount = BuildingGetCartCount("#Smithy")

	if CartCount>0 then
		for i=0, CartCount-1 do
			if BuildingGetCart("#Smithy", CartCount-1, "Cart") then
				for i=1, 249 do
					ObjCount = ObjCount + GetItemCount("Cart",i)
				end
			end
		end
	end

	local CartCount = BuildingGetCartCount("#Residence")

	if CartCount>0 then
		for i=0, CartCount-1 do
			if BuildingGetCart("#Smithy", CartCount-1, "Cart") then
				for i=1, 249 do
					ObjCount = ObjCount + GetItemCount("Cart",i)
				end
			end
		end
	end

	if ObjCount>0 then
		return true
	else
		return false
	end
	
end

-- check if the character is dead
function CheckDead(char)

	if not(AliasExists(char)) then
		return true
	end

	if GetState(char, STATE_DEAD) then
		return true
	end
	
	if GetState(char, STATE_UNCONSCIOUS) then
		SimSetMortal(char, true)
		Kill(char)
		return true
	end
	
	return false

end


function CheckDayTime()

	local time = math.mod(GetGametime(),24)

	if time >= 8 and time < 20 then
		return true
	else
		return false
	end

end


-- create an evidence against Lambert Parmiter in chapter 4
function CreateEvidence(offender, target)

	local victim = -1
	local target1 = -1
	local target2 = -1
	
	local num = Find("#Market", "__F( (Object.GetObjectsByRadius(Sim)==10000)AND NOT(Object.IsDynastySim()))","found", -1)
	if num>0 then
		for i=0,num-1 do
			if not(GetDynastyID("found"..i) == GetDynastyID(offender)) and not(GetDynastyID("found"..i)==GetDynastyID("#Duncan")) and not(GetState("found"..i, STATE_NPC)) then
				if victim == -1 then
					victim = i
				elseif target1 == -1 then
					target1 = i
				elseif target2 == -1 then
					target2 = i
				end
				
				if (victim > -1) and (target1 > -1) and (target2 > -1) then
					break
				end
			end
		end
	end
	
	if (victim < 0) and (target1 < 0) and (target2 < 0) then
		return false
	end

	local random = Rand(3)

	if random == 0 then --POISON
		if not target then
			AddEvidence("found"..target1, offender, "found"..victim, 11)
			Talk("found"..target1, "found"..target2)
		else
			AddEvidence(target, offender, "found"..victim, 11)
		end
	elseif random == 1 then --MURDER
		if not SimCreate(17, "#Capital", "#ResidenceLambert", "PoorVictim") then
			return "unable to create sim to kill (campaign_CreateEvidence)"
		end
		if not target then
			AddEvidence("found"..target1, offender, "PoorVictim", 16)
			Talk("found"..target1, "found"..target2)
		else
			AddEvidence(target, offender, "found"..victim, 11)
		end
		Kill("PoorVictim")
	elseif random == 2 then --ATTACKCIVILIAN
		if not target then
			AddEvidence("found"..target1, offender, "found"..victim, 18)
			Talk("found"..target1, "found"..target2)
		else
			AddEvidence(target, offender, "found"..victim, 11)
		end
	end
	return true
		
end


