MP.Clear_Mind = T{}

-- ------------------------------------------------------------------------------------------------------
-- Get the max clear mind level.
-- ------------------------------------------------------------------------------------------------------
MP.Clear_Mind.Rank = function()
    local main_job = Ashita.Job()
    local main_job_level = Ashita.Job_Level()
    local sub_job = Ashita.Job(true)
    local sub_job_level = Ashita.Job_Level(true)
    local cm_rank = 0
    if Clear_Mind[main_job] then
        for rank = 6, 1, -1 do
            local cm_level = Clear_Mind[main_job][rank]
            if Clear_Mind[main_job][rank] then
                if main_job_level >= cm_level then return rank end
            end
        end
    elseif Clear_Mind[sub_job] then
        for rank = 6, 1, -1 do
            local cm_level = Clear_Mind[sub_job][rank]
            if Clear_Mind[sub_job][rank] then
                if sub_job_level >= cm_level then return rank end
            end
        end
    end
    return cm_rank
end

-- ------------------------------------------------------------------------------------------------------
-- Turns a clear mind rank into a display string for the breakdown.
-- ------------------------------------------------------------------------------------------------------
---@param rank integer
---@return string
-- ------------------------------------------------------------------------------------------------------
MP.Clear_Mind.Display_Rank = function(rank)
    if not rank then return "None" end
    if Clear_Mind.Numerals[rank] then return Clear_Mind.Numerals[rank] end
    return "None"
end

-- ------------------------------------------------------------------------------------------------------
-- Take the clear mind rank and translate that into additional MP gained per tick.
-- ------------------------------------------------------------------------------------------------------
MP.Clear_Mind.MP = function()
    local cm_rank = MP.Clear_Mind.Rank()
    if not cm_rank then return 0 end
    return Clear_Mind.HMP[cm_rank]
end

-- ------------------------------------------------------------------------------------------------------
-- Upon hitting 75 you get additional HMP per tick. (Horizon)
-- ------------------------------------------------------------------------------------------------------
MP.Clear_Mind.Max_Level_Bonus = function()
    local main_job = Ashita.Job()
    local main_job_level = Ashita.Job_Level()
    if main_job_level < 75 then return 0 end
    if main_job == "RDM" then return 1 end
    if main_job == "BLM" then return 2 end
    if main_job == "WHM" then return 3 end
    return 0
end

-- ------------------------------------------------------------------------------------------------------
-- Return the base HMP rate.
-- ------------------------------------------------------------------------------------------------------
MP.Clear_Mind.Base_HMP = function()
    return MP.Enum.BASE_HMP + MP.Clear_Mind.Max_Level_Bonus()
end

-- ------------------------------------------------------------------------------------------------------
-- Return the incremental HMP rate.
-- ------------------------------------------------------------------------------------------------------
MP.Clear_Mind.Inc_HMP = function()
    return MP.Enum.INC_HMP + MP.Clear_Mind.Max_Level_Bonus()
end