modutil.mod.Path.Context.Wrap.Static("HecateKillPresentation", function ( unit, args )
    modutil.mod.Path.Wrap("AddOutline", function (base, args)
        if game.CurrentRun.IsDreamRun and config.disable_visage_forms.model then
            return
        end
        return base(args)
    end)
    modutil.mod.Path.Wrap("SetThingProperty", function (base, args)
        args = args or {}
        if game.CurrentRun.IsDreamRun and config.disable_visage_forms.model and args.Value == "HecateHubDream_Mesh" then
            return
        end
        return base(args)
    end)
end)

modutil.mod.Path.Context.Wrap.Static("HecateBattleStart", function ( hecate, args )
    modutil.mod.Path.Wrap("AddOutline", function (base, args)
        if game.CurrentRun.IsDreamRun and config.disable_visage_forms.model then
            return
        end
        return base(args)
    end)
    modutil.mod.Path.Wrap("SetThingProperty", function (base, args)
        args = args or {}
        if game.CurrentRun.IsDreamRun and config.disable_visage_forms.model and "GR2/HecateBattleDream_Color" == args.Value then
            return
        elseif game.CurrentRun.IsDreamRun and config.disable_visage_forms.model and "GR2/HecateEMDream_Color" == args.Value then
            args.Value = "GR2/HecateEM_Color"
        end
        return base(args)
    end)
end)

modutil.mod.Path.Context.Wrap.Static("InfestedCerberusHorribleRaceConditionForTempPresentation", function ( unit )
     modutil.mod.Path.Wrap("AddOutline", function (base, args)
        if game.CurrentRun.IsDreamRun and config.disable_visage_forms.model then
            return
        end
        return base(args)
    end)
    modutil.mod.Path.Wrap("SetThingProperty", function (base, args)
        args = args or {}
        if game.CurrentRun.IsDreamRun and config.disable_visage_forms.model and args.Value == "GR2/CerberusDream_Color" then
            return
        end
        return base(args)
    end)
end)

modutil.mod.Path.Context.Wrap.Static("CerberusStageEnter", function ( unit )
    modutil.mod.Path.Wrap("SetThingProperty", function (base, args)
        args = args or {}
        if game.CurrentRun.IsDreamRun and config.disable_visage_forms.model and args.Value == "GR2/InfestedCerberusDreamEM2_Color" then
            args.Value = "GR2/InfestedCerberusEM2_Color"
        end
        return base(args)
    end)
end)

modutil.mod.Path.Context.Wrap.Static("TyphonHeadSummonPresentation", function ( unit )
    modutil.mod.Path.Wrap("SetThingProperty", function (base, args)
        args = args or {}
        if game.CurrentRun.IsDreamRun and config.disable_visage_forms.model and string.match(args.Value, "_Color") then
            args.Value = string.gsub(args.Value, "Dream", "")
        end
        return base(args)
    end)
end)

modutil.mod.Path.Context.Wrap.Static("FakeDeathTyphonEntrance", function ( unit )
    modutil.mod.Path.Wrap("SetThingProperty", function (base, args)
        args = args or {}
        if game.CurrentRun.IsDreamRun and config.disable_visage_forms.model and string.match(args.Value, "_Color") then
            args.Value = string.gsub(args.Value, "Dream", "")
        end
        return base(args)
    end)
end)