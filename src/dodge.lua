local totalDodge = 0

modutil.mod.Path.Wrap("SetLifeProperty", function (base, args)
    if args.DestinationId == game.CurrentRun.Hero.ObjectId and args.Property == "DodgeChance" then
        print(args.ValueChangeType, args.Value)
        if args.ValueChangeType == "Add" then
            totalDodge = totalDodge + args.Value
            print("totalDodge", totalDodge)
        end
    end
    return base(args)
end)

modutil.mod.Path.Wrap("LeaveRoom", function (base, ...)
    totalDodge = 0
    return base(...)
end)

modutil.mod.Path.Wrap("DeathAreaSwitchRoom", function (base, ...)
    totalDodge = 0
    return base(...)
end)

function mod.GetLastHeroTrait( traitName )
	--if verboseLogging then
		--DebugAssert({ Condition = (CurrentRun.Hero.TraitDictionary[traitName] ~= nil), Text = "Trait " .. tostring(traitName) .. " not found on call to GetHeroTrait.", Owner = "Alice" })
	--end
	if game.CurrentRun.Hero.TraitDictionary[traitName] ~= nil then
		return game.CurrentRun.Hero.TraitDictionary[traitName][#(game.CurrentRun.Hero.TraitDictionary[traitName])]
	end
	return nil
end

function mod.ElementalDodgeBoonSetup(hero, traitArgs, args)
    print("ElementalDodgeBoonSetup")
    local trait = mod.GetLastHeroTrait("ElementalDodgeBoon")
    if trait then
        local airCount = game.CurrentRun.Hero.Elements.Air
        print("aircount", airCount)
        print("CurrentAirDodgeBonus", trait.CurrentAirDodgeBonus)
        trait.CurrentAirDodgeBonus = airCount * traitArgs.DodgePerAirElement
        if game.CurrentRun.IsDreamRun then
            if airCount <= 10 then
                trait.CurrentAirDodgeBonus = airCount * traitArgs.DodgePerAirElement
            elseif traitArgs.Decay * (airCount-10) <= traitArgs.DodgePerAirElement then
                trait.CurrentAirDodgeBonus = airCount * traitArgs.DodgePerAirElement - traitArgs.Decay * (airCount - 10) * (airCount - 10 - 1) / 2
            else
                local decayLimit = math.floor(traitArgs.DodgePerAirElement/traitArgs.Decay)
                trait.CurrentAirDodgeBonus = airCount * traitArgs.DodgePerAirElement - traitArgs.Decay * decayLimit * (decayLimit - 1) / 2
            end
        end
        game.SetLifeProperty({ Property = "DodgeChance", Value = trait.CurrentAirDodgeBonus, ValueChangeType = "Add", DestinationId = game.CurrentRun.Hero.ObjectId, DataValue = false })
    else
        print("trying to setup non-existent ElementalDodgeBoon")
    end
end

function mod.ElementalDodgeBoonClear(traitArgs, trait)
    print("ElementalDodgeBoonClear")
    local airCount = game.CurrentRun.Hero.Elements.Air
    print("aircount", airCount)
    game.SetLifeProperty({ Property = "DodgeChance", Value = -trait.CurrentAirDodgeBonus, ValueChangeType = "Add", DestinationId = game.CurrentRun.Hero.ObjectId, DataValue = false })
end

local dodgeTraits = {
    ElementalDodgeBoon = {
        InheritFrom = {"UnityTrait"},
		Icon = "Boon_Aphrodite_33",
		GameStateRequirements =
		{
			{
				Path = { "CurrentRun", "Hero", "Elements", "Air" },
				Comparison = ">=",
				Value = 2,
			},
		},
        ElementalMultipliers =
		{
			Air = true,
		},
        RarityLevels =
		{
			Common =
			{
				Multiplier = 1
			},
		},
        CurrentAirDodgeBonus = 0,
        SetupFunction =
		{
			Name = _PLUGIN.guid .. "." .. "ElementalDodgeBoonSetup",
			Args =
			{
				DodgePerAirElement = 0.02,
                Decay = 0.0003,
                ReportValues = {
                    ReportedDodgeBonus = "DodgePerAirElement",
                }
			},
		},
        OnExpire = {
            FunctionName = _PLUGIN.guid .. "." .. "ElementalDodgeBoonClear",
        },
        StatLines =
		{
			"ElementalDodgeStatDisplay1",
		},
		TrayStatLines =
		{
			"TotalDodgeChanceStatDisplay1",
		},
		ExtractValues =
		{
            {
				Key = "ReportedDodgeBonus",
				ExtractAs = "TooltipDodgeBonus",
				Format = "Percent",
                DecimalPlaces = 5,
			},
			{
				Key = "CurrentAirDodgeBonus",
				ExtractAs = "TooltipTotalDodgeBonus",
				Format = "Percent",
                DecimalPlaces = 5,
			},
		},
    }
}

game.OverwriteTableKeys(game.TraitData, dodgeTraits)

game.SetupRunData()