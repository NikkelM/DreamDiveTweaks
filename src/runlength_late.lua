--#region Run result subtitle

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

--#endregion

--#region NPC scaling

function mod.OpenUpgradeChoiceMenu_NPC(base, source, args)
    if game.CurrentRun.EnteredBiomes > 4 and game.CurrentRun.EnteredBiomes <= 6 then
        for _, item in pairs(source.UpgradeOptions) do
            if (game.TraitData[item.ItemName].RarityLevels or {})["Heroic"] then
                item.Rarity = "Heroic"
            end
		end
    end
    if game.CurrentRun.EnteredBiomes > 6 and game.CurrentRun.EnteredBiomes <= 10 then
        for _, item in pairs(source.UpgradeOptions) do
            if (game.TraitData[item.ItemName].RarityLevels or {})[_PLUGIN.guid .. "RarityBiome1"] then
			    item.Rarity = _PLUGIN.guid .. "RarityBiome1"
            else
                item.Rarity = "Heroic"
            end
		end
    end
    if game.CurrentRun.EnteredBiomes > 10 then
        for _, item in pairs(source.UpgradeOptions) do
            if (game.TraitData[item.ItemName].RarityLevels or {})[_PLUGIN.guid .. "RarityBiome2"] then
			    item.Rarity = _PLUGIN.guid .. "RarityBiome2"
            else
                item.Rarity = "Heroic"
            end
		end
    end
    return base(source, args)
end

local NPC_fucntions = {
    "EchoChoice",
    "ArachneCostumeChoice",
    "NarcissusBenefitChoice",
    "MedeaCurseChoice",
    "CirceBlessingChoice",
    "IcarusBenefitChoice",
}

for _, functionName in ipairs(NPC_fucntions) do
    modutil.mod.Path.Context.Wrap.Static(functionName, function ()
        modutil.mod.Path.Wrap("OpenUpgradeChoiceMenu", function (base, source, args)
            return mod.OpenUpgradeChoiceMenu_NPC(base, source, args)
        end)
    end)
end

--#endregion