table.insert(game.NamedRequirementsData.DreamRunsUnlocked.OrRequirements,{
    {
        PathTrue = {_PLUGIN.guid, "config", "early_unlock"},
    },
    {
        PathTrue = { "GameState", "RoomsEntered", "I_Boss01" },
    },
    {
        PathTrue = { "GameState", "RoomsEntered", "Q_Boss01" }
    }
})