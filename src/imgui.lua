print(game.GameData.FullRunBiomeCount)

local count = 0
for enemy, data in pairs(game.EnemyData) do
    if data.DreamBiomeData and not data.DreamBiomeData[5] then
        print(enemy)
        count = count + 1
    end
end
print("unpatched enemies reaminaing", count)