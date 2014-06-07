local libFilters = LibStub("libFilters")


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

local BUTTON_STRING = "AdvancedFilters_Button_Filter"
local DROPDOWN_STRING = "AdvancedFilters_Dropdown_Filter"

local _

AdvancedFilterGroup = ZO_Object:Subclass()

local function AdvancedFilters_GetLanguage()
	local lang = GetCVar("language.2")

	--check for supported languages
	if(lang == "de" or lang == "en" or lang == "fr") then return lang end

	--return english if not supported
	return "en"
end

local function MoveHighlightToMe( self )
	highlightTexture:ClearAnchors()
	highlightTexture:SetParent(self)
	highlightTexture:SetAnchor(CENTER, self, CENTER)
	highlightTexture:SetHidden(false)
end

local function SetUpCallbackFilter( self, filterString )
	local laf = libFilters:InventoryTypeToLAF(GetCurrentInventoryType())

	--first, clear current filter
	libFilters:UnregisterFilter(filterString)
	--then register new one
	libFilters:RegisterFilter(filterString, laf, self.filterCallback)
end

local function CycleTextures( self )
	if(self == currentSelected) then return end

	if(self.upTexture) then
		highlightTexture:SetHidden(true)
		self:GetNamedChild("Flash"):SetHidden(false)
		self:GetNamedChild("Texture"):SetTexture(self.downTexture)
		self:SetScale(1.5)
		self:SetMouseEnabled(false)
	end

	if(currentSelected and currentSelected.upTexture) then 
		currentSelected:GetNamedChild("Flash"):SetHidden(true)
		currentSelected:GetNamedChild("Texture"):SetTexture(currentSelected.upTexture)
		currentSelected:SetScale(1)
		currentSelected:SetMouseEnabled(true)
	end
end

local function OnClickedCallback( self )
	if(not GetCurrentInventoryType() or self == currentSelected) then return end

	if(self.filterCallback and currentSelected and currentSelected.filterCallback and not (self == currentSelected)) then 
		local dropdown = currentSelected:GetParent().dropdown
		if(dropdown) then
			dropdown.m_comboBox:SelectFirstItem()
			dropdown:SetHidden(true)
		end
	end

	CycleTextures(self)

	currentSelected = self

	SetUpCallbackFilter(self, BUTTON_STRING)
	-- PLAYER_INVENTORY:UpdateList(GetCurrentInventoryType())
end

local function OnDropdownSelect( self )
	if(not GetCurrentInventoryType()) then return end
	currentDropdown = self

	SetUpCallbackFilter(self, DROPDOWN_STRING)
	-- PLAYER_INVENTORY:UpdateList(GetCurrentInventoryType())
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
	self.label:SetText(string.upper(AF_Strings[AdvancedFilters_GetLanguage()].TOOLTIPS["All"]))

	self.divider = WINDOW_MANAGER:CreateControlFromVirtual(self.control:GetName() .. "Divider", self.control, "ZO_WideHorizontalDivider")
	self.divider:SetHidden(false)
	self.divider:SetAnchor(TOPLEFT, self.control, BOTTOMLEFT)
	self.divider:SetAnchor(TOPRIGHT, self.control, BOTTOMRIGHT)
	self.divider:SetAlpha(0.3)

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

