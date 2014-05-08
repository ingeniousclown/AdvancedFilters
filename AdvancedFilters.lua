------------------------------------------------------------------
--AdvancedFilters.lua
--Author: ingeniousclown
--v0.4.0

--Advanced Filters adds a line of subfilters to the inventory
--screen.
------------------------------------------------------------------

local ADV_FILTER_HEIGHT = 40
local oldY = nil

local WEAPONS, ARMOR, CONSUMABLES, MATERIALS, MISCELLANOUS

local currentInventoryType = nil
local currentBag = ZO_PlayerInventoryBackpack
local currentFilter = nil
local isRearranged = false

local BAGS = ZO_PlayerInventoryBackpack
local BANK = ZO_PlayerBankBackpack
local GUILDBANK = ZO_GuildBankBackpack
local QUEST = ZO_PlayerInventoryQuest

local currentSubFilter = {
	[INVENTORY_BACKPACK] = nil,
	[INVENTORY_BANK] = nil,
	[INVENTORY_GUILD_BANK] = nil
}

local subfilterRows = {
	[ITEMFILTERTYPE_WEAPONS] = nil,
	[ITEMFILTERTYPE_ARMOR] = nil,
	[ITEMFILTERTYPE_CONSUMABLE] = nil,
	[ITEMFILTERTYPE_CRAFTING] = nil,
	[ITEMFILTERTYPE_MISCELLANEOUS] = nil
}

local _

local function InventoryTypeToBagId( inventoryType )
	if(inventoryType == 1) then
		return 1
	elseif(inventoryType == 3) then
		return 2
	elseif(inventoryType == 4) then
		return 3
	end
	return 0
end

function GetCurrentInventoryType()
	return currentInventoryType
end

function InventoryToInventoryType( inventory )
	if(inventory == BAGS) then return 1 end
	if(inventory == QUEST) then return 2 end
	if(inventory == BANK) then return 3 end
	if(inventory == GUILDBANK) then return 4 end
end

local function RearrangeControls( self )
	if(not (self == BAGS or self == BANK or self == GUILDBANK or self == QUEST)) then return end

	if (not self.oldY) then
		local sortBy = self:GetParent():GetNamedChild("SortBy")
		local _,_,_,_,_,offsetY = sortBy:GetAnchor()
		self.oldY = offsetY
	end

	if(not (self.currentFilter == ITEMFILTERTYPE_WEAPONS
		or self.currentFilter == ITEMFILTERTYPE_ARMOR
		or self.currentFilter == ITEMFILTERTYPE_CONSUMABLE
		or self.currentFilter == ITEMFILTERTYPE_CRAFTING
		or self.currentFilter == ITEMFILTERTYPE_MISCELLANEOUS )
		or self == QUEST) then
		if(self.isRearranged or (self == QUEST and BAGS.isRearranged)) then
			if(self ~= QUEST) then
				self.isRearranged = false
			else
				BAGS.isRearranged = false
				self = BAGS
			end
			local sortBy = self:GetParent():GetNamedChild("SortBy")
			sortBy:ClearAnchors()
			sortBy:SetAnchor(TOPLEFT, self:GetParent(), TOPLEFT, 0, self.oldY)

			local contents = self:GetNamedChild("Contents")
			contents:ClearAnchors()
			contents:SetAnchor(TOPLEFT, self, TOPLEFT, 0, 0)
			contents:SetAnchor(BOTTOMRIGHT, self, BOTTOMRIGHT, -16)
			contents:SetHeight(contents:GetDesiredHeight() + ADV_FILTER_HEIGHT)

			ZO_ScrollList_SetHeight(self, self:GetHeight())
			if(self ~= QUEST) then
				PLAYER_INVENTORY:UpdateList(self.inventoryType)
			end
		end
		return
	end
	if(self.isRearranged and not self.isRearranged == nil) then return end
	self.isRearranged = true

	local sortBy = self:GetParent():GetNamedChild("SortBy")
	sortBy:ClearAnchors()
	sortBy:SetAnchor(TOPLEFT, self:GetParent(), TOPLEFT, 0, self.oldY + ADV_FILTER_HEIGHT)

	local contents = self:GetNamedChild("Contents")
	contents:ClearAnchors()
	contents:SetAnchor(TOPLEFT, self, TOPLEFT, 0, ADV_FILTER_HEIGHT)
	contents:SetAnchor(BOTTOMRIGHT, self, BOTTOMRIGHT, -16)
	contents:SetHeight(contents:GetDesiredHeight() - ADV_FILTER_HEIGHT)

	ZO_ScrollList_SetHeight(self, self:GetHeight() - ADV_FILTER_HEIGHT)
