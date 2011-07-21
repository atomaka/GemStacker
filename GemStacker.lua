GemStacker = LibStub('AceAddon-3.0'):NewAddon('GemStacker','AceConsole-3.0','AceEvent-3.0')
local core = GemStacker
local queue = {}

function core:OnInitialize()	

end

function core:OnEnable()
	self:RegisterEvent('CHAT_MSG_LOOT','TrackGems')
	self:RegisterEvent('ITEM_PUSH','StackGems')
end

function core:TrackGems(_,message)
	print('track gems')
	-- Get the gem we just cut
	local tradeskill = message:match("%[(.-)%]")

	local destination = {false,false};
	-- Find the biggest, non-full stack we can find
	for bag = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			local itemID = GetContainerItemID(bag, slot)
			if(itemID) then
				local itemName, _, _, _, _, _, _, maxStack = GetItemInfo(itemID)
				
				if tradeskill == itemName and maxStack ~= 1 then
					local _, count = GetContainerItemInfo(bag, slot)
					
					-- Find the biggest, non-full stack we can
					if(count < maxStack) then
						table.insert(queue, itemID)
					end
				end
			end
		end
	end

	core:StackGems()
end

function core:StackGems()
	print('stackgems:')
	local _, stackItemID = next(queue)
	if not stackItemID then return end
	
	print('stacking gem',stackItemID)
	
	local combineSlots = {}
	for bag = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			local itemID = GetContainerItemID(bag, slot)
			if(itemID) then
				local itemName, _, _, _, _, _, _, maxStack = GetItemInfo(itemID)
				
				if itemID == stackItemID and maxStack ~= 1 then
					print('Found', itemName,bag,slot)
					local _, count = GetContainerItemInfo(bag, slot)
					
					if count < 20 and #combineSlots < 2 then
						combineSlots[#combineSlots + 1] = { bag, slot }
					end
				end
			end
		end
	end
	
	--and then stack the gems
	if #combineSlots > 1 then
		PickupContainerItem(combineSlots[1][1], combineSlots[1][2])	
		PickupContainerItem(combineSlots[2][1], combineSlots[2][2])
		
		queue[stackItemID] = nil
	elseif #combineSlots == 0 then
		queue[stackItemID] = nil
	end
end