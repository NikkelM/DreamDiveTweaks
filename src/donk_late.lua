modutil.mod.Path.Context.Wrap.Static("DreamRunPreRunStartPresentation", function (usee)
    modutil.mod.Path.Wrap("SetAnimation", function (base, args)
        if args.Name == "Melinoe_DeathHover_Start" and config.donk then
            args.Name = "Melinoe_DiveExit_Portal_Start"
        end
        return base(args)
    end)
end)