end

local function SetFilterParent( parent )
	local inventory = parent:GetParent()
	for k,v in pairs(subfilterRows) do
		v.control:SetParent(inventory)
		v.control:ClearAnchors()
		v.control:SetAnchor(TOPLEFT, inventory, TOPLEFT, 0, v.offsetY)
		v.control:SetHidden(true)
	end
end

local function CheckSubfilters()
	if(not subfilterRows[currentBag.currentFilter]) then return end

	for _,v in ipairs(subfilterRows[currentBag.currentFilter].subfilters) do
		v.texture:SetColor(.3, .3, .3, .9)
		v.isActive = false
	end

	for _,item in pairs(PLAYER_INVENTORY.inventories[GetCurrentInventoryType()].slots) do
		for _,filter in ipairs(subfilterRows[currentBag.currentFilter].subfilters) do
			if(not filter.isActive and filter.button.filterCallback(item)) then
				filter.isActive = true
				filter.texture:SetColor(1, 1, 1, 1)
			end
		end
	end
end

local function GuildBankReady()
	if(GetCurrentInventoryType() == INVENTORY_GUILD_BANK) then
		CheckSubfilters()
		if(subfilterRows[currentBag.currentFilter]) then
			subfilterRows[currentBag.currentFilter]:ResetToAll()
		end
	end
end

--this handles the sudden change between bags
--because all the filter bars are shared, they would be hidden upon changing inventories
local function InventoryShown( self, isHidden )
	if(currentBag == self or isHidden) then return end

	self = self:GetNamedChild("Backpack")
	SetFilterParent(self)
	if(self.currentFilter) then
		subfilterRows[self.currentFilter]:SetHidden(false)
		subfilterRows[self.currentFilter]:ResetToAll()
	end

	currentInventoryType = InventoryToInventoryType(self)
	currentBag = self
	CheckSubfilters()
end

local function ChangeFilter( self, filterTab )
	local inventoryType = filterTab.inventoryType
	local inventory = PLAYER_INVENTORY.inventories[inventoryType]

	if not inventoryType then return end

	if(inventoryType ~= currentInventoryType) then
		if(inventoryType == INVENTORY_BACKPACK) then currentBag = BAGS end
		if(inventoryType == INVENTORY_BANK) then currentBag = BANK end
		if(inventoryType == INVENTORY_GUILD_BANK) then currentBag = GUILDBANK end
		SetFilterParent(currentBag)
		currentInventoryType = inventoryType
	end

	if(currentBag.currentFilter) then
		subfilterRows[currentBag.currentFilter]:SetHidden(true)
		subfilterRows[currentBag.currentFilter]:ResetToAll()
	end

	-- if(PLAYER_INVENTORY.appliedLayout) then
	-- 	PLAYER_INVENTORY.appliedLayout.additionalFilter = PLAYER_INVENTORY.appliedLayout.defaultAdditionalFilter
	-- end
	local newFilter = self:GetTabFilterInfo(inventoryType, filterTab)
	
	if( not (newFilter == ITEMFILTERTYPE_WEAPONS
		or newFilter == ITEMFILTERTYPE_ARMOR
		or newFilter == ITEMFILTERTYPE_CONSUMABLE
		or newFilter == ITEMFILTERTYPE_CRAFTING
		or newFilter == ITEMFILTERTYPE_MISCELLANEOUS )) then
		currentBag.currentFilter = nil
		return
	end

	currentBag.currentFilter = newFilter
	currentSubFilter = nil
	subfilterRows[newFilter]:SetHidden(false)
	subfilterRows[newFilter]:ResetToAll()

	CheckSubfilters()
