Config = Config or {}


Config.MinPolice = 2

Config.Inventory = "ox" -- qb / ox

Config.Target = "ox"    -- qb or ox

Config.RegisterSearchTime = 25000

Config.HackItem = "trojan_usb"

Config.Prize = {
    min = 1000,
    max = 12000,
    item = 'black_money', -- if this one is not present, it will give cash instead
    safe = {
        ['black_money'] = {
            min = 5000,
            max = 10000,
            chance = 100
        },
        ['goldbar'] = {
            min = 1,
            max = 5,
            chance = 20
        },
        ['moneybag'] = {
            min = 1,
            max = 2,
            chance = 10
        }
    }
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
                robbed = false,
                coords = vector4(24.23, -1344.85, 29.5, 272.64)
            },
            [2] = {
                robbed = false,
                coords = vector4(24.41, -1347.36, 29.5, 275.64)
            }
        },
        -- player must search for combination... Ain't no way I'm gonna make my player do robbery so easy
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
        safe = {
            coords = vector4(28.26, -1339.13, 29.5, 5.83)
        }
    },
    [2] = {
        coords = vector3(-3042.11, 588.7, 7.91),
        hack = {
            hacked = false,
            coords = vec3(-3049.4, 589.2, 7.9),
            size = vec3(0.55, 0.6, 0.95),
            rotation = 18.0,
        },
        registar = {
            [1] = {
                robbed = false,
                coords = vector4(-3041.22, 583.84, 7.91, 14.29)
            },
            [2] = {
                robbed = false,
                coords = vector4(-3038.93, 584.58, 7.91, 19.15)
            }
        },
        search = {
            [1] = {
                coords = vec3(-3048.9, 588.75, 7.45),
                size = vec3(0.6, 0.45, 0.95),
                rotation = 17.75,
            },
            [2] = {
                coords = vec3(-3049.15, 587.9, 7.9),
                size = vec3(0.3, 0.7, 1.8),
                rotation = 17.75,
            },
            [3] = {
                coords = vec3(-3048.9, 586.7, 7.9),
                size = vec3(0.45, 0.5, 0.45),
                rotation = 13.75,
                iscomputer = true
            }
        },
        safe = {
            coords = vector3(-3047.76, 585.72, 7.91)
        }
    },
    [3] = {
        coords = vector3(-3243.62, 1005.08, 12.83),
        hack = {
            hacked = false,
            coords = vec3(-3241.9, 1012.45, 12.6),
            size = vec3(0.6, 0.5, 0.95),
            rotation = 355.5,
        },
        registar = {
            [1] = {
                robbed = false,
                coords = vector4(-3244.58, 1000.22, 12.83, 3.14)
            },
            [2] = {
                robbed = false,
                coords = vector4(-3242.2, 999.95, 12.83, 355.47)
            }
        },
        search = {
            [1] = {
                coords = vec3(-3249.8, 1007.65, 12.4),
                size = vec3(0.6, 0.5, 1.05),
                rotation = 355.5,
            },
            [2] = {
                coords = vec3(-3250.5, 1007.0, 12.75),
                size = vec3(0.65, 0.65, 1.85),
                rotation = 356.25,
            },
            [3] = {
                coords = vec3(-3250.65, 1005.8, 12.9),
                size = vec3(0.3, 0.5, 0.6),
                rotation = 352.25,
                iscomputer = true
            }
        },
        safe = {
            coords = vector4(-3250.01, 1004.44, 12.83, 88.01)
        }
    },
    [4] = {
        coords = vector3(1733.4, 6414.97, 35.04),
        registar = {
            [1] = {
                robbed = false,
                coords = vector4(1728.9, 6417.25, 35.04, 228.64)
            },
            [2] = {
                robbed = false,
                coords = vector4(1727.86, 6415.15, 35.04, 249.11)
            }
        },
        search = {
            [1] = {
                coords = vec3(1737.8, 6419.4, 34.5),
                size = vec3(0.4, 0.55, 1.05),
                rotation = 333.75,
            },
            [2] = {
                coords = vec3(1737.35, 6420.25, 35.0),
                size = vec3(0.7, 0.55, 1.8),
                rotation = 333.75,
            },
            [3] = {
                coords = vec3(1736.35, 6420.95, 35.1),
                size = vec3(0.5, 0.5, 0.4),
                rotation = 331.75,
                iscomputer = true
            }
        },
        safe = {
            coords = vector4(1734.81, 6420.82, 35.04, 343.39)
        }
    },
    [5] = {
        coords = vector3(1702.06, 4925.55, 42.06),
        hack = {
            hacked = false,
            coords = vec3(1710.6, 4934.25, 42.4),
            size = vec3(0.9, 0.25, 1.3),
            rotation = 326.25,
        },
        registar = {
            [1] = {
                robbed = false,
                coords = vector4(1698.12, 4922.89, 42.06, 334.23)
            },
            [2] = {
                robbed = false,
                coords = vector4(1696.66, 4923.89, 42.06, 331.83)
            }
        },
        search = {
            [1] = {
                coords = vec3(1705.6, 4922.75, 42.0),
                size = vec3(0.6, 0.5, 1.8),
                rotation = 326.0,
            },
            [2] = {
                coords = vec3(1706.3, 4922.7, 41.55),
                size = vec3(0.7, 0.5, 1.05),
                rotation = 325.0,
            },
            [3] = {
                coords = vec3(1707.3, 4921.85, 42.15),
                size = vec3(0.5, 0.2, 0.5),
                rotation = 325.0,
                iscomputer = true
            }
        },
        safe = {
            coords = vector4(1707.94, 4920.34, 42.06, 327.33)
        }
    },
    [6] = {
        coords = vector3(1963.32, 3743.95, 32.34),
        registar = {
            [1] = {
                robbed = false,
                coords = vector4(1958.94, 3741.98, 32.34, 304.07)
            },
            [2] = {
                robbed = false,
                coords = vector4(1960.07, 3739.99, 32.34, 294.36)
            }
        },
        search = {
            [1] = {
                coords = vec3(1961.15, 3750.7, 32.0),
                size = vec3(0.45, 0.65, 2.65),
                rotation = 300.25,
            },
            [2] = {
                coords = vec3(1962.1, 3750.6, 31.85),
                size = vec3(0.65, 0.35, 1.0),
                rotation = 300.25,
            },
            [3] = {
                coords = vec3(1960.05, 3750.25, 32.4),
                size = vec3(0.55, 0.3, 0.45),
                rotation = 25.5,
                iscomputer = true
            }
        },
        safe = {
            coords = vector4(1959.22, 3748.92, 32.34, 30.24)
        }
    },
    [7] = {
        coords = vector3(544.26, 2668.7, 42.16),
        registar = {
            [1] = {
                robbed = false,
                coords = vector4(549.43, 2669.03, 42.16, 90.0)
            },
            [2] = {
                robbed = false,
                coords = vector4(549.13, 2671.37, 42.16, 82.94)
            }
        },
        search = {
            [1] = {
                coords = vec3(543.15, 2662.35, 41.7),
                size = vec3(0.55, 0.5, 0.95),
                rotation = 276.0,
            },
            [2] = {
                coords = vec3(544.0, 2661.8, 42.0),
                size = vec3(0.55, 0.65, 1.95),
                rotation = 276.5,
            },
            [3] = {
                coords = vec3(545.2, 2661.85, 42.25),
                size = vec3(0.45, 0.5, 0.55),
                rotation = 275.25,
                iscomputer = true
            }
        },
        safe = {
            coords = vector4(546.37, 2662.82, 42.16, 194.7)
        }
    },
    [8] = {
        coords = vector3(2678.13, 3284.9, 55.24),
        hack = {
            hacked = false,
            coords = vec3(2676.4, 3293.75, 55.4),
            size = vec3(0.2, 0.6, 0.95),
            rotation = 241.25,
        },
        registar = {
            [1] = {
                robbed = false,
                coords = vector4(2675.96, 3280.61, 55.24, 342.33)
            },
            [2] = {
                robbed = false,
                coords = vector4(2677.94, 3279.47, 55.24, 317.85)
            }
        },
        search = {
            [1] = {
                coords = vec3(2674.35, 3289.5, 54.75),
                size = vec3(0.35, 0.6, 1.0),
                rotation = 241.25,
            },
            [2] = {
                coords = vec3(2673.6, 3289.05, 55.2),
                size = vec3(0.65, 0.4, 1.65),
                rotation = 241.25,
            },
            [3] = {
                coords = vec3(2672.7, 3288.2, 55.3),
                size = vec3(0.55, 0.4, 0.55),
                rotation = 236.25,
                iscomputer = true
            }
        },
        safe = {
            coords = vector4(2672.8, 3286.69, 55.24, 77.45)
        }
    },
    [9] = {
        coords = vector3(2555.56, 386.01, 108.62),
        registar = {
            [1] = {
                robbed = false,
                coords = vector4(2554.88, 380.94, 108.62, 6.34)
            },
            [2] = {
                robbed = false,
                coords = vector4(2557.32, 380.83, 108.62, 354.05)
            }
        },
        search = {
            [1] = {
                coords = vec3(2549.35, 388.15, 108.15),
                size = vec3(0.45, 0.55, 1.05),
                rotation = 266.25,
            },
            [2] = {
                coords = vec3(2548.85, 387.4, 108.65),
                size = vec3(0.6, 0.4, 1.7),
                rotation = 266.5,
            },
            [3] = {
                coords = vec3(2548.5, 386.25, 108.75),
                size = vec3(0.5, 0.4, 0.6),
                rotation = 262.0,
                iscomputer = true
            }
        },
        safe = {
            coords = vector4(2549.19, 384.88, 108.62, 104.86)
        }
    },
    [10] = {
        coords = vector3(377.93, 327.15, 103.57),
        registar = {
            [1] = {
                robbed = false,
                coords = vector4(373.05, 328.71, 103.57, 257.52)
            },
            [2] = {
                robbed = false,
                coords = vector4(372.55, 326.46, 103.57, 251.15)
            }
        },
        search = {
            [1] = {
                coords = vec3(381.4, 332.55, 103.15),
                size = vec3(0.55, 0.4, 1.0),
                rotation = 256.0,
            },
            [2] = {
                coords = vec3(380.75, 333.3, 103.6),
                size = vec3(0.45, 0.65, 1.65),
                rotation = 256.0,
            },
            [3] = {
                coords = vec3(379.6, 333.8, 103.7),
                size = vec3(0.4, 0.6, 0.5),
                rotation = 251.0,
                iscomputer = true
            }
        },
        safe = {
            coords = vector4(378.27, 333.41, 103.57, 349.16)
        }
    }
}
