if wi == nil then
	wi = class({})
end

local utils = require("utils/utils")

-- info
-- 1 - swordsman
-- 1.1 - tank, 1.1.1 - Veins_fire, 1.1.2 - stone_block
-- 1.2 - berserker, 1.2.1 - melee, 1.2.2 - illusionist
-- 2 - archer
-- 2.1 - shooter, 2.1.1 - gunner, 2.1.2 - sniper
-- 2.2 - ranger, 2.2.1 - pathfinder, 2.2.2 - marksman
-- 3 - mage
-- 3.1 - elementalist, 3.1.1 - fire_mage, 3.1.2 - air_mage
-- 3.2 - shaman, 3.2.1 - def_shaman, 3.2.2 - fight_shaman
-- 4 - catapult
-- 4.1 - siege_tower, 4.1.1 - trebuchet, 4.1.2 - ballista
-- 4.2 - bomber, 4.2.1 - rapid_fire, 4.2.2 - miner

wi.unitTypes = {
	"swordsman", "archer", "mage", "catapult"
}

wi.unitDescription = {
	["tank"] = "#unit_desc_tank",
	["berserker"] = "#unit_desc_berserker",
	["shooter"] = "#unit_desc_shooter",
	["ranger"] = "#unit_desc_ranger",
	["elementalist"] = "#unit_desc_elementalist",
	["shaman"] = "#unit_desc_shaman",
	["siege_tower"] = "#unit_desc_siege_tower",
	["bomber"] = "#unit_desc_bomber",
	
	["Veins_fire"] = "#unit_desc_Veins_fire",
	["stone_block"] = "#unit_desc_stone_block",
	["melee"] = "#unit_desc_melee",
	["illusionist"] = "#unit_desc_illusionist",
	["gunner"] = "#unit_desc_gunner",
	["sniper"] = "#unit_desc_sniper",
	["pathfinder"] = "#unit_desc_pathfinder",
	["marksman"] = "#unit_desc_marksman",
	["fire_mage"] = "#unit_desc_fire_mage",
	["air_mage"] = "#unit_desc_air_mage",
	["def_shaman"] = "#unit_desc_def_shaman",
	["fight_shaman"] = "#unit_desc_fight_shaman",
	["trebuchet"] = "#unit_desc_trebuchet",
	["ballista"] = "#unit_desc_ballista",
	["rapid_fire"] = "#unit_desc_rapid_fire",
	["miner"] = "#unit_desc_miner",
}

wi.requirement = {
	["tank"] = {upgs = {{"def", 2}, {"hp", 3}}},
	["berserker"] = {upgs = {{"damage", 4}, {"def", 1}}},
	["shooter"] = {upgs = {{"agility", 2}, {"strength", 2}}},
	["ranger"] = {upgs = {{"agility", 3}, {"def", 1}}},
	["elementalist"] = {upgs = {{"mana", 2}, {"spell_power", 3}}},
	["shaman"] = {upgs = {{"mana", 3}, {"def", 2}}},
	["siege_tower"] = {upgs = {{"siege", 3}, {"def", 2}}},
	["bomber"] = {upgs = {{"damage", 4}}},
	
	["Veins_fire"] = {class = "tank", upgs = {{"mag_armor", 3}}},
	["stone_block"] = {class = "tank", upgs = {{"phys_armor", 3}}},
	["melee"] = {class = "berserker", upgs = {{"crit", 3}}},
	["illusionist"] = {class = "berserker", upgs = {{"evade", 3}}},
	["gunner"] = {class = "shooter", upgs = {{"heave", 3}}},
	["sniper"] = {class = "shooter", upgs = {{"light", 3}}},
	["pathfinder"] = {class = "ranger", upgs = {{"nature", 3}}},
	["marksman"] = {class = "ranger", upgs = {{"multy", 3}}},
	["fire_mage"] = {class = "elementalist", upgs = {{"fire_upgrade", 3}}},
	["air_mage"] = {class = "elementalist", upgs = {{"water_upgrade", 3}}},
	["def_shaman"] = {class = "shaman", upgs = {{"chakra", 3}}},
	["fight_shaman"] = {class = "shaman", upgs = {{"dmg_boost", 3}}},
	["trebuchet"] = {class = "siege_tower", upgs = {{"splash", 3}}},
	["ballista"] = {class = "siege_tower", upgs = {{"speed_siege", 3}}},
	["rapid_fire"] = {class = "bomber", upgs = {{"dragon_slave", 3}}},
	["miner"] = {class = "bomber", upgs = {{"bombordiro", 3}}},
}

wi.specials = {
	-- ["unit"] = {{"replace", "from", "to"}, {"upgrade", "name"}, {"set", "name", 2}}, -- example
	["tank"] = {{"upgrade", "dota_clicker_tidehunter_kraken_shell"}},
	["bomber"] = {{"remove", "creep_siege"}},
	["siege_tower"] = {{"upgrade", "creep_siege"}},
	["sniper"] = {{"upgrade", "dc_sniper_headshot"}},
	["marksman"] = {{"upgrade", "dc_medusa_split_shot"}},
	["fire_mage"] = {{"replace", "dc_winter_wyvern_cold_embrace", "dc_lina_light_strike_array"}},
	["air_mage"] = {{"upgrade", "dc_winter_wyvern_cold_embrace"}, {"replace", "dc_jakiro_liquid_fire", "dc_jakiro_liquid_ice"}},
	["trebuchet"] = {{"upgrade", "black_dragon_splash_attack"}},
	["ballista"] = {{"replace", "black_dragon_splash_attack", "black_dragon_splash_attack_small"}},
	["miner"] = {"replace", "dc_lina_dragon_slave", "dc_techies_suicide_big"}
}