function AdvancedFilterGroup:AddSubfilter( name, icon, callback, dropdownCallbacks, dropdownWidth )
	local tooltipSet = AF_Strings[AdvancedFilters_GetLanguage()].TOOLTIPS

	local anchorX = -STARTX + #self.subfilters * -ICON_SIZE

	local subfilter = WINDOW_MANAGER:CreateControl( self.control:GetName() .. name, self.control, CT_CONTROL )
	subfilter.name = name
	subfilter:SetAnchor(CENTER, self.control, RIGHT, anchorX, 0)
	subfilter:SetDimensions(ICON_SIZE, ICON_SIZE)

	local button = WINDOW_MANAGER:CreateControl( subfilter:GetName() .. "Button", subfilter, CT_BUTTON )
	button:SetAnchor(TOPLEFT, subfilter, TOPLEFT)
	button:SetDimensions(ICON_SIZE, ICON_SIZE)
	button:SetHandler("OnClicked", function(innerSelf)
			if(not subfilter.isActive) then return end
			if(innerSelf == currentSelected) then return end
			self:ChangeLabel(tooltipSet[name])
			if(subfilter.dropdown) then
				subfilter.dropdown:SetHidden(false)
			end
			MoveHighlightToMe(innerSelf)
			OnClickedCallback(innerSelf)
		end)
	button.filterCallback = callback
	button.isSelected = false
	button.upTexture = icon.upTexture
	button.downTexture = icon.downTexture
	subfilter.button = button

	local texture = WINDOW_MANAGER:CreateControl( button:GetName() .. "Texture", button, CT_TEXTURE )
	texture:SetAnchor(CENTER, subfilter, CENTER)
	texture:SetDimensions(ICON_SIZE, ICON_SIZE)
	texture:SetTexture(icon.upTexture or icon)
	subfilter.texture = texture

	local flash
	if(icon.flash) then
		flash = WINDOW_MANAGER:CreateControl( button:GetName() .. "Flash", button, CT_TEXTURE)
		flash:SetAnchor(CENTER, subfilter, CENTER)
		flash:SetDimensions(ICON_SIZE, ICON_SIZE)
		flash:SetTexture(icon.flash)
		flash:SetHidden(true)
	end

	button:SetHandler("OnMouseEnter", function(self)
		ZO_Tooltips_ShowTextTooltip(self, TOP, tooltipSet[name])
		if(flash and subfilter.isActive) then
			flash:SetHidden(false)
		end
	end)
	button:SetHandler("OnMouseExit", function(self)
		ZO_Tooltips_HideTextTooltip()
		if(flash) then
			flash:SetHidden(true)
		end
	end)

	if(dropdownCallbacks) then
		local dropdown = self:AddDropdownFilter( subfilter, dropdownCallbacks, dropdownWidth )
	end

	subfilter.isActive = true

	table.insert(self.subfilters, subfilter)
end

function AdvancedFilterGroup:AddDropdownFilter( parent, callbackTable, dropdownWidth )
	local tooltipSet = AF_Strings[AdvancedFilters_GetLanguage()].TOOLTIPS
	local dropdown = WINDOW_MANAGER:CreateControlFromVirtual(parent:GetName() .. "DropdownFilter", parent, "ZO_ComboBox")

	parent.dropdown = dropdown
	dropdown:SetHidden(true)
	dropdown:SetAnchor(LEFT, self.control, LEFT, 10)
	dropdown:SetHeight(24)
	if(dropdownWidth) then
		dropdown:SetWidth(dropdownWidth)
	end
	local comboBox = dropdown.m_comboBox
    comboBox:SetSortsItems(false)

	for _,v in ipairs(callbackTable) do
		comboBox:AddItem(ZO_ComboBox:CreateItemEntry(tooltipSet[v.name], function()
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
		libFilters:UnregisterFilter(BUTTON_STRING)
		libFilters:UnregisterFilter(DROPDOWN_STRING)
		self.label:SetText("ALL")
		-- MoveHighlightToMe(self.control:GetNamedChild("AllButton"))
		-- self.control:GetNamedChild("AllButtonTexture"):SetTexture(AF_TextureMap.ALL.downTexture)
		-- self.control:GetNamedChild("AllButton"):SetScale(1.5)
		if(currentSelected and currentSelected.filterCallback and currentSelected:GetParent().dropdown) then
			currentSelected:GetParent().dropdown.m_comboBox:SelectFirstItem()
			currentSelected:GetParent().dropdown:SetHidden(true)
		end
		local allBtnHandler = self.control:GetNamedChild("AllButton"):GetHandler("OnClicked")
		allBtnHandler(self.control:GetNamedChild("AllButton"));
		self.control:GetNamedChild("AllButtonFlash"):SetHidden(true)
		-- currentSelected = self.control:GetNamedChild("AllButton")
	end
	-- currentDropdown = nil

	-- OnClickedCallback(self)
	-- PLAYER_INVENTORY:UpdateList(GetCurrentInventoryType())
end

function AdvancedFilterGroup:SetHidden( shouldHide )
	self.control:SetHidden(shouldHide)
end

function AdvancedFilterGroup:GetControl()
	return self.control
end