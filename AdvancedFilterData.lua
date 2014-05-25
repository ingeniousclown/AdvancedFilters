
local hasInit = false
local _

local function GetFilterCallbackForWeaponType( filterTypes )
	return function( slot )
		local itemLink = GetItemLink(slot.bagId, slot.slotIndex)
		local weaponType = GetItemWeaponType(itemLink)
		for i=1, #filterTypes do
			if(filterTypes[i] == weaponType) then 
				return true 
			end
		end
	end
end

local function GetFilterCallbackForArmorType( filterTypes )
	return function( slot )
		local itemLink = GetItemLink(slot.bagId, slot.slotIndex)
		local armorType = GetItemArmorType(itemLink)
		for i=1, #filterTypes do
			if(filterTypes[i] == armorType) then 
				return true 
			end
		end
	end
end

local function GetFilterCallbackForGear( filterTypes )
	return function( slot )
		local result = false
		for i=1, #filterTypes do
			local _,_,_,_,_,equipType = GetItemInfo(slot.bagId, slot.slotIndex)
			result = result or (filterTypes[i] == equipType)
		end
		return result
	end
end

local function GetFilterCallback( filterTypes )
	if(not filterTypes) then return function(slot) return true end end

	return function( slot )
		local result = false
		for i=1, #filterTypes do
			result = result or (filterTypes[i] == GetItemType(slot.bagId, slot.slotIndex))
		end
		return result
	end
end

