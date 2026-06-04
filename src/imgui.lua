print("current run length", game.GameData.FullRunBiomeCount)

local previousConfig = {biome_pool = {custom_order_data = {}}}

rom.gui.add_imgui(function()
    if rom.ImGui.Begin("Dream Dive Tweaks") then
        DrawMenu()
        rom.ImGui.End()
    end
end)

rom.gui.add_to_menu_bar(function()
    if rom.ImGui.BeginMenu("Dream Dive Tweaks") then
        DrawMenu()
        rom.ImGui.EndMenu()
    end
end)

function DrawMenu()
    local value, checked = rom.ImGui.Checkbox("Disable Visage Form Texture/Models", config.disable_visage_forms.model)
    if checked then
        config.disable_visage_forms.model = value
    end

    value, checked = rom.ImGui.Checkbox("Disable Visage Form Voice Modulation", config.disable_visage_forms.voice)
    if checked then
        config.disable_visage_forms.voice = value
    end

    value, checked = rom.ImGui.Checkbox("Allow harvestable resources to spawn in Dream Dives", config.dream_resources)
    if checked then
        config.dream_resources = value
    end

    value, checked = rom.ImGui.Checkbox("Unlock Dream Dives earlier than intended. Requires\nboth Chronos and Typhon to be fought at least once", config.early_unlock)
    if checked then
        config.early_unlock = value
    end

    value, checked = rom.ImGui.Checkbox("Fix shop music being absent in Dream Dives", config.shop_music_fix)
    if checked then
        config.shop_music_fix = value
    end

    rom.ImGui.Separator()

    value, checked = rom.ImGui.Checkbox("Fix final biomes having too many meta rewards", config.meta_reward_fix)
    if checked then
        config.meta_reward_fix = value
    end
    if config.meta_reward_fix then
        local selected
        value, selected = rom.ImGui.SliderInt("###metacap", config.meta_reward_fix_chance_cap, 30, 90, '%d%%')
        if selected and value ~= previousConfig.meta_reward_fix_chance_cap then
            config.meta_reward_fix_chance_cap = value
            previousConfig.meta_reward_fix_chance_cap = value
        end
        rom.ImGui.Text("meta reward spawn chance cap")
    end

    rom.ImGui.Separator()

    rom.ImGui.Text("Chance for a Hermes Shrine to appear in post boss room")
    local selected
    value, selected = rom.ImGui.SliderInt("###hermeschance", config.hermes_shrine_chance, 0, 100, '%d%%')
    if selected and value ~= previousConfig.hermes_shrine_chance then
        config.hermes_shrine_chance = value
        previousConfig.hermes_shrine_chance = value
    end

    rom.ImGui.Separator()

    value, checked = rom.ImGui.Checkbox("Add purging wells to post boss rooms", config.purging_well)
    if checked then
        config.purging_well = value
    end

    value, checked = rom.ImGui.Checkbox("Enable softcaps for Hasty Retreat and Wispy Wiles", config.biome_pool.dodge_softcap)
    if checked then
        config.biome_pool.dodge_softcap = value
    end

    rom.ImGui.Separator()

    if game.CurrentHubRoom then
        rom.ImGui.Text(string.gsub("Set a longer/shorter number of Regions (2-MaxBiomeCount)", "MaxBiomeCount", mod.MaxAllowedBiomeCount))
        value, selected = rom.ImGui.SliderInt("Regions", config.biome_count, 2, mod.MaxAllowedBiomeCount, '%d%')
        if selected and value ~= previousConfig.biome_count then
            config.biome_count = value
            previousConfig.biome_count = value
            game.GameData.FullRunBiomeCount = config.biome_count
        end

        if mod.IsZagAvailable then
            value, checked = rom.ImGui.Checkbox("Disable Zagreus' Journey (Hades 1) biomes in Dream Dives", config.biome_pool.disable_zag_biomes)
            if checked then
                config.biome_pool.disable_zag_biomes = value
                mod.IsZag = not value
                mod.MaxAllowedBiomeCount = (mod.IsZag and 12) or 8
                config.biome_count = math.min(config.biome_count, mod.MaxAllowedBiomeCount)
                game.GameData.FullRunBiomeCount = config.biome_count
            end
        end

        DrawCustomOrderOptions()

        if not config.biome_pool.custom_order then
            value, checked = rom.ImGui.Checkbox("Deterministic biome order (Undo Night will preserve the current biome order)", config.biome_pool.deterministic_biome_order)
            if checked then
                config.biome_pool.deterministic_biome_order = value
            end

            value, checked = rom.ImGui.Checkbox("Allow Erebus, Ephyra and Tartarus (H1) as the first random biome", config.biome_pool.larger_starting_pool)
            if checked then
                config.biome_pool.larger_starting_pool = value
            end

            value, checked = rom.ImGui.Checkbox("Easy first biome (no Tartarus, Summit, Elysium, Styx or Olympus)", config.biome_pool.easy_first_biome)
            if checked then
                config.biome_pool.easy_first_biome = value
            end

            value, checked = rom.ImGui.Checkbox("Hard final biome (one of Tartarus, Summit, Elysium, Styx or Olympus)", config.biome_pool.hard_last_biome)
            if checked then
                config.biome_pool.hard_last_biome = value
            end
        end
    else
        rom.ImGui.Text("Current Biome Pool configuration")
        rom.ImGui.Text("  Number of Regions: " .. config.biome_count)
        if mod.IsZagAvailable then
            rom.ImGui.Text("  Zagreus' Journey (Hades 1) biomes: " .. tostring(not config.biome_pool.disable_zag_biomes))
        end
        rom.ImGui.Text("  Deterministic biome order: "..tostring(config.biome_pool.deterministic_biome_order))
        rom.ImGui.Text("  Unblock Erebus and Ephyra from 1st biome: "..tostring(config.biome_pool.larger_starting_pool))
        rom.ImGui.Text("  Easy first biome: "..tostring(config.biome_pool.easy_first_biome))
        rom.ImGui.Text("  Hard last biome: "..tostring(config.biome_pool.hard_last_biome))
        rom.ImGui.Text("  Custom order: "..tostring(config.biome_pool.custom_order))
        rom.ImGui.Text("These settings can only be configured at the Crossroads")
    end
end