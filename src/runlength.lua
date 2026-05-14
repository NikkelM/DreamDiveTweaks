import 'EnemyScalingData.lua'
import 'EnemyScalingData12.lua'
import 'EncounterScalingLogic.lua'

--#region Basic runlength changes

if type(config.biome_count) == "number" then
    config.biome_count = math.min(config.biome_count, mod.MaxAllowedBiomeCount)
    config.biome_count = math.max(config.biome_count, 2)
else
    config.biome_count = 4
end

game.GameData.FullRunBiomeCount = config.biome_count

game.ConcatTableValuesIPairs(game.RoomSets.Dream,{
    "Dream_PostBoss01",
    "Dream_PostBoss02",
    "Dream_PostBoss03",
    "Dream_PostBoss01",
    "Dream_PostBoss02",
    "Dream_PostBoss03",
    "Dream_PostBoss01",
    "Dream_PostBoss02",
    "Dream_PostBoss03",
    "Dream_PostBoss01",
    "Dream_PostBoss02",
    "Dream_PostBoss03",
})

modutil.mod.Path.Wrap("SelectNextDreamBiome", function (base, source, args)
    base(source,args)
    if game.CurrentRun.CurrentRoom.NextRoomSet[1] == nil then
        game.CurrentRun.CurrentRoom.NextRoomSet = { game.RemoveRandomValue( game.CurrentRun.DreamBiomePool ) }
    end
end)

function mod.SanitizeKeepsakeCache()
    local shortenedKeepsakes = {}
    for i = 1, 4 do
        shortenedKeepsakes[i] = game.CurrentRun.KeepsakeCache[i]
    end
    game.CurrentRun.KeepsakeCache = shortenedKeepsakes
end

modutil.mod.Path.Wrap("KillHero", function (base, ...)
    mod.SanitizeKeepsakeCache()
    return base(...)
end)

modutil.mod.Path.Wrap("DeathAreaRoomTransition", function (base, ...)
    mod.SanitizeKeepsakeCache()
    return base(...)
end)

modutil.mod.Path.Wrap("CheckDreamBiomeCompletion", function (base, ...)
    -- safeguard incase config is modfified erroneously or a different save is loaded
    if game.CurrentRun.EnteredBiomes > game.GameData.FullRunBiomeCount then
        game.TraitTrayScreenClose( game.ActiveScreens.TraitTrayScreen )
        game.CloseBoonInfoScreen( game.ActiveScreens.BoonInfo )
        game.CloseCodexScreen( game.ActiveScreens.Codex )
        game.CloseInventoryScreen( game.ActiveScreens.InventoryScreen )

        game.thread( game.EndDreamRunPresentation )
        return true
    end
    return base(...)
end)

--#endregion

modutil.mod.Path.Wrap("IsBossDifficultyShrineUpgradeActive", function (base, source, args)
    if game.CurrentRun.IsDreamRun and game.GameData.FullRunBiomeCount ~= 4 then
        args = args or {}

        if args.UseShrineUpgradesCache then
            if (game.CurrentRun.ShrineUpgradesCache.BossDifficultyShrineUpgrade or 0) * game.GameData.FullRunBiomeCount < game.CurrentRun.EnteredBiomes * 4 then
                return false
            end
        else
            if (game.GameState.ShrineUpgrades.BossDifficultyShrineUpgrade or 0) * game.GameData.FullRunBiomeCount < game.CurrentRun.EnteredBiomes * 4 then
                return false
            end
	    end

        if game.CurrentRun.IsDreamRun and game.CurrentRun.EnteredBiomes > 0 then
            -- Block VoR boss encounters in dream runs if they've never been seen before
            local latestBiomeVisited = game.CurrentRun.BiomeVisitOrder[game.CurrentRun.EnteredBiomes]
            local encounterMapData = game.BossDifficultyShrineEncounterBiomeMap[latestBiomeVisited]
            if encounterMapData.OnlyRequireSeen then
                return game.GameState.EncountersOccurredCache[encounterMapData.Encounter]
            else
                return game.GameState.EncountersCompletedCache[encounterMapData.Encounter]
            end
        end
        return true
    end
    return base(source, args)
end)

--#region Run result subtitle

local screenTextEnFile = rom.path.combine(rom.paths.Content, "Game\\Text\\en\\ScreenText.en.sjson")

