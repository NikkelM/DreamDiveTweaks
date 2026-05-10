modutil.mod.Path.Context.Wrap.Static("ShowRunHistory", function ( screen, button )
    modutil.mod.Path.Wrap("ModifyTextBox", function (base, args)
        args = args or {}
        if args.Text == "RunHistoryScreen_DreamBiomeVisitOrder" and type(args.LuaValue) == "table" and #args.LuaValue > 4 then
            args.Text = args.Text .. #args.LuaValue
        end
        return base(args)
    end)
end)

modutil.mod.Path.Context.Wrap.Static("OpenRunClearScreen", function (  )
    modutil.mod.Path.Wrap("RunClearMessagePresentation", function (base, screen, message, tooltipData)
        if message == "ClearDreamRun" and type(tooltipData) == "table" and #tooltipData > 4 then
            message = message .. #tooltipData
        end
        return base(screen, message, tooltipData)
    end)
end)