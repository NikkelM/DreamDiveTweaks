local newScalingData = {
    Zagreus = {
        DreamBiomeData = {
            [1] =
			{
				DataOverrides =
				{
					-- HealthMultiplier = 0.7,
				},
				AddOutgoingDamageModifier =
				{
				 	-- PlayerMultiplier = 1.0,
				},
			},
			[2] =
			{
				DataOverrides =
				{
					-- HealthMultiplier = 1.25,
				},
				AddOutgoingDamageModifier =
				{
				 	-- PlayerMultiplier = 1.25,
				},
			},
			[3] =
			{
				DataOverrides =
				{
					-- HealthMultiplier = 2.75,
					-- SpeedMultiplier = 1.1,
				},
				AddOutgoingDamageModifier =
				{
				 	-- PlayerMultiplier = 1.9,
				},
			},
			[4] =
			{
                DataOverrides =
                {
                    HealthMultiplier = 3,
                    SpeedMultiplier = 1,
                },
                AddOutgoingDamageModifier =
                {
                    PlayerMultiplier = 3,
                },
            },
            [5] =
            {
                DataOverrides =
                {
                    HealthMultiplier = 3,
                    SpeedMultiplier = 1,
                },
                AddOutgoingDamageModifier =
                {
                    PlayerMultiplier = 3,
                },
            },
            [6] =
            {
                DataOverrides =
                {
                    HealthMultiplier = 3,
                    SpeedMultiplier = 1,
                },
                AddOutgoingDamageModifier =
                {
                    PlayerMultiplier = 3,
                },
            },
            [7] =
            {
                DataOverrides =
                {
                    HealthMultiplier = 5,
                    SpeedMultiplier = 1.2,
                },
                AddOutgoingDamageModifier =
                {
                    PlayerMultiplier = 5,
                },
            },
            [8] =
            {
                DataOverrides =
                {
                    HealthMultiplier = 5,
                    SpeedMultiplier = 1.2,
                },
                AddOutgoingDamageModifier =
                {
                    PlayerMultiplier = 5,
                },
            },
            [9] =
            {
                DataOverrides =
                {
                    HealthMultiplier = 5,
                    SpeedMultiplier = 1.2,
                },
                AddOutgoingDamageModifier =
                {
                    PlayerMultiplier = 5,
                },
            },
            [10] =
            {
                DataOverrides =
                {
                    HealthMultiplier = 15,
                    SpeedMultiplier = 1.3,
                },
                AddOutgoingDamageModifier =
                {
                    PlayerMultiplier = 7,
                },
            },
            [11] =
            {
                DataOverrides =
                {
                    HealthMultiplier = 15,
                    SpeedMultiplier = 1.3,
                },
                AddOutgoingDamageModifier =
                {
                    PlayerMultiplier = 7,
                },
            },
            [12] =
            {
                DataOverrides =
                {
                    HealthMultiplier = 15,
                    SpeedMultiplier = 1.3,
                },
                AddOutgoingDamageModifier =
                {
                    PlayerMultiplier = 7,
                },
            },
        }
    },

    Charon = {
        DreamBiomeData = {
            [1] = { DataOverrides = {  }, AddOutgoingDamageModifier = {  } },
			[2] = { DataOverrides = {  }, AddOutgoingDamageModifier = {  } },
			[3] = { DataOverrides = {  }, AddOutgoingDamageModifier = {  } },
			[4] =
            {
                DataOverrides =
                {
                    HealthMultiplier = 3.51,
                    SpeedMultiplier = 1.25,
                },
                AddOutgoingDamageModifier =
                {
                    PlayerMultiplier = 4.2,
                },
            },
            [5] =
            {
                DataOverrides =
                {
                    HealthMultiplier = 3.51,
                    SpeedMultiplier = 1.25,
                },
                AddOutgoingDamageModifier =
                {
                    PlayerMultiplier = 4.2,
                },
            },
            [6] =
            {
                DataOverrides =
                {
                    HealthMultiplier = 3.51,
                    SpeedMultiplier = 1.25,
                },
                AddOutgoingDamageModifier =
                {
                    PlayerMultiplier = 4.2,
                },
            },
            [7] =
            {
                DataOverrides =
                {
                    HealthMultiplier = 5.93,
                    SpeedMultiplier = 1.25,
                },
                AddOutgoingDamageModifier =
                {
                    PlayerMultiplier = 6.05,
                },
            },
            [8] =
            {
                DataOverrides =
                {
                    HealthMultiplier = 5.93,
                    SpeedMultiplier = 1.25,
                },
                AddOutgoingDamageModifier =
                {
                    PlayerMultiplier = 6.05,
                },
            },
            [9] =
            {
                DataOverrides =
                {
                    HealthMultiplier = 5.93,
                    SpeedMultiplier = 1.25,
                },
                AddOutgoingDamageModifier =
                {
                    PlayerMultiplier = 6.05,
                },
            },
            [10] =
            {
                DataOverrides =
                {
                    HealthMultiplier = 16.94,
                    SpeedMultiplier = 1.25,
                },
                AddOutgoingDamageModifier =
                {
                    PlayerMultiplier = 12.54,
                },
            },
            [11] =
            {
                DataOverrides =
                {
                    HealthMultiplier = 16.94,
                    SpeedMultiplier = 1.25,
                },
                AddOutgoingDamageModifier =
                {
                    PlayerMultiplier = 12.54,
                },
            },
            [12] =
            {
                DataOverrides =
                {
                    HealthMultiplier = 16.94,
                    SpeedMultiplier = 1.25,
                },
                AddOutgoingDamageModifier =
                {
                    PlayerMultiplier = 12.54,
                },
            },
        }
    }
}

for enemyName, newData in pairs(newScalingData) do
    if game.EnemyData[enemyName] then
        game.OverwriteTableKeys(game.EnemyData[enemyName], newData)
    end
end