
local hasInit = false
local _

local function GetFilterCallbackForWeaponType( filterTypes )
	return function( slot )
		for i=1, #filterTypes do
			local icon,_,_,_,_,equipType = GetItemInfo(slot.bagId, slot.slotIndex)
			if(equipType > 0 and string.find(icon, filterTypes[i])) then return true end
		end
	end
end

--only one type this time...
local function GetFilterCallbackForArmorType( filterType, iconString )
	return function( slot )
		local icon,_,_,_,_,equipType = GetItemInfo(slot.bagId, slot.slotIndex)
		local soundCategory = GetItemSoundCategory(slot.bagId, slot.slotIndex)
		if(equipType > 0 and (string.find(icon, iconString) or filterType == soundCategory)) then 
			return true 
		end
	end
end

local function GetFilterCallbackForWeaponArmorType( filterTypes )
	return function( slot )
		for i=1, #filterTypes do
			local soundCategory = GetItemSoundCategory(slot.bagId, slot.slotIndex)
			if(filterTypes[i] == soundCategory) then return true end
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

	--WEAPONS--
	local WEAPONS = AdvancedFilterGroup:New("Weapons")
	--heal staff = [[/esoui/art/progression/icon_healstaff.dds]]
	WEAPONS:AddSubfilter("Staff", [[/esoui/art/progression/icon_firestaff.dds]], GetFilterCallbackForWeaponArmorType({ITEM_SOUND_CATEGORY_STAFF}))
	WEAPONS:AddSubfilter("Bow", [[/esoui/art/progression/icon_bows.dds]], GetFilterCallbackForWeaponArmorType({ITEM_SOUND_CATEGORY_BOW}))
	WEAPONS:AddSubfilter("TwoHand", [[/esoui/art/progression/icon_2handed.dds]], 
		function(slot)
			local callbackA = GetFilterCallbackForGear({EQUIP_TYPE_TWO_HAND})
			local callbackB = GetFilterCallbackForWeaponArmorType({ITEM_SOUND_CATEGORY_STAFF, ITEM_SOUND_CATEGORY_BOW})
			return callbackA(slot) and not callbackB(slot)
		end)
	WEAPONS:AddSubfilter("OneHand", [[/esoui/art/progression/icon_dualwield.dds]], GetFilterCallbackForGear({EQUIP_TYPE_ONE_HAND}))
	WEAPONS:AddSubfilter("All", AF_TextureMap.ALL, GetFilterCallback(nil))

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
	ARMORS:AddSubfilter("Light", [[/esoui/art/charactercreate/charactercreate_bodyicon_up.dds]], GetFilterCallbackForArmorType(ITEM_SOUND_CATEGORY_LIGHT_ARMOR, "light"),
						lightArmorDropdownCallbacks)
	ARMORS:AddSubfilter("Medium", [[/esoui/art/campaign/overview_indexicon_scoring_up.dds]], GetFilterCallbackForArmorType(ITEM_SOUND_CATEGORY_MEDIUM_ARMOR, "medium"),
						mediumArmorDropdownCallbacks)
	ARMORS:AddSubfilter("Heavy", [[/esoui/art/inventory/inventory_tabicon_armor_up.dds]], GetFilterCallbackForArmorType(ITEM_SOUND_CATEGORY_HEAVY_ARMOR, "heavy"),
						heavyArmorDropdownCallbacks)
	ARMORS:AddSubfilter("All", AF_TextureMap.ALL, GetFilterCallback(nil), allArmorDropdownCallbacks)

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

	local MISCELLANEOUS = AdvancedFilterGroup:New("Miscellaneous")
	MISCELLANEOUS:AddSubfilter("Trophy", [[/esoui/art/campaign/campaign_tabicon_leaderboard_up.dds]], GetFilterCallback({ITEMTYPE_TROPHY}))
	MISCELLANEOUS:AddSubfilter("Trash", [[/esoui/art/inventory/inventory_tabicon_junk_up.dds]], GetFilterCallback({ITEMTYPE_TRASH}))
	MISCELLANEOUS:AddSubfilter("Bait", [[/esoui/art/mounts/feed_icon.dds]], GetFilterCallback({ITEMTYPE_LURE}))
	MISCELLANEOUS:AddSubfilter("Siege", [[/esoui/art/ava/ava_keepstatus_tabicon_keep_inactive.dds]], GetFilterCallback({ITEMTYPE_SIEGE}))
	MISCELLANEOUS:AddSubfilter("SoulGem", [[/esoui/art/guild/guild_indexicon_leader_up.dds]], GetFilterCallback({ITEMTYPE_SOUL_GEM}))
	MISCELLANEOUS:AddSubfilter("JewelryGlyph", [[/esoui/art/guild/guild_indexicon_member_up.dds]], GetFilterCallback({ITEMTYPE_GLYPH_JEWELRY}))
	MISCELLANEOUS:AddSubfilter("ArmorGlyph", [[/esoui/art/guild/guild_indexicon_officer_up.dds]], GetFilterCallback({ITEMTYPE_GLYPH_ARMOR}))
	MISCELLANEOUS:AddSubfilter("WeaponGlyph", [[/esoui/art/guild/guild_indexicon_leader_up.dds]], GetFilterCallback({ITEMTYPE_GLYPH_WEAPON}))
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