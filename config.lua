-- ==================== QR-MULTICHARACTER CONFIG ====================
Config = {}

-- ==================== LOCALIZATION SETTINGS ====================
Config.Locale = {
    language = 'en', -- Default language ('en' for English, 'ar' for Arabic)
    availableLanguages = {'en', 'ar'}, -- Available languages
    fallbackLanguage = 'en', -- Fallback language if selected language is not available
}

-- ==================== DEBUG SETTINGS ====================
-- لتفعيل الديبوق: استخدم الأمر /multidebug في اللعبة
-- أو قم بتغيير القيم هنا وإعادة تشغيل المورد
Config.Debug = {
    enabled = false, -- تفعيل/تعطيل الديبوق العام
    client = false,  -- تفعيل/تعطيل رسائل الديبوق للكلاينت
    server = false,  -- تفعيل/تعطيل رسائل الديبوق للسيرفر
    events = false,  -- تفعيل/تعطيل تتبع الأحداث
    performance = false, -- تفعيل/تعطيل مراقبة الأداء
}

Config.OPTIMIZATION = {
    MENU_UPDATE_DELAY = 50,
    CHARACTER_LOAD_DELAY = 100,
    FADE_DURATION = 250
}

-- ==================== GENERAL SETTINGS ====================
Config.StartingApartment = false -- Enable/disable starting apartments
Config.MaxCharacters = 5 -- Maximum characters per player
Config.DefaultNumberOfCharacters = 5 -- Default number of characters allowed

-- ==================== STARTER ITEMS ====================
Config.StarterItems = {
    {item = 'water', amount = 5},    -- ماء
    {item = 'bread', amount = 5},    -- خبز
}

-- ==================== SPAWN SETTINGS ====================
Config.DefaultSpawn = vector3(-1035.71, -2731.87, 12.86) -- Default spawn coordinates

-- ==================== CHARACTER SELECTION SETTINGS ====================
Config.CharacterSelection = {
    -- Exterior location near Valentine for character selection
    coords = vector3(-1810.85, -430.77, 158.33),
    heading = 225.0,
    weather = 'CLEAR',
    time = { hour = 12, minute = 0 } -- Noon for best lighting
}

-- ==================== PERFORMANCE OPTIMIZATION ====================
Config.Performance = {
    EnableCaching = true, -- Enable character data caching
    CacheTimeout = 300000, -- Cache timeout in milliseconds (5 minutes)
    PreloadDistance = 100.0, -- Distance to preload character models
    LowSpecMode = false, -- Enable for lower-end systems
}

-- ==================== UI SETTINGS ====================
Config.UI = {
    ShowCharacterDetails = true, -- Show detailed character information
    ShowPlaytime = true, -- Display character playtime
    ShowLevel = true, -- Display character level
    EnablePreview = true, -- Enable character preview feature
    AnimationSpeed = 1000, -- UI animation speed in milliseconds
}

-- ==================== PLAYER SPECIFIC CHARACTER LIMITS ====================
Config.PlayersNumberOfCharacters = {
    -- Example: { license = "license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", numberOfChars = 2 },
}

-- ==================== DISCONNECT MESSAGE ====================
Config.DisconnectText = "You have disconnected from QRCore RedM Server"

-- ==================== CAMERA SETTINGS ====================
Config.Camera = {
    Selection = {
        coords = vector3(-562.8157, -3776.266, 239.0805),
        rotation = vector3(-4.2146, -0.0007, -87.8802),
        fov = 30.0
    },
    Customization = {
        coords = vector3(-561.8157, -3780.966, 239.0805),
        rotation = vector3(-4.2146, -0.0007, -87.8802),
        fov = 30.0
    },
    -- Cinematic camera system for character selection
    Cinematic = {
        -- Single straight line path through Valentine - elevated aerial view
        points = {
            {
                coords = vector3(-400.0, 785.0, 140.0),
                rotation = vector3(-15.0, 0.0, 90.0),
                fov = 50.0,
                duration = 15000 -- 15 seconds (very slow)
            },
            {
                coords = vector3(-370.0, 785.0, 140.0),
                rotation = vector3(-15.0, 0.0, 90.0),
                fov = 50.0,
                duration = 15000
            },
            {
                coords = vector3(-340.0, 785.0, 140.0),
                rotation = vector3(-15.0, 0.0, 90.0),
                fov = 50.0,
                duration = 15000
            },
            {
                coords = vector3(-310.0, 785.0, 140.0),
                rotation = vector3(-15.0, 0.0, 90.0),
                fov = 50.0,
                duration = 15000
            },
            {
                coords = vector3(-280.0, 785.0, 140.0),
                rotation = vector3(-15.0, 0.0, 90.0),
                fov = 50.0,
                duration = 15000
            },
            {
                coords = vector3(-250.0, 785.0, 140.0),
                rotation = vector3(-15.0, 0.0, 90.0),
                fov = 50.0,
                duration = 15000
            }
        }
    }
}

-- ==================== CHARACTER SPAWN LOCATION ====================
Config.CharacterSpawn = {
    coords = vector3(-559.5, -3776.5, 237.63),
    heading = 90.0
}