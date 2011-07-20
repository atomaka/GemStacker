GemStacker = LibStub('AceAddon-3.0'):NewAddon('GemStacker','AceConsole-3.0','AceEvent-3.0')
local core = GemStacker

function core:OnInitialize()	

end

function core:OnEnable()
	self:RegisterEvent('CHAT_MSG_LOOT','StackGems')
end

function core:StackGems(_,message)
	local lastTradeskill = message:match("%[(.-)%]")
	local combineSlots = {}
	
	--loop through bags in reverse
	for bag = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			local itemID = GetContainerItemID(bag, slot)
			if(itemID) then
				local itemName, _, _, _, _, _, _, maxStack = GetItemInfo(itemID)
				
				if lastTradeskill == itemName and maxStack ~= 1 then
					print('Found', itemName)
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
	end
end