function Init()
 --needed for caching
end

function AttackRangedVisual(SoundType)
	--started when a projectile is fired 
	
	local ShootAngle = 90
	local Shootrange = 5000
	local side = 1
	local angle = GetRotation("","Destination") - ObjectGetRotationY("")
	--local angle = 90
		 
	if angle <= 0 then
		angle = 360 + angle
	end

	if angle > 180 then
		angle = 360 - angle
		side = -side
	end

	
	local NumGuns = GetProperty("","ShipCannonCntBase")
	local NumShots = 0
	local VisibleShots = 0
	--if NumGuns <= 15 then
		NumShots = 5
	--end
	local DelayTime = 0.3
	GetPosition("","ShipPos")
	local Type = CartGetType("")
	local OffsetArray = 	{
				}
	
				
	if Type == EN_CT_MERCHANTMAN_SMALL then
		OffsetArray = 	{150,60,200,1,
				170,60,100,1,
				190,60,0,1,
				170,60,-100,1,
				150,60,-200,1
				}
		NumShots = 5
		VisibleShots = 1
	elseif Type == EN_CT_MERCHANTMAN_BIG then
		OffsetArray = 	{200,100,300,1,
				210,100,200,1,
				220,100,100,1,
				230,100,0,1,
				230,100,-100,1,
				220,100,-200,1,
				210,100,-300,1,
				200,100,-400,1
				}
		NumShots = 8
		VisibleShots = 2
	elseif Type == EN_CT_CORSAIR then
		OffsetArray = 	{200,100,300,1,
				210,100,200,1,
				220,100,100,1,
				230,100,0,1,
				230,100,-100,1,
				220,100,-200,1,
				210,100,-300,1,
				200,100,-400,1
				}
		NumShots = 8
		VisibleShots = 3
	elseif Type == EN_CT_WARSHIP then
		OffsetArray = 	{200,174,555,1,
				226,169,445,1,
				244,161,319,1,
				230,144,190,1,
				240,137,56,1,
				250,140,-64,1,
				254,149,-192,1,
				280,169,-325,1,
				279,182,-452,1,
				278,202,-577,1,
				252,225,-704,1
				}
		NumShots = 11
		VisibleShots = 3
		DelayTime = 0.2	
	elseif Type == EN_CT_FISHERBOOT then
		OffsetArray = 	{190,60,0,1
				}
		NumShots = 1
	end
	
	
	local rotation = (ObjectGetRotationY("") / 360) * (2 * math.pi)
	local tx,ty,tz = PositionGetVector("ShipPos") 
	local size = 2
	
	LogMessage("anims_fight_ship "..GetID("").." NumShots="..NumShots.."  Type="..Type.."   Delay="..DelayTime)
	
	
	
	for i=0,VisibleShots-1 do
	
		LogMessage("anims_fight_ship "..GetID("").."  executing loop for "..i)
		
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
		if side == -1 then
			if Type == EN_CT_WARSHIP then
				nx = nx + 20
			end
		end
		nz = nz + tz		
		PositionSetVector("ShipPos",nx,ny,nz)
		OffsetArray[(Gun*4)+4] = 0
		
		StartSingleShotParticle("particles/gunshot.nif","ShipPos",size,4)
		ThrowObject("", "Destination", "Outdoor/NewAssets/cannonball.nif",0.1, "CannonBall", OffsetArray[(Gun*4)+1]*side, OffsetArray[(Gun*4)+2], OffsetArray[(Gun*4)+3])
		--PlaySound3DVariation("","ship/ShipCannonFiresBig",1)
		PlaySound3DVariation("","Effects/combat_cannon_shot",1)
		Sleep(DelayTime)
		
	end
end

function DrawWeaponVisual()
	--started when the ship is readied for combat

	PlaySound3DVariation("","Effects/combat_strike_metal",1)
end

function UndrawWeaponVisual()
	--started when the ship is finishing combat

	PlaySound3DVariation("","Effects/combat_strike_metal",1)
end

function HitArmedVisual(SoundType, Damage)
	--started when the ship is hit by cannons
	local tx
	local ty
	local tz
	local randval
	
	--for i=0,4 do
		GetPosition("","DestPos")
		randval = Rand(100)
		if (randval > 10) then
			PlaySound3D("","fire/Explosion_s_01.wav",1)
			tx, ty, tz = PositionGetVector("DestPos")
			PositionSetVector("DestPos",tx+(Rand(400)-200),ty+100,tz+(Rand(400)-200))
			local DestType = CartGetType("")
			
			if DestType==EN_CT_MERCHANTMAN_BIG then
				tx,ty,tz = PositionGetVector("DestPos")
				PositionSetVector("DestPos",tx+(Rand(200)-200),ty+200,tz+(Rand(200)-200))
			end
			if DestType==EN_CT_WARSHIP then
				tx,ty,tz = PositionGetVector("DestPos")
				PositionSetVector("DestPos",tx+(Rand(200)-200),ty+300,tz+(Rand(200)-200))
			end
			if DestType==EN_CT_CORSAIR then
				tx,ty,tz = PositionGetVector("DestPos")
				PositionSetVector("DestPos",tx+(Rand(200)-200),ty+250,tz+(Rand(200)-200))
			end
			
			randval = Rand(100)
			if (randval > 7) then	
				StartSingleShotParticle("particles/ship_hit.nif","DestPos",Rand(2)+1,2)
			else
				StartSingleShotParticle("particles/Explosion.nif","DestPos",1,2)
			end
		else
			
			tx,ty,tz = PositionGetVector("DestPos")
			
			PositionSetVector("DestPos",tx+(Rand(800)-400),ty-50,tz+(Rand(800)-400))
			PlaySound3DVariation("","effects/watersplash",1)
			StartSingleShotParticle("particles/water_splash.nif","DestPos",Rand(2)+2,5)
		end
		--Sleep(0.3)
	--end
end

			
