GemStacker = LibStub('AceAddon-3.0'):NewAddon('GemStacker','AceConsole-3.0','AceEvent-3.0');
local core = GemStacker;

function core:OnInitialize()	

end

function core:OnEnable()
	self:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED','StackGem');
end

function core:StackGem(unitID,spell,rank,lineID,spellID)
	--should receive something like "player","Reckless Ember Topaz","",2,73369
	if(unitID ~= 'player') then return end;
	if(not gems[spellID]) then return end;
	
	--go through all bag slots and find all stacks of this gem type.
	--local sourceStack = {};
	--local destStack = {};
	--for all of the bags
	--	for all of the slots
	--		if(gems[spellID] == GetContainerItemID(1,11)) then
	--			_,count = GetContainerItemInfo(container, slot)
	--			if(count == 1) then
	--				sourceStack = {container,slot);
	--			elseif(count < 20) then
	--				destStack = {container,slot);
	--			end
	--		end
	--	end
	--end

	--if there is a stack of 1 and a stack of < 20, combine them
	PickupContainerItem(sourceStack[0],sourceStack[1])
	PickupContainerItem(destStack[0],destStack[1])
end

--BAG_UPDATE - container
--SPELL_CAST_START