function AdvancedFilters_InitAllFilters()
	if(hasInit) then return nil end
	hasInit = true

	local icon = [[/esoui/art/buttons/edit_disabled.dds]]

	-- WEAPONS --
	local oneHandedDropdownCallbacks = {
		[1] = { name = "All", filterCallback = GetFilterCallback(nil) },
		[2] = { name = "Axe", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_AXE}) },
		[3] = { name = "Hammer", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_HAMMER}) },
		[4] = { name = "Sword", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_SWORD}) },
		[5] = { name = "Dagger", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_DAGGER}) }
	}
	local twoHandedDropdownCallbacks = {
		[1] = { name = "All", filterCallback = GetFilterCallback(nil) },
		[2] = { name = "Axe", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_AXE}) },
		[3] = { name = "Hammer", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_HAMMER}) },
		[4] = { name = "Sword", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_SWORD}) },
	}
	local destructionStaffDropdownCallbacks = {
		[1] = { name = "All", filterCallback = GetFilterCallback(nil) },
		[2] = { name = "Fire", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_FIRE_STAFF}) },
		[3] = { name = "Frost", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_FROST_STAFF}) },
		[4] = { name = "Lightning", filterCallback = GetFilterCallbackForWeaponType({WEAPONTYPE_LIGHTNING}) },
	}

	local WEAPONS = AdvancedFilterGroup:New("Weapons")
	WEAPONS:AddSubfilter("HealStaff", [[/esoui/art/progression/icon_healstaff.dds]], 
		GetFilterCallbackForWeaponType({WEAPONTYPE_HEALING_STAFF}))
	WEAPONS:AddSubfilter("DestructionStaff", [[/esoui/art/progression/icon_firestaff.dds]], 
		GetFilterCallbackForWeaponType({WEAPONTYPE_FIRE_STAFF, WEAPONTYPE_FROST_STAFF, WEAPONTYPE_LIGHTNING_STAFF}),
		destructionStaffDropdownCallbacks)
	WEAPONS:AddSubfilter("Bow", [[/esoui/art/progression/icon_bows.dds]], 
		GetFilterCallbackForWeaponType({WEAPONTYPE_BOW}))
	WEAPONS:AddSubfilter("TwoHand", [[/esoui/art/progression/icon_2handed.dds]], 
		GetFilterCallbackForWeaponType({WEAPONTYPE_TWO_HANDED_AXE, WEAPONTYPE_TWO_HANDED_HAMMER, WEAPONTYPE_TWO_HANDED_SWORD}),
		twoHandedDropdownCallbacks)
	WEAPONS:AddSubfilter("OneHand", [[/esoui/art/progression/icon_dualwield.dds]], 
		GetFilterCallbackForWeaponType({WEAPONTYPE_AXE, WEAPONTYPE_HAMMER, WEAPONTYPE_SWORD, WEAPONTYPE_DAGGER}),
		oneHandedDropdownCallbacks)
	WEAPONS:AddSubfilter("All", AF_TextureMap.ALL, GetFilterCallback(nil))

	-- ARMORS --
	local lightArmorDropdownCallbacks = {
		[1] = { name = "All", filterCallback = GetFilterCallback(nil) },
		[2] = { name = "Head", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_HEAD}) },
		[3] = { name = "Chest", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_CHEST}) },
		[4] = { name = "Shoulders", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_SHOULDERS}) },
		[5] = { name = "Hand", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_HAND}) },
		[6] = { name = "Waist", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_WAIST}) },
		[7] = { name = "Legs", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_LEGS}) },
		[8] = { name = "Feet", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_FEET}) }
	}
	local mediumArmorDropdownCallbacks = ZO_DeepTableCopy(lightArmorDropdownCallbacks, mediumArmorDropdownCallbacks)
	local heavyArmorDropdownCallbacks = ZO_DeepTableCopy(lightArmorDropdownCallbacks, heavyArmorDropdownCallbacks)
	local allArmorDropdownCallbacks = ZO_DeepTableCopy(lightArmorDropdownCallbacks, allArmorDropdownCallbacks)

	local jewelryDropdownCallbacks = {
		[1] = { name = "All", filterCallback = GetFilterCallback(nil) },
		[2] = { name = "Ring", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_RING}) },
		[3] = { name = "Neck", filterCallback = GetFilterCallbackForGear({EQUIP_TYPE_NECK}) },
	}

	local ARMORS = AdvancedFilterGroup:New("Armors")
	ARMORS:AddSubfilter("Misc", [[/esoui/art/inventory/inventory_tabicon_misc_up.dds]], GetFilterCallbackForGear({EQUIP_TYPE_DISGUISE, EQUIP_TYPE_COSTUME}))
	ARMORS:AddSubfilter("Jewelry", [[/esoui/art/charactercreate/charactercreate_accessory_up.dds]], GetFilterCallbackForGear({EQUIP_TYPE_RING, EQUIP_TYPE_NECK}),
						jewelryDropdownCallbacks)
	ARMORS:AddSubfilter("Shield", [[/esoui/art/guild/guildhistory_indexicon_guild_up.dds]], GetFilterCallbackForGear({EQUIP_TYPE_OFF_HAND}))
	ARMORS:AddSubfilter("Light", [[/esoui/art/charactercreate/charactercreate_bodyicon_up.dds]], GetFilterCallbackForArmorType({ARMORTYPE_LIGHT}),
						lightArmorDropdownCallbacks)
	ARMORS:AddSubfilter("Medium", [[/esoui/art/campaign/overview_indexicon_scoring_up.dds]], GetFilterCallbackForArmorType({ARMORTYPE_MEDIUM}),
						mediumArmorDropdownCallbacks)
	ARMORS:AddSubfilter("Heavy", [[/esoui/art/inventory/inventory_tabicon_armor_up.dds]], GetFilterCallbackForArmorType({ARMORTYPE_HEAVY}),
						heavyArmorDropdownCallbacks)
	ARMORS:AddSubfilter("All", AF_TextureMap.ALL, GetFilterCallback(nil), allArmorDropdownCallbacks)

	-- CONSUMABLES --
	local CONSUMABLES = AdvancedFilterGroup:New("Consumables")
	CONSUMABLES:AddSubfilter("AvARepair", AF_TextureMap.AVAREPAIR, GetFilterCallback({ITEMTYPE_AVA_REPAIR}))
	CONSUMABLES:AddSubfilter("Container", AF_TextureMap.CONTAINER, GetFilterCallback({ITEMTYPE_CONTAINER}))
	CONSUMABLES:AddSubfilter("Scroll", AF_TextureMap.SCROLL, GetFilterCallback({ITEMTYPE_SCROLL}))
	CONSUMABLES:AddSubfilter("Poison", AF_TextureMap.POISON, GetFilterCallback({ITEMTYPE_POISON}))
	CONSUMABLES:AddSubfilter("Potion", AF_TextureMap.POTION, GetFilterCallback({ITEMTYPE_POTION}))
	CONSUMABLES:AddSubfilter("Recipe", AF_TextureMap.RECIPE, GetFilterCallback({ITEMTYPE_RECIPE}))
	CONSUMABLES:AddSubfilter("Drink", AF_TextureMap.DRINK, GetFilterCallback({ITEMTYPE_DRINK}))
	CONSUMABLES:AddSubfilter("Food", AF_TextureMap.FOOD, GetFilterCallback({ITEMTYPE_FOOD}))
	CONSUMABLES:AddSubfilter("All", AF_TextureMap.ALL, GetFilterCallback(nil))

	-- MATERIALS --
	local MATERIALS = AdvancedFilterGroup:New("Materials")
	MATERIALS:AddSubfilter("ArmorTrait", AF_TextureMap.ATRAIT, GetFilterCallback({ITEMTYPE_ARMOR_TRAIT}))
	MATERIALS:AddSubfilter("WeaponTrait", AF_TextureMap.WTRAIT, GetFilterCallback({ITEMTYPE_WEAPON_TRAIT}))
	MATERIALS:AddSubfilter("Style", AF_TextureMap.STYLE, GetFilterCallback({ITEMTYPE_STYLE_MATERIAL}))
	MATERIALS:AddSubfilter("Provisioning", AF_TextureMap.PROVISIONING, GetFilterCallback({ITEMTYPE_INGREDIENT}))
	MATERIALS:AddSubfilter("Enchanting", AF_TextureMap.ENCHANTING, GetFilterCallback({ITEMTYPE_ENCHANTING_RUNE}))
	MATERIALS:AddSubfilter("Alchemy", AF_TextureMap.ALCHEMY, GetFilterCallback({ITEMTYPE_REAGENT, ITEMTYPE_ALCHEMY_BASE}))
	MATERIALS:AddSubfilter("Woodworking", AF_TextureMap.WOODWORKING, GetFilterCallback({ITEMTYPE_WOODWORKING_MATERIAL, ITEMTYPE_WOODWORKING_RAW_MATERIAL, ITEMTYPE_WOODWORKING_BOOSTER}))
	MATERIALS:AddSubfilter("Clothier", AF_TextureMap.CLOTHIER, GetFilterCallback({ITEMTYPE_CLOTHIER_MATERIAL, ITEMTYPE_CLOTHIER_RAW_MATERIAL, ITEMTYPE_CLOTHIER_BOOSTER}))
	MATERIALS:AddSubfilter("Blacksmithing", AF_TextureMap.BLACKSMITHING, GetFilterCallback({ITEMTYPE_BLACKSMITHING_MATERIAL, ITEMTYPE_BLACKSMITHING_RAW_MATERIAL, ITEMTYPE_BLACKSMITHING_BOOSTER}))
	MATERIALS:AddSubfilter("All", AF_TextureMap.ALL, GetFilterCallback(nil))

	-- MISCELLANEOUS --
	local MISCELLANEOUS = AdvancedFilterGroup:New("Miscellaneous")
	MISCELLANEOUS:AddSubfilter("Trophy", AF_TextureMap.TROPHY, GetFilterCallback({ITEMTYPE_TROPHY}))
	MISCELLANEOUS:AddSubfilter("Trash", AF_TextureMap.TRASH, GetFilterCallback({ITEMTYPE_TRASH}))
	MISCELLANEOUS:AddSubfilter("Bait", AF_TextureMap.BAIT, GetFilterCallback({ITEMTYPE_LURE}))
	MISCELLANEOUS:AddSubfilter("Siege", [[/esoui/art/ava/ava_keepstatus_tabicon_keep_inactive.dds]], GetFilterCallback({ITEMTYPE_SIEGE}))
	MISCELLANEOUS:AddSubfilter("SoulGem", [[/esoui/art/guild/guild_indexicon_leader_up.dds]], GetFilterCallback({ITEMTYPE_SOUL_GEM}))
	MISCELLANEOUS:AddSubfilter("JewelryGlyph", AF_TextureMap.JEWELRYGLYPH, GetFilterCallback({ITEMTYPE_GLYPH_JEWELRY}))
	MISCELLANEOUS:AddSubfilter("ArmorGlyph", AF_TextureMap.ARMORGLYPH, GetFilterCallback({ITEMTYPE_GLYPH_ARMOR}))
	MISCELLANEOUS:AddSubfilter("WeaponGlyph", AF_TextureMap.WEAPONGLYPH, GetFilterCallback({ITEMTYPE_GLYPH_WEAPON}))
	MISCELLANEOUS:AddSubfilter("All", AF_TextureMap.ALL, GetFilterCallback(nil))

	return WEAPONS,ARMORS,CONSUMABLES,MATERIALS,MISCELLANEOUS
end


-- fire staff
		--[[/esoui/art/progression/icon_firestaff.dds]]
-- lightning staff
		--[[/esoui/art/progression/icon_lightningstaff.dds]]
-- ice staff
		--[[/esoui/art/progression/icon_icestaff.dds]]
-- heal staff
		--[[/esoui/art/progression/icon_healstaff.dds]]
-- bow
		--[[/esoui/art/progression/icon_bows.dds]]