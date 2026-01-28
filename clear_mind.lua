ClearMind = { }

-- ------------------------------------------------------------------------------------------------------
-- Get the max clear mind level.
-- ------------------------------------------------------------------------------------------------------
ClearMind.Rank = function()
    local mainJob      = Ashita.Job()
    local mainJobLevel = Ashita.JobLevel()
    local subJob       = Ashita.Job(true)
    local subJobLevel  = Ashita.JobLevel(true)
    local cmRank       = 0

    if Res.Clear_Mind[mainJob] then
        for rank = 6, 1, -1 do
            local cmLevel = Res.Clear_Mind[mainJob][rank]

            if Res.Clear_Mind[mainJob][rank] then
                if mainJobLevel >= cmLevel then
                    return rank
                end
            end
        end

    elseif Res.Clear_Mind[subJob] then
        for rank = 6, 1, -1 do
            local cmLevel = Res.Clear_Mind[subJob][rank]

            if Res.Clear_Mind[subJob][rank] then
                if subJobLevel >= cmLevel then
                    return rank
                end
            end
        end
    end

    return cmRank
end

-- ------------------------------------------------------------------------------------------------------
-- Turns a clear mind rank into a display string for the breakdown.
-- ------------------------------------------------------------------------------------------------------
---@param rank integer
---@return string
-- ------------------------------------------------------------------------------------------------------
ClearMind.DisplayRank = function(rank)
    if not rank then
        return 'None'
    end

    if Res.Clear_Mind.Numerals[rank] then
        return Res.Clear_Mind.Numerals[rank]
    end

    return 'None'
end

-- ------------------------------------------------------------------------------------------------------
-- Take the clear mind rank and translate that into additional MP gained per tick.
-- ------------------------------------------------------------------------------------------------------
ClearMind.MP = function()
    local cmRank = ClearMind.Rank()

    if not cmRank then
        return 0
    end

    return Res.Clear_Mind.HMP[cmRank]
end

-- ------------------------------------------------------------------------------------------------------
-- Upon hitting 75 you get additional HMP per tick. (Horizon)
-- ------------------------------------------------------------------------------------------------------
ClearMind.MaxLevelBonus = function()
    local mainJob      = Ashita.Job()
    local mainJobLevel = Ashita.JobLevel()

    if mainJobLevel < 75 then
        return 0
    end

    if mainJob == 'RDM' then
        return 1
    end

    if mainJob == 'BLM' then
        return 2
    end

    if mainJob == 'WHM' then
        return 3
    end

    return 0
end

-- ------------------------------------------------------------------------------------------------------
-- Return the base HMP rate.
-- ------------------------------------------------------------------------------------------------------
ClearMind.BaseHMP = function()
    return HPMP.Enum.BASE_HMP + ClearMind.MaxLevelBonus()
end

-- ------------------------------------------------------------------------------------------------------
-- Return the incremental HMP rate.
-- ------------------------------------------------------------------------------------------------------
ClearMind.IncHMP = function()
    return HPMP.Enum.INC_HMP + ClearMind.MaxLevelBonus()
end
