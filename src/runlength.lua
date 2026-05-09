if type(config.biome_count) == "number" then
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