local biomeVisitOrderFormat = {
    Id = "RunHistoryScreen_DreamBiomeVisitOrder",
    DisplayName = "{!TooltipData[1]} {!TooltipData[2]} {!TooltipData[3]} {!TooltipData[4]}",
    OverwriteLocalization = true,
}

local biomeVisitOrderOrder = {
    "Id",
    "DisplayName",
    "OverwriteLocalization"
}

local clearDreamRunFormat = {
    Id = "ClearDreamRun",
    DisplayName = "{!TooltipData[1]} {!TooltipData[2]} {!TooltipData[3]} {!TooltipData[4]}",
}

local clearDreamRunOrder = {
    "Id",
    "DisplayName"
}

sjson.hook(screenTextEnFile, function (data)
    local lastDisplayName = biomeVisitOrderFormat.DisplayName
    for i = 5, 12 do
        local newBiomeVisitOrder = game.DeepCopyTable(biomeVisitOrderFormat)
        newBiomeVisitOrder.Id = newBiomeVisitOrder.Id .. i
        lastDisplayName = lastDisplayName .. string.gsub(" {!TooltipData[Position]}", "Position", i)
        newBiomeVisitOrder.DisplayName = "- " .. lastDisplayName .. " -"
        table.insert(data.Texts, sjson.to_object(newBiomeVisitOrder,biomeVisitOrderOrder))

        local newClearDreamRun = game.DeepCopyTable(clearDreamRunFormat)
        newClearDreamRun.Id = newClearDreamRun.Id .. i
        newClearDreamRun.DisplayName = lastDisplayName
        table.insert(data.Texts, sjson.to_object(newClearDreamRun, clearDreamRunOrder))
    end
    return data
end)

