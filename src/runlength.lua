import 'EnemyScalingData.lua'
import 'EncounterScalingLogic.lua'

if type(config.biome_count) == "number" then
    config.biome_count = math.min(config.biome_count, 8)
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
})

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
    for i = 5, 8 do
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