wi.skills = {
  -- ["unit"] = {"spell", "spell"}, -- example
  ["ballista"] = {"dc_windrunner_powershot"},
  ["mage"] = {"dotac_luna_lucent_beam"},
  ["catapult"] = {"creep_siege"},
  ["elementalist"] = {"dc_zuus_arc_lightning"},
  ["shaman"] = {"dc_shadow_shaman_mass_serpent_ward"},
  ["bomber"] = {"dc_techies_suicide"},
  ["Veins_fire"] = {"burning_strikes"},
  ["stone_block"] = {"dc_mars_bulwark"},
  ["fight_shaman"] = {"dc_witch_doctor_death_ward"},
  ["illusionist"] = {"melee_spawn_unit"},
  ["pathfinder"] = {"pathfinder_spawn_unit"},
  ["fire_mage"] = {"dc_batrider_flamebreak"},
  -- ["air_mage"] = {"dc_silencer_last_word"},
}

wi.units = {
	["swordsman"] = "npc_dota_clicker_main_warrior",
	["archer"] = "npc_dota_clicker_main_archer",
	["mage"] = "npc_dota_clicker_main_mage",
	["catapult"] = "npc_dota_clicker_main_engineer",
	
	["tank"] = "npc_dota_clicker_evol_tank",
	["berserker"] = "npc_dota_clicker_evol_melee",
	["shooter"] = "npc_dota_clicker_evol_shooter",
	["ranger"] = "npc_dota_clicker_evol_ranger",
	["elementalist"] = "npc_dota_clicker_evol_elementalist",
	["shaman"] = "npc_dota_clicker_evol_shaman",
	["siege_tower"] = "npc_dota_clicker_evol_catapult",
	["bomber"] = "npc_dota_clicker_evol_kamikaze",
	
	["Veins_fire"] = "npc_dota_clicker_evol_tank",
	["stone_block"] = "npc_dota_clicker_evol_tank",
	["melee"] = "npc_dota_clicker_evol_melee",
	["illusionist"] = "npc_dota_clicker_evol_melee",
	["gunner"] = "npc_dota_clicker_sub_gunner",
	["sniper"] = "npc_dota_clicker_sub_sniper",
	["pathfinder"] = "npc_dota_clicker_evol_ranger",
	["marksman"] = "npc_dota_clicker_evol_ranger",
	["fire_mage"] = "npc_dota_clicker_evol_elementalist",
	["air_mage"] = "npc_dota_clicker_sub_water_mage",
	["def_shaman"] = "npc_dota_clicker_evol_shaman",
	["fight_shaman"] = "npc_dota_clicker_evol_shaman",
	["trebuchet"] = "npc_dota_clicker_evol_catapult",
	["ballista"] = "npc_dota_clicker_evol_catapult",
	["rapid_fire"] = "npc_dota_clicker_sub_rapid_fire",
	["miner"] = "npc_dota_clicker_sub_miner",
}

wi.base = {
	["swordsman"] =
	{
		{type = "hp", levels = {
			{{type = "hp", value = 50}, {type = "hpreg", value = 0.1}, cost = 1},
			{{type = "hp", value = 50}, {type = "hpreg", value = 0.3}, cost = 2},
			{{type = "hp", value = 75}, {type = "hpreg", value = 0.2}, cost = 3},
			{{type = "hp", value = 50}, {type = "hpreg", value = 0.7}, cost = 4},
			{{type = "hp", value = 125}, {type = "hpreg", value = 2.7}, cost = 5},
		}},
		{type = "damage", levels = {
			{{type = "atk", value = 7}, {type = "atks", value = 3}, cost = 1},
			{{type = "atk", value = 9}, {type = "atks", value = 7}, cost = 2},
			{{type = "atk", value = 14}, {type = "atks", value = 5}, cost = 3},
			{{type = "atk", value = 20}, {type = "atks", value = 3}, cost = 4},
			{{type = "atk", value = 19}, {type = "atks", value = 15}, cost = 5},
		}},
		{type = "def", levels = {
			{{type = "magr", value = 1}, {type = "armor", value = 1}, cost = 1},
			{{type = "magr", value = 5}, {type = "armor", value = 1}, cost = 2},
			{{type = "magr", value = 12}, cost = 3},
			{{type = "magr", value = 6}, {type = "armor", value = 1}, cost = 4},
			{{type = "spell", value = "dota_clicker_tidehunter_kraken_shell"}, {type = "armor", value = 1}, cost = 5},
		}}, cost = 400
	},
	["archer"] =
	{
		{type = "agility", levels = {
			{{type = "atks", value = 3}, {type = "vision", value = 100}, cost = 1},
			{{type = "atks", value = 6}, cost = 2},
			{{type = "atks", value = 12}, {type = "vision", value = 150}, cost = 3},
			{{type = "atks", value = 7}, cost = 4},
			{{type = "atks", value = 18}, {type = "vision", value = 350}, cost = 5},
		}},
		{type = "strength", levels = {
			{{type = "atk", value = 7}, {type = "atk_dis", value = 25}, cost = 1},
			{{type = "spell", value = "dota_clicker_sniper_take_aim"}, cost = 2},
			{{type = "atk", value = 9}, {type = "atk_dis", value = 25}, cost = 3},
			{{type = "atk", value = 14}, {type = "atk_dis", value = 25}, cost = 4},
			{{type = "atk", value = 22}, {type = "atk_dis", value = 50}, cost = 5},
		}},
		{type = "def", levels = {
			{{type = "hp", value = 100}, {type = "armor", value = 1}, cost = 1},
			{{type = "hp", value = 25}, cost = 2},
			{{type = "hp", value = 100}, cost = 3},
			{{type = "hp", value = 25}, {type = "armor", value = 1}, cost = 4},
			{{type = "hp", value = 100}, {type = "armor", value = 1}, cost = 5},
		}}, cost = 500
	},
	["mage"] =
	{
		{type = "mana", levels = {
			{{type = "mana", value = 30}, {type = "manareg", value = 0.3}, cost = 1},
			{{type = "mana", value = 60}, {type = "manareg", value = 0.3}, cost = 2},
			{{type = "mana", value = 100}, cost = 3},
			{{type = "mana", value = 100}, cost = 4},
			{{type = "mana", value = 150}, {type = "manareg", value = 2.7}, cost = 5},
		}},
		{type = "spell_power", levels = {
			{{type = "spell_amp", value = 5}, {type = "spell_up", value = "dotac_luna_lucent_beam"}, cost = 1},
			{{type = "spell_amp", value = 7}, cost = 2},
			{{type = "spell_amp", value = 7}, {type = "spell_up", value = "dotac_luna_lucent_beam"}, cost = 3},
			{{type = "spell_amp", value = 9},cost = 4},
			{{type = "spell_amp", value = 15}, {type = "spell_up", value = "dotac_luna_lucent_beam"},cost = 5},
		}},
		{type = "def", levels = {
			{{type = "spell", value = "dc_frogmen_water_bubble_small"}, cost = 1},
			{{type = "spell_up", value = "dc_frogmen_water_bubble_small"}, {type = "armor", value = 1}, cost = 2},
			{{type = "spell_up", value = "dc_frogmen_water_bubble_small"}, cost = 3},
			{{type = "spell_up", value = "dc_frogmen_water_bubble_small"}, cost = 4},
			{{type = "spell_up", value = "dc_frogmen_water_bubble_small"}, {type = "armor", value = 1}, cost = 5},
		}}, cost = 600
	},
	["catapult"] =
	{
		{type = "siege", levels = {
			{{type = "atk", value = 20}, cost = 1},
			{{type = "atk", value = 40}, cost = 2},
			{{type = "atks", value = -40}, {type = "", value = 0}, cost = 3},
			{{type = "spell_up", value = "creep_siege"}, {type = "atk", value = 40}, cost = 4},
			{{type = "spell_up", value = "creep_siege"}, {type = "atk", value = 40}, cost = 5},
		}},
		{type = "damage", levels = {
			{{type = "atk", value = 15}, cost = 1},
			{{type = "atk", value = 20}, {type = "spell_amp", value = 7}, cost = 2},
			{{type = "atks", value = 15}, cost = 3},
			{{type = "atk", value = 25}, {type = "atks", value = 15}, cost = 4},
			{{type = "atk", value = 40}, {type = "spell_amp", value = 12}, cost = 5},
		}},
		{type = "def", levels = {
			{{type = "hp", value = 75}, {type = "armor", value = 1}, cost = 1},
			{{type = "hp", value = 75}, {type = "hpreg", value = 0.4}, cost = 2},
			{{type = "hp", value = 100}, cost = 3},
			{{type = "hp", value = 125}, {type = "hpreg", value = 1.4}, cost = 4},
			{{type = "hp", value = 125}, {type = "armor", value = 1}, cost = 5},
		}}, cost = 800
	},
}

