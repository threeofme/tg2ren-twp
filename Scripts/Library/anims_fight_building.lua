function Init()
 --needed for caching
end

function AttackRangedVisual(SoundType)
	--started when a projectile is fired
	
	local ShootAngle = 45 
	local Shootrange = 5000
	local side = -1
	--local angle = GetRotation("","Destination") - ObjectGetRotationY("")
	local angle = 90
		 
	if angle <= 0 then
		angle = 360 + angle
	end

	if angle > 180 then
		angle = 360 - angle
		side = -1
	end
		
	if not ((angle < (90 + ShootAngle / 2)) and (angle > (90 - ShootAngle / 2))) then
		StopMeasure()
	end

	local DelayTime = 0.3
	GetPosition("","BuildingPos")
	
	local BuildingLevel = BuildingGetLevel("")
	local NumShots = BuildingLevel

	local OffsetArray = 	{
				0,400*BuildingLevel,0,1,
				-100,400*BuildingLevel,100,1,
				100,400*BuildingLevel,-100,1,
				}
	
	local rotation = (ObjectGetRotationY("") / 360) * (2 * math.pi)
	local tx
	local ty
	local tz
	
	tx,ty,tz = PositionGetVector("BuildingPos") 
	local size = 2
	
	for i=0,NumShots-1 do
		local Gun = Rand(NumShots)
		while OffsetArray[(Gun*4)+4] == 0 do
			Gun = Gun + 1
			if Gun >= NumShots then
				Gun = 0
			end
		end
		local nx = (OffsetArray[(Gun*4)+1]*side) * math.cos(rotation) + OffsetArray[(Gun*4)+3] * math.sin(rotation)
		local ny = OffsetArray[(Gun*4)+2] + ty
		local nz = OffsetArray[(Gun*4)+3] * math.cos(rotation) - (OffsetArray[(Gun*4)+1]*side) * math.sin(rotation)
		nx = nx + tx

		nz = nz + tz		
		PositionSetVector("BuildingPos",nx,ny,nz)
		OffsetArray[(Gun*4)+4] = 0
		
		if AliasExists("Destination") then
			StartSingleShotParticle("particles/gunshot.nif","BuildingPos",size,4)
			ThrowObject("", "Destination", "particles/cannonball.nif",0.1, "CannonBall", OffsetArray[(Gun*4)+1]*side, OffsetArray[(Gun*4)+2], OffsetArray[(Gun*4)+3])
			PlaySound3DVariation("","Effects/combat_cannon_shot",1)
		end

		Sleep(DelayTime)		
	end
end

function DrawWeaponVisual()
	--started when the building is readied for combat

	PlaySound3DVariation("","Effects/combat_strike_metal",1)
end

function UndrawWeaponVisual()
	--started when the building is finishing combat

	PlaySound3DVariation("","Effects/combat_strike_metal",1)
end

function HitArmedVisual(SoundType, Damage)
	--started when the building is hit by cannons
	local tx
	local ty
	local tz
	local randval = 0
	for i=1,4 do
		if GetLocatorByName("","fire"..i,"OriginPos") then	
			GetPosition("OriginPos","DestPos")
			PlaySound3DVariation("","Effects/combat_cannon_strike_building",1)
			tx, ty, tz = PositionGetVector("DestPos")
			PositionSetVector("DestPos",tx+(Rand(200)-100),ty-Rand(150),tz+(Rand(200)-100))
			
			randval = Rand(100)
			if (randval > 7) then	
				StartSingleShotParticle("particles/ship_hit.nif","DestPos",Rand(3)+1,2)
			else
				StartSingleShotParticle("particles/Explosion.nif","DestPos",Rand(2)+1,2)
			end
		end
		Sleep(0.3)
	end
end

