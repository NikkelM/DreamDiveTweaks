import 'EnemyScalingData.lua'

if type(config.biome_count) == "number" then
    config.biome_count = math.min(config.biome_count, 8)
    config.biome_count = math.max(config.biome_count, 2)
    game.GameData.FullRunBiomeCount = config.biome_count
end

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
    if game.CurrentRun.IsDreamRun then
        args = args or {}

        -- if VoR is maxed out always return true
	    if args.UseShrineUpgradesCache then
            if (game.CurrentRun.ShrineUpgradesCache.BossDifficultyShrineUpgrade or 0) >= 4 then
                return true
            end
        else
            if (game.GameState.ShrineUpgrades.BossDifficultyShrineUpgrade or 0) >= 4 then
                return true
            end
        end
    end
    return base(source, args)
end)