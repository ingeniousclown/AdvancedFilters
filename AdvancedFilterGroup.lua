
local index = 0
local function GetNextIndex()
	index = index + 1
	return index
end

local SUBFILTER_HEIGHT = 40
local ICON_SIZE = 32 	--this will be square
local STARTX = 148

local HIGHLIGHT_TEXTURE = [[/esoui/art/actionbar/magechamber_lightningspelloverlay_up.dds]]
local highlightTexture = nil

local defaultCallback = nil
local currentSelected = nil
local currentDropdown = nil

AdvancedFilterGroup = ZO_Object:Subclass()

local function MoveHighlightToMe( self )
	highlightTexture:ClearAnchors()
	highlightTexture:SetParent(self)
	highlightTexture:SetAnchor(CENTER, self, CENTER)
	highlightTexture:SetHidden(false)
end

local function SetUpCallbackFilter( self )
	PLAYER_INVENTORY.inventories[GetCurrentInventoryType()].additionalFilter = function(slot)
			local result = true

			if(PLAYER_INVENTORY.appliedLayout and PLAYER_INVENTORY.appliedLayout.defaultAdditionalFilter) then
				result = result and PLAYER_INVENTORY.appliedLayout.defaultAdditionalFilter(slot)
			end

			if(currentDropdown) then
				result = result and currentDropdown.filterCallback(slot)
			end

			if(self.filterCallback) then
				return result and self.filterCallback(slot)
			else
				return result
			end
		end
end

local function OnClickedCallback( self )
	if(not GetCurrentInventoryType()) then return end
	currentSelected = self

	SetUpCallbackFilter(self)
	PLAYER_INVENTORY:UpdateList(GetCurrentInventoryType())
end

local function OnDropdownSelect( self )
	if(not GetCurrentInventoryType()) then return end
	currentDropdown = self

	SetUpCallbackFilter(self)
	PLAYER_INVENTORY:UpdateList(GetCurrentInventoryType())
end

function AdvancedFilterGroup:New( groupName )
	local obj = ZO_Object.New( self )
	obj:Init(groupName)
	return obj
end

function AdvancedFilterGroup:Init( groupName )
	local _,_,_,_,_,offsetY = ZO_PlayerInventorySortBy:GetAnchor()

	self.offsetY = offsetY

	self.name = groupName;
	self.control = WINDOW_MANAGER:CreateControl("AdvancedFilterGroup" .. groupName, ZO_PlayerInventory, CT_CONTROL, GetNextIndex)
	self.control:SetAnchor(TOPLEFT, ZO_PlayerInventory, TOPLEFT, 0, offsetY)
	self.control:SetDimensions(ZO_PlayerInventory:GetWidth(), SUBFILTER_HEIGHT)
	self.control:SetHidden(true)

	self.label = WINDOW_MANAGER:CreateControl(self.control:GetName() .. "Label", self.control, CT_LABEL)
	self.label:SetAnchor(RIGHT, self.control, RIGHT, 20)
	self.label:SetFont("ZoFontGameSmall")
	self.label:SetHidden(false)
	self.label:SetVerticalAlignment(CENTER)
	-- self.label:SetHorizontalAlignment(LEFT)
	self.label:SetDimensions(STARTX - 12, SUBFILTERHEIGHT)
	self.label:SetText(string.upper("All"))

	if(not highlightTexture) then
		highlightTexture = WINDOW_MANAGER:CreateControl("AdvancedFilterGroupHighlight", self.control, CT_TEXTURE)
		highlightTexture:SetDimensions(ICON_SIZE, ICON_SIZE)
		highlightTexture:SetTexture(HIGHLIGHT_TEXTURE)
		highlightTexture:SetTextureCoords(0.25, 0.75, 0.25, 0.75)
		highlightTexture:SetColor(1, 1, 1, .75)
	end

	self.subfilters = {}
end

function AdvancedFilterGroup:ChangeLabel( text )
	self.label:SetText(string.upper(text))
end

function AdvancedFilterGroup:AddSubfilter( name, icon, callback, tooltip )
	local anchorX = -STARTX + #self.subfilters * -ICON_SIZE
	if(not tooltip) then tooltip = name end

	local subfilter = WINDOW_MANAGER:CreateControl( self.control:GetName() .. name, self.control, CT_CONTROL )
	subfilter:SetAnchor(CENTER, self.control, RIGHT, anchorX, 0)
	subfilter:SetDimensions(ICON_SIZE, ICON_SIZE)

	local button = WINDOW_MANAGER:CreateControl( subfilter:GetName() .. "Button", subfilter, CT_BUTTON )
	button:SetAnchor(TOPLEFT, subfilter, TOPLEFT)
	button:SetDimensions(ICON_SIZE, ICON_SIZE)
	button:SetHandler("OnClicked", function(innerSelf)
			self:ChangeLabel(tooltip)
			OnClickedCallback(innerSelf)
			MoveHighlightToMe(innerSelf)
		end)
	button.filterCallback = callback
	button.isSelected = false
	--button:SetHandler("Mouseover", tooltip with name)

	local texture = WINDOW_MANAGER:CreateControl( subfilter:GetName() .. "Texture", subfilter, CT_TEXTURE )
	-- texutre:SetBlendMode(0)
	texture:SetAnchor(CENTER, subfilter, CENTER)
	texture:SetDimensions(ICON_SIZE, ICON_SIZE)
	texture:SetTexture(icon)

	button:SetHandler("OnMouseEnter", function(self)
		ZO_Tooltips_ShowTextTooltip(self, TOP, tooltip)
	end)
	button:SetHandler("OnMouseExit", function(self)
		ZO_Tooltips_HideTextTooltip()
	end)

	-- subfilter:SetHidden(true)

	table.insert(self.subfilters, subfilter)
end

function AdvancedFilterGroup:AddDropdownFilter( callbackTable )
	local dropdown = WINDOW_MANAGER:CreateControlFromVirtual(self.control:GetName() .. "DropdownFilter", self.control, "ZO_ComboBox")
	self.dropdown = dropdown
	dropdown:SetAnchor(TOP, self.control, BOTTOM, 10, -2)
	dropdown:SetHeight(24)
	local comboBox = dropdown.m_comboBox
    comboBox:SetSortsItems(false)

	for _,v in ipairs(callbackTable) do
		comboBox:AddItem(ZO_ComboBox:CreateItemEntry(v.name, function()
				OnDropdownSelect(v)
			end))
	end
	comboBox:SelectFirstItem()
    comboBox:SetSelectedItemFont("ZoFontGameSmall")
    comboBox:SetDropdownFont("ZoFontGameSmall")
	return dropdown
end

function AdvancedFilterGroup:ResetToAll()
	if(self) then 
		self.label:SetText("ALL")
		MoveHighlightToMe(self.control:GetNamedChild("AllButton"))
		if(self.dropdown) then
			self.dropdown.m_comboBox:SelectFirstItem()
		end
	end
	currentSelected = nil
	currentDropdown = nil

	OnClickedCallback(self)
	PLAYER_INVENTORY:UpdateList(GetCurrentInventoryType())
end

function AdvancedFilterGroup:SetHidden( shouldHide )
	self.control:SetHidden(shouldHide)
end

function AdvancedFilterGroup:GetControl()
	return self.control
end
