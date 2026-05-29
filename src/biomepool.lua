local hard_biomes = {"I", "Q", "P"}

local easy_biomes = {"G", "H", "O"}

local starting_biomes = {"I", "Q", "H", "P", "G", "O"}

local all_biomes = {"F", "G", "H", "I", "N", "O", "P", "Q"}

local default_order = {
    ["1"] = "F",
    ["2"] = "G",
    ["3"] = "H",
    ["4"] = "I",
    ["5"] = "N",
    ["6"] = "O",
    ["7"] = "P",
    ["8"] = "Q",
    ["9"] = "Tartarus",
    ["10"] = "Asphodel",
    ["11"] = "Elysium",
    ["12"] = "Styx",
}

local preset_orders = {
    ["Underworld - Surface"] = {
        order = {
            ["1"] = "F",
            ["2"] = "G",
            ["3"] = "H",
            ["4"] = "I",
            ["5"] = "N",
            ["6"] = "O",
            ["7"] = "P",
            ["8"] = "Q",
            ["9"] = "Tartarus",
            ["10"] = "Asphodel",
            ["11"] = "Elysium",
            ["12"] = "Styx",
        },
        count = 8,
    },
    ["Surface - Underworld"] = {
        order = {
            ["1"] = "N",
            ["2"] = "O",
            ["3"] = "P",
            ["4"] = "Q",
            ["5"] = "F",
            ["6"] = "G",
            ["7"] = "H",
            ["8"] = "I",
            ["9"] = "Tartarus",
            ["10"] = "Asphodel",
            ["11"] = "Elysium",
            ["12"] = "Styx",
        },
        count = 8,
    },
    ["Alternating"] = {
        order = {
            ["1"] = "F",
            ["2"] = "N",
            ["3"] = "G",
            ["4"] = "O",
            ["5"] = "H",
            ["6"] = "P",
            ["7"] = "I",
            ["8"] = "Q",
            ["9"] = "Tartarus",
            ["10"] = "Asphodel",
            ["11"] = "Elysium",
            ["12"] = "Styx",
        },
        count = 8,
    },
    ["Underworld - Underworld-ZJ - Surface"] = {
        order = {
            ["1"] = "F",
            ["2"] = "G",
            ["3"] = "H",
            ["4"] = "I",
            ["5"] = "Tartarus",
            ["6"] = "Asphodel",
            ["7"] = "Elysium",
            ["8"] = "Styx",
            ["9"] = "N",
            ["10"] = "O",
            ["11"] = "P",
            ["12"] = "Q",
        },
        zag = true,
        count = 12,
    },
    ["Alternating-ZJ"] = {
        order = {
            ["1"] = "F",
            ["2"] = "N",
            ["3"] = "Tartarus",
            ["4"] = "G",
            ["5"] = "O",
            ["6"] = "Asphodel",
            ["7"] = "H",
            ["8"] = "P",
            ["9"] = "Elysium",
            ["10"] = "Q",
            ["11"] = "I",
            ["12"] = "Styx",
        },
        zag = true,
        count = 12,
    },
    ["Final boss rush"] = {
        order = {
            ["1"] = "Q",
            ["2"] = "I",
            ["3"] = "Styx"
        },
        zag = true,
        count = 3,
    }
}

local biomeDisplayNameMap = {
    ["F"] = "Erebus",
    ["G"] = "Oceanus",
    ["H"] = "Fields",
    ["I"] = "Tartarus (H2)",
    ["N"] = "Ephyra",
    ["O"] = "Thessaly",
    ["P"] = "Olympus",
    ["Q"] = "Summit",
    ["Tartarus"] = "Tartarus (H1)"
}

function UpdateZagBiomeSets()
    table.insert(hard_biomes, "Styx")
    table.insert(hard_biomes, "Elysium")
    table.insert(easy_biomes, "Asphodel")
    game.ConcatTableValuesIPairs(starting_biomes, {"Styx", "Elysium", "Asphodel"})
    game.ConcatTableValuesIPairs(all_biomes, {"Tartarus", "Asphodel", "Elysium", "Styx"})
end

function PurgeZagBiomeSets()
    game.RemoveValueAndCollapse(hard_biomes, "Styx")
    game.RemoveValueAndCollapse(hard_biomes, "Elysium")
    game.RemoveValueAndCollapse(easy_biomes, "Asphodel")
    for _, value in ipairs( {"Styx", "Elysium", "Asphodel"} ) do
        game.RemoveValueAndCollapse(starting_biomes, value)
    end
    for _, value in ipairs( {"Styx", "Elysium", "Asphodel", "Tartarus"} ) do
        game.RemoveValueAndCollapse(all_biomes, value)
    end
