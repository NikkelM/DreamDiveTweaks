function GameStateRequirementHasIsDreamRun(requirement)
    if requirement then
        for index, condition in ipairs(requirement) do
            if condition.PathTrue and table.concat(condition.PathTrue) == "CurrentRunIsDreamRun" then
                return true
            end
        end
    end
    return false
end

for unitName, unitData in pairs(game.EnemyData) do
    local setupFunctions = unitData.SetupEvents
    if setupFunctions then
        for index, functionData in ipairs(setupFunctions) do
            local changeRequirement = false
            if functionData.FunctionName == "OverwriteSelf" and functionData.Args and
               functionData.Args.GrannyTexture and string.match(functionData.Args.GrannyTexture, "Dream.*Color") then
                functionData.GameStateRequirements = functionData.GameStateRequirements or {}
                changeRequirement = true
            end
            if functionData.FunctionName == "GenericPresentation" and functionData.Args and
               functionData.Args.SetModel and string.match(functionData.Args.SetModel, "Dream.*Mesh") then
                functionData.GameStateRequirements = functionData.GameStateRequirements or {}
                changeRequirement = true
            end
            if functionData.FunctionName == "OverwriteSelf" and functionData.Args and
               functionData.Args.GrannyAttachmentTexture and functionData.Args.GrannyAttachmentTexture.GrannyTexture and
               string.match(functionData.Args.GrannyAttachmentTexture.GrannyTexture, "Dream.*Color") then
                functionData.GameStateRequirements = functionData.GameStateRequirements or {}
                changeRequirement = true
            end
            if functionData.FunctionName == "OverwriteSelf" and functionData.Args and
                functionData.Args.Outline and GameStateRequirementHasIsDreamRun(functionData.GameStateRequirements) then
                changeRequirement = true
            end
            if changeRequirement then
                table.insert(functionData.GameStateRequirements, {
                    PathFalse = {_PLUGIN.guid, "config", "disable_visage_forms", "model"}
                })
            end
        end
    end
end

modutil.mod.Path.Wrap("SetAudioEffectState", function (base, args)
    args = args or {}
    if args.Name == "Dream" and config.disable_visage_forms.voice then
        return
    end
    return base(args)
end)