end

local function InventorySlotUpdated( eventId, bagId, slotIndex )
	local inventoryType = PLAYER_INVENTORY.bagToInventoryType[bagId]
	local pseudoSlot = {}
	pseudoSlot.bagId = bagId
	pseudoSlot.slotIndex = slotIndex
	if(inventoryType == GetCurrentInventoryType() and subfilterRows[currentBag.currentFilter]) then
		for _,filter in ipairs(subfilterRows[currentBag.currentFilter].subfilters) do
			if(not filter.isActive and filter.button.filterCallback(pseudoSlot)) then
				filter.isActive = true
				filter.texture:SetColor(1, 1, 1, 1)
			end
		end
	end
end

local function AdvancedFilters_Loaded(eventCode, addOnName)
    if(addOnName ~= "AdvancedFilters") then
        return
    end

    ZO_PreHook(PLAYER_INVENTORY, "ChangeFilter", ChangeFilter)
	ZO_PreHook("ZO_ScrollList_UpdateScroll", RearrangeControls)

	WEAPONS, ARMOR, CONSUMABLES, MATERIALS, MISCELLANOUS = AdvancedFilters_InitAllFilters()
	subfilterRows[ITEMFILTERTYPE_WEAPONS] = WEAPONS
	subfilterRows[ITEMFILTERTYPE_ARMOR] = ARMOR
	subfilterRows[ITEMFILTERTYPE_CONSUMABLE] = CONSUMABLES
	subfilterRows[ITEMFILTERTYPE_CRAFTING] = MATERIALS
	subfilterRows[ITEMFILTERTYPE_MISCELLANEOUS] = MISCELLANOUS

	BAGS.inventoryType = INVENTORY_BACKPACK
	BANK.inventoryType = INVENTORY_BANK
	GUILDBANK.inventoryType = INVENTORY_GUILD_BANK

	local bagSearch = ZO_PlayerInventorySearchBox
	bagSearch:ClearAnchors()
	bagSearch:SetAnchor(BOTTOMLEFT, ZO_PlayerInventory, TOPLEFT, 36, -8)
	bagSearch:SetHidden(false)

	local bankSearch = ZO_PlayerBankSearchBox
	bankSearch:ClearAnchors()
	bankSearch:SetAnchor(BOTTOMLEFT, ZO_PlayerBank, TOPLEFT, 36, -8)
	bankSearch:SetHidden(false)
	bankSearch:SetWidth(bagSearch:GetWidth())

	local guildBankSearch = ZO_GuildBankSearchBox
	guildBankSearch:ClearAnchors()
	guildBankSearch:SetAnchor(BOTTOMLEFT, ZO_GuildBank, TOPLEFT, 36, -8)
	guildBankSearch:SetHidden(false)
	guildBankSearch:SetWidth(bagSearch:GetWidth())

	currentInventoryType = INVENTORY_BACKPACK

	ZO_PreHook(BAGS:GetParent(), "SetHidden", InventoryShown)
	ZO_PreHook(BANK:GetParent(), "SetHidden", InventoryShown)
	ZO_PreHook(GUILDBANK:GetParent(), "SetHidden", InventoryShown)

	EVENT_MANAGER:RegisterForEvent("AdvancedFilters_InventorySlotUpdate", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, InventorySlotUpdated)
	EVENT_MANAGER:RegisterForEvent("AdvancedFilters_GuildBankReady", EVENT_GUILD_BANK_ITEMS_READY, GuildBankReady)
end

local function AdvancedFilters_Initialized()
	EVENT_MANAGER:RegisterForEvent("AdvancedFilters_Loaded", EVENT_ADD_ON_LOADED, AdvancedFilters_Loaded)
end

AdvancedFilters_Initialized()