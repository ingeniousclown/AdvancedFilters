------------------------------------------------------------------
--AdvancedFilters.lua
--Author: ingeniousclown
--v0.2.1

--Advanced Filters adds a line of subfilters to the inventory
--screen.
------------------------------------------------------------------


local ADV_FILTER_HEIGHT = 30
local oldY = nil

local WEAPONS, ARMOR, CONSUMABLES, MATERIALS, MISCELLANOUS

local currentInventoryType = nil
local currentBag = ZO_PlayerInventoryBackpack
local currentFilter = nil
local isRearranged = false

local BAGS = ZO_PlayerInventoryBackpack
local BANK = ZO_PlayerBankBackpack
local GUILDBANK = ZO_GuildBankBackpack

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

--replace "additional filter" with  "additional filter AND myfilter"

function GetCurrentInventoryType()
	return currentInventoryType
end

local function RearrangeControls( self )
	if(not (self == BAGS or self == BANK or self == GUILDBANK)) then return end

	if (not self.oldY) then
		local sortBy = self:GetParent():GetNamedChild("SortBy")
		local _,_,_,_,_,offsetY = sortBy:GetAnchor()
		self.oldY = offsetY
	end

	if(not (self.currentFilter == ITEMFILTERTYPE_WEAPONS
		or self.currentFilter == ITEMFILTERTYPE_ARMOR
		or self.currentFilter == ITEMFILTERTYPE_CONSUMABLE
		or self.currentFilter == ITEMFILTERTYPE_CRAFTING
		or self.currentFilter == ITEMFILTERTYPE_MISCELLANEOUS )) then
		if(self.isRearranged) then
			self.isRearranged = false
			local sortBy = self:GetParent():GetNamedChild("SortBy")
			sortBy:ClearAnchors()
			sortBy:SetAnchor(TOPLEFT, self:GetParent(), TOPLEFT, 0, self.oldY)

			local contents = self:GetNamedChild("Contents")
			contents:ClearAnchors()
			contents:SetAnchor(TOPLEFT, self, TOPLEFT, 0, 0)
			contents:SetAnchor(BOTTOMRIGHT, self, BOTTOMRIGHT, -16)
			contents:SetHeight(contents:GetDesiredHeight() + ADV_FILTER_HEIGHT)

			ZO_ScrollList_SetHeight(self, self:GetHeight())
			PLAYER_INVENTORY:UpdateList(self.inventoryType)
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

	if(PLAYER_INVENTORY.appliedLayout) then
		PLAYER_INVENTORY.appliedLayout.additionalFilter = PLAYER_INVENTORY.appliedLayout.defaultAdditionalFilter
	end
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

	currentInventoryType = INVENTORY_BACKPACK

	BACKPACK_MAIL_LAYOUT_FRAGMENT.layoutData.defaultAdditionalFilter = BACKPACK_MAIL_LAYOUT_FRAGMENT.layoutData.additionalFilter
	BACKPACK_PLAYER_TRADE_LAYOUT_FRAGMENT.layoutData.defaultAdditionalFilter = BACKPACK_PLAYER_TRADE_LAYOUT_FRAGMENT.layoutData.additionalFilter
	BACKPACK_STORE_LAYOUT_FRAGMENT.layoutData.defaultAdditionalFilter = BACKPACK_STORE_LAYOUT_FRAGMENT.layoutData.additionalFilter
end

local function AdvancedFilters_Initialized()
	EVENT_MANAGER:RegisterForEvent("AdvancedFilters_Loaded", EVENT_ADD_ON_LOADED, AdvancedFilters_Loaded)
end

AdvancedFilters_Initialized()