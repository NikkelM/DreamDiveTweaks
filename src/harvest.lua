rom.mods["NikkelM-Resources_In_Chaos_Trials"].config.dreamDives = config.dream_resources

game.TraitData.PlantHealthBoon.GameStateRequirements[4] = nil

game.TraitData.PlantHealthBoon.GameStateRequirements.OrRequirements = {
    {
        {
            PathFalse = { "CurrentRun", "IsDreamRun", },
        },
    },
    {
        {
            PathTrue = {_PLUGIN.guid, "config", "dream_resources"},
        }
    }
}