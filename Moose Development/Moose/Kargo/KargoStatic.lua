--- **Ops** - Generic group enhancement.
-- 
-- This class is **not** meant to be used itself by the end user. It contains common functionalities of derived classes for air, ground and sea.
--     
-- ===
--
-- ### Author: **funkyfranky**
-- 
-- ===
-- @module Kargo.KargoBase
-- @image KARGO_KargoBase.png


--- KARGOBASE class.
-- @type KARGOBASE
-- @field #string ClassName Name of the class.
-- @field #number verbose Verbosity level. 0=silent.
-- @field #string lid Class id string for output to DCS log file.
-- 
-- @extends Core.Fsm#FSM

--- *A small group of determined and like-minded people can change the course of history.* --- Mahatma Gandhi
--
-- ===
--
-- ![Banner Image](..\Presentations\OPS\OpsGroup\_Main.png)
--
-- # The KARGOBASE Concept
-- 
-- The KARGOBASE class contains common functions used by other classes such as FLIGHGROUP, NAVYGROUP and ARMYGROUP.
-- Those classes inherit everything of this class and extend it with features specific to their unit category.  
-- 
-- This class is **NOT** meant to be used by the end user itself.
-- 
-- 
-- @field #KARGOBASE
KARGOBASE = {
  ClassName          = "KARGOBASE",
  verbose            =     0,
  lid                =   nil,
}


--- OPS group element.
-- @type KARGOBASE.Element
-- @field #string name Name of the element, i.e. the unit.
-- @field Wrapper.Unit#UNIT unit The UNIT object.
-- @field #string status The element status.
-- @field #string typename Type name.
-- @field #number length Length of element in meters.
-- @field #number width Width of element in meters.
-- @field #number height Height of element in meters.
-- @field #number life0 Initial life points.
-- @field #number life Life points when last updated.

--- Status of group element.
-- @type KARGOBASE.ElementStatus
-- @field #string INUTERO Element was not spawned yet or its status is unknown so far.
-- @field #string SPAWNED Element was spawned into the world.
-- @field #string PARKING Element is parking after spawned on ramp.
-- @field #string ENGINEON Element started its engines.
-- @field #string TAXIING Element is taxiing after engine startup.
-- @field #string TAKEOFF Element took of after takeoff event.
-- @field #string AIRBORNE Element is airborne. Either after takeoff or after air start.
-- @field #string LANDING Element is landing.
-- @field #string LANDED Element landed and is taxiing to its parking spot.
-- @field #string ARRIVED Element arrived at its parking spot and shut down its engines.
-- @field #string DEAD Element is dead after it crashed, pilot ejected or pilot dead events.
KARGOBASE.ElementStatus={
  INUTERO="inutero",
  SPAWNED="spawned",
  PARKING="parking",
  ENGINEON="engineon",
  TAXIING="taxiing",
  TAKEOFF="takeoff",
  AIRBORNE="airborne",
  LANDING="landing",
  LANDED="landed",
  ARRIVED="arrived",
  DEAD="dead",
}

--- Ops group task status.
-- @type KARGOBASE.TaskStatus
-- @field #string SCHEDULED Task is scheduled.
-- @field #string EXECUTING Task is being executed.
-- @field #string PAUSED Task is paused.
-- @field #string DONE Task is done.
KARGOBASE.TaskStatus={
  SCHEDULED="scheduled",
  EXECUTING="executing",
  PAUSED="paused",
  DONE="done",
}

--- Ops group task status.
-- @type KARGOBASE.TaskType
-- @field #string SCHEDULED Task is scheduled and will be executed at a given time.
-- @field #string WAYPOINT Task is executed at a specific waypoint.
KARGOBASE.TaskType={
  SCHEDULED="scheduled",
  WAYPOINT="waypoint",
}

--- NavyGroup version.
-- @field #string version
KARGOBASE.version="0.7.0"

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TODO list
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
-- TODO: A lot!

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Constructor
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Create a new KARGOBASE class object.
-- @param #KARGOBASE self
-- @return #KARGOBASE self
function KARGOBASE:New()

  -- Inherit everything from FSM class.
  local self=BASE:Inherit(self, FSM:New()) -- #KARGOBASE
      
  -- Set some string id for output to DCS.log file.
  --self.lid=string.format("KARGOBASE %s | ", tostring(self.groupname))
  
  
  -- Start state.
  self:SetStartState("InUtero")

  -- Add FSM transitions.
  --                 From State  -->   Event      -->     To State
  self:AddTransition("InUtero",       "Spawned",          "Idle")     -- The whole group was spawned.
  
  self:AddTransition("Idle",          "Wait",             "Waiting")  -- Waiting for transportation.
  
  self:AddTransition("Wait",          "Board",            "Boarding")     -- The whole group was spawned.
  self:AddTransition("Wait",          "Load",             "Loaded")       -- The cargo is directly loaded into the carrier (without boarding step).  
  self:AddTransition("Boarding",      "Load",             "Loaded")       -- The cargo is directly loaded into the carrier (without boarding step).
  
  self:AddTransition("Loaded",        "Unload",           "Idle")         -- The cargo is directly loaded into the carrier (without boarding step).

  ------------------------
  --- Pseudo Functions ---
  ------------------------

  --- Triggers the FSM event "Stop". Stops the KARGOBASE and all its event handlers.
  -- @param #KARGOBASE self

  --- Triggers the FSM event "Stop" after a delay. Stops the KARGOBASE and all its event handlers.
  -- @function [parent=#KARGOBASE] __Stop
  -- @param #KARGOBASE self
  -- @param #number delay Delay in seconds.

  --- Triggers the FSM event "Status".
  -- @function [parent=#KARGOBASE] Status
  -- @param #KARGOBASE self

  --- Triggers the FSM event "Status" after a delay.
  -- @function [parent=#KARGOBASE] __Status
  -- @param #KARGOBASE self
  -- @param #number delay Delay in seconds.

  -- TODO: Add pseudo functions.

  return self  
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- User Functions
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Status Monitoring
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FSM Functions
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


