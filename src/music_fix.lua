modutil.mod.Path.Wrap("StartRoomMusic", function (base, currentRun, currentRoom)
    local roomData = game.RoomData[currentRoom.Name] or currentRoom
    local secretMusicCopy = roomData.SecretMusic
    if config.shop_music_fix and currentRun.IsDreamRun and currentRoom.ChosenRewardType == "Shop" and not currentRoom.SkipShopSecretMusic then
        print("overriding secret music", roomData.SecretMusic, roomData.ShopSecretMusic)
        roomData.SecretMusic = roomData.ShopSecretMusic
    end
    local retval = base(currentRun, currentRoom)
    return retval
end)