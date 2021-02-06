--- **Location** - Location.
--
-- **Main Features:**
--
--    TODO: * Not sure yet
--
-- ===
--
-- ## Example Missions:
-- 
-- Demo missions can be found on [github](https://github.com/FlightControl-Master/MOOSE_MISSIONS/tree/develop/Location%20-%20Location).
--    
-- ===
--
-- ### Author: **rollnthndr**
-- @module Location.Location
-- TODO:@image Location_Location.png


--- LOCATION class.
-- @type LOCATION

--- *Son, your ego is writing checks your body can't cash!.* -- Stinger
--
-- ===
--
-- TODO: ![Banner Image](..\Presentations\OPS\LOCATION\_Main.png)
--
-- # The LOCATION Concept
-- 
--  The LOCATION class contains locations and boundries of things like countries, states/provs, cities, bridges, ports, etc.
--  It will also keep track of locations coalition , damage state, etc.
--
-- 
-- @field #LOCATION
LOCATION = {
    ClassName       = "LOCATION"
    Type            = nil
  }
  
--- Location type.
-- @type LOCATION.Type
-- @field #string POPULATION Location is a city, town, village, etc.
-- @field #string STRATEGIC Location is a strategic target
-- @field #string PORT Location is a sea port
LOCATION.Type={
  COUNTRY="country",
  PROVINCE="province",
  POPULATION="population",
  STRATEGIC="strategic",
  PORT="port",
}

  --- Location version.
  -- @field #string version
  LOCATION.version="0.0.1"
  
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  -- TODO list
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  -- TODO: Determine location types
  
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  -- Constructor
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  --- Create a new LOCATION class object.
  -- @param #LOCATION self
  -- @return #LOCATION self
function LOCATION:New()
  -- Inherit everything from FSM class.
  local self=BASE:Inherit(self, FSM:New()) -- #LOCATION

  return self
end