MP.Util = T{}

-- ------------------------------------------------------------------------------------------------------
-- Calculates the difference between max MP and current MP.
-- ------------------------------------------------------------------------------------------------------
MP.Util.Missing_MP = function()
    return Ashita.Max_MP() - Ashita.Current_MP()
end