wi.classes = {
	["tank"] = { -- swordsman
		{type = "mag_armor", levels = {
			{{type = "magr", value = 9}, cost = 2},
			{{type = "magr", value = 9}, cost = 4},
			{{type = "magr", value = 19}, cost = 6},
		}},
		{type = "phys_armor", levels = {
			{{type = "armor", value = 1}, {type = "hp", value = 400}, cost = 2},
			{{type = "armor", value = 1}, {type = "hpreg", value = 20}, cost = 4},
			{{type = "armor", value = 2}, {type = "hp", value = 600}, cost = 6},
		}}, cost = 10
	},
	["berserker"] = { -- swordsman
		{type = "crit", levels = {
			{{type = "spell", value = "dota_clicker_juggernaut_blade_dance"}, cost = 2},
			{{type = "spell_up", value = "dota_clicker_juggernaut_blade_dance"}, {type = "atk", value = 60}, cost = 4},
			{{type = "spell_up", value = "dota_clicker_juggernaut_blade_dance"}, {type = "atk", value = 100}, {type = "armor", value = 1}, cost = 7},
		}},
		{type = "evade", levels = {
			{{type = "spell", value = "dota_clicker_phantom_assassin_immaterial"}, {type = "hp", value = 300}, cost = 3},
			{{type = "spell_up", value = "dota_clicker_phantom_assassin_immaterial"}, {type = "atks", value = 20}, cost = 4},
			{{type = "spell_up", value = "dota_clicker_phantom_assassin_immaterial"}, {type = "atks", value = 20}, cost = 6},
		}}, cost = 10
	},
	["shooter"] = { -- archer
		{type = "heave", levels = { --+atks
			{{type = "hp", value = 100}, {type = "atks", value = 20}, cost = 2},
			{{type = "hp", value = 150}, {type = "atks", value = 20}, cost = 4},
			{{type = "hp", value = 250}, {type = "atks", value = 60}, cost = 6},
		}},
		{type = "light", levels = { -- -atks
			{{type = "atk", value = 50}, {type = "atks", value = -30}, {type = "spell", value = "dc_sniper_headshot"}, cost = 2},
			{{type = "atk", value = 70}, {type = "atks", value = -30}, {type = "spell_up", value = "dc_sniper_headshot"}, cost = 4},
			{{type = "atk", value = 75}, {type = "atks", value = -40}, {type = "spell_up", value = "dc_sniper_headshot"}, cost = 6},
		}}, cost = 10
	},
	["ranger"] = { -- archer
		{type = "nature", levels = {
			{{type = "hp", value = 120}, {type = "hpreg", value = 2}, cost = 2},
			{{type = "hp", value = 160}, {type = "armor", value = 1}, cost = 4},
			{{type = "hp", value = 200}, {type = "hpreg", value = 9}, cost = 6},
		}},
		{type = "multy", levels = {
			{{type = "spell", value = "dc_medusa_split_shot"}, cost = 2},
			{{type = "spell_up", value = "dc_medusa_split_shot"}, {type = "atks", value = 10}, cost = 4},
			{{type = "spell_up", value = "dc_medusa_split_shot"}, {type = "atks", value = 30}, cost = 6},
		}}, cost = 10
	},
	["elementalist"] = { -- mage
		{type = "fire_upgrade", levels = { -- даётся ликвид фаер змея горыныча
			{{type = "spell", value = "dc_jakiro_liquid_fire"}, {type = "spell_amp", value = 10}, cost = 2},
			{{type = "spell_up", value = "dc_jakiro_liquid_fire"}, cost = 4},
			{{type = "spell_up", value = "dc_jakiro_liquid_fire"}, {type = "spell_amp", value = 10}, cost = 6},
		}},
		{type = "water_upgrade", levels = { -- даётся колба виверны, огненный маг потом заменяет на вампиризм заклинанием
			{{type = "spell", value = "dc_winter_wyvern_cold_embrace"}, {type = "hpreg", value = 3}, cost = 2},
			{{type = "spell_up", value = "dc_winter_wyvern_cold_embrace"}, {type = "hpreg", value = 6}, cost = 4},
			{{type = "spell_up", value = "dc_winter_wyvern_cold_embrace"}, cost = 6},
		}}, cost = 10
	},
	["shaman"] = { -- mage
		{type = "chakra", levels = { -- chakra kotla
			{{type = "manareg", value = 12}, {type = "spell", value = "dc_keeper_of_the_light_chakra_magic"}, cost = 2},
			{{type = "manareg", value = 6}, {type = "spell_up", value = "dc_keeper_of_the_light_chakra_magic"}, cost = 4},
			{{type = "mana", value = 300}, {type = "spell_up", value = "dc_keeper_of_the_light_chakra_magic"}, cost = 6},
		}},
		{type = "dmg_boost", levels = { -- aura
			{{type = "spell", value = "dc_vengefulspirit_command_aura"}, cost = 2},
			{{type = "spell_up", value = "dc_vengefulspirit_command_aura"}, {type = "atk", value = 40}, cost = 4},
			{{type = "spell_up", value = "dc_vengefulspirit_command_aura"}, {type = "atk", value = 50}, cost = 6},
		}}, cost = 10
	},
	["siege_tower"] = { -- catapult
		{type = "splash", levels = {
			{{type = "spell", value = "black_dragon_splash_attack"}, cost = 2},
			{{type = "atk_dis", value = 40}, cost = 4},
			{{type = "spell_up", value = "black_dragon_splash_attack"}, {type = "atk_dis", value = 35}, cost = 6},
		}},
		{type = "speed_siege", levels = {
			{{type = "atks", value = 20}, cost = 2},
			{{type = "atks", value = 15}, {type = "atk", value = 40}, cost = 4},
			{{type = "atks", value = 20}, {type = "atk", value = 40}, cost = 6},
		}}, cost = 10
	},
	["bomber"] = { -- catapult
		{type = "bombordiro", levels = {
			{{type = "spell", value = "dc_techies_sticky_bomb"}, cost = 2},
			{{type = "spell_up", value = "dc_techies_sticky_bomb"}, cost = 4},
			{{type = "spell_up", value = "dc_techies_sticky_bomb"}, {type = "spell_amp", value = 10}, cost = 6},
		}},
		{type = "dragon_slave", levels = { -- у минера заменяется на улучшение прыжка
			{{type = "spell", value = "dc_lina_dragon_slave"}, cost = 2},
			{{type = "spell_up", value = "dc_lina_dragon_slave"}, {type = "mana", value = 200}, cost = 4},
			{{type = "spell_up", value = "dc_lina_dragon_slave"}, {type = "spell_amp", value = 5}, cost = 6},
		}}, cost = 10
	},
}

