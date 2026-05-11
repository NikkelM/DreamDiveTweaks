local config = {
  enabled = true;
  disable_visage_forms = {
    voice = true,
    model = true,
  },
  -- easy_first_biome = false,
  -- hard_last_biome = false,
  -- larger_starting_pool = true,
  -- deterministic_biome_order = false,
  meta_reward_fix = true,
  meta_reward_fix_chance_cap = 50,
  dream_resources = true,
  early_unlock = false,
  shop_music_fix = true,
  -- purging_well = true,
  -- hermes_shrine = true,
  -- hermes_shrine_chance = 0.5,
  biome_count = 4,
}

local configDesc = {
  disable_visage_forms = {
    voice = "Disable Visage Form voice modulation",
    model = "Disable Visage Form models/textures",
  },
  meta_reward_fix = "Fix final biomes having too many meta progression rewards",
  meta_reward_fix_chance_cap = "% chance of having meta progression reward will be capped to this value",
  dream_resources = "Allow harvestable resources to spawn in Dream Dives",
  early_unlock = "Unlock Dream Dives earlier than intended, requires both Chronos and Typhon to be fought at least once",
  shop_music_fix = "Fix shop music being absent in Dream Dives",
  biome_count = "Set a longer/shorter number of Regions (2-8)"
}

return config, configDesc