modutil.mod.Path.Context.Env("HecateKillPresentation", function ( unit, args )
    modutil.mod.Path.Wrap("AddOutline", function (base, args)
        if game.CurrentRun.IsDreamRun and config.disable_visage_forms.model then
            return
        end
        return base(args)
    end)
    modutil.mod.Path.Wrap("SetThingProperty", function (base, args)
        args = args or {}
        if game.CurrentRun.IsDreamRun and config.disable_visage_forms.model and args.Property == "GrannyModel" and args.Value == "HecateHubDream_Mesh" then
            return
        end
        return base(args)
    end)
end)

modutil.mod.Path.Context.Env("HecateBattleStart", function ( hecate, args )
    modutil.mod.Path.Wrap("AddOutline", function (base, args)
        if game.CurrentRun.IsDreamRun and config.disable_visage_forms.model then
            return
        end
        return base(args)
    end)
    modutil.mod.Path.Wrap("SetThingProperty", function (base, args)
        args = args or {}
        if game.CurrentRun.IsDreamRun and config.disable_visage_forms.model and args.Property == "GrannyTexture" and "GR2/HecateBattleDream_Color" == args.Value then
            return
        elseif game.CurrentRun.IsDreamRun and config.disable_visage_forms.model and args.Property == "GrannyTexture" and "GR2/HecateEMDream_Color" == args.Value then
            args.Value = "GR2/HecateEM_Color"
        end
        return base(args)
    end)
end)

modutil.mod.Path.Context.Env("InfestedCerberusHorribleRaceConditionForTempPresentation", function ( unit )
     modutil.mod.Path.Wrap("AddOutline", function (base, args)
        if game.CurrentRun.IsDreamRun and config.disable_visage_forms.model then
            return
        end
        return base(args)
    end)
    modutil.mod.Path.Wrap("SetThingProperty", function (base, args)
        args = args or {}
        if game.CurrentRun.IsDreamRun and config.disable_visage_forms.model and args.Property == "GrannyTexture" and args.Value == "GR2/CerberusDream_Color" then
            return
        end
        return base(args)
    end)
end)

modutil.mod.Path.Context.Env("CerberusStageEnter", function ( unit )
    modutil.mod.Path.Wrap("SetThingProperty", function (base, args)
        args = args or {}
        if game.CurrentRun.IsDreamRun and config.disable_visage_forms.model and args.Property == "GrannyTexture" and args.Value == "GR2/InfestedCerberusDreamEM2_Color" then
            args.Value = "GR2/InfestedCerberusEM2_Color"
        end
        return base(args)
    end)
end)

modutil.mod.Path.Context.Env("TyphonHeadSummonPresentation", function ( unit )
    modutil.mod.Path.Wrap("SetThingProperty", function (base, args)
        args = args or {}
        if game.CurrentRun.IsDreamRun and config.disable_visage_forms.model and args.Property == "GrannyTexture" and string.match(args.Value, "_Color") then
            args.Value = string.gsub(args.Value, "Dream", "")
        end
        return base(args)
    end)
end)

modutil.mod.Path.Context.Env("TyphonHeadStageTransition", function ( unit )
    modutil.mod.Path.Wrap("SetThingProperty", function (base, args)
        args = args or {}
        if game.CurrentRun.IsDreamRun and config.disable_visage_forms.model and args.Property == "GrannyTexture" and string.match(args.Value, "_Color") then
            args.Value = string.gsub(args.Value, "Dream", "")
        end
        return base(args)
    end)
end)

modutil.mod.Path.Context.Env("FakeDeathTyphonEntrance", function ( unit )
    modutil.mod.Path.Wrap("SetThingProperty", function (base, args)
        args = args or {}
        if args.Value == "GR2/TyphonHeadDreamStage3_Color" and game.CurrentRun.IsDreamRun and config.disable_visage_forms.model and args.Property == "GrannyTexture" then
            args.Value = "GR2/TyphonHeadStage3_Color"
        end
        return base(args)
    end)
end)