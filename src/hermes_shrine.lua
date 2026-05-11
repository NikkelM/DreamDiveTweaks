function mod.CheckWellShop(source, functionArgs, args)
    if not source then
        return
    end
    local isHermes = game.RandomChance(config.hermes_shrine_chance/100)
    source[_PLUGIN.guid .. "HermesShrineResult"] = source[_PLUGIN.guid .. "HermesShrineResult"] or {isHermes}
    return not source[_PLUGIN.guid .. "HermesShrineResult"][1]
end

function mod.CheckSurfaceShop(source, functionArgs, args)
    if not source then
        return
    end
    local isHermes = game.RandomChance(config.hermes_shrine_chance/100)
    source[_PLUGIN.guid .. "HermesShrineResult"] = source[_PLUGIN.guid .. "HermesShrineResult"] or {isHermes}
    return source[_PLUGIN.guid .. "HermesShrineResult"][1]
end

local shopModifications = {
    ForceWellShop = false,
    SurfaceShopSpawnChance = 1,
    SurfaceShopRequirements =
    {
        {
            PathTrue = { "GameState", "WorldUpgrades", "WorldUpgradeSurfaceShops" },
        },
        {
            FunctionName = _PLUGIN.guid .. "." .. "CheckSurfaceShop"
        }
    },
    WellShopRequirements =
    {
        {
            PathTrue = { "GameState", "WorldUpgradesAdded", "WorldUpgradePostBossWellShops" },
        },
        {
            FunctionName = _PLUGIN.guid .. "." .. "CheckWellShop"
        }
    },
}

local shopRoomList = {
    "Dream_PostBoss01",
    "Dream_PostBoss02",
    "Dream_PostBoss03",
}

for _, roomName in ipairs(shopRoomList) do
    game.OverwriteTableKeys(game.RoomData[roomName], shopModifications)
end