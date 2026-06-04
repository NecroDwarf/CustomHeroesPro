if wa == nil then
	wa = class({})
end

local info = require("utils/wavesInfo")
local utils = require("utils/utils")
local ri = require("utils/roshanInfo")

-- info
-- 1 - swordsman
-- 1.1 - tank, 1.1.1 - Veins_fire, 1.1.2 - stone_block
-- 1.2 - berserker, 1.2.1 - melee, 1.2.2 - illusionist
-- 2 - archer
-- 2.1 - shooter, 2.1.1 - marksman, 2.1.2 - headhunter
-- 2.2 - ranger, 2.2.1 - forest_guard, 2.2.2 - beast_master
-- 3 - mage
-- 3.1 - elementalist, 3.1.1 - fire_mage, 3.1.2 - air_mage
-- 3.2 - shaman, 3.2.1 - def_shaman, 3.2.2 - fight_shaman
-- 4 - catapult
-- 4.1 - siege_tower, 4.1.1 - fort_breaker, 4.1.2 - wall_crusher
-- 4.2 - mobile_launcher, 4.2.1 - rapid_fire, 4.2.2 - long_range

function wa:sortUnits(array)
	local priority = {
		swordsman = 1,
		archer    = 2,
		mage      = 3,
		catapult  = 4,
	}
	
    table.sort(array, function(a, b)
        return (priority[a] or math.huge) < (priority[b] or math.huge)
    end)
    return array
end

function wa:InitAddon(player, spawnPos, path, team, caravanSpawn, caravanPath, atkCarPath)
	-- player.units = {}
	player.units = {}
	
	player.upgrades = {
		["swordsman"] = {
			{type = "base", levels = {0, 0, 0}}, 
			{type = "class", levels = {0, 0}}, 
			{type = "sub", levels = {0}}, 
			nil, nil},
		["archer"] = {
			{type = "base", levels = {0, 0, 0}}, 
			{type = "class", levels = {0, 0}}, 
			{type = "sub", levels = {0}}, 
			nil, nil},
		["mage"] = {
			{type = "base", levels = {0, 0, 0}}, 
			{type = "class", levels = {0, 0}}, 
			{type = "sub", levels = {0}}, 
			nil, nil},
		["catapult"] = {
			{type = "base", levels = {0, 0, 0}}, 
			{type = "class", levels = {0, 0}}, 
			{type = "sub", levels = {0}}, 
			nil, nil},
	}
	
	player.path = path
	player.spawnPos = spawnPos
	player.team = team
	player.caravanSpawn = caravanSpawn
	player.caravanPath = caravanPath
	
	if player and player.GetPlayerID and atkCarPath then
		player.atkCarPath = atkCarPath
		local playerID = player:GetPlayerID()
		local playerKey = "player_" .. playerID
		
		CustomNetTables:SetTableValue("caravan_units", playerKey, {})
	end
end

function wa:spawnUnit(spawn_unit, player, spawnPos, pUpgrades, team, path)
	local name = spawn_unit
	
	local playerID
	if player and player.GetPlayerID then
		playerID = player:GetPlayerID()
	else
		playerID = "bot"
	end
	local unitUpg = pUpgrades[name]
	local class = unitUpg[4]
	local subclass = unitUpg[5]
	
	local pathName = name
	if subclass then pathName = subclass
	elseif class then pathName = class end
	local unitPath = info:getUnitByName(pathName)
	
	local unit = CreateUnitByName(unitPath, spawnPos, true, nil, nil, team)
	unit.path = path
	unit.type = name
	unit.class = class
	unit.subclass = subclass
	
	unit.skills = {}
	unit.items = {}
	unit.bonus = {}
	
	local names = {name, class, subclass}
	for i = 1, #names do
		local pUpgrade = unitUpg[i]
		local type = pUpgrade.type
		local levels = pUpgrade.levels
		local unitType = names[i]
		
		local skills = wi.skills[unitType]
		if skills then
			for k = 1, #skills do
				local skill = skills[k]
				utils:addAbility(unit, skill)
			end
		end
		
		for j = 1, #levels do
			local lvl = levels[j]
			
			if lvl > 0 and unitType then
				local upgrades = info.upgrades[type][unitType][j].levels
				
				for k = 1, lvl do
					local upgradeLevel = upgrades[k]
					
					for n = 1, #upgradeLevel do
						local upgrade = upgradeLevel[n]
						if upgrade.type == "spell" then
							-- print("SPELL:", upgrade.value)
							utils:addAbility(unit, upgrade.value)
							-- unit:AddAbility(upgrade.value)
						elseif upgrade.type == "spell_up" then
							utils:upgradeAbility(unit, upgrade.value)
						elseif upgrade.type == "replace" then
							utils:replaceAbility(unit, upgrade.value[1], upgrade.value[2])
						else
							if upgrade.type == "armor" then
								unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue() + upgrade.value)
							elseif upgrade.type == "magr" then
								unit:SetBaseMagicalResistanceValue(unit:GetBaseMagicalResistanceValue() + upgrade.value)
							elseif upgrade.type == "hpreg" then
								unit:SetBaseHealthRegen(unit:GetBaseHealthRegen() + upgrade.value)
							else
								-- остальные бонусы в модификатор
								if not unit.bonus[upgrade.type] then unit.bonus[upgrade.type] = 0 end
								unit.bonus[upgrade.type] = unit.bonus[upgrade.type] + upgrade.value
							end
						end
					end
					
				end
			end
			
		end
		
		local special = info.specials[unitType]
		if special then
			for j = 1, #special do
				local arr = special[j]
				if arr[1] == "replace" then
					utils:replaceAbility(unit, arr[2], arr[3])
				elseif arr[1] == "set" then
					local ability = unit:FindAbilityByName(arr[2])
					if ability then
						ability:SetLevel(arr[3])
					end
				elseif arr[1] == "upgrade" then
					utils:upgradeAbility(unit, arr[2])
				elseif arr[1] == "remove" then
					utils:removeAbility(unit, arr[2])
				end
			end
		end
	end
	
	local roshanId = ri:getRoshanUpgrade(playerID, unit.type)
	if roshanId and tonumber(roshanId) ~= 0 then
		local itemName = ri:getRoshanItem(playerID, unit.type)
		local item = CreateItem(itemName, unit, unit)
		unit:AddItem(item)
		table.insert(unit.items, item)
	end
	
	Timers:CreateTimer(0.5, function()
		unit:AddNewModifier(unit, nil, "modifier_buff_stats", {})
	end)
	
	return unit
