GemStacker = LibStub('AceAddon-3.0'):NewAddon('GemStacker','AceConsole-3.0','AceEvent-3.0');
local core = GemStacker;

function core:OnInitialize()	

end

function core:OnEnable()
	--use chat_msg_loot later
	self:RegisterEvent('CHAT_MSG_LOOT','StackGems');
end

function core:StackGems(_,message)
	--should receive something like "player","Reckless Ember Topaz","",2,73369
	if(not string.find(message,'You create')) then return end;
	local gem = message:match("%[(.-)%]");

	local sourceContainer,sourceSlot,destContainer,destSlot = -1,-1,-1,-1;
	for bag = 0,4 do
		for slot = 1,GetContainerNumSlots(bag) do
			itemId = GetContainerItemID(bag,slot)
			if(itemId) then
				itemName = GetItemInfo(itemId);
				if(gem == itemName) then
					local _,count = GetContainerItemInfo(bag,slot);
					if(count == 1 and sourceContainer < 0) then
						sourceContainer = bag;
						sourceSlot = slot;
					elseif(count < 20 and (count > 1 or destContainer < 0)) then
						destContainer = bag;
						destSlot = slot;
					end
				end
			end
		end
	end

	if(sourceContainer ~= -1 and destContainer ~= -1) then
		PickupContainerItem(sourceContainer,sourceSlot);
		PickupContainerItem(destContainer,destSlot)
	end
end