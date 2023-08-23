Config = Config or {}


Config.Prize = {
    min = 1000,
    max = 12000,
    item = 'black_money' -- if this one is not present, it will give cash instead
}

Config.Store = {
    [1] = {
        coords = vector3(29.71, -1346.0, 29.5),
        hack = {
            hacked = false,
            coords = vec3(19.4, -1335.55, 29.2),
            size = vec3(0.4, 1, 1),
            rotation = 0.0,
        },
        registar = {
            [1] = {
                unlocked = false,
                robbed = false,
                coords = vector4(24.23, -1344.85, 29.5, 272.64)
            },
            [2] = {
                unlocked = false,
                robbed = false,
                coords = vector4(24.41, -1347.36, 29.5, 275.64)
            }
        },
        -- player must search for combination... Ain't no way I'm gonna make my player base take rob so easy
        search = {
            [1] = {
                coords = vec3(30.75, -1338.65, 29.0),
                size = vec3(0.65, 0.55, 2.9),
                rotation = 0.0,
            },
            [2] = {
                coords = vec3(31.5, -1339.2, 29.0),
                size = vec3(0.4, 0.55, 1.1),
                rotation = 0.0,
            },
            [3] = {
                coords = vec3(29.55, -1338.4, 29.5),
                size = vec3(0.5, 0.4, 0.5),
                rotation = 355.5,
                iscomputer = true
            }
        },
        safe = vector4(28.04, -1339.16, 29.5, 2.16)
    },

}
