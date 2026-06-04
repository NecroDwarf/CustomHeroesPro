if custom_heroes_pro == nil then
	custom_heroes_pro = class({})
end

local utils = require("utils/utils")

--### CONSTANTS ###
local START_GOLD = 600
local PLAYER_INFO_CNT = "player_info"

-- Команды кастомок: DOTA_TEAM_CUSTOM_1 ... DOTA_TEAM_CUSTOM_8
local CUSTOM_TEAMS = {
	DOTA_TEAM_CUSTOM_1,
	DOTA_TEAM_CUSTOM_2,
	DOTA_TEAM_CUSTOM_3,
	DOTA_TEAM_CUSTOM_4,
	DOTA_TEAM_CUSTOM_5,
	DOTA_TEAM_CUSTOM_6,
	DOTA_TEAM_CUSTOM_7,
	DOTA_TEAM_CUSTOM_8,
}

local processedHeroes = {}
local waveUnits = {}

-- Fallback-таблица.
-- Основная логика теперь НЕ через whitelist, а через DOTA_ABILITY_BEHAVIOR_INNATE.
-- Сюда добавляй только способности, если вдруг какая-то врождёнка не определяется автоматически.
local FORCE_KEEP_ABILITIES = {
	["generic_hidden"] = true,
}

function custom_heroes_pro:GetTeamName(teamNumber)
	for index, team in ipairs(CUSTOM_TEAMS) do
		if team == teamNumber then
			return "DOTA_TEAM_CUSTOM_" .. index
		end
	end

	if teamNumber == DOTA_TEAM_GOODGUYS then
		return "DOTA_TEAM_GOODGUYS"
	end

	if teamNumber == DOTA_TEAM_BADGUYS then
		return "DOTA_TEAM_BADGUYS"
	end

	return tostring(teamNumber)
end

function custom_heroes_pro:BuildPlayerData(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local hero = PlayerResource:GetSelectedHeroEntity(playerID)
	local teamNumber = PlayerResource:GetTeam(playerID)
	local gold = PlayerResource:GetGold(playerID)

	return {
		id = playerID,
		player = player,
		hero = hero and hero:GetUnitName() or "",
		team_name = self:GetTeamName(teamNumber),
		gold = gold,
	}
end

function custom_heroes_pro:UpdatePlayerData(playerID)
	if playerID == nil or playerID < 0 then
		return
	end

	self.Players[playerID] = self.Players[playerID] or {}

	local data = self:BuildPlayerData(playerID)
	self.Players[playerID].player = data.player
	self.Players[playerID].hero_name = data.hero
	self.Players[playerID].team_name = data.team_name
	self.Players[playerID].gold = data.gold

	utils:setDataCNT(playerID, PLAYER_INFO_CNT, data)
	
	print("ZXC", utils:getDataCNT(playerID, PLAYER_INFO_CNT).team_name)
end

function custom_heroes_pro:InitGameMode()
	print("CUSTOM HEROES PRO INIT")

	-- Базовые правила
	GameRules:SetStartingGold(START_GOLD)
	GameRules:SetUseUniversalShopMode(true)
	GameRules:SetGoldPerTick(0)

	-- Single Draft для тестов
	GameRules:SetHeroSelectionTime(60)
	GameRules:SetSameHeroSelectionEnabled(false)

	local mode = GameRules:GetGameModeEntity()

	-- Курьеры / респавн / видимость
	mode:SetFreeCourierModeEnabled(false)

	-- Вся карта видна
	mode:SetFogOfWarDisabled(true)

	if mode.SetUnseenFogOfWarEnabled then
		mode:SetUnseenFogOfWarEnabled(false)
	end

	-- 8 команд по 1 игроку
	self:SetupTeams()

	-- Таблица состояния игроков
	self.Players = {}
	self.Duels = {}
	self.CurrentDuel = {}
	self.Wave = {}

	-- Game state
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(self, "chpStateChange"), self)

	-- Игроки / подключения
	ListenToGameEvent("player_connect_full", Dynamic_Wrap(self, "OnPlayerConnectFull"), self)
	ListenToGameEvent("player_disconnect", Dynamic_Wrap(self, "OnPlayerDisconnect"), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(self, "OnPlayerReconnected"), self)

	-- Герои / юниты / смерти
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(self, "OnNPCSpawned"), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(self, "OnEntityKilled"), self)
end

function custom_heroes_pro:SetupTeams()
	for _, team in pairs(CUSTOM_TEAMS) do
		GameRules:SetCustomGameTeamMaxPlayers(team, 1)
	end

	-- На всякий случай отключаем обычные команды Radiant/Dire.
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 0)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 0)
end

