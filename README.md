# QR-Multicharacter v3.0.0

## 🎬 **Latest Update: Multi-Language System & Cinematic Experience**

This version features a completely redesigned experience with professional cinematic camera system, comprehensive multi-language support, and optimized ox_lib integration.

### ✨ **New Features:**
- **🎥 Cinematic Camera System**: Smooth aerial tour of Valentine during character selection
- **🌐 Multi-Language System**: English, Arabic, and extensible to more languages
- **📐 Linear Camera Path**: Professional straight-line movement with configurable speed
- **🎛️ Config-Based Settings**: All camera and language settings in config.lua
- **🧹 Clean Code Structure**: Organized, optimized, and well-documented codebase
- **⚡ Enhanced Performance**: Optimized for RedM with smooth transitions
- **🎯 Professional UI**: Two-tier menu system with localized text
- **🔒 Safe Character Management**: Secure deletion with confirmation system
- **🌍 Exterior Location**: Valentine-based character selection (no interior loading)
- **🎨 Dynamic Language Switching**: Change language in real-time without restart

### 🌍 **Language Support:**
- **English (en)** - Default language
- **Arabic (ar)** - Full RTL support with cultural adaptations
- **Extensible** - Easy to add new languages
- **Commands**: 
  - `/lang` - Open language selection menu
  - `/setlang <code>` - Change language directly (e.g., `/setlang ar`)
- **Fallback System** - Automatic fallback to English for missing translations

### 🎬 **Cinematic Camera Features:**
- **Path**: Single straight line through Valentine at 140.0 elevation
- **Speed**: Configurable 15-second segments (very slow and cinematic)
- **View**: Beautiful aerial perspective of Valentine's architecture
- **Loop**: Continuous seamless movement during character selection
- **Quality**: 60 FPS smooth interpolation between camera points
- **Localized**: All camera messages support multiple languages

### 🛠️ **Dependencies:**
- `ox_lib` - Required for context menus and input dialogs
- `qr-core` - Core framework

### 📋 **Character Creation Fields:**
- First Name (2-15 characters)
- Last Name (2-15 characters)
- Date of Birth (Date picker with DD/MM/YYYY format)
- Gender (Male/Female with icons)
- Nationality (9 options with flag emojis)

### 🎮 **How to Use:**

#### **Character Selection:**
1. **View Characters**: Browse your character list with detailed information
2. **Select Character**: Click on any character name to see options
3. **Character Options**:
   - 🎮 **Enter Character**: Login with selected character
   - 🗑️ **Delete Character**: Permanently remove character
   - ⬅️ **Back to Characters**: Return to character list

#### **Character Management:**
- **Create New**: Click "➕ Create New Character" and fill the detailed form
- **Delete Safety**: Type "DELETE" in capital letters to confirm deletion
- **Disconnect**: Safe server exit option

### ⚙️ **Configuration:**

#### **Language Configuration:**
```lua
Config.Locale = {
    language = 'en', -- Default language ('en' for English, 'ar' for Arabic)
    availableLanguages = {'en', 'ar'}, -- Available languages
    fallbackLanguage = 'en', -- Fallback language if translation not found
}
```

#### **Character Settings:**
```lua
Config.StartingApartment = false -- Enable/disable starting apartments
Config.MaxCharacters = 5 -- Maximum characters per player
Config.DefaultNumberOfCharacters = 5 -- Default number of characters allowed
```

#### **Cinematic Camera Configuration:**
```lua
Config.Camera.Cinematic = {
    points = {
        {
            coords = vector3(-400.0, 785.0, 140.0),
            rotation = vector3(-15.0, 0.0, 90.0),
            fov = 50.0,
            duration = 15000 -- 15 seconds per segment
        },
        -- Additional points...
    }
}
```

#### **Performance Optimization:**
```lua
Config.Performance = {
    EnableCaching = true,
    CacheTimeout = 300000,
    LowSpecMode = false
}
```

#### **Debug Configuration:**
```lua
Config.Debug = {
    enabled = false,     -- تفعيل/تعطيل الديبوق العام
    client = false,      -- تفعيل/تعطيل رسائل الديبوق للكلاينت
    server = false,      -- تفعيل/تعطيل رسائل الديبوق للسيرفر
    events = false,      -- تفعيل/تعطيل تتبع الأحداث
    performance = false  -- تفعيل/تعطيل مراقبة الأداء
}
```

