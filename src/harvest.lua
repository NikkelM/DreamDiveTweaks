modutil.mod.Path.Wrap("CreateRoom", function (base, roomData, args)
    rom.mods["NikkelM-Resources_In_Chaos_Trials"].config.dreamDives = config.dream_resources
    return base(roomData, args)
end)