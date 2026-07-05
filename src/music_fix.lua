local revertSecretMusicMap = {}

modutil.mod.Path.Wrap("KillHero", function (base, ...)
    for roomName, value in pairs(revertSecretMusicMap) do
        local roomData = game.RoomData[roomName]
        if roomData then
            roomData.SecretMusic = value
        else
            print("Unable to revert SecretMusic flag for", roomName)
        end
    end
    revertSecretMusicMap = {}
    return base(...)
end)

modutil.mod.Path.Wrap("StartRoomMusic", function (base, currentRun, currentRoom)
    local roomData = game.RoomData[currentRoom.Name] or currentRoom
    local secretMusicCopy = roomData.SecretMusic
    if config.shop_music_fix and currentRun.IsDreamRun and currentRoom.ChosenRewardType == "Shop" and not currentRoom.SkipShopSecretMusic then
        print("overriding secret music", roomData.SecretMusic, roomData.ShopSecretMusic)
        roomData.SecretMusic = roomData.ShopSecretMusic
        revertSecretMusicMap[currentRoom.Name] = secretMusicCopy
    end
    return base(currentRun, currentRoom)
end)