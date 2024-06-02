MP = T{}

MP.Enum = T{
    BASE_HMP = 12,
    INC_HMP  = 4,
}

require("resources.hmp_items")
require("resources.clear_mind")

MP.Equipment = T{}
MP.Clear_Mind = T{}
MP.Additional = T{}

MP.Breakdown = T{
    Base = MP.Enum.BASE_HMP,
    Increment = 0,
    Bonus = 0,
    Gear = 0,
    CM = 0,
    Food = 0,
}

-- Horizon HMP Documentation
-- https://horizonffxi.wiki/MP_Recovered_While_Healing
-- https://horizonffxi.wiki/Clear_Mind

-- Retail HMP Documentation
-- https://www.bg-wiki.com/ffxi/Clear_Mind

-- ------------------------------------------------------------------------------------------------------
-- This is the primary resting loop.
-- ------------------------------------------------------------------------------------------------------
MP.Check_Resting_Status = function()
    if Ashita.Is_Resting() and not Rest.Is_Resting then         -- Just started resting.
        Rest.Is_Resting = true
        Rest.Tick_Time = os.time()
        Rest.First_Tick = false
        Rest.Mod = 20
        MP.Remaining()

    elseif not Ashita.Is_Resting() and Rest.Is_Resting then     -- Just stopped resting.
        Rest.Is_Resting = false
        Rest.Tick_Time = nil
        Rest.Duration = 0
        Rest.Total_Time = 0
        Rest.Ticks = 0
        Rest.MP_Needed = 0

    elseif Rest.Is_Resting then                                 -- Currently resting.
        Rest.Duration = os.time() - Rest.Tick_Time
        if Rest.Duration >= 20 then
            Rest.First_Tick = true
            Rest.Mod = 10
        end
        Rest.MP_Needed = MP.Remaining()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Calcualtes how much MP is needed to get to full MP.
-- The progress bar will not be reset for refresh ticks.
-- ------------------------------------------------------------------------------------------------------
MP.Remaining = function()
    local max_mp = Ashita.Max_MP()
    local curr_mp = Ashita.Current_MP()

    local difference = max_mp - curr_mp

    if difference ~= Rest.MP_Needed then
        if (Rest.MP_Needed - difference) > MP.Enum.BASE_HMP then   -- Resting Tick
            Rest.Tick_Time = os.time()
            Rest.Duration = 0
            Rest.Ticks = Rest.Ticks + 1
        end
        MP.Time_To_Full(difference)
    end

    return difference
end

-- ------------------------------------------------------------------------------------------------------
-- Calculates how much time remains until full MP.
-- ------------------------------------------------------------------------------------------------------
---@param difference integer
-- ------------------------------------------------------------------------------------------------------
MP.Time_To_Full = function(difference)
    local total_time = 0
    if not Rest.First_Tick then
        total_time = total_time + 20
        difference = difference - MP.Enum.BASE_HMP
    end

    if difference < 0 then difference = 0 end
    local ticks = 0
    while difference > 0 do
        ticks = ticks + 1
        total_time = total_time + 10
        difference = difference
                     - MP.Enum.BASE_HMP + MP.Additional.Max_Level()
                     - ((MP.Enum.INC_HMP + MP.Additional.Max_Level()) * ticks)
                     - MP.Equipment.MP()
                     - MP.Clear_Mind.MP()
                     - Config.Settings.Food_HMP
    end

    Rest.Total_Time = total_time
end

-- ------------------------------------------------------------------------------------------------------
-- Calculates how much the player should get on the next tick.
-- ------------------------------------------------------------------------------------------------------
MP.Next_Tick = function()
    MP.Breakdown.Base = MP.Enum.BASE_HMP + MP.Additional.Max_Level()
    MP.Breakdown.Increment = ((MP.Enum.INC_HMP + MP.Additional.Max_Level()) * Rest.Ticks) or 0
    MP.Breakdown.Gear = MP.Equipment.MP() or 0
    MP.Breakdown.CM = MP.Clear_Mind.MP() or 0
    MP.Breakdown.Food = Config.Settings.Food_HMP or 0

    return MP.Breakdown.Base + MP.Breakdown.Increment + MP.Breakdown.Gear + MP.Breakdown.CM + MP.Breakdown.Food
end

-- ------------------------------------------------------------------------------------------------------
-- Returns the resting progress percentage.
-- ------------------------------------------------------------------------------------------------------
MP.Progress = function()
    if not Rest.Duration then Rest.Duration = 0 end
    if not Rest.Mod then Rest.Mod = 20 end
    return Rest.Duration / Rest.Mod
end

-- ------------------------------------------------------------------------------------------------------
-- Calculates additional HMP from gear.
-- ------------------------------------------------------------------------------------------------------
MP.Equipment.MP = function()
    local additional_hmp = 0
    for slot, _ in pairs(Ashita.Slots) do
        local item_id = Ashita.Equipment(slot)
        if HMP[item_id] then
            additional_hmp = additional_hmp + HMP[item_id]
        end
    end
    return additional_hmp
end

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
MP.Additional.Max_Level = function()
    local main_job = Ashita.Job()
    local main_job_level = Ashita.Job_Level()
    if main_job_level < 75 then return 0 end
    if main_job == "RDM" then return 1 end
    if main_job == "BLM" then return 2 end
    if main_job == "WHM" then return 3 end
    return 0
end