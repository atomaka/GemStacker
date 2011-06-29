GemStacker = LibStub('AceAddon-3.0'):NewAddon('GemStacker','AceConsole-3.0','AceEvent-3.0');
local core = GemStacker;
core.gems = {};
core.lastGem = false;

function core:OnInitialize()	

end

function core:OnEnable()
	core.gems['Puissant Dream Emerald'] = true;
	
	--use chat_msg_loot later
	self:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED','FindGemCast');
end

function core:FindGemCast(_,unitId,spell,...)
	print('GemStacker: Casted ',spell);
	--should receive something like "player","Reckless Ember Topaz","",2,73369
	if(unitId ~= 'player') then return end;
	if(not core.gems[spell]) then return end;
	
	core.lastGem = spell;
	self:RegisterEvent('BAG_UPDATE','StackGem');
end

function core:StackGem(...)
	print('GemStacker: StackGem');
	if(not core.lastGem) then return end;
	
	local sourceContainer,sourceSlot,destContainer,destSlot = -1,-1,-1,-1;
	for bag = 0,4 do
		for slot = 1,GetContainerNumSlots(bag) do
			itemId = GetContainerItemID(bag,slot)
			if(itemId) then
				itemName = GetItemInfo(itemId);
				if(core.lastGem == itemName) then
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
	
	core.lastGem = false;
	self:UnregisterEvent('BAG_UPDATE');
end