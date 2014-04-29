
local hasInit = false

local function GetFilterCallbackForWeaponType( filterTypes )
	return function( slot )
		for i=1, #filterTypes do
			local icon = GetItemInfo(slot.bagId, slot.slotIndex)
			if(string.find(icon, filterTypes[i])) then return true end
		end
	end
end

local function GetFilterCallbackForArmorType( filterTypes )
	return function( slot )
		for i=1, #filterTypes do
			local icon = GetItemInfo(slot.bagId, slot.slotIndex)
			if(string.find(icon, filterTypes[i])) then return true end
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
--/script ZO_PlayerInventory_AFGConsumables:SetHidden(false)
--/zgoo ZO_PlayerInventory_AFGConsumables
function AdvancedFilters_InitAllFilters()
	if(hasInit) then return nil end
	hasInit = true

	local icon = [[/esoui/art/buttons/edit_disabled.dds]]

	--WEAPONS--
	local WEAPONS = AdvancedFilterGroup:New("Weapons")
	--heal staff = [[/esoui/art/progression/icon_healstaff.dds]]
	WEAPONS:AddSubfilter("Staff", [[/esoui/art/progression/icon_firestaff.dds]], GetFilterCallbackForWeaponType({"_staff"}))
	WEAPONS:AddSubfilter("Bow", [[/esoui/art/progression/icon_bows.dds]], GetFilterCallbackForWeaponType({"_bow"}))
	WEAPONS:AddSubfilter("TwoHand", [[/esoui/art/progression/icon_2handed.dds]], 
		function(slot)
			local callbackA = GetFilterCallbackForGear({EQUIP_TYPE_TWO_HAND})
			local callbackB = GetFilterCallbackForWeaponType({"_staff", "_bow"})
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
	ARMORS:AddSubfilter("Light", [[/esoui/art/charactercreate/charactercreate_bodyicon_up.dds]], GetFilterCallbackForArmorType({"_light"}),
						lightArmorDropdownCallbacks)
	ARMORS:AddSubfilter("Medium", [[/esoui/art/campaign/overview_indexicon_scoring_up.dds]], GetFilterCallbackForArmorType({"_medium"}),
						mediumArmorDropdownCallbacks)
	ARMORS:AddSubfilter("Heavy", [[/esoui/art/inventory/inventory_tabicon_armor_up.dds]], GetFilterCallbackForArmorType({"_heavy"}),
						heavyArmorDropdownCallbacks)
	ARMORS:AddSubfilter("All", AF_TextureMap.ALL, GetFilterCallback(nil))

	local CONSUMABLES = AdvancedFilterGroup:New("Consumables")
	CONSUMABLES:AddSubfilter("AvARepair", AF_TextureMap.AVAREPAIR, GetFilterCallback({ITEMTYPE_AVA_REPAIR}))
	CONSUMABLES:AddSubfilter("Container", AF_TextureMap.CONTAINER, GetFilterCallback({ITEMTYPE_CONTAINER}))
	CONSUMABLES:AddSubfilter("Scroll", AF_TextureMap.SCROLL, GetFilterCallback({ITEMTYPE_SCROLL}))
	CONSUMABLES:AddSubfilter("Poison", AF_TextureMap.POISON, GetFilterCallback({ITEMTYPE_POISON}))
	CONSUMABLES:AddSubfilter("Potion", AF_TextureMap.POTION, GetFilterCallback({ITEMTYPE_POTION}))
	CONSUMABLES:AddSubfilter("Recipe", AF_TextureMap.RECIPE, GetFilterCallback({ITEMTYPE_RECIPE}))
	CONSUMABLES:AddSubfilter("Drink", AF_TextureMap.DRINK, GetFilterCallback({ITEMTYPE_DRINK}))
	CONSUMABLES:AddSubfilter("Food", [[/esoui/art/ava/ava_keepstatus_icon_food_neutral.dds]], GetFilterCallback({ITEMTYPE_FOOD}))
	CONSUMABLES:AddSubfilter("All", AF_TextureMap.ALL, GetFilterCallback(nil))

	local MATERIALS = AdvancedFilterGroup:New("Materials")
	MATERIALS:AddSubfilter("ArmorTrait", [[/esoui/art/lfg/lfg_tabicon_mygroup_up.dds]], GetFilterCallback({ITEMTYPE_ARMOR_TRAIT}))
	MATERIALS:AddSubfilter("WeaponTrait", [[/esoui/art/progression/icon_1handplusrune.dds]], GetFilterCallback({ITEMTYPE_WEAPON_TRAIT}))
	MATERIALS:AddSubfilter("Style", [[/esoui/art/campaign/campaignbrowser_indexicon_specialevents_up.dds]], GetFilterCallback({ITEMTYPE_STYLE_MATERIAL}))
	MATERIALS:AddSubfilter("Provisioning", [[/esoui/art/ava/ava_keepstatus_icon_food_neutral.dds]], GetFilterCallback({ITEMTYPE_INGREDIENT}))
	MATERIALS:AddSubfilter("Enchanting", [[/esoui/art/progression/icon_enchanter.dds]], GetFilterCallback({ITEMTYPE_ENCHANTING_RUNE}))
	MATERIALS:AddSubfilter("Alchemy", [[/esoui/art/inventory/inventory_tabicon_consumables_up.dds]], GetFilterCallback({ITEMTYPE_REAGENT, ITEMTYPE_ALCHEMY_BASE}))
	MATERIALS:AddSubfilter("Woodworking", [[/esoui/art/ava/ava_keepstatus_tabicon_wood_inactive.dds]], GetFilterCallback({ITEMTYPE_WOODWORKING_MATERIAL, ITEMTYPE_WOODWORKING_RAW_MATERIAL, ITEMTYPE_WOODWORKING_BOOSTER}))
	MATERIALS:AddSubfilter("Clothier", [[/esoui/art/characterwindow/gearslot_tabard.dds]], GetFilterCallback({ITEMTYPE_CLOTHIER_MATERIAL, ITEMTYPE_CLOTHIER_RAW_MATERIAL, ITEMTYPE_CLOTHIER_BOOSTER}))
	MATERIALS:AddSubfilter("Blacksmithing", [[/esoui/art/inventory/inventory_tabicon_crafting_up.dds]], GetFilterCallback({ITEMTYPE_BLACKSMITHING_MATERIAL, ITEMTYPE_BLACKSMITHING_RAW_MATERIAL, ITEMTYPE_BLACKSMITHING_BOOSTER}))
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


-- shield
		--[[/esoui/art/guild/guildhistory_indexicon_guild_up.dds]]
		--[[/esoui/art/characterwindow/gearslot_offhand.dds]]
-- light
		--[[/esoui/art/characterwindow/gearslot_tabard.dds]]
-- medium
		--[[/esoui/art/progression/progression_tabicon_passive_inactive.dds]]
-- heavy
		--[[/esoui/art/progression/progression_indexicon_armor_up.dds]]


-- general Miscellaneous
		--/esoui/art/inventory/inventory_tabicon_misc_up.dds