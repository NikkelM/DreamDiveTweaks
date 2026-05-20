mod.ShopTypes = {
    Well = {
        Animation = "WellShopLocked",
        ObstacleName = "WellShop",
    },
    Surface = {
        Animation = "SurfaceShopLocked",
        ObstacleName = "SurfaceShop",
    },
    Sell = {
        Animation = "SellTraitShopLocked",
        ObstacleName = "SellTraitShop"
    }
}

local PurgeWellLocationData = {
    Dream_PostBoss01 = {
        DestinationId = 800777,
        OffsetX = 250,
        OffsetY = -125,
        Flipped = true,
    },

    Dream_PostBoss02 = {
        DestinationId = 800777,
        OffsetX = 300,
        OffsetY = -30,
        Flipped = true,
    },

    Dream_PostBoss03 = {
        DestinationId = 800777,
        OffsetX = -700,
        OffsetY = -125,
        Flipped = true,
    },
}

function mod.SpawnSellShop(destId, offsetX, offsetY, shopType, flipped)
    shopType = shopType or "Sell"
    local shopData = mod.ShopTypes[shopType] or mod.ShopTypes.Sell
    local shop = game.DeepCopyTable(game.ObstacleData[shopData.ObstacleName])

    shop.ObjectId = game.SpawnObstacle({Name = "ChallengeSwitchBase", DestinationId = destId, OffsetY = offsetY, OffsetX = offsetX, Group = "Standing"})
    game.SetupObstacle(shop)
    shop.ReadyToUse = false
    game.RefreshUseButton( shop.ObjectId, shop )
    game.SetAnimation({ Name = shopData.Animation, DestinationId = shop.ObjectId })
    game.UseableOn({ Id = shop.ObjectId })

    if flipped then
        game.FlipHorizontal({Id = shop.ObjectId})
    end

    game.CurrentRun.CurrentRoom[shopData.ObstacleName] = shop
end

modutil.mod.Path.Wrap("HandleSecretSpawns", function (base, currentRun)
    local retval = base(currentRun)
    local currentRoom = currentRun.CurrentRoom
    if config.purging_well and PurgeWellLocationData[currentRoom.Name] and
            mod.CheckWellShop(currentRoom) and game.GameState.WorldUpgradesAdded.WorldUpgradePostBossSellTraitShops then
        local wellData = PurgeWellLocationData[currentRoom.Name]
        mod.SpawnSellShop(wellData.DestinationId, wellData.OffsetX, wellData.OffsetY, "Sell", wellData.Flipped)
    end
    return retval
end)