end

function wa:spawnWave(player)
	local spawnPos = player.spawnPos
	local units = player.units
	local pUpgrades = player.upgrades
	local team = player.team
	
	units = wa:sortUnits(units)
	
	-- local hero = PlayerResource:GetSelectedHeroEntity(0)
	-- hero.bonus = {}
	-- hero.bonus["spell_amp"] = 50
	-- Timers:CreateTimer(0.5, function()
		-- hero:AddNewModifier(hero, nil, "modifier_buff_stats", {})
	-- end)
	
	for i = 1, #units do
		Timers:CreateTimer(0.5*i, function()
			wa:spawnUnit(units[i], player, spawnPos, pUpgrades, team, player.path)
		end)
	end
end

function wa:pingCaravan(owner, time)
	Timers:CreateTimer(time-10, function()
		local pingPos = owner.caravanSpawn
		utils:throughPlayers(function(player, hero, index)
			GameRules:ExecuteTeamPing( player:GetTeamNumber(), pingPos.x, pingPos.y, player, 0 )
		end, notHero)
	end)
end

function wa:spawnCaravan(player, level, enemies)
	local spawnPos = player.caravanSpawn
	local units = player.units
	local pUpgrades = player.upgrades
	local team = player.team
	local path = player.caravanPath
	
	
	local caravanUnits = {}
	local rogues = {}
	units = wa:sortUnits(units)
	
	local caravanInfo = {}
	caravanInfo.units = caravanUnits
	caravanInfo.rogues = rogues
	caravanInfo.reward = math.random(200, 800)
	
	local half = math.floor(#units/2)
	
	local function lSpawn(i)
		local unit = wa:spawnUnit(units[i], player, spawnPos, pUpgrades, team, path)
		
		local cost = info.base[units[i]].cost
		caravanInfo.reward = caravanInfo.reward + cost
		
		unit.isCaravan = true
		unit:SetBaseMoveSpeed(400)
		unit.caravan = caravanInfo
		table.insert(caravanUnits, unit)
	end
	
	local interval = 0.5
	for i = 1, half do
		Timers:CreateTimer(interval*i, function()
			lSpawn(i)
		end)
	end
	for i = 1, 3 do
		Timers:CreateTimer(interval*i + half*interval, function()
			local caravan = CreateUnitByName("npc_dota_clicker_treasure_carrier"..math.random(1, 2), spawnPos, true, nil, nil, team)
			caravan.path = path
			caravan.type = "caravan"
			caravan.isCaravan = true
			caravan.bonus = {
				hp = 300*(level-1)
			}
			caravan:SetBaseMoveSpeed(400)
			
			caravan.caravan = caravanInfo
			table.insert(caravanUnits, caravan)
			
			Timers:CreateTimer(0.5, function()
				caravan:AddNewModifier(unit, nil, "modifier_buff_stats", {})
			end)
		end)
	end
	for i = half+1, #units do
		Timers:CreateTimer(interval*i + interval*3, function()
			lSpawn(i)
		end)
	end
	
	for i = 1, #enemies do
		local enemyId = enemies[i]
		if enemyId then
			wa:spawnRogues(enemyId, rogues)
		end
	end
end

function wa:spawnRogues(playerID, rogues)
	local player = PlayerResource:GetPlayer(playerID)
	if player then
		local path = player.atkCarPath
		local spawnPos = path[1]:GetAbsOrigin()
		local pUpgrades = player.upgrades
		local team = player.team
		
		local playerKey = "player_" .. playerID
		local data = CustomNetTables:GetTableValue("caravan_units", playerKey)
		local units = utils:getArrFromCNT(data)
		
		units = wa:sortUnits(units)
		for i = 1, #units do
			Timers:CreateTimer(0.5*i, function()
				local unit = wa:spawnUnit(units[i], player, spawnPos, pUpgrades, team, path)
				unit.isRogue = true
				table.insert(rogues, unit)
			end)
		end
		
		CustomNetTables:SetTableValue("caravan_units", playerKey, {})
	end
end

return wa