wi.subClasses = { -- усиляются их способности
	["Veins_fire"] = {
		{type = "Veins_fire_upgrade", levels = {
			{{type = "spell_up", value = "burning_strikes"}, cost = 3},
			{{type = "hp", value = 100}, {type = "magr", value = 5}, cost = 6},
			{{type = "spell_up", value = "burning_strikes"}, cost = 9},
		}}, cost = 20
	}, -- tank
	["stone_block"] = {
		{type = "stone_block_upgrade", levels = {
			{{type = "spell_up", value = "dc_mars_bulwark"}, cost = 3},
			{{type = "hp", value = 150}, {type = "hpreg", value = 1}, cost = 6},
			{{type = "spell_up", value = "dc_mars_bulwark"}, cost = 9},
		}}, cost = 20
	}, -- tank
	["melee"] = {
		{type = "melee_upgrade", levels = {
			{{type = "spell", value = "dc_weaver_geminate_attack"}, {type = "spell_up", value = "dota_clicker_juggernaut_blade_dance"}, cost = 3},
			{{type = "spell_up", value = "dc_weaver_geminate_attack"}, {type = "spell_up", value = "dota_clicker_juggernaut_blade_dance"}, {type = "hp", value = 300}, cost = 6},
			{{type = "spell_up", value = "dc_weaver_geminate_attack"}, {type = "spell_up", value = "dota_clicker_juggernaut_blade_dance"}, cost = 9},
		}}, cost = 20
	}, -- berserker
	["illusionist"] = {
		{type = "illusionist_upgrade", levels = {
			{{type = "spell", value = "dc_riki_permanent_invisibility"}, cost = 3},
			{{type = "spell_up", value = "melee_spawn_unit"}, {type = "hp", value = 300}, cost = 6},
			{{type = "spell_up", value = "melee_spawn_unit"}, cost = 9},
		}}, cost = 20
	}, -- berserker
	["gunner"] = {
		{type = "gunner_upgrade", levels = {
			{{type = "spell", value = "dc_troll_warlord_fervor"}, cost = 3},
			{{type = "spell_up", value = "dc_troll_warlord_fervor"}, cost = 6},
			{{type = "spell_up", value = "dc_troll_warlord_fervor"}, cost = 9},
		}}, cost = 20
	}, -- shooter
	["sniper"] = {
		{type = "sniper_upgrade", levels = {
			{{type = "spell_up", value = "dc_phantom_assassin_coup_de_grace"}, cost = 3},
			{{type = "spell_up", value = "dc_sniper_headshot"}, cost = 6},
			{{type = "spell_up", value = "dc_phantom_assassin_coup_de_grace"}, cost = 9},
		}}, cost = 20
	}, -- shooter
	["pathfinder"] = {
		{type = "pathfinder_upgrade", levels = {
			{{type = "spell_up", value = "pathfinder_spawn_unit"}, cost = 3},
			{{type = "spell", value = "dc_beastmaster_call_of_the_wild_hawk"}, cost = 6},
			{{type = "spell_up", value = "pathfinder_spawn_unit"}, cost = 9},
		}}, cost = 20
	}, -- ranger
	["marksman"] = {
		{type = "marksman_upgrade", levels = {
			{{type = "spell", value = "dc_windrunner_shackleshot"}, cost = 3},
			{{type = "spell_up", value = "dc_medusa_split_shot"}, cost = 6},
			{{type = "spell_up", value = "dc_medusa_split_shot"}, cost = 9},
		}}, cost = 20
	}, -- ranger
	["fire_mage"] = {
		{type = "fire_mage_upgrade", levels = {
			{{type = "spell_up", value = "dc_batrider_flamebreak"}, cost = 3},
			{{type = "spell", value = "dotac_magical_crit"}, cost = 6},
			{{type = "spell_up", value = "dc_lina_light_strike_array"}, cost = 9},
		}}, cost = 20
	}, -- elementalist
	["air_mage"] = {
		{type = "air_mage_upgrade", levels = {
			{{type = "spell", value = "dc_silencer_last_word"}, cost = 3},
			{{type = "spell_up", value = "dc_winter_wyvern_cold_embrace"}, cost = 6},
			{{type = "spell_up", value = "dc_winter_wyvern_cold_embrace"}, {type = "spell_up", value = "dc_jakiro_liquid_ice"}, cost = 9},
		}}, cost = 20
	}, -- elementalist
	["def_shaman"] = {
		{type = "def_shaman_upgrade", levels = {
			{{type = "spell_up", value = "dc_witch_doctor_voodoo_restoration"}, {type = "armor", value = 4}, cost = 3},
			{{type = "spell", value = "dc_witch_doctor_death_ward"}, cost = 6},
			{{type = "hpreg", value = 5}, {type = "spell_up", value = "dc_witch_doctor_voodoo_restoration"}, cost = 9},
		}}, cost = 20
	}, -- shaman
	["fight_shaman"] = {
		{type = "fight_shaman_upgrade", levels = {
			{{type = "spell_up", value = "dc_vengefulspirit_command_aura"}, cost = 3},
			{{type = "spell_up", value = "dc_witch_doctor_death_ward"}, cost = 6},
			{{type = "spell_up", value = "dc_witch_doctor_death_ward"}, cost = 9},
		}}, cost = 20
	}, -- shaman
	["trebuchet"] = {
		{type = "trebuchet_upgrade", levels = {
			{{type = "spell", value = "dc_earthshaker_enchant_totem"}, cost = 3},
			{{type = "spell_up", value = "black_dragon_splash_attack", value = "creep_siege	"}, cost = 6},
			{{type = "spell_up", value = "dc_earthshaker_enchant_totem"}, cost = 9},
		}}, cost = 20
	}, -- siege_tower
	["ballista"] = {
		{type = "ballista_upgrade", levels = {
			{{type = "spell_up", value = "dc_windrunner_powershot"}, cost = 3},
			{{type = "spell_up", value = "dc_windrunner_powershot"}, cost = 6},
			{{type = "spell_up", value = "dc_windrunner_powershot"}, cost = 9},
		}}, cost = 20
	}, -- siege_tower
	["rapid_fire"] = {
		{type = "rapid_fire_upgrade", levels = {
			{{type = "spell_up", value = "dc_shredder_flamethrower"}, cost = 3},
			{{type = "spell", value = "dc_batrider_sticky_napalm"}, cost = 6},
			{{type = "spell_up", value = "dc_batrider_sticky_napalm"}, cost = 9},
		}}, cost = 20
	}, -- bomber
	["miner"] = {
		{type = "miner_upgrade", levels = {
			{{type = "spell_up", value = "dc_techies_land_mines"}, cost = 3},
			{{type = "spell_up", value = "dc_techies_sticky_bomb"}, cost = 6},
			{{type = "spell_up", value = "dc_techies_land_mines"}, cost = 9},
		}}, cost = 20
	}, -- bomber
}

