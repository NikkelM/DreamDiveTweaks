modutil.mod.Path.Wrap("StartOver", function (base, args)
    if args.ActiveBounty then
        args.StartingRoomName = game.BountyData[args.ActiveBounty].StartingRoomName
    end
    return base(args)
end)

modutil.mod.Path.Wrap("StartNewRun", function (base, ...)
    local currentRun = base(...)
    if currentRun.IsDreamRun then
        currentRun.ActiveBounty = nil
    end
    return currentRun
end)

modutil.mod.Path.Wrap("HubPostDreamLoad", function (base, args)
    if game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"] then
        game.RestorePackagedBountyGameState()
    end
    return base(args)
end)

game.ObstacleData.GiftRack.SetupEvents[1].GameStateRequirements[2] = nil

game.ObstacleData.GiftRack.SetupEvents[1].GameStateRequirements.OrRequirements =
{
    {
        {
            Path = { "CurrentRun", "ActiveBounty" },
            IsAny = game.GameData.AllRandomPackagedBounties,
        },
    },
    {
        {
            PathTrue = { "CurrentRun", "Dream_RandomPackagedBounty" },
        }
    }
}
