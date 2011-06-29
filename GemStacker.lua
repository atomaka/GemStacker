GemStacker = LibStub('AceAddon-3.0'):NewAddon('GemStacker','AceConsole-3.0','AceEvent-3.0');
local core = GemStacker;

function core:OnInitialize()	

end

function core:OnEnable()
	self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED','CheckGemCut');
end

function core:CheckGemCut(_,event,_,sourceGUID,sourceName,_,_,_,_,_,_,spellSchool)
	if(not gemCasts[spellSchool]) then return end;
	
	self:RegisterEvent('BAG_UPDATE','StackGem');
end

function core:StackGem(container)
	--find the item (tricky?)

	--check all bags to see if there is an existing stack
	
	--if there is an existing stack and it is not max, stack the new gem on the old stack

	self:UnregisterEvent('BAG_UDATE');
end

--BAG_UPDATE - container
--SPELL_CAST_START