wi.upgrades = {
	["base"] = wi.base,
	["class"] = wi.classes,
	["sub"] = wi.subClasses,
}

wi.unitNames = {
	{"swordsman", "tank", "berserker", "Veins_fire", "stone_block", "melee", "illusionist"},
	{"archer", "shooter", "ranger", "gunner", "sniper", "pathfinder", "marksman"},
	{"mage", "elementalist", "shaman", "fire_mage", "air_mage", "def_shaman", "fight_shaman"},
	{"catapult", "siege_tower", "bomber", "trebuchet", "ballista", "rapid_fire", "miner"},
}

local autoDesc = {
    atks = "#add %d #add_atks",
    atk = "#add %d #add_atk",
    atk_dis = "#add %d #add_dis_atak",
    vision = "#add %d #add_vision",
    hp = "#add %d ед. #add_hp",
    armor = "#add %d #add_def",
    magr = "#add %d%% #add_def_mag",
    spell_amp = "#add %d%% #add_mag_damage",
    hpreg = "#add %.1f #add_hp_reg",
    mana = "#add %d #add_mana",
    manareg = "#add %.1f #add_mana_reg",
    spell = "#open_abil %s",
    spell_up = "#upg_abil %s",
}
wi.autoDesc = autoDesc

local abilitiesNames = {
	dc_batrider_flamebreak = "Fireball",
	dc_batrider_sticky_napalm = "Sticky Napalm",
	dc_beastmaster_call_of_the_wild_hawk = "Call Of The Wild Hawk",
	dc_earthshaker_enchant_totem = "Enchant Totem",
	dc_enchantress_natures_attendants = "Natures Attendants",
	dc_frogmen_water_bubble_small = "Water Bubble Small",
	dc_jakiro_liquid_fire = "Liquid Fire",
	dc_jakiro_liquid_ice = "Liquid Ice",
	dc_keeper_of_the_light_chakra_magic = "Chakra Magic",
	dc_lina_dragon_slave = "Dragon Slave",
	dc_lina_light_strike_array = "Light Strike Array",
	dc_mars_bulwark = "Bulwark",
	dc_medusa_split_shot = "Split Shot",
	dc_phantom_assassin_coup_de_grace = "in Coup De Grace",
	dc_riki_permanent_invisibility = "Permanent Invisibility",
	dc_shadow_shaman_mass_serpent_ward = "Mass Serpent Ward",
	dc_shredder_flamethrower = "Flamethrower",
	dc_silencer_last_word = "Last Word",
	dc_sniper_headshot = "Headshot",
	dc_techies_land_mines = "Land Mines",
	dc_techies_sticky_bomb = "Sticky Bomb",
	dc_techies_suicide = "Suicide",
	dc_techies_suicide_big = "Suicide Big",
	dc_troll_warlord_fervor = "Fervor",
	dc_vengefulspirit_command_aura = "Command Aura",
	dc_weaver_geminate_attack = "Geminate Attack",
	dc_windrunner_powershot = "Powershot",
	dc_windrunner_shackleshot = "Shackleshot",
	dc_witch_doctor_death_ward = "Death Ward",
	dc_witch_doctor_voodoo_restoration = "Voodoo Restoration",
	dc_winter_wyvern_cold_embrace = "Cold Embrace",
	dc_zuus_arc_lightning = "Arc Lightning",
	dota_clicker_juggernaut_blade_dance = "Blade Dance",
	dota_clicker_phantom_assassin_immaterial = "Immaterial",
	dota_clicker_sniper_take_aim = "Take Aim",
	dota_clicker_tidehunter_kraken_shell = "Kraken Shell",
	dotac_luna_lucent_beam = "Lucent Beam",
	burning_strikes = "Burning Strikes",
	black_dragon_splash_attack = "Splash",
	pathfinder_spawn_unit = "Call Of The Wild Boar",
	melee_spawn_unit = "Mirror Image",
	creep_siege = "Siege",
}

