------------------------------------------------------------------------------------------------------
-- Load settings when the addon is loaded.
------------------------------------------------------------------------------------------------------
ashita.events.register('load', 'load_cb', function()
    Rest = T{
        Bar    = Settings.load(Bar.Config.Defaults, Bar.Config.ALIAS),
        MP     = Settings.load(MP.Config.Defaults, MP.Config.ALIAS),
        Config = Settings.load(Config.Defaults, Config.ALIAS),
    }
    _Globals.Initialized = true
end)

------------------------------------------------------------------------------------------------------
-- Save settings when the addon is unloaded.
------------------------------------------------------------------------------------------------------
ashita.events.register('unload', 'unload_cb', function ()
    Settings.save(Bar.Config.ALIAS)
    Settings.save(MP.Config.ALIAS)
    Settings.save(Config.ALIAS)
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific bar settings.
------------------------------------------------------------------------------------------------------
Settings.register(Bar.Config.ALIAS, "settings_update", function(settings)
    if settings ~= nil then
        Rest.Bar = settings
        Bar.Reset_Position = true
        Bar.Scaling_Set = false
        Settings.save(Bar.Config.ALIAS)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific MP settings.
------------------------------------------------------------------------------------------------------
Settings.register(MP.Config.ALIAS, "settings_update", function(settings)
    if settings ~= nil then
        Rest.MP = settings
        Settings.save(MP.Config.ALIAS)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific MP settings.
------------------------------------------------------------------------------------------------------
Settings.register(Config.ALIAS, "settings_update", function(settings)
    if settings ~= nil then
        Rest.Config = settings
        Config.Reset_Position = true
        Settings.save(Config.ALIAS)
    end
end)