## Commands

### Language Commands
- `/lang` - Opens language selection menu
- `/setlang <language>` - Changes language directly
  - Example: `/setlang ar` for Arabic
  - Example: `/setlang en` for English

### Admin Commands
- `/multidebug` - Toggle multicharacter debug mode (admin only)
- `/clearmulticache` - Clear multicharacter cache (admin only)
- `/forcecleanrestart` - Force clean restart for all players (admin only)

### Character Management
- Character creation, deletion, and selection are handled through the in-game UI
- All validation and safety checks are built into the interface
- Type "DELETE" in capital letters to confirm character deletion

## Adding New Languages

1. Create a new file in `locales/[language_code].lua`
2. Copy the structure from `locales/en.lua`
3. Translate all text strings
4. Add the language code to `Config.Locale.availableLanguages`
5. Restart the resource

Example language file structure:
```lua
local Translations = {
    ['char_select_title'] = 'Your Translation Here',
    ['char_create_new'] = 'Your Translation Here',
    -- ... more translations
}

return Translations
```

### 🔧 **Technical Improvements:**

#### **v3.0.0 Changes:**
- ✅ **Cinematic Camera System**: Professional Valentine aerial tour
- ✅ **Config-Based Camera**: All camera settings in config.lua
- ✅ **Code Organization**: Clean, documented, and optimized structure
- ✅ **Two-Tier Menus**: Character List → Character Options flow
- ✅ **Performance**: Optimized for RedM with smooth 60 FPS movement
- ✅ **Exterior Location**: Valentine-based selection (no interior issues)

#### **v2.0.0 Changes:**
- ✅ **Added**: ox_lib context menus and input dialogs
- ✅ **Added**: Better error handling and confirmation systems

### 🎨 **Customization Guide:**

#### **Camera Speed:**
```lua
duration = 10000  -- Faster (10 seconds)
duration = 20000  -- Slower (20 seconds)
```

#### **Camera Height:**
```lua
coords = vector3(-400.0, 785.0, 160.0)  -- Higher view
coords = vector3(-400.0, 785.0, 120.0)  -- Lower view
```

#### **Camera Angles:**
```lua
rotation = vector3(-20.0, 0.0, 90.0)  -- Steeper angle
rotation = vector3(-10.0, 0.0, 90.0)  -- Gentler angle
```

### 📖 **Documentation:**
- **CAMERA_CONFIG_GUIDE.md**: Complete camera customization guide
- **EXPORTS.md**: Available functions for other resources
- **Configuration Examples**: Multiple camera path examples

### 🔧 **Debug System:**

The resource includes a comprehensive debug system for troubleshooting and development:

#### **Debug Configuration:**
```lua
Config.Debug = {
    enabled = false,     -- تفعيل/تعطيل الديبوق العام
    client = false,      -- تفعيل/تعطيل رسائل الديبوق للكلاينت
    server = false,      -- تفعيل/تعطيل رسائل الديبوق للسيرفر
    events = false,      -- تفعيل/تعطيل تتبع الأحداث
    performance = false  -- تفعيل/تعطيل مراقبة الأداء
}
```

#### **Debug Commands (Admin Only):**
- `/multidebug all` - Toggle all debug modes
- `/multidebug client` - Toggle client-side debug
- `/multidebug server` - Toggle server-side debug
- `/multidebug events` - Toggle event tracking
- `/multidebug performance` - Toggle performance monitoring

#### **Debug Output:**
- **Client Debug**: Purple colored messages with client-side information
- **Server Debug**: Yellow colored messages with server-side information
- **Events Debug**: Tracks all major events and callbacks
- **Performance Debug**: Shows execution times for functions

### 🚀 **Exports for Other Resources:**
```lua
-- Setup/Reset character location
exports['qr-multicharacter']:setupCharacterLocation()
exports['qr-multicharacter']:resetCharacterLocation()

-- Character selection control
exports['qr-multicharacter']:openCharacterSelection()
exports['qr-multicharacter']:getCurrentCharacterCount()
exports['qr-multicharacter']:isInCharacterSelection()

-- Resource management
exports['qr-multicharacter']:forceCleanup()
```

---
**Version**: 3.0.0  
**Framework**: QR-Core  
**UI Library**: ox_lib  
**Game**: RedM  
**Camera System**: Valentine Cinematic Tour  
**Last Updated**: January 2025