function wi:getUpgradeCost(unit, name, level)
	local upgrades = wi:getUpgrades(unit, name)
	if upgrades then 
		upgrades = upgrades.levels[level]
		if upgrades then
			return upgrades.cost or 300
		end
	end
	return 0
end

local function costText(cost)
	return "<br><br>#cost_text <font color='#4DA6FF'>" .. cost .. " #points</font>"
end

function wi:getUpgradeDescription(unit, name, level)
	
	local upgrades, type = wi:getUpgrades(unit, name)
	
	local desc = ""
	if upgrades then
		local maxLevel = wi:getMaxLevel(type, unit, name)
		upgrades = upgrades.levels[level]
		if upgrades then
			for i = 1, #upgrades do
				local upgrade = upgrades[i]
				if i > 1 then desc = desc .. "<br><br>" end
				if upgrade.desc then
					desc = desc .. upgrade.desc
				else
					local pattern = autoDesc[upgrade.type]
					if pattern and upgrade.value then
						if upgrade.type == "spell" or upgrade.type == "spell_up" then
							-- Берём локализованное имя способности
							-- desc = desc .. string.format(pattern, abilitiesNames[upgrade.value])
							desc = desc .. string.format(pattern, "#DOTA_Tooltip_ability_"..upgrade.value)
						else
							desc = desc .. string.format(pattern, upgrade.value)
						end
					end
				end
			end
		end
		
		if level <= maxLevel then
			local cost = wi:getUpgradeCost(unit, name, level)
			desc = desc .. costText(cost)
		end
	end
    return desc
end

function wi:getUnitByName(name)
	return wi.units[name]
end

function wi:getArrByUnit(unit)
	if wi.base[unit] then
		return wi.base[unit], "base"
	elseif wi.classes[unit] then
		return wi.classes[unit], "class"
	elseif wi.subClasses[unit] then
		return wi.subClasses[unit], "sub"
	end
end

function wi:getUpgByName(unit, name)
	local function getId(arr, type)
		for i = 1, #arr do
			local upg = arr[i]
			if upg.type == name then
				return i, type
			end
		end
		return nil
	end
	
	for i = 1, #wi.unitNames do
		local names = wi.unitNames[i]
		if utils:indexOf(names, unit) then
			for j = 1, #names do
				local unitName = names[j]
				local i, type = getId(wi:getArrByUnit(unitName))
				if i then
					return i, type, unitName
				end
			end
		end
	end
	return nil
end

function wi:getMaxLevel(type, unit, name)
	local id, _ = self:getUpgByName(unit, name)
	local upgrade = wi.upgrades[type][unit][id]
	if upgrade then
		return #upgrade.levels
	else
		return 0
	end
end

function wi:getUnitName(name)
	for i = 1, #wi.unitNames do
		local arr = wi.unitNames[i]
		if utils:indexOf(arr, name) then
			return arr[1]
		end
	end
end

function wi:getUpgrades(unit, name)
	local id, type = wi:getUpgByName(unit, name)
	local arr = wi:getArrByUnit(unit)
	
	return arr[id], type
end

-- Добавляем в конец файла wi.lua

