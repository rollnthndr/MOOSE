--- **Populations** - Populations.
--
-- **Main Features:**
--
--    TODO: * Not sure yet
--
-- ===
--
-- ## Example Missions:
-- 
-- Demo missions can be found on [github](https://github.com/FlightControl-Master/MOOSE_MISSIONS/tree/develop/Populations%20-%20Populations).
--    
-- ===
--
-- ### Author: **rollnthndr**
-- @module Populations.Populations
-- TODO:@image Populations_Populations.png


--- POPULATIONS class.
-- @type POPULATIONS

--- TODO: *Son, your ego is writing checks your body can't cash!.* -- Stinger
--
-- ===
--
-- TODO: ![Banner Image](..\Presentations\OPS\POPULATIONS\_Main.png)
--
-- # The POPULATIONS Concept
-- 
--  TODO: Concept
-- 
-- @field #POPULATIONS
POPULATIONS = {
    ClassName       = "POPULATIONS"
  }
  
--- Population types.
-- @type POPULATION.Type
-- @field #string CITY Population is a city.
-- @field #string TOWN Population is a town.
-- @field #string VILLAGE Population is a village.
POPULATIONS.Type={
  CITY="city",
  TOWN="town",
  VILLAGE="village",
}

  --- Populations version.
  -- @field #string version
  POPULATIONS.version="0.0.1"
  
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  -- TODO list
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  -- TODO: Determine population types
  
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  -- Constructor
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  --- Create a new POPULATIONS class object.
  -- @param #POPULATIONS self
  -- @return #POPULATIONS self
function POPULATIONS:New()
  -- Inherit everything from FSM class.
  local self=BASE:Inherit(self, FSM:New()) -- #POPULATIONS

  return self
end