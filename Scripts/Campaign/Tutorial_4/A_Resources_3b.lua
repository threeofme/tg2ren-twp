-------------------------------------------------------------------------------
----
----	OVERVIEW "Tutorial_4\A_Resources_3"
----
----	OPEN CHAR OVERVIEW
----
----	1. function Bind
----
----	2. Bind / Start the next Quest(s)
----
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
----	1. function Bind
-------------------------------------------------------------------------------
function Bind()
	return true
end

function CheckStart()
	return true
end

function Start()
	local CartCount = BuildingGetCartCount("#Smithy")
	local CurrentCart
	local RemainingSpace = 0
	for CurrentCart=0,CartCount do
		BuildingGetCart("#Smithy",CurrentCart,"MyCart")
		RemainingSpace = RemainingSpace + GetRemainingInventorySpace("MyCart","Iron")
	end
	SetData("InventorySpace",RemainingSpace)

	while true do
		local MinMoney = 1500
		if GetMoney("#Player") < MinMoney then
			local GiveMoney = 1500 - GetMoney("#Player")
			CreditMoney("#Player",GiveMoney,"Buy Resources Credit")
		end
		
		local CartCount = BuildingGetCartCount("#Smithy")
		local CurrentCart
		local RemainingSpace = 0
		for CurrentCart=0,CartCount do
			BuildingGetCart("#Smithy",CurrentCart,"MyCart")
			RemainingSpace = RemainingSpace + GetRemainingInventorySpace("MyCart","Iron")
		end
		if (RemainingSpace ~= GetData("InventorySpace")) then
			local IronCount = 0
			for CurrentCart=0,CartCount-1 do
				BuildingGetCart("#Smithy",CurrentCart,"MyCart")
				IronCount = IronCount + GetItemCount("MyCart","Iron")
			end
			if (IronCount > 0) then
				if (IronCount >= 2) then
					HideTutorialBox()
					break
				end
			else
				for CurrentCart=0,CartCount-1 do
					BuildingGetCart("#Smithy",CurrentCart,"MyCart")
					
					local Slots = InventoryGetSlotCount("MyCart")
					local ItemId
					local ItemCount
					local Number
					for Number = Slots-1, 0, -1 do
						ItemId, ItemCount = InventoryGetSlotInfo("MyCart", Number)
						if ItemId and ItemCount then
							RemoveItems("MyCart", ItemId, ItemCount)
						end
					end
				end
				MsgQuest("#Player",0,"MB_OK","@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_IRON_NAME","@L_TUTORIAL_CHAPTER_4_BUY_RESSOURCES_IRON_FAILED")
			end
		end
		Sleep(1)
	end
	
	StartQuest("A_Resources_4","#Player","",false)

	KillQuest("A_Resources_3")
	KillQuest()	
end

function CheckEnd()
	return true
end

function Run()
end

-------------------------------------------------------------------------------
----	2. Bind / Start Quest(s)
----		Bind / Start the next Quest(s) and kill the former Quest(s)
-------------------------------------------------------------------------------
function End()
end