-- Маппинг названий
wi.nameMapping = {
	-- Базовые типы
	["swordsman"] = "#unit_swordsman",
	["archer"] = "#unit_archer", 
	["mage"] = "#unit_mage",
	["catapult"] = "#unit_catapult",
	
	-- Классы (evolutions)
	["tank"] = "#unit_tank",
	["berserker"] = "#unit_berserker",
	["shooter"] = "#unit_shooter",
	["ranger"] = "#unit_ranger",
	["elementalist"] = "#unit_elementalist",
	["shaman"] = "#unit_shaman",
	["siege_tower"] = "#unit_siege_tower",
	["bomber"] = "#unit_bomber",
	
	-- Подклассы (subclasses)
	["Veins_fire"] = "#unit_Veins_fire",
	["stone_block"] = "#unit_stone_block",
	["melee"] = "#unit_melee",
	["illusionist"] = "#unit_illusionist",
	["gunner"] = "#unit_gunner",
	["sniper"] = "#unit_sniper",
	["pathfinder"] = "#unit_pathfinder",
	["marksman"] = "#unit_marksman",
	["fire_mage"] = "#unit_fire_mage",
	["air_mage"] = "#unit_air_mage",
	["def_shaman"] = "#unit_def_shaman",
	["fight_shaman"] = "#unit_fight_shaman",
	["trebuchet"] = "#unit_trebuchet",
	["ballista"] = "#unit_ballista",
	["rapid_fire"] = "#unit_rapid_fire",
	["miner"] = "#unit_miner",
	
	-- Названия апгрейдов
	["mana"] = "#upgrade_mana",
	["spell_power"] = "#upgrade_spell_power",
	["hp"] = "#upgrade_hp",
	["damage"] = "#upgrade_damage",
	["armor"] = "#upgrade_armor",
	["def"] = "#upgrade_def",
	["agility"] = "#upgrade_agility",
	["strength"] = "#upgrade_strength",
	["siege"] = "#upgrade_siege",
	["mag_armor"] = "#upgrade_mag_armor",
	["phys_armor"] = "#upgrade_phys_armor",
	["crit"] = "#upgrade_crit",
	["evade"] = "#upgrade_evade",
	["heave"] = "#upgrade_heave",
	["light"] = "#upgrade_light",
	["nature"] = "#upgrade_nature",
	["multy"] = "#upgrade_multy",
	["fire_upgrade"] = "#upgrade_fire_upgrade",
	["water_upgrade"] = "#upgrade_water_upgrade",
	["chakra"] = "#upgrade_chakra",
	["dmg_boost"] = "#upgrade_dmg_boost",
	["splash"] = "#upgrade_splash",
	["speed_siege"] = "#upgrade_speed_siege",
	["bombordiro"] = "#upgrade_bombordiro",
	["dragon_slave"] = "#upgrade_dragon_slave",
	["Veins_fire_upgrade"] = "#upgrade_Veins_fire_upgrade",
	["stone_block_upgrade"] = "#upgrade_stone_block_upgrade",
	["melee_upgrade"] = "#upgrade_melee_upgrade",
	["illusionist_upgrade"] = "#upgrade_illusionist_upgrade",
	["gunner_upgrade"] = "#upgrade_gunner_upgrade",
	["sniper_upgrade"] = "#upgrade_sniper_upgrade",
	["pathfinder_upgrade"] = "#upgrade_pathfinder_upgrade",
	["marksman_upgrade"] = "#upgrade_marksman_upgrade",
	["fire_mage_upgrade"] = "#upgrade_fire_mage_upgrade",
	["air_mage_upgrade"] = "#upgrade_air_mage_upgrade",
	["def_shaman_upgrade"] = "#upgrade_def_shaman_upgrade",
	["fight_shaman_upgrade"] = "#upgrade_fight_shaman_upgrade",
	["trebuchet_upgrade"] = "#upgrade_trebuchet_upgrade",
	["ballista_upgrade"] = "#upgrade_ballista_upgrade",
	["rapid_fire_upgrade"] = "#upgrade_rapid_fire_upgrade",
	["miner_upgrade"] = "#upgrade_miner_upgrade"
}

local roleNames = {
	dps = "[<font color='#E63946'>DPS</font>]",
	tank = "[<font color='#6C757D'>Tank</font>]",
	healer = "[<font color='#2ECC71'>Healer</font>]",
	buffer = "[<font color='#4DB6E5'>Buffer</font>]",
	debuffer = "[<font color='#9B59B6'>Debuffer</font>]",
	caster = "[<font color='#1F77D0'>Caster</font>]",
	siege = "[<font color='#E67E22'>Siege</font>]",
	summoner = "[<font color='#F1C40F'>Summoner</font>]",
}

local unitRoles = {
	["tank"] = {"tank"},
	["berserker"] = {"dps"},
	["shooter"] = {"dps"},
	["ranger"] = {"dps"},
	["elementalist"] = {"dps", "caster", "healer"},
	["shaman"] = {"summoner", "buffer"},
	["siege_tower"] = {"siege"},
	["bomber"] = {"dps", "caster"},
	
	["Veins_fire"] = {"tank", "debuffer"},
	["stone_block"] = {"tank"},
	["melee"] = {"dps"},
	["illusionist"] = {"dps", "summoner"},
	["gunner"] = {"dps"},
	["sniper"] = {"dps"},
	["pathfinder"] = {"dps", "summoner"},
	["marksman"] = {"dps", "debuffer"},
	["fire_mage"] = {"dps"},
	["air_mage"] = {"healer", "debuffer"},
	["def_shaman"] = {"buffer", "healer"},
	["fight_shaman"] = {"summoner", "buffer"},
	["trebuchet"] = {"siege"},
	["ballista"] = {"dps", "siege"},
	["rapid_fire"] = {"dps", "debuffer", "caster"},
	["miner"] = {"dps", "caster"},
}

function wi:getRoleText(unit)
	local roles = unitRoles[unit]
	local text = ""
	for i = 1, #roles do
		local role = roles[i]
		text = text..roleNames[role].." "
	end
	text = text.."<br>"
	return text
end

