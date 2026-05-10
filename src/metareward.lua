modutil.mod.Path.Wrap("CalcMetaProgressRatio", function (base, run)
    local ratio = base(run)
    local MinorRunProgressChanceCap = 0.5
    -- force meta progression fix if EnteredBiomes exceed 4
    if ratio and run.IsDreamRun and (config.meta_reward_fix or run.EnteredBiomes > 4) then
        local targetMetaRewardsRatio = (run.TargetMetaRewardsRatio or run.CurrentRoom.TargetMetaRewardsRatio or run.Hero.TargetMetaRewardsRatio)
        local minorRunProgressChance = targetMetaRewardsRatio
        minorRunProgressChance = minorRunProgressChance + (run.Hero.TargetMetaRewardsAdjustSpeed * (targetMetaRewardsRatio - ratio))
        if minorRunProgressChance > MinorRunProgressChanceCap then
            print("capping minorRunProgressChance from", minorRunProgressChance, "to", MinorRunProgressChanceCap, "in", run.CurrentRoom.Name)
            return targetMetaRewardsRatio - (MinorRunProgressChanceCap - targetMetaRewardsRatio)/run.Hero.TargetMetaRewardsAdjustSpeed
        end
    end
    return ratio
end)