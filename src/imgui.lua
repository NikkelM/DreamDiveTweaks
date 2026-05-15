print(game.GameData.FullRunBiomeCount)

local previousConfig = {}

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

    rom.ImGui.Text(string.gsub("Set a longer/shorter number of Regions (2-MaxBiomeCount)", "MaxBiomeCount", mod.MaxAllowedBiomeCount))
    if game.CurrentHubRoom or (game.CurrentRun and game.CurrentRun.CurrentRoom and game.CurrentRun.CurrentRoom.Name == "Dream_Intro") then
        local selected
        value, selected = rom.ImGui.SliderInt("Regions", config.biome_count, 2, mod.MaxAllowedBiomeCount, '%d%')
        if selected and value ~= previousConfig.biome_count then
            config.biome_count = value
            previousConfig.biome_count = value
            game.GameData.FullRunBiomeCount = config.biome_count
        end
    else
        rom.ImGui.Text("Currently configured number of Regions: " .. config.biome_count)
        rom.ImGui.Text("This can only be configured at the Crossroads")
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
end

local count = 0
local count2 = 0
for enemy, data in pairs(game.EnemyData) do
    if data.DreamBiomeData and not (data.DreamBiomeData[12] and data.DreamBiomeData[8]) then
        print(enemy)
        count = count + 1
    elseif data.DreamBiomeData and (data.DreamBiomeData[12] and data.DreamBiomeData[8]) then
        count2 = count2 + 1
    end
end
print("unpatched enemies remainaing", count,"/", count2+count)