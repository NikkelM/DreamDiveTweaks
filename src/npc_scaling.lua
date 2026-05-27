local npcsToScale = {
    "NPC_Circe_01",
    "NPC_Arachne_01",
    "NPC_Echo_01",
    "NPC_Icarus_01",
    "NPC_Medea_01",
    "NPC_Narcissus_01",
}

for _, npc in ipairs(npcsToScale) do
    local npcData = game.EnemyData[npc]
    if npcData and npcData.Traits then
        local traitList = npcData.Traits
        for _, traitName in ipairs(traitList) do
            local rarityData = game.TraitData[traitName].RarityLevels
            if rarityData then
                local rarityDelta = rarityData.Heroic.Multiplier - rarityData.Epic.Multiplier
                for i = 1, 2 do
                    rarityData[_PLUGIN.guid .. "RarityBiome" .. i] = {
                        Multiplier = rarityData.Heroic.Multiplier + i * rarityDelta
                    }
                end
            end
        end
    end
end