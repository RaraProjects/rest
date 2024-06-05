------------------------------------------------------------------------------------------------------
-- Subscribe to addon commands.
-- Influenced by HXUI: https://github.com/tirem/HXUI
------------------------------------------------------------------------------------------------------
ashita.events.register('command', 'command_cb', function (e)
    local command_args = e.command:lower():args()
    local arg = command_args[2]

    ---@diagnostic disable-next-line: undefined-field
    if table.contains({"/rest"}, command_args[1]) then
        if not arg then
            Config.Toggle_Visible()
        elseif arg == "breakdown" or arg == "b" then
            MP.Config.Toggle_MP_Breakdown()
        elseif arg == "mp" then
            MP.Config.Toggle_MP()
        elseif arg == "timer" or arg == "t" then
            MP.Config.Toggle_Time_To_Full()
        end
    end

end)