end

function UpdateEasyBiome()
    table.insert(easy_biomes, "F")
    table.insert(easy_biomes, "N")
    game.ConcatTableValuesIPairs(starting_biomes, {"F", "N"})
end

function PurgeEasyBiome()
    game.RemoveValueAndCollapse(easy_biomes, "F")
    game.RemoveValueAndCollapse(easy_biomes, "N")
    game.RemoveValueAndCollapse(starting_biomes, "F")
    game.RemoveValueAndCollapse(starting_biomes, "N")
end

function UpdateEasyBiomeZag()
    table.insert(easy_biomes, "Tartarus")
    table.insert(starting_biomes, "Tartarus")
end

function PurgeEasyBiomeZag()
    game.RemoveValueAndCollapse(easy_biomes, "Tartarus")
    game.RemoveValueAndCollapse(starting_biomes, "Tartarus")
end

PurgeZagBiomeSets()
if mod.MaxAllowedBiomeCount == 12 then
    UpdateZagBiomeSets()
end

PurgeEasyBiome()
if config.biome_pool.larger_starting_pool then
    UpdateEasyBiome()
end

PurgeEasyBiomeZag()
if config.biome_pool.larger_starting_pool and mod.MaxAllowedBiomeCount == 12 then
    UpdateEasyBiomeZag()
end

