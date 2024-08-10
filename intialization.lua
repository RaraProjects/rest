------------------------------------------------------------------------------------------------------
-- Load settings when the addon is loaded.
------------------------------------------------------------------------------------------------------
ashita.events.register('load', 'load_cb', function()
    Rest = T{
        Bar    = Settings.load(Config.Bar.Defaults, Config.Bar.ALIAS),
        MP     = Settings.load(Config.MP.Defaults, Config.MP.ALIAS),
        HP     = Settings.load(Config.HP.Defaults, Config.HP.ALIAS),
        Config = Settings.load(Config.Defaults, Config.ALIAS),
    }
    _Globals.Initialized = true
end)

------------------------------------------------------------------------------------------------------
-- Save settings when the addon is unloaded.
------------------------------------------------------------------------------------------------------
ashita.events.register('unload', 'unload_cb', function ()
    Settings.save(Config.Bar.ALIAS)
    Settings.save(Config.MP.ALIAS)
    Settings.save(Config.HP.ALIAS)
    Settings.save(Config.ALIAS)
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific bar settings.
------------------------------------------------------------------------------------------------------
Settings.register(Config.Bar.ALIAS, "settings_update", function(settings)
    if settings ~= nil then
        Rest.Bar = settings
        Bar.Reset_Position = true
        Bar.Scaling_Set = false
        Settings.save(Config.Bar.ALIAS)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific MP settings.
------------------------------------------------------------------------------------------------------
Settings.register(Config.MP.ALIAS, "settings_update", function(settings)
    if settings ~= nil then
        Rest.MP = settings
        Settings.save(Config.MP.ALIAS)
    end
end)

------------------------------------------------------------------------------------------------------
-- Check for character switches. Reloads character specific HP settings.
------------------------------------------------------------------------------------------------------
Settings.register(Config.HP.ALIAS, "settings_update", function(settings)
    if settings ~= nil then
        Rest.HP = settings
        Settings.save(Config.HP.ALIAS)
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