modutil.mod.Path.Wrap("GetVisitedBiomeIcons", function (base, run)
    local tooltipData = {}
	for i=1, math.max( #(run.BiomeVisitOrder), 4) do
		local icon = game.RoomSetIcons[run.BiomeVisitOrder[i]] or "BiomeMysteryIcon"
		tooltipData[i] = game.IconData[icon].TexturePath
	end
	return tooltipData
end)

--#endregion

--#region 3rd hammer after 4th region

game.NamedRequirementsData[_PLUGIN.guid.."LateHammerLootRequirements"] =
{
    -- unlock requirements
    {
        Path = { "GameState", "TextLinesRecord" },
        CountOf =
        {
            "PoseidonFirstPickUp",
            "DemeterFirstPickUp",
            "HestiaFirstPickUp",
            "AphroditeFirstPickUp",
            "ZeusFirstPickUp",
            "HephaestusFirstPickUp",
        },
        Comparison = ">=",
        Value = 4,
    },

    -- run requirements
    {
        FunctionName = "RequiredNotInStore",
        FunctionArgs = { Name = "WeaponUpgradeDrop", },
    },
    {
        Path = { "CurrentRun", "EnteredBiomes" },
        Comparison = ">",
        Value = 4,
    },
    {
        Path = { "CurrentRun", "LootTypeHistory", "WeaponUpgrade" },
        Comparison = "==",
        Value = 2,
    },
}

table.insert(game.RewardStoreData.RunProgress, {
    Name = "WeaponUpgrade",
    GameStateRequirements =
    {
        NamedRequirements = { _PLUGIN.guid.."LateHammerLootRequirements" },
    }
})

table.insert(game.RewardStoreData.TartarusRewards, {
    Name = "WeaponUpgrade",
    GameStateRequirements =
    {
        NamedRequirements = { _PLUGIN.guid.."LateHammerLootRequirements" },
    }
})

table.insert(game.RewardStoreData.TyphonBossRewards, {
    Name = "WeaponUpgrade",
    GameStateRequirements =
    {
        NamedRequirements = { _PLUGIN.guid.."LateHammerLootRequirements" },
    }
})

table.insert(game.PresetEventArgs.NemesisBuyItemChoices.GetOptions,{
    Name = "WeaponUpgrade", CostResourceName = "Money", CostResourceMin = 180, CostResourceMax = 205,
    GameStateRequirements =
    {
        NamedRequirements = { _PLUGIN.guid.."LateHammerLootRequirements", },
    },
})

table.insert(game.StoreData.WorldShop.GroupsOf[2].OptionsData, 3, {
    Name = "WeaponUpgradeDrop", Weight = 2.5,
    ReplaceRequirements =
    {
        {
            PathTrue = { "GameState", "UseRecord", "WeaponUpgrade" },
        },
        NamedRequirements = { _PLUGIN.guid.."LateHammerLootRequirements" },
    },
})

--#endregion

--#region 3rd Hermes drop
game.NamedRequirementsData[_PLUGIN.guid.."LateHermesUpgradeRequirements"] =
{
    -- unlock requirements
    {
        Path = { "GameState", "TextLinesRecord" },
        HasAll = { "HermesFirstPickUp" },
    },

    -- run requirements
    {
        FunctionName = "RequiredNotInStore",
        FunctionArgs = { Name = "ShopHermesUpgrade", },
    },
    {
        Path = { "CurrentRun", "BiomeUseRecord", },
        HasNone = { "HermesUpgrade", "ShopHermesUpgrade", },
    },
    {
        Path = { "CurrentRun", "LootTypeHistory", "HermesUpgrade" },
        Comparison = "==",
        Value = 2,
    },
    {
        Path = { "CurrentRun", "EnteredBiomes" },
        Comparison = ">",
        Value = 4,
    },
}

table.insert(game.RewardStoreData.HubRewards, {
    Name = "HermesUpgrade",
    GameStateRequirements =
    {
        NamedRequirements = { _PLUGIN.guid.."LateHermesUpgradeRequirements", },
    }
})

table.insert(game.RewardStoreData.RunProgress, {
    Name = "HermesUpgrade",
    GameStateRequirements =
    {
        NamedRequirements = { _PLUGIN.guid.."LateHermesUpgradeRequirements", },
    }
})
--#endregion

--#region 5th god

modutil.mod.Path.Wrap("StartRoom", function (base, currentRun, currentRoom)
    base(currentRun, currentRoom)
    if currentRun.IsDreamRun and currentRun.EnteredBiomes == 5 and currentRoom.BiomeStartRoom then
        game.CurrentRun.MaxGodsPerRun = 5
    end
end)

--#endregion

--#region Hermes early spawn

function mod.SpawnShopItemsEarly()
    if game.CurrentRun.IsDreamRun and game.CurrentRun.EnteredBiomes == game.GameData.FullRunBiomeCount then
        local hermesTraits = {}
        for _, trait in pairs( game.CurrentRun.Hero.Traits ) do
            if trait.OnExpire and trait.OnExpire.SpawnShopItem then
                table.insert( hermesTraits, trait )
            end
        end
        for _, trait in pairs( hermesTraits ) do
		    game.RemoveTraitData( game.CurrentRun.Hero, trait, { Silent = true })
        end
    end
end

local shopRooms = {
    "F_PreBoss01",
    "G_PreBoss01",
    "H_PreBoss01",
    "I_PreBoss02",
    "I_PreBoss01",

    "N_PreBoss01",
    "O_PreBoss01",
    "P_PreBoss01",

    "A_PreBoss01",
    "X_PreBoss01",
    "Y_PreBoss01",
}

for _, roomName in ipairs(shopRooms) do
    local roomData = game.RoomData[roomName]
    if roomData then
        roomData.StartThreadedEvents = roomData.StartThreadedEvents or {}
        table.insert(roomData.StartThreadedEvents, {
            FunctionName = _PLUGIN.guid .. "." .. "SpawnShopItemsEarly"
        })
    end
end

function mod.CheckLastBiome(source, args)
    return (game.CurrentRun.EnteredBiomes == game.GameData.FullRunBiomeCount and game.CurrentRun.IsDreamRun) or (game.CurrentRun.EnteredBiomes == 4 and not game.CurrentRun.IsDream)
end

if game.RoomData["Q_PreBoss01"].DistanceTriggers[1].GameStateRequirements.OrRequirements then
    table.insert(game.RoomData["Q_PreBoss01"].DistanceTriggers[1].GameStateRequirements.OrRequirements, {
        {
            FunctionName = _PLUGIN.guid .. "." .. "CheckLastBiome"
        }
    })
else
    game.RoomData["Q_PreBoss01"].DistanceTriggers[1].GameStateRequirements =
    {
        OrRequirements =
        {
            {
                {
                    FunctionName = _PLUGIN.guid .. "." .. "CheckLastBiome"
                },
            }
        }
    }
end

--endregion