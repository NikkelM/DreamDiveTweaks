modutil.mod.Path.Wrap("ApplyBurn", function (base, victim, functionArgs, triggerArgs)
    local maxStacksCopy = game.EffectData.BurnEffect.MaxStacks
    if config.increase_scorch_cap then
        game.EffectData.BurnEffect.MaxStacks = math.max(9999, game.EffectData.BurnEffect.MaxStacks)
    end
    base(victim, functionArgs, triggerArgs)
    game.EffectData.BurnEffect.MaxStacks = maxStacksCopy
end)