function custom_heroes_pro:chpStateChange(data)
	local newState = GameRules:State_Get()

	if newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		print("HERO SELECTION STARTED")
	end

	if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:chpStart()
	end
end

function custom_heroes_pro:chpStart()
	print("CUSTOM HEROES PRO START")
	
	
end

function custom_heroes_pro:OnNPCSpawned(data)
	local unit = EntIndexToHScript(data.entindex)

	if not unit then
		return
	end

	if not unit:IsRealHero() then
		return
	end

	local playerID = unit:GetPlayerOwnerID()

	if playerID == nil or playerID < 0 then
		return
	end

	-- Сохраняем героя игрока
	self.Players[playerID] = self.Players[playerID] or {}
	self.Players[playerID].hero = unit
	self:UpdatePlayerData(playerID)

	-- Отключаем респавн конкретно этому герою на всякий случай
	if unit.SetRespawnsDisabled then
		unit:SetRespawnsDisabled(true)
	end

	-- Чтобы не чистить героя повторно
	if processedHeroes[playerID] then
		return
	end

	processedHeroes[playerID] = true

	-- Небольшая задержка нужна, чтобы способности героя точно успели создаться
	if Timers then
		Timers:CreateTimer(0.1, function()
			if unit and not unit:IsNull() then
				self:CleanHeroAbilities(unit)
			end
		end)
	else
		self:CleanHeroAbilities(unit)
	end
end

function custom_heroes_pro:CleanHeroAbilities(hero)
	if not hero or hero:IsNull() then
		return
	end

	print("Cleaning abilities for hero:", hero:GetUnitName())

	local abilitiesToRemove = {}

	-- Обычно хватает 0..23.
	-- Таланты, врождёнки и fallback-способности не удаляем.
	for i = 0, 23 do
		local ability = hero:GetAbilityByIndex(i)

		if ability then
			local abilityName = ability:GetAbilityName()

			if self:ShouldKeepAbility(abilityName, ability) then
				print("Keeping ability:", abilityName)
			else
				table.insert(abilitiesToRemove, abilityName)
			end
		end
	end

	-- Удаляем отдельно, чтобы не ломать обход слотов
	for _, abilityName in pairs(abilitiesToRemove) do
		print("Removing ability:", abilityName)
		hero:RemoveAbility(abilityName)
	end
end

function custom_heroes_pro:ShouldKeepAbility(abilityName, ability)
	if not abilityName or abilityName == "" then
		return false
	end

	-- Таланты
	if string.find(abilityName, "special_bonus_") == 1 then
		return true
	end

	-- Fallback whitelist
	if FORCE_KEEP_ABILITIES[abilityName] then
		return true
	end

	-- Врождённые способности
	if self:IsInnateAbility(ability) then
		return true
	end

	return false
end

function custom_heroes_pro:IsInnateAbility(ability)
	if not ability then
		return false
	end

	if not DOTA_ABILITY_BEHAVIOR_INNATE then
		return false
	end

	if not ability.GetBehaviorInt then
		return false
	end

	local behavior = ability:GetBehaviorInt()

	if not behavior then
		return false
	end

	return bit.band(behavior, DOTA_ABILITY_BEHAVIOR_INNATE) ~= 0
end

function custom_heroes_pro:OnPlayerConnectFull(data)
	local playerID = data.PlayerID

	if playerID == nil or playerID < 0 then
		return
	end

	self.Players[playerID] = self.Players[playerID] or {}
	self.Players[playerID].connected = true
	self:UpdatePlayerData(playerID)

	print("Player connected full:", playerID)
end

function custom_heroes_pro:OnPlayerDisconnect(data)
	local playerID = data.PlayerID

	if playerID == nil or playerID < 0 then
		return
	end

	self.Players[playerID] = self.Players[playerID] or {}
	self.Players[playerID].connected = false
	self.Players[playerID].disconnectedAt = GameRules:GetGameTime()

	print("Player disconnected:", playerID)
end

function custom_heroes_pro:OnPlayerReconnected(data)
	local playerID = data.PlayerID

	if playerID == nil or playerID < 0 then
		return
	end

	self.Players[playerID] = self.Players[playerID] or {}
	self.Players[playerID].connected = true

	print("Player reconnected:", playerID)
end

function custom_heroes_pro:OnEntityKilled(data)
	local killed = EntIndexToHScript(data.entindex_killed)

	if not killed then
		return
	end

	if not killed:IsRealHero() then
		return
	end

	local playerID = killed:GetPlayerOwnerID()

	print("Hero killed:", playerID, killed:GetUnitName())

	-- Страховка от респавна
	if killed.SetRespawnsDisabled then
		killed:SetRespawnsDisabled(true)
	end
end
