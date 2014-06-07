
--thanks ckaotik
local function AF_Localize(text)
	if type(text) == 'number' then
		-- get the string from this constant
		text = GetString(text)
	end
	-- clean up suffixes such as ^F or ^S
	return zo_strformat(SI_TOOLTIP_ITEM_NAME, text)
end

AF_Strings = {
	["en"] = {
		TOOLTIPS = {
			["All"] = "All",

			["Axe"] = AF_Localize(SI_WEAPONTYPE1),
			["Sword"] = AF_Localize(SI_WEAPONTYPE3),
			["Hammer"] = AF_Localize(SI_WEAPONTYPE2),
			["Dagger"] = AF_Localize(SI_WEAPONTYPE11),
			["Fire"] = AF_Localize(SI_WEAPONTYPE12),
			["Frost"] = AF_Localize(SI_WEAPONTYPE13),
			["Lightning"] = AF_Localize(SI_WEAPONTYPE15),

			["DestructionStaff"] = "Destruction Staff",
			["HealStaff"] = AF_Localize(SI_WEAPONTYPE9),
			["Bow"] = "Bow",
			["TwoHand"] = "Two-Handed",
			["OneHand"] = "One-Handed",

			["Head"] = "Head",
			["Chest"] = "Chest",
			["Shoulders"] = "Shoulders",
			["Hand"] = "Hand",
			["Waist"] = "Waist",
			["Legs"] = "Legs",
			["Feet"] = "Feet",

			["Ring"] = "Ring",
			["Neck"] = "Neck",

			["Aspect"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
			["Essence"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
			["Potency"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),

			["Misc"] = "Miscellaneous",
			["Jewelry"] = "Jewelry",
			["Shield"] = "Shield",
			["Light"] = "Light",
			["Medium"] = "Medium",
			["Heavy"] = "Heavy",

			["AvARepair"] = "AvA Repair",
			["Container"] = "Container",
			["Scroll"] = "Scroll",
			["Poison"] = "Poison",
			["Potion"] = "Potion",
			["Recipe"] = "Recipe",
			["Drink"] = "Drink",
			["Food"] = "Food",

			["ArmorTrait"] = "Armor Trait",
			["WeaponTrait"] = "Weapon Trait",
			["Style"] = "Style",
			["Provisioning"] = "Provisioning",
			["Enchanting"] = "Enchanting",
			["Alchemy"] = "Alchemy",
			["Woodworking"] = "Woodworking",
			["Clothier"] = "Clothier",
			["Blacksmithing"] = "Blacksmithing",

			["Trophy"] = "Trophy",
			["Trash"] = "Trash",
			["Bait"] = "Bait",
			["Siege"] = "Siege",
			["SoulGem"] = "Soul Gem",
			["JewelryGlyph"] = "Jewelry Glyph",
			["ArmorGlyph"] = "Armor Glyph",
			["WeaponGlyph"] = "Weapon Glyph"
		}
	},
	["de"] = {
		TOOLTIPS = {
			["All"] = "Alle",

			["Axe"] = AF_Localize(SI_WEAPONTYPE1),
			["Sword"] = AF_Localize(SI_WEAPONTYPE3),
			["Hammer"] = AF_Localize(SI_WEAPONTYPE2),
			["Dagger"] = AF_Localize(SI_WEAPONTYPE11),
			["Fire"] = AF_Localize(SI_WEAPONTYPE12),
			["Frost"] = AF_Localize(SI_WEAPONTYPE13),
			["Lightning"] = AF_Localize(SI_WEAPONTYPE15),

			["DestructionStaff"] = "Zerst\195\182rungsst\195\164be",
			["HealStaff"] = AF_Localize(SI_WEAPONTYPE9),
			["Bow"] = "B\195\182gen",
			["TwoHand"] = "Zweih\195\164nder",
			["OneHand"] = "Einh\195\164nder",

			["Head"] = "Kopf",
			["Chest"] = "Brust",
			["Shoulders"] = "Schultern",
			["Hand"] = "H\195\164nde",
			["Waist"] = "Taille",
			["Legs"] = "Beine",
			["Feet"] = "F\195\188ße",

			["Ring"] = "Ring",
			["Neck"] = "Hals",

			["Aspect"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
			["Essence"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
			["Potency"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),

			["Misc"] = "Sonstige",
			["Jewelry"] = "Schmuck",
			["Shield"] = "Schilde",
			["Light"] = "Leichte",
			["Medium"] = "Mittlere",
			["Heavy"] = "Schwere",

			["AvARepair"] = "Reparaturzeug",
			["Container"] = "Beh\195\164lter",
			["Scroll"] = "Schriftrollen",
			["Poison"] = "Gifte",
			["Potion"] = "Zaubertr\195\164nke",
			["Recipe"] = "Rezepte",
			["Drink"] = "Getr\195\164nke",
			["Food"] = "Speisen",

			["ArmorTrait"] = "R\195\188stungsmerkmale",
			["WeaponTrait"] = "Waffenmerkmale",
			["Style"] = "Stilmaterial",
			["Provisioning"] = "Versorgen",
			["Enchanting"] = "Verzaubern",
			["Alchemy"] = "Alchemie",
			["Woodworking"] = "Schreinerei",
			["Clothier"] = "Schneiderei",
			["Blacksmithing"] = "Schmiedekunst",

			["Trophy"] = "Troph\195\164en",
			["Trash"] = "Plunder",
			["Bait"] = "K\195\182der",
			["Siege"] = "Belagerung",
			["SoulGem"] = "Seelensteine",
			["JewelryGlyph"] = "Schmuckglyphen",
			["ArmorGlyph"] = "R\195\188stungsglyphen",
			["WeaponGlyph"] = "Waffenglyphen"
		}
	},
	["fr"] = {
		TOOLTIPS = {
			["All"] = "Tout",

			["Axe"] = AF_Localize(SI_WEAPONTYPE1),
			["Sword"] = AF_Localize(SI_WEAPONTYPE3),
			["Hammer"] = AF_Localize(SI_WEAPONTYPE2),
			["Dagger"] = AF_Localize(SI_WEAPONTYPE11),
			["Fire"] = AF_Localize(SI_WEAPONTYPE12),
			["Frost"] = AF_Localize(SI_WEAPONTYPE13),
			["Lightning"] = AF_Localize(SI_WEAPONTYPE15),

			["DestructionStaff"] = "Destruction Staff",
			["HealStaff"] = AF_Localize(SI_WEAPONTYPE9),
			["Bow"] = "Arcs",
			["TwoHand"] = "Deux Mains",
			["OneHand"] = "Une Main",

			["Head"] = "T\195\170te",
			["Chest"] = "Buste",
			["Shoulders"] = "Epaules",
			["Hand"] = "Mains",
			["Waist"] = "Taille",
			["Legs"] = "Jambes",
			["Feet"] = "Pieds",

			["Ring"] = "Anneaux",
			["Neck"] = "Pendentifs",

			["Aspect"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION1),
			["Essence"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION2),
			["Potency"] = AF_Localize(SI_ENCHANTINGRUNECLASSIFICATION3),

			["Misc"] = "Divers",
			["Jewelry"] = "Bijoux",
			["Shield"] = "Boucliers",
			["Light"] = "L\195\169g\195\168re",
			["Medium"] = "Interm\195\169diaire",
			["Heavy"] = "Lourde",

			["AvARepair"] = "R\195\169paration",
			["Container"] = "Conteneurs",
			["Scroll"] = "Parchemins",
			["Poison"] = "Poisons",
			["Potion"] = "Potions",
			["Recipe"] = "Recettes",
			["Drink"] = "Boissons",
			["Food"] = "Nourriture",

			["ArmorTrait"] = "Traits d'armure",
			["WeaponTrait"] = "Traits d'arme",
			["Style"] = "Style",
			["Provisioning"] = "Approvisionnement",
			["Enchanting"] = "Enchantement",
			["Alchemy"] = "Alchimie",
			["Woodworking"] = "Travail du bois",
			["Clothier"] = "Couture",
			["Blacksmithing"] = "Forge",

			["Trophy"] = "Troph\195\169es",
			["Trash"] = "Rebuts",
			["Bait"] = "App\195\162ts",
			["Siege"] = "Si\195\168ge",
			["SoulGem"] = "Pierres d'\195\162me",
			["JewelryGlyph"] = "Glyphes de bijou",
			["ArmorGlyph"] = "Glyphes d'armure",
			["WeaponGlyph"] = "Glyphes d'arme"
		}
	}
}

