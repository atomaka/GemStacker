GemStacker = LibStub('AceAddon-3.0'):NewAddon('GemStacker','AceConsole-3.0','AceEvent-3.0');
local core = GemStacker;

function core:OnInitialize()	

end

function core:OnEnable()
	self:RegisterEvent('CHAT_MSG_LOOT','StackGems')
end

function core:StackGems(_,message)
	--LOOT_ITEM_CREATED_SELF = "You create: %s.";
	print('stack gems')
	--local gem = message:match(LOOT_ITEM_CREATED_SELF)
	print('found gem',gem)

	local sourceContainer,sourceSlot,destContainer,destSlot = -1,-1,-1,-1;
	for bag = 0,NUM_BAG_SLOTS do
		for slot = 1,GetContainerNumSlots(bag) do
			local itemId = GetContainerItemID(bag,slot)
			if itemId then
				local itemName,_,_,_,_,_,_,maxStack = GetItemInfo(itemId);
				if gem == itemName and maxStack ~= 1 then
					local _,count = GetContainerItemInfo(bag,slot)
					if count == 1 and sourceContainer < 0 then
						sourceContainer = bag
						sourceSlot = slot
					elseif count < 20 and (count > 1 or destContainer < 0) then
						destContainer = bag
						destSlot = slot
					end
				end
			end
		end
	end

	if sourceContainer ~= -1 and destContainer ~= -1 then
		PickupContainerItem(sourceContainer,sourceSlot)
		PickupContainerItem(destContainer,destSlot)
	end
end