-- Функция преобразования всех данных в один большой массив
function wi:convertToUnifiedStructure()
  local result = {}
  
  local function newArray()
    return setmetatable({}, { __jsontype = 'array' })
  end

  -- Проходим по базовым типам юнитов
  for _, unitType in ipairs(wi.unitTypes) do
    local unitData = {
      name = wi.nameMapping[unitType] or unitType,
      baseUpgrades = newArray(),
      evolutions = newArray(),
      subclasses = newArray()
    }
    
    -- Получаем базовые апгрейды
    if wi.base[unitType] then
      for _, upgrade in ipairs(wi.base[unitType]) do
        local upgradeData = {
          id = upgrade.type,
          name = wi.nameMapping[upgrade.type] or upgrade.type,
          description = wi:getUpgradeDescription(unitType, upgrade.type, 1),
          level = 0,
          maxLevel = #upgrade.levels
        }
        table.insert(unitData.baseUpgrades, upgradeData)
      end
    end
    
    -- Находим все классы (evolutions) для данного базового типа
    for className, classData in pairs(wi.classes) do
      local parentType = wi:getUnitName(className)
      if parentType == unitType then
        local evolution = {
          id = className,
          name = wi.nameMapping[className] or className,
          description = wi:getRoleText(className) .. wi.unitDescription[className] .. costText(wi.classes[className].cost) .. "<br>" or "",
          requirement = {},
          skills = newArray()
        }
        
        -- Парсим требования из wi.requirement
        if wi.requirement[className] and wi.requirement[className].upgs then
          local reqs = wi.requirement[className].upgs
          for i = 1, #reqs do
            if reqs[i] then
              evolution.requirement[reqs[i][1]] = reqs[i][2]
            end
          end
        end
        
        -- Преобразуем levels в skills
        for _, skill in ipairs(classData) do
          local skillData = {
            id = skill.type,
            name = wi.nameMapping[skill.type] or skill.type,
            description = wi:getUpgradeDescription(className, skill.type, 1),
            level = 0,
            maxLevel = #skill.levels
          }
          table.insert(evolution.skills, skillData)
        end
        
        table.insert(unitData.evolutions, evolution)
      end
    end
    
    -- Находим все подклассы (subclasses) для данного базового типа
    for subClassName, subClassData in pairs(wi.subClasses) do
      local parentType = wi:getUnitName(subClassName)
      if parentType == unitType then
        local subclass = {
          id = subClassName,
          name = wi.nameMapping[subClassName] or subClassName,
          description = wi:getRoleText(subClassName) .. wi.unitDescription[subClassName] .. costText(wi.subClasses[subClassName].cost) .. "<br>" or "",
          requirement = {},
          skills = newArray()
        }
        
        -- Парсим требования из wi.requirement для подклассов
        if wi.requirement[subClassName] then
          local req = wi.requirement[subClassName]
          if req.class then
            -- Структура: { evolutions: { class_name: { upgrade_requirements } } }
            subclass.requirement.evolutions = {}
            subclass.requirement.evolutions[req.class] = {}
            
            if req.upgs then
              for i = 1, #req.upgs do
                if req.upgs[i] then
                  subclass.requirement.evolutions[req.class][req.upgs[i][1]] = req.upgs[i][2]
                end
              end
            end
          end
        end
        
		for _, skill in ipairs(subClassData) do
          local skillData = {
            id = skill.type,
            name = wi.nameMapping[skill.type] or skill.type,
            description = wi:getUpgradeDescription(subClassName, skill.type, 1),
            level = 0,
            maxLevel = #skill.levels
          }
          table.insert(subclass.skills, skillData)
        end
        
        table.insert(unitData.subclasses, subclass)
      end
    end
    
    result[unitType] = unitData
  end
  
  return result
end


-- Функция для вывода структуры в консоль для проверки
function wi:printUnifiedStructure()
	local data = wi:convertToUnifiedStructure()
	
	print("=== UNIFIED UNIT STRUCTURE ===")
	
	for unitType, unitData in pairs(data) do
		print("\n" .. unitType .. ": {")
		print("  name: \"" .. unitData.name .. "\",")
		
		-- Выводим базовые апгрейды
		print("  baseUpgrades: [")
		for _, upgrade in ipairs(unitData.baseUpgrades) do
			print("    { id: \"" .. upgrade.id .. "\", name: \"" .. upgrade.name .. "\", level: " .. upgrade.level .. ", maxLevel: " .. upgrade.maxLevel .. " },")
		end
		print("  ],")
		
		-- Выводим эволюции
		print("  evolutions: [")
		for _, evolution in ipairs(unitData.evolutions) do
			print("    {")
			print("      id: \"" .. evolution.id .. "\",")
			print("      name: \"" .. evolution.name .. "\",")
			print("      description: \"" .. evolution.description .. "\",")
			
			-- Выводим требования
			print("      requirement: {")
			local reqCount = 0
			for reqKey, reqValue in pairs(evolution.requirement) do
				if reqCount > 0 then print(", ") end
				print(" " .. reqKey .. ": " .. reqValue)
				reqCount = reqCount + 1
			end
			print(" },")
			
			-- Выводим скиллы
			print("      skills: [")
			for _, skill in ipairs(evolution.skills) do
				print("        { id: \"" .. skill.id .. "\", name: \"" .. skill.name .. "\", level: " .. skill.level .. ", maxLevel: " .. skill.maxLevel .. " },")
			end
			print("      ]")
			print("    },")
		end
		print("  ],")
		
		-- Выводим подклассы
		print("  subclasses: [")
		for _, subclass in ipairs(unitData.subclasses) do
			print("    {")
			print("      id: \"" .. subclass.id .. "\",")
			print("      name: \"" .. subclass.name .. "\",")
			print("      description: \"" .. subclass.description .. "\",")
			
			-- Выводим требования для подклассов
			print("      requirement: {")
			if subclass.requirement.evolutions then
				print("        evolutions: {")
				for evolName, evolReqs in pairs(subclass.requirement.evolutions) do
					print("          " .. evolName .. ": {")
					local reqCount = 0
					for reqKey, reqValue in pairs(evolReqs) do
						if reqCount > 0 then print(", ") end
						print(" " .. reqKey .. ": " .. reqValue)
						reqCount = reqCount + 1
					end
					print(" }")
				end
				print("        }")
			end
			print("      },")
			
			-- Выводим скиллы
			print("      skills: [")
			for _, skill in ipairs(subclass.skills) do
				print("        { id: \"" .. skill.id .. "\", name: \"" .. skill.name .. "\", level: " .. skill.level .. ", maxLevel: " .. skill.maxLevel .. " },")
			end
			print("      ]")
			print("    },")
		end
		print("  ]")
		print("},")
	end
	
	print("\n=== END STRUCTURE ===")
end

print("ZXCZXCZXC", "#neutral_damage_bonus")

return wi