function mod.GetRandomTableValue(tableArg)
    if config.biome_pool.deterministic_biome_order then
        return tableArg[game.RandomInt(1, #tableArg)]
    else
        return tableArg[math.random(#tableArg)]
    end
end

function GetCustomOrder()
    if not CheckOrderValid() then
        game.thread(game.InCombatText, game.CurrentRun.Hero.ObjectId, "Invalid custom order, resetting to default order", 3, { OffsetY = -60, SkipRise = true })
        config.biome_pool.custom_order_data = default_order
        config.biome_count = mod.MaxAllowedBiomeCount
        game.GameData.FullRunBiomeCount = config.biome_count
    end
    local route = {}
    for i = 1, config.biome_count do
        route[i] = config.biome_pool.custom_order_data[i..""]
    end
    return route
end

function GenerateRoute()
    if config.biome_pool.custom_order then
        return GetCustomOrder()
    end
    local startBiome
    local endBiome
    local biomeList = game.DeepCopyTable(all_biomes)
    if config.biome_pool.easy_first_biome then
        startBiome = mod.GetRandomTableValue(easy_biomes)
        game.RemoveValueAndCollapse(biomeList, startBiome)
    else
        startBiome = mod.GetRandomTableValue(starting_biomes)
        game.RemoveValueAndCollapse(biomeList, startBiome)
    end

    if config.biome_pool.hard_last_biome then
        endBiome = mod.GetRandomTableValue(hard_biomes)
        game.RemoveValueAndCollapse(biomeList, endBiome)
    end

    local route = {}
    route[1] = startBiome
    route[game.GameData.FullRunBiomeCount] = endBiome
    for depth = 1, game.GameData.FullRunBiomeCount do
        if not route[depth] then
            route[depth] = mod.GetRandomTableValue(biomeList)
            game.RemoveValueAndCollapse(biomeList, route[depth])
            local currentRoomSet = route[depth]
            if depth > 1 and #biomeList > 1 then
                if route[depth] == game.NextRoomSets[route[depth-1]] then
                    route[depth] = mod.GetRandomTableValue(biomeList)
                    game.RemoveValueAndCollapse(biomeList, route[depth])
                    table.insert(biomeList, currentRoomSet)
                end
            end
        end
    end
    print("GeneratedRoute", dump(route))
    return route
end

if not WrappedNextDream then
    modutil.mod.Path.Wrap("SelectNextDreamBiome", function (base, source, args)
        -- clamp max biome count and configured biome count if we detect ZJ doesn't have its requirements met
        if mod.IsZag and (game.GameState.ModsNikkelMHadesBiomesClearedRunsCache or 0) < 1 then
            if config.biome_count > 8 then
                game.thread(game.InCombatText, game.CurrentRun.Hero.ObjectId, "Complete a vanilla ZJ run to enable them for Dream Dives", 6, { OffsetY = -120, UseProgressiveStack = true, PreDelay = 0.6, SkipRise = true })
                game.wait(0.01)
                game.thread(game.InCombatText, game.CurrentRun.Hero.ObjectId, "Zagreus Journey biomes requirement not met", 6, { OffsetY = -120, UseProgressiveStack = true, PreDelay = 0.6, SkipRise = true })
            end
            mod.MaxAllowedBiomeCount = 8
            config.biome_count = math.min(config.biome_count, mod.MaxAllowedBiomeCount)
            game.GameData.FullRunBiomeCount = config.biome_count
        elseif mod.IsZag then
            mod.MaxAllowedBiomeCount = 12
        end

        PurgeZagBiomeSets()
        if mod.MaxAllowedBiomeCount == 12 then
            UpdateZagBiomeSets()
        end

        PurgeEasyBiome()
        if config.biome_pool.larger_starting_pool then
            UpdateEasyBiome()
        end

        PurgeEasyBiomeZag()
        if config.biome_pool.larger_starting_pool and mod.MaxAllowedBiomeCount == 12 then
            UpdateEasyBiomeZag()
        end

        -- on getting a pre generated route from elsewhere
        if not game.IsEmpty(game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"]) and (game.CurrentRun.EnteredBiomes or 0) == 0 then
            game.CurrentRun[_PLUGIN.guid .. "StoredFullBiomeCount"] = config.biome_count
            config.biome_count = #game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"]
            game.GameData.FullRunBiomeCount = config.biome_count
        end

        -- only run this if starting a new run or in the middle of a DreamDiveTweaks modded run
        if game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"] or (game.CurrentRun.EnteredBiomes or 0) == 0 then
            args = args or {}
            local nextRoomSet = nil

            if game.IsEmpty( game.CurrentRun.DreamBiomePool ) then
                game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"] = GenerateRoute()
                nextRoomSet = game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"][1]
                game.CurrentRun.DreamBiomePool = game.DeepCopyTable(all_biomes)
            else
                game.CurrentRun.EnteredBiomes = game.CurrentRun.EnteredBiomes or 0
                nextRoomSet = game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"][game.CurrentRun.EnteredBiomes + 1]
            end

            game.RemoveValueAndCollapse(game.CurrentRun.DreamBiomePool, nextRoomSet)

            game.CurrentRun.CurrentRoom.NextRoomSet = { nextRoomSet }
        else
            base(source, args)
        end

        if game.CurrentRun.CurrentRoom.NextRoomSet[1] == nil then
            print("nil NextRoomSet detected", dump(game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"]), dump(game.CurrentRun.BiomeVisitOrder), game.CurrentRun.EnteredBiomes, game.CurrentRun.DreamBiomePool)
            game.CurrentRun.CurrentRoom.NextRoomSet = { game.RemoveRandomValue( game.CurrentRun.DreamBiomePool ) }
        end
    end)

    table.insert(game.EncounterData.OpeningEmpty.GameStateRequirements.OrRequirements[2],
    {
        Path = { "CurrentRun", "EnteredBiomes" },
        Comparison = ">",
        Value = 0
    })

    WrappedNextDream = true
end

function CheckOrderValid()
    local set = {}
    for i = 1, config.biome_count do
        if set[config.biome_pool.custom_order_data[i..""]] or not game.Contains(all_biomes, config.biome_pool.custom_order_data[i..""]) then
            return false
        end
        set[config.biome_pool.custom_order_data[i..""]] = true
    end
    return true
end

CurrentPresetName = CurrentPresetName or "Underworld - Surface"

function DrawCustomOrderOptions()

    local value, checked = rom.ImGui.Checkbox("Custom biome order", config.biome_pool.custom_order)
    if checked then
        config.biome_pool.custom_order = value
    end

    if config.biome_pool.custom_order then

        rom.ImGui.SameLine()

        local clicked = rom.ImGui.Button("Reset Order")
        if clicked then
            config.biome_pool.custom_order_data = default_order
            config.biome_count = mod.MaxAllowedBiomeCount
            game.GameData.FullRunBiomeCount = config.biome_count
        end

        for depth = 1, config.biome_count do
            local currentBiome = config.biome_pool.custom_order_data[depth..""]
            rom.ImGui.Text(depth..":"); rom.ImGui.SameLine()
            if rom.ImGui.BeginCombo("###biome"..depth, biomeDisplayNameMap[currentBiome] or currentBiome) then
                for _, biome in ipairs(all_biomes) do
                    -- print(currentBiome, biome)
                    if rom.ImGui.Selectable(biomeDisplayNameMap[biome] or biome, (currentBiome == biome)) then
                        config.biome_pool.custom_order_data[depth..""] = biome
                        currentBiome = biome
                        rom.ImGui.SetItemDefaultFocus()
                    end
                end
                rom.ImGui.EndCombo()
            end
        end

        if not CheckOrderValid() then
            rom.ImGui.Text("WARNING: Invalid custom order, will be\nreverted to default order on run start")
        end

        rom.ImGui.Text("Select order preset")
        if rom.ImGui.BeginCombo("###biomeorderpreset", CurrentPresetName) then
            for presetName, presetData in pairs(preset_orders) do
                if presetData.count <= mod.MaxAllowedBiomeCount and (not presetData.zag or mod.MaxAllowedBiomeCount == 12) then
                    if rom.ImGui.Selectable(presetName, (CurrentPresetName == presetName)) then
                        CurrentPresetName = presetName
                        config.biome_count = presetData.count
                        game.GameData.FullRunBiomeCount = config.biome_count
                        config.biome_pool.custom_order_data = presetData.order
                        rom.ImGui.SetItemDefaultFocus()
                    end
                end
            end
            rom.ImGui.EndCombo()
        end
    end
end

-- function ValidateTestRoute(route)
--     local printRoute
--     if config.biome_pool.easy_first_biome and not game.Contains({"F","G","O","H","N","Tartarus","Asphodel"}, route[1]) then
--         printRoute = true
--         print("easy test failed", route[1])
--     end
--     if config.biome_pool.hard_last_biome and not game.Contains({"I", "Q", "P", "Styx", "Elysium"}, route[#route]) then
--         printRoute = true
--         print("hard test failed", route[#route])
--     end
--     if not config.biome_pool.larger_starting_pool and game.Contains({"F", "N", "Tartarus"}, route[1]) then
--         printRoute = true
--         print("large pool test failed", route[1])
--     end
--     if printRoute then
--         print(dump(route))
--     end
-- end

-- function TestRouteGeneration()
--     config.biome_pool.easy_first_biome = true
--     config.biome_pool.hard_last_biome = true
--     config.biome_pool.larger_starting_pool = true
--     config.biome_pool.deterministic_biome_order = false

--     for i = 1, 2 do
--         for j = 1, 2 do
--             for k = 1, 2 do
--                 PurgeZagBiomeSets()
--                 if mod.MaxAllowedBiomeCount == 12 then
--                     UpdateZagBiomeSets()
--                 end

--                 PurgeEasyBiome()
--                 if config.biome_pool.larger_starting_pool then
--                     UpdateEasyBiome()
--                 end

--                 PurgeEasyBiomeZag()
--                 if config.biome_pool.larger_starting_pool and mod.MaxAllowedBiomeCount == 12 then
--                     UpdateEasyBiomeZag()
--                 end
--                 print(config.biome_pool.easy_first_biome, config.biome_pool.hard_last_biome, config.biome_pool.larger_starting_pool)
--                 for test_length = 2, mod.MaxAllowedBiomeCount do
--                     game.CurrentRun.DreamBiomePool = {}
--                     game.CurrentRun.EnteredBiomes = 0
--                     game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"] = nil
--                     config.biome_count = test_length
--                     game.GameData.FullRunBiomeCount = config.biome_count
--                     game.SelectNextDreamBiome()
--                     local route = {game.CurrentRun.CurrentRoom.NextRoomSet[1]}
--                     for _ = 2, test_length do
--                         game.CurrentRun.EnteredBiomes = game.CurrentRun.EnteredBiomes + 1
--                         game.SelectNextDreamBiome()
--                         table.insert(route, game.CurrentRun.CurrentRoom.NextRoomSet[1])
--                     end
--                     ValidateTestRoute(route)
--                     if table.concat(route) ~= table.concat(game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"]) then
--                         print("route mismatch", dump(route), dump(game.CurrentRun[_PLUGIN.guid .. "GeneratedRoute"]))
--                     else
--                         print("passed", test_length)
--                     end
--                 end
--                 config.biome_pool.larger_starting_pool = not config.biome_pool.larger_starting_pool
--             end
--             config.biome_pool.hard_last_biome = not config.biome_pool.hard_last_biome
--         end
--         config.biome_pool.easy_first_biome = not config.biome_pool.easy_first_biome
--     end
-- end

-- for _ = 1, 100 do
--     TestRouteGeneration()
-- end