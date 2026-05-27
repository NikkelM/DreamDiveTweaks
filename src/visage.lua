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

function GameStateRequirementHasFalseIsDreamRun(requirement)
    if requirement then
        for index, condition in ipairs(requirement) do
            if condition.PathFalse and table.concat(condition.PathFalse) == "CurrentRunIsDreamRun" then
                return index
            end
        end
    end
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
               functionData.Args.SetModel and string.match(functionData.Args.SetModel, "Dream.*Mesh") and GameStateRequirementHasIsDreamRun(functionData.GameStateRequirements) then
                functionData.GameStateRequirements = functionData.GameStateRequirements or {}
                changeRequirement = true
            end
            if functionData.FunctionName == "GenericPresentation" and functionData.Args and
               functionData.Args.SetModel and GameStateRequirementHasFalseIsDreamRun(functionData.GameStateRequirements) then
                print(unitName, "lucifer check")
                local req_index = GameStateRequirementHasFalseIsDreamRun(functionData.GameStateRequirements)
                functionData.GameStateRequirements[req_index] = {}
                functionData.GameStateRequirements.OrRequirements = functionData.GameStateRequirements.OrRequirements or {}
                table.insert(functionData.GameStateRequirements.OrRequirements, {
                    {
                        PathFalse = { "CurrentRun", "IsDreamRun" },
                    }
                })
                table.insert(functionData.GameStateRequirements.OrRequirements, {
                    {
                        PathTrue = {_PLUGIN.guid, "config", "disable_visage_forms", "model"}
                    }
                })
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
            -- seen in cerberus EM so far
            if functionData.FunctionName == "OverwriteSelf" and functionData.Args and
               functionData.Args.GrannyTexture and string.match(functionData.Args.GrannyTexture, ".*_Color$") and not string.match(functionData.Args.GrannyTexture, "Dream") and
               GameStateRequirementHasFalseIsDreamRun(functionData.GameStateRequirements) then
                local req_index = GameStateRequirementHasFalseIsDreamRun(functionData.GameStateRequirements)
                game.RemoveIndexAndCollapse(functionData.GameStateRequirements, req_index)
                functionData.GameStateRequirements.OrRequirements = {
                    {
                        {
                            PathFalse = { "CurrentRun", "IsDreamRun" },
                        },
                    },
                    {
                        {
                            PathTrue = {_PLUGIN.guid, "config", "disable_visage_forms", "model"}
                        }
                    }
                }
            end
        end
    end
end

print(dump(game.EnemyData.Eris.SetupEvents))

modutil.mod.Path.Wrap("SetAudioEffectState", function (base, args)
    args = args or {}
    if args.Name == "Dream" and config.disable_visage_forms.voice then
        return
    end
    return base(args)
end)