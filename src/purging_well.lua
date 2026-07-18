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
        ShadowId = 824065,
        OffsetX = 250,
        OffsetY = -125,
        Flipped = true,
        ShadowColor = {80/255, 169/255, 255/255, 255/255}
    },

    Dream_PostBoss02 = {
        DestinationId = 800777,
        ShadowId = 824063,
        OffsetX = 300,
        OffsetY = -30,
        Flipped = true,
    },

    Dream_PostBoss03 = {
        DestinationId = 800777,
        ShadowId = 822826,
        OffsetX = -700,
        OffsetY = -125,
        Flipped = true,
        ShadowHSV = {0,-1,0},
        ShadowOffsetX = -20,
        ShadowOffsetY = -10,
    },
}

function mod.SpawnSellShop(destId, offsetX, offsetY, shopType, flipped, wellData)
    -- shadow obstacle
    local shadowId = game.SpawnObstacle({
        Name = "AtmosphereShadowRectangle06",
        DestinationId = wellData.ShadowId,
        OffsetY = offsetY + (wellData.ShadowOffsetY or 0),
        OffsetX = offsetX + (wellData.ShadowOffsetX or 0),
        Group = "Terrain_Shadow_01",
        Scale = 0.102
    })
    game.SetScale({Id = shadowId, Fraction = 0.102})
    if wellData.ShadowColor then
        game.SetColor({Id = shadowId, Color = wellData.ShadowColor})
        game.SetHSV({Id = shadowId, HSV = {0,-1,0}})
    else
        game.SetColor({Id = shadowId, Color = {255,255,255,255}})
    end
    if wellData.ShadowHSV then
        game.SetHSV({Id = shadowId, HSV = wellData.ShadowHSV})
    end
    game.SetThingProperty({ Property = "Ambient", Value = -1, DestinationId = shadowId })

    -- shop obstacle
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
    else
        game.FlipHorizontal({Id = shadowId})
    end

    game.CurrentRun.CurrentRoom[shopData.ObstacleName] = shop
end

modutil.mod.Path.Wrap("HandleSecretSpawns", function (base, currentRun)
    local retval = base(currentRun)
    local currentRoom = currentRun.CurrentRoom
    if config.purging_well and PurgeWellLocationData[currentRoom.Name] and
            mod.CheckWellShop(currentRoom) and game.GameState.WorldUpgradesAdded.WorldUpgradePostBossSellTraitShops and
            game.IsGameStateEligible( currentRoom, currentRoom.WellShopRequirements ) then
        local wellData = PurgeWellLocationData[currentRoom.Name]
        mod.SpawnSellShop(wellData.DestinationId, wellData.OffsetX, wellData.OffsetY, "Sell", wellData.Flipped, wellData)
    end
    return retval
end)