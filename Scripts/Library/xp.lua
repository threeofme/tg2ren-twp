-- -----------------------
-- Init
-- -----------------------
function Init()
 --needed for caching
end

-- ------------------
-- AttackEnemy
-- ------------------
function AttackEnemy(Owner, OwnLevel, EnemyLevel)
	if AliasExists(Owner) then
		IncrementXP(Owner, (EnemyLevel - OwnLevel + 10) * 5)
	end
end

-- ------------------
-- BlackmailCharacter
-- ------------------
function BlackmailCharacter(Owner, BaseXP, EvidenceCount)
	if AliasExists(Owner) then
		IncrementXP(Owner, BaseXP + EvidenceCount * 10)
	end
end

-- ------------------
-- BuyNobilityTitle
-- ------------------
function BuyNobilityTitle(Owner, BaseXP, Title)
	local GainXP = BaseXP + Title * 25 
	if AliasExists(Owner) then
		local Count = DynastyGetMemberCount(Owner)
		for i=0,Count-1 do
			if DynastyGetMember(Owner, i, "Member") then
				IncrementXP("Member", GainXP)
			end
		end
	end
end

-- ------------------
-- CaptureBuilding
-- ------------------
function CaptureBuilding(Owner, BaseXP, BuildingLevel)
	if AliasExists(Owner) then
		IncrementXP(Owner, BaseXP + BuildingLevel * 50)
	end
end

-- ------------------
-- CohabitWithCharacter
-- ------------------
function CohabitWithCharacter(Owner, ChildCount)
	if AliasExists(Owner) then
		if ChildCount == 0 then
			IncrementXP(Owner, 150)
		else
			IncrementXP(Owner, 100)
		end
	end
end

-- ------------------
-- CourttingSuccess
-- ------------------
function CourttingSuccess(Owner, Difficulty, Ceremony)
	if AliasExists(Owner) then
		if Difficulty < 4 then
			if Ceremony == 1 then
				IncrementXP(Owner, 500)
			else
				IncrementXP(Owner, 250)
			end
		elseif Difficulty < 7 then
			if Ceremony == 1 then
				IncrementXP(Owner, 1000)
			else
				IncrementXP(Owner, 500)
			end
		elseif not Difficulty == nil then
			if Ceremony == 1 then
				IncrementXP(Owner, 1500)
			else
				IncrementXP(Owner, 750)
			end
		end
	end
end

-- ------------------
-- BuildBuilding
-- ------------------
function BuildBuilding(Owner, Level)
	if AliasExists(Owner) then
		IncrementXP(Owner, 250 + Level * 250)
	end
end

-- ------------------
-- RunForAnOffice
-- ------------------
function RunForAnOffice(Owner, OfficeLevel)
	if AliasExists(Owner) then
		IncrementXP(Owner, OfficeLevel * 75)
	end
end

-- ------------------
-- DuelWithOpponent
-- ------------------
function DuelWithOpponent(Owner, Won, Difficulty)
	local XP = 100
	-- 25 bonus or malus depending on difficulty
	XP = XP + 25*Difficulty
		
	if XP < 25 then
		XP = 25
	end
	
	
	if AliasExists(Owner) then
		if Won == true then -- The owner won the duel
			XP = XP*3
			IncrementXP(Owner, XP)
		else -- It´s a draw
			IncrementXP(Owner, XP)
		end
	end
end

-- ------------------
-- ChargeCharacter
-- ------------------
function ChargeCharacter(Owner, SentenceLevel)
	if AliasExists(Owner) then
		IncrementXP(Owner, SentenceLevel * 75)
	end
end

-- ------------------
-- OrderASabotage
-- ------------------
function OrderASabotage(Owner, BaseXP)
	if AliasExists(Owner) then
		IncrementXP(Owner, BaseXP)
	end
end

-- ------------------
-- LevelUpBuilding
-- ------------------
function LevelUpBuilding(Owner, Level)
	if AliasExists(Owner) then
		IncrementXP(Owner, 250 + Level * 250)
	end
end

-- ------------------
-- ApplyDeposition
-- ------------------
function ApplyDeposition(Owner, OfficeLevel)
	if AliasExists(Owner) then
		IncrementXP(Owner, OfficeLevel * 100)
	end
end

-- ------------------
-- BurgleAHouse
-- ------------------
function BurgleAHouse(Owner, BuildingLevel)
	if AliasExists(Owner) then
		IncrementXP(Owner, BuildingLevel * 50)
	end
end

-- ------------------
-- HijackCharacter
-- ------------------
function HijackCharacter(Owner, Level)
	if AliasExists(Owner) then
		IncrementXP(Owner, Level * 50)
	end
end

-- ------------------
-- WaylayForBooty
-- ------------------
function WaylayForBooty(Owner, ItemValue)
	if AliasExists(Owner) then
		local xp = ItemValue / 5
		if xp > 1000 then
			xp = 1000
		end
		IncrementXP(Owner, xp)
	end
end


-- ------------------
-- School
-- ------------------
function School(Owner)
	IncrementXP(Owner, 1000)
end


function Apprenticeship(Owner)
--	if SimGetClass(Owner)~=3 then
		IncrementXP(Owner, 500)
--	end
end

function University(Owner)
	IncrementXP(Owner, 1000)
end

function Doctor(Owner)
	IncrementXP(Owner, 1000)
end

