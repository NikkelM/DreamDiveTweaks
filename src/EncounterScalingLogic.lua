local function ExtendDreamBiomeData( biomeData, maxIndex )
	maxIndex = maxIndex or 8

	for i = 5, maxIndex do
		local prevEntry = biomeData[4]

		if prevEntry == nil then
			break
		end

		local newEntry = game.DeepCopyTable( prevEntry )
		biomeData[i] = newEntry
	end
end

local function ExtendAllDreamBiomeData( encounterTable, maxIndex )
	for _, encounterData in pairs( encounterTable ) do
		if type( encounterData ) == "table" and encounterData.DreamBiomeData then
			ExtendDreamBiomeData(encounterData.DreamBiomeData, maxIndex)
		end
	end
end

ExtendAllDreamBiomeData( game.EncounterData, mod.MaxAllowedBiomeCount )