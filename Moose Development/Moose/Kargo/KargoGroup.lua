--- **KARGOGROUP** - Generic group enhancement.
-- 
-- This class is **not** meant to be used itself by the end user. It contains common functionalities of derived classes for air, ground and sea.
--     
-- ===
--
-- ### Author: **funkyfranky**
-- 
-- ===
-- @module Kargo.KargoGroup
-- @image KARGO_KargoGroup.png


--- KARGOGROUP class.
-- @type KARGOGROUP
-- @field #string ClassName Name of the class.
-- @field #number verbose Verbosity level. 0=silent.
-- @field #string lid Class id string for output to DCS log file.
-- 
-- @field Core.Timer#TIMER statustimer Status timer.
-- 
-- @extends Kargo.KargoBase#KARGOBASE

--- *A small group of determined and like-minded people can change the course of history.* --- Mahatma Gandhi
--
-- ===
--
-- ![Banner Image](..\Presentations\OPS\OpsGroup\_Main.png)
--
-- # The KARGOGROUP Concept
-- 
-- 
-- @field #KARGOGROUP
KARGOGROUP = {
  ClassName          = "KARGOGROUP",
  verbose            =     0,
  lid                =   nil,
}


--- KargoGroup version.
-- @field #string version
KARGOGROUP.version="0.0.1"

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TODO list
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
-- TODO: A lot!

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Constructor
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Create a new KARGOGROUP class object.
-- @param #KARGOGROUP self
-- @param Wrapper.Group#GROUP CargoGroup The cargo GROUP object.
-- @return #KARGOGROUP self
function KARGOGROUP:New(CargoGroup)

  -- Inherit everything from FSM class.
  local self=BASE:Inherit(self, KARGOBASE:New(CargoGroup)) -- #KARGOGROUP
      
  -- Set some string id for output to DCS.log file.
  self.lid=string.format("KARGOGROUP %s | ", tostring(self.cargoname))

  local units=CargoGroup:GetUnits()
  
  local weight=0
  for _,_unit in pairs(units) do
    local unit=_unit --Wrapper.Unit#UNIT
    
    local desc=unit:GetDesc()
    
    weight=weight+desc.massEmpty or 90
  
  end

  self:SetWeight(weight)
  
  self:I(self.lid..string.format("Weight %.1f kg", self:GetWeight()))
  
  self.statustimer=TIMER:New(self.StatusUpdate, self):Start(nil, 30)

  return self  
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- User Functions
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Status Monitoring
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Create a new KARGOGROUP class object.
-- @param #KARGOGROUP self
-- @return #KARGOGROUP self
function KARGOGROUP:StatusUpdate()

  local fsmstate=self:GetState()
  
  local text=string.format("State=%s", fsmstate)
  
  self:I(self.lid..text)

  return self
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FSM Functions
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- On after "Wait" event.
-- @param #KARGOGROUP self
-- @param #string From From state.
-- @param #string Event Event.
-- @param #string To To state.
-- @param Core.Point#COORDINATE Coordinate
function KARGOGROUP:onafterWait(From, Event, To, Coordinate)



end


--- On after "Board" event.
-- @param #KARGOGROUP self
-- @param #string From From state.
-- @param #string Event Event.
-- @param #string To To state.
function KARGOGROUP:onafterBoard(From, Event, To, Carrier)



end
