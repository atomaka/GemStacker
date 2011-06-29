GemStacker = LibStub('AceAddon-3.0'):NewAddon('GemStacker','AceConsole-3.0','AceEvent-3.0');
local core = GemStacker;
core.gems = {};

function core:OnInitialize()	
	print('GemStacker: Initialized');
end

function core:OnEnable()
	print('GemStacker: Enabled');
	
	core.gems['Puissant Dream Emerald'] = true;
	
	self:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED','FindGemCast');
end

function core:FindGemCast(_,unitId,spell,...)
	print('GemStacker: Casted ',spell);
	--should receive something like "player","Reckless Ember Topaz","",2,73369
	if(unitId ~= 'player') then return end;
	print('GemStacker: Player casted spell.');
	if(not core.gems[spell]) then return end;
	print('GemStacker: Gem found');
	
	local sourceContainer,sourceSlot,destContainer,destSlot = -1,-1,-1,-1;
	for bag = 0,1 do
		for slot = 1,GetContainerNumSlots(bag) do
			print('GemStacker: Checking ',bag,slot);
			itemId = GetContainerItemID(bag,slot)
			if(itemId) then
				itemName = GetItemInfo(itemId);
				if(spell == itemName) then
					print('GemStacker: Found gem in bag: ',bag,slot);
					local _,count = GetContainerItemInfo(bag,slot);
					if(count == 1 and sourceContainer < 0) then
						print('GemStacker: Found source');
						sourceContainer = bag;
						sourceSlot = slot;
					elseif(count < 20 and (count > 1 or destContainer < 0)) then
						print('GemStacker: Found dest');
						destContainer = bag;
						destSlot = slot;
					end
				end
			else
				print('GemStacker: ',bag,slot,'emptry');
			end
		end
	end

	if(sourceContainer < 0 and destContainer < 0) then
		print('GemStacker: Stacking');
		PickupContainerItem(sourceContainer,sourceSlot);
		PickupContainerItem(destContainer,destSlot)
	end
	
	--self:RegisterEvent('BAG_UPDATE','StackGem');
end

function core:StackGem(...)
	
	
	self:UnregisterEvent('BAG_UPDATE');
end