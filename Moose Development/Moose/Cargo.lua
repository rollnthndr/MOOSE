--- This module contains the CARGO classes.
--
-- ===
--
-- 1) @{Cargo#CARGO_BASE} class, extends @{Base#BASE}
-- ==================================================
-- The @{#CARGO_BASE} class defines the core functions that defines a cargo object within MOOSE.
-- A cargo is a logical object defined within a @{Mission}, that is available for transport, and has a life status within a simulation.
--
-- Cargo can be of various forms:
--
--   * CARGO_UNIT, represented by a @{Unit} in a @{Group}: Cargo can be represented by a Unit in a Group. Destruction of the Unit will mean that the cargo is lost.
--   * CARGO_STATIC, represented by a @{Static}: Cargo can be represented by a Static. Destruction of the Static will mean that the cargo is lost.
--   * CARGO_PACKAGE, contained in a @{Unit} of a @{Group}: Cargo can be contained within a Unit of a Group. The cargo can be **delivered** by the @{Unit}. If the Unit is destroyed, the cargo will be destroyed also.
--   * CARGO_PACKAGE, Contained in a @{Static}: Cargo can be contained within a Static. The cargo can be **collected** from the @Static. If the @{Static} is destroyed, the cargo will be destroyed.
--   * CARGO_SLINGLOAD, represented by a @{Cargo} that is transportable: Cargo can be represented by a Cargo object that is transportable. Destruction of the Cargo will mean that the cargo is lost.
--
-- @module Cargo



CARGOS = {}

do -- CARGO

  --- @type CARGO
  -- @extends Base#BASE
  -- @field #string Type A string defining the type of the cargo. eg. Engineers, Equipment, Screwdrivers.
  -- @field #string Name A string defining the name of the cargo. The name is the unique identifier of the cargo.
  -- @field #number Weight A number defining the weight of the cargo. The weight is expressed in kg.
  -- @field #number ReportRadius (optional) A number defining the radius in meters when the cargo is signalling or reporting to a Carrier.
  -- @field #number NearRadius (optional) A number defining the radius in meters when the cargo is near to a Carrier, so that it can be loaded.
  -- @field Controllable#CONTROLLABLE CargoObject The alive DCS object representing the cargo. This value can be nil, meaning, that the cargo is not represented anywhere...
  -- @field Positionable#POSITIONABLE CargoCarrier The alive DCS object carrying the cargo. This value can be nil, meaning, that the cargo is not contained anywhere...
  -- @field #boolean Slingloadable This flag defines if the cargo can be slingloaded.
  -- @field #boolean Moveable This flag defines if the cargo is moveable.
  -- @field #boolean Representable This flag defines if the cargo can be represented by a DCS Unit.
  -- @field #boolean Containable This flag defines if the cargo can be contained within a DCS Unit.
  CARGO = {
    ClassName = "CARGO",
    STATUS = {
      NONE = 0,
      LOADED = 1,
      UNLOADED = 2,
      LOADING = 3
    },
    Type = nil,
    Name = nil,
    Weight = nil,
    CargoObject = nil,
    CargoCarrier = nil,
    Representable = false,
    Slingloadable = false,
    Moveable = false,
    Containable = false,
  }

--- @type CARGO.CargoObjects
-- @map < #string, Positionable#POSITIONABLE > The alive POSITIONABLE objects representing the the cargo.


--- CARGO Constructor.
-- @param #CARGO self
-- @param Mission#MISSION Mission
-- @param #string Type
-- @param #string Name
-- @param #number Weight
-- @param #number ReportRadius (optional)
-- @param #number NearRadius (optional)
-- @return #CARGO
function CARGO:New( Mission, Type, Name, Weight, ReportRadius, NearRadius ) 
  local self = BASE:Inherit( self, BASE:New() ) -- #CARGO
  self:F( { Type, Name, Weight, ReportRadius, NearRadius } )


  self.Type = Type
  self.Name = Name
  self.Weight = Weight
  self.ReportRadius = ReportRadius
  self.NearRadius = NearRadius
  self.CargoObjects = nil
  self.CargoCarrier = nil
  self.Representable = false
  self.Slingloadable = false
  self.Moveable = false
  self.Containable = false

  self:StatusNone()
  
  CARGOS[self.CargoName] = self

  return self
end

--- Template method to spawn a new representation of the CARGO in the simulator.
-- @param #CARGO self
-- @return #CARGO
function CARGO:Spawn( PointVec2 )
  self:F()

  return self

end

function CARGO:Load( CargoObject, CargoCarrier )
  self:F()

  self:StatusLoaded( CargoCarrier )

  return self
end


function CARGO:UnLoad( CargoCarrier, CargoObject )
  self:F()

  self:StatusUnLoaded( CargoObject )

  return self
end

function CARGO:OnBoard( CargoCarrier )
  self:F()

end

function CARGO:OnBoarded( CargoCarrier )
  self:F()

  local OnBoarded = false

  return OnBoarded
end


function CARGO:IsNear( CargoCarrier, CargoObject, Radius )
  self:F()

  local Near = true

  return Near

end


function CARGO:IsLoading()
  self:F()

  if self:IsStatusLoading() then
    return self.Object
  end

  return nil

end


function CARGO:IsContained()
  self:F()

  if self:IsStatusContained() then
    return self.Object
  end

  return nil

end


function CARGO:IsLandingRequired()
  self:F()
  return true
end

function CARGO:IsSlingLoad()
  self:F()
  return false
end


function CARGO:StatusNone()
  self:F()

  self.CargoClient = nil
  self.CargoStatus = CARGO.STATUS.NONE

  return self
end

function CARGO:StatusLoading( Carrier )
  self:F()

  self.CargoClient = Carrier
  self.CargoStatus = CARGO.STATUS.LOADING
  self:T( "Cargo " .. self.CargoName .. " loading to Client: " .. self.CargoClient:GetClientGroupName() )

  return self
end

function CARGO:StatusLoaded( Client )
  self:F()

  self.CargoClient = Client
  self.CargoStatus = CARGO.STATUS.LOADED
  self:T( "Cargo " .. self.CargoName .. " loaded in Client: " .. self.CargoClient:GetClientGroupName() )

  return self
end

function CARGO:StatusUnLoaded()
  self:F()

  self.CargoClient = nil
  self.CargoStatus = CARGO.STATUS.UNLOADED

  return self
end


function CARGO:IsStatusNone()
  self:F()

  return self.CargoStatus == CARGO.STATUS.NONE
end

function CARGO:IsStatusLoading()
  self:F()

  return self.CargoStatus == CARGO.STATUS.LOADING
end

function CARGO:IsStatusLoaded()
  self:F()

  return self.CargoStatus == CARGO.STATUS.LOADED
end

function CARGO:IsStatusUnLoaded()
  self:F()

  return self.CargoStatus == CARGO.STATUS.UNLOADED
end

end

do -- CARGO_REPRESENTABLE

  --- @type CARGO_REPRESENTABLE
  -- @extends #CARGO
  CARGO_REPRESENTABLE = {
    ClassName = "CARGO_REPRESENTABLE"
  }

  --- CARGO_REPRESENTABLE Constructor.
  -- @param #CARGO_REPRESENTABLE self
  -- @param Mission#MISSION Mission
  -- @param Controllable#Controllable CargoObject
  -- @param #string Type
  -- @param #string Name
  -- @param #number Weight
  -- @param #number ReportRadius (optional)
  -- @param #number NearRadius (optional)
  -- @return #CARGO_REPRESENTABLE
  function CARGO_REPRESENTABLE:New( Mission, CargoObject, Type, Name, Weight, ReportRadius, NearRadius ) 
    local self = BASE:Inherit( self, CARGO:New( Mission, Type, Name, Weight, ReportRadius, NearRadius ) ) -- #CARGO
    self:F( { Type, Name, Weight, ReportRadius, NearRadius } )
  
    self.CargoObject = CargoObject
  
    return self
  end
  
  --- Onboard representable Cargo to a Carrier.
  -- @param #CARGO_REPRESENTABLE self
  -- @param Unit#UNIT Carrier
  function CARGO_REPRESENTABLE:Onboard( Carrier )
    self:F()
  
    local OnBoardScheduler = SCHEDULER:New( self, self.ExecuteOnboarding, 1, 1, 0, 30 )
  
    self.CargoInAir = self.CargoObject:InAir()
  
    self:T( self.CargoInAir )
  
    -- Only move the group to the carrier when the cargo is not in the air
    -- (eg. cargo can be on a oil derrick, moving the cargo on the oil derrick will drop the cargo on the sea).
    if not self.CargoInAir then
  
      local Points = {}
      
      local PointStartVec2 = self.CargoObject:GetPointVec2()
      local PointEndVec2 = Carrier:GetPointVec2()
      
  
      Points[#Points+1] = PointStartVec2:RoutePointGround( "Cone", 10 )
      Points[#Points+1] = PointEndVec2:RoutePointGround( "Cone", 10 )
  
      local TaskRoute = self.CargoObject:TaskRoute( Points )
      self.CargoObject:SetTask( TaskRoute, 4 )
    end
  
    self:StatusLoading( Carrier )
  end
  
  --- Can the Cargo Onboard to the Carrier?
  -- @param #CARGO_REPRESENTABLE self
  -- @return #boolean true if Cargo is near enough to be Onboarded.
  function CARGO_REPRESENTABLE:CanOnboard( Carrier )
    return self:IsNear( Carrier )
  end

  --- Execute the Cargo Onboarding to the Carrier.
  -- @param #CARGO_REPRESENTABLE self
  function CARGO_REPRESENTABLE:ExecuteOnboarding( Carrier )
    if self:CanOnboard( Carrier ) then
      self.CargoCarrier = Carrier
      self.CargoObject:Destroy()
      return false
    end
    return true
  end

end

do -- CARGO_UNIT

  --- @type CARGO_UNIT
  -- @extends #CARGO_REPRESENTABLE
  CARGO_UNIT = {
    ClassName = "CARGO_UNIT"
  }

  --- CARGO_UNIT Constructor.
  -- @param #CARGO_UNIT self
  -- @param Mission#MISSION Mission
  -- @param Unit#UNIT CargoUnit
  -- @param #string Type
  -- @param #string Name
  -- @param #number Weight
  -- @param #number ReportRadius (optional)
  -- @param #number NearRadius (optional)
  -- @return #CARGO_UNIT
  function CARGO_UNIT:New( Mission, CargoUnit, Type, Name, Weight, ReportRadius, NearRadius ) 
    local self = BASE:Inherit( self, CARGO_REPRESENTABLE:New( Mission, CargoUnit, Type, Name, Weight, ReportRadius, NearRadius ) ) -- #CARGO
    self:F( { Type, Name, Weight, ReportRadius, NearRadius } )
  
    return self
  end

end

do -- CARGO_GROUP

  --- @type CARGO_GROUP
  CARGO_GROUP = {
    ClassName = "CARGO_GROUP"
  }

--- CARGO_GROUP Constructor.
-- @param #CARGO_GROUP self
-- @param Mission#MISSION Mission
-- @param Group#GROUP CargoGroup
-- @param #string Type
-- @param #string Name
-- @param #number Weight
-- @param #number ReportRadius (optional)
-- @param #number NearRadius (optional)
-- @return #CARGO_GROUP
function CARGO_GROUP:New( Mission, CargoGroup, Type, Name, Weight, ReportRadius, NearRadius ) 
  local self = BASE:Inherit( self, CARGO:New( Mission, CargoGroup, Type, Name, Weight, ReportRadius, NearRadius ) ) -- #CARGO
  self:F( { Type, Name, Weight, ReportRadius, NearRadius } )

  self.CargoSpawn = SPAWN:NewWithAlias( CargoGroupTemplate, CargoName )
  self.CargoZone = CargoZone

  CARGOS[self.CargoName] = self

  return self

end

function CARGO_GROUP:Spawn( Client )
  self:F( { Client } )

  local SpawnCargo = true

  if self:IsStatusNone() then
    local CargoGroup = Group.getByName( self.CargoName )
    if CargoGroup and CargoGroup:isExist() then
      SpawnCargo = false
    end

  elseif self:IsStatusLoading() then

    local Client = self:IsLoadingToClient()
    if Client and Client:GetDCSGroup() then
      SpawnCargo = false
    else
      local CargoGroup = Group.getByName( self.CargoName	 )
      if CargoGroup and CargoGroup:isExist() then
        SpawnCargo = false
      end
    end

  elseif self:IsStatusLoaded()  then

    local ClientLoaded = self:IsLoadedInClient()
    -- Now test if another Client is alive (not this one), and it has the CARGO, then this cargo does not need to be initialized and spawned.
    if ClientLoaded and ClientLoaded ~= Client then
      local ClientGroup = Client:GetDCSGroup()
      if ClientLoaded:GetClientGroupDCSUnit() and ClientLoaded:GetClientGroupDCSUnit():isExist() then
        SpawnCargo = false
      else
        self:StatusNone()
      end
    else
      -- Same Client, but now in initialize, so set back the status to None.
      self:StatusNone()
    end

  elseif self:IsStatusUnLoaded() then

    SpawnCargo = false

  end

  if SpawnCargo then
    if self.CargoZone:GetCargoHostUnit() then
      --- ReSpawn the Cargo from the CargoHost
      self.CargoGroupName = self.CargoSpawn:SpawnFromUnit( self.CargoZone:GetCargoHostUnit(), 60, 30, 1 ):GetName()
    else
      --- ReSpawn the Cargo in the CargoZone without a host ...
      self:T( self.CargoZone )
      self.CargoGroupName = self.CargoSpawn:SpawnInZone( self.CargoZone, true, 1 ):GetName()
    end
    self:StatusNone()
  end

  self:T( { self.CargoGroupName, CARGOS[self.CargoName].CargoGroupName } )

  return self
end

function CARGO_GROUP:IsNear( Client, LandingZone )
  self:F()

  local Near = false

  if self.CargoGroupName then
    local CargoGroup = Group.getByName( self.CargoGroupName )
    if routines.IsPartOfGroupInRadius( CargoGroup, Client:GetPositionVec3(), 250 ) then
      Near = true
    end
  end

  return Near

end


function CARGO_GROUP:OnBoard( Client, LandingZone, OnBoardSide )
  self:F()

  local Valid = true

  local ClientUnit = Client:GetClientGroupDCSUnit()

  local CarrierPos = ClientUnit:getPoint()
  local CarrierPosMove = ClientUnit:getPoint()
  local CarrierPosOnBoard = ClientUnit:getPoint()

  local CargoGroup = Group.getByName( self.CargoGroupName )

  local CargoUnit = CargoGroup:getUnit(1)
  local CargoPos = CargoUnit:getPoint()

  self.CargoInAir = CargoUnit:inAir()

  self:T( self.CargoInAir )

  -- Only move the group to the carrier when the cargo is not in the air
  -- (eg. cargo can be on a oil derrick, moving the cargo on the oil derrick will drop the cargo on the sea).
  if not self.CargoInAir then

    local Points = {}

    self:T( 'CargoPos x = ' .. CargoPos.x .. " z = " .. CargoPos.z )
    self:T( 'CarrierPosMove x = ' .. CarrierPosMove.x .. " z = " .. CarrierPosMove.z )

    Points[#Points+1] = routines.ground.buildWP( CargoPos, "Cone", 10 )

    self:T( 'Points[1] x = ' .. Points[1].x .. " y = " .. Points[1].y )

    if OnBoardSide == nil then
      OnBoardSide = CLIENT.ONBOARDSIDE.NONE
    end

    if OnBoardSide == CLIENT.ONBOARDSIDE.LEFT then

      self:T( "TransportCargoOnBoard: Onboarding LEFT" )
      CarrierPosMove.z = CarrierPosMove.z - 25
      CarrierPosOnBoard.z = CarrierPosOnBoard.z - 5
      Points[#Points+1] = routines.ground.buildWP( CarrierPosMove, "Cone", 10 )
      Points[#Points+1] = routines.ground.buildWP( CarrierPosOnBoard, "Cone", 10 )

    elseif  OnBoardSide == CLIENT.ONBOARDSIDE.RIGHT then

      self:T( "TransportCargoOnBoard: Onboarding RIGHT" )
      CarrierPosMove.z = CarrierPosMove.z + 25
      CarrierPosOnBoard.z = CarrierPosOnBoard.z + 5
      Points[#Points+1] = routines.ground.buildWP( CarrierPosMove, "Cone", 10 )
      Points[#Points+1] = routines.ground.buildWP( CarrierPosOnBoard, "Cone", 10 )

    elseif  OnBoardSide == CLIENT.ONBOARDSIDE.BACK then

      self:T( "TransportCargoOnBoard: Onboarding BACK" )
      CarrierPosMove.x = CarrierPosMove.x - 25
      CarrierPosOnBoard.x = CarrierPosOnBoard.x - 5
      Points[#Points+1] = routines.ground.buildWP( CarrierPosMove, "Cone", 10 )
      Points[#Points+1] = routines.ground.buildWP( CarrierPosOnBoard, "Cone", 10 )

    elseif  OnBoardSide == CLIENT.ONBOARDSIDE.FRONT then

      self:T( "TransportCargoOnBoard: Onboarding FRONT" )
      CarrierPosMove.x = CarrierPosMove.x + 25
      CarrierPosOnBoard.x = CarrierPosOnBoard.x + 5
      Points[#Points+1] = routines.ground.buildWP( CarrierPosMove, "Cone", 10 )
      Points[#Points+1] = routines.ground.buildWP( CarrierPosOnBoard, "Cone", 10 )

    elseif  OnBoardSide == CLIENT.ONBOARDSIDE.NONE then

      self:T( "TransportCargoOnBoard: Onboarding CENTRAL" )
      Points[#Points+1] = routines.ground.buildWP( CarrierPos, "Cone", 10 )

    end
    self:T( "TransportCargoOnBoard: Routing " .. self.CargoGroupName )

    --routines.scheduleFunction( routines.goRoute, { self.CargoGroupName, Points}, timer.getTime() + 4 )
    SCHEDULER:New( self, routines.goRoute, { self.CargoGroupName, Points}, 4 )
  end

  self:StatusLoading( Client )

  return Valid

end


function CARGO_GROUP:OnBoarded( Client, LandingZone )
  self:F()

  local OnBoarded = false

  local CargoGroup = Group.getByName( self.CargoGroupName )

  if not self.CargoInAir then
    if routines.IsPartOfGroupInRadius( CargoGroup, Client:GetPositionVec3(), 25 ) then
      CargoGroup:destroy()
      self:StatusLoaded( Client )
      OnBoarded = true
    end
  else
    CargoGroup:destroy()
    self:StatusLoaded( Client )
    OnBoarded = true
  end

  return OnBoarded
end


function CARGO_GROUP:UnLoad( Client, TargetZoneName )
  self:F()

  self:T( 'self.CargoName = ' .. self.CargoName )

  local CargoGroup = self.CargoSpawn:SpawnFromUnit( Client:GetClientGroupUnit(), 60, 30 )

  self.CargoGroupName = CargoGroup:GetName()
  self:T( 'self.CargoGroupName = ' .. self.CargoGroupName )

  CargoGroup:TaskRouteToZone( ZONE:New( TargetZoneName ), true )

  self:StatusUnLoaded()

  return self
end

end

CARGO_PACKAGE = {
  ClassName = "CARGO_PACKAGE"
}


function CARGO_PACKAGE:New( CargoType, CargoName, CargoWeight, CargoClient ) local self = BASE:Inherit( self, CARGO:New( CargoType, CargoName, CargoWeight ) )
  self:F( { CargoType, CargoName, CargoWeight, CargoClient } )

  self.CargoClient = CargoClient

  CARGOS[self.CargoName] = self

  return self

end


function CARGO_PACKAGE:Spawn( Client )
  self:F( { self, Client } )

  -- this needs to be checked thoroughly

  local CargoClientGroup = self.CargoClient:GetDCSGroup()
  if not CargoClientGroup then
    if not self.CargoClientSpawn then
      self.CargoClientSpawn = SPAWN:New( self.CargoClient:GetClientGroupName() ):Limit( 1, 1 )
    end
    self.CargoClientSpawn:ReSpawn( 1 )
  end

  local SpawnCargo = true

  if self:IsStatusNone() then

  elseif self:IsStatusLoading() or self:IsStatusLoaded() then

    local CargoClientLoaded = self:IsLoadedInClient()
    if CargoClientLoaded and CargoClientLoaded:GetDCSGroup() then
      SpawnCargo = false
    end

  elseif self:IsStatusUnLoaded() then

    SpawnCargo = false

  else

  end

  if SpawnCargo then
    self:StatusLoaded( self.CargoClient )
  end

  return self
end


function CARGO_PACKAGE:IsNear( Client, LandingZone )
  self:F()

  local Near = false

  if self.CargoClient and self.CargoClient:GetDCSGroup() then
    self:T( self.CargoClient.ClientName )
    self:T( 'Client Exists.' )

    if routines.IsUnitInRadius( self.CargoClient:GetClientGroupDCSUnit(), Client:GetPositionVec3(), 150 ) then
      Near = true
    end
  end

  return Near

end


function CARGO_PACKAGE:OnBoard( Client, LandingZone, OnBoardSide )
  self:F()

  local Valid = true

  local ClientUnit = Client:GetClientGroupDCSUnit()

  local CarrierPos = ClientUnit:getPoint()
  local CarrierPosMove = ClientUnit:getPoint()
  local CarrierPosOnBoard = ClientUnit:getPoint()
  local CarrierPosMoveAway = ClientUnit:getPoint()

  local CargoHostGroup = self.CargoClient:GetDCSGroup()
  local CargoHostName = self.CargoClient:GetDCSGroup():getName()

  local CargoHostUnits = CargoHostGroup:getUnits()
  local CargoPos = CargoHostUnits[1]:getPoint()

  local Points = {}

  self:T( 'CargoPos x = ' .. CargoPos.x .. " z = " .. CargoPos.z )
  self:T( 'CarrierPosMove x = ' .. CarrierPosMove.x .. " z = " .. CarrierPosMove.z )

  Points[#Points+1] = routines.ground.buildWP( CargoPos, "Cone", 10 )

  self:T( 'Points[1] x = ' .. Points[1].x .. " y = " .. Points[1].y )

  if OnBoardSide == nil then
    OnBoardSide = CLIENT.ONBOARDSIDE.NONE
  end

  if OnBoardSide == CLIENT.ONBOARDSIDE.LEFT then

    self:T( "TransportCargoOnBoard: Onboarding LEFT" )
    CarrierPosMove.z = CarrierPosMove.z - 25
    CarrierPosOnBoard.z = CarrierPosOnBoard.z - 5
    CarrierPosMoveAway.z = CarrierPosMoveAway.z - 20
    Points[#Points+1] = routines.ground.buildWP( CarrierPosMove, "Cone", 10 )
    Points[#Points+1] = routines.ground.buildWP( CarrierPosOnBoard, "Cone", 10 )
    Points[#Points+1] = routines.ground.buildWP( CarrierPosMoveAway, "Cone", 10 )

  elseif  OnBoardSide == CLIENT.ONBOARDSIDE.RIGHT then

    self:T( "TransportCargoOnBoard: Onboarding RIGHT" )
    CarrierPosMove.z = CarrierPosMove.z + 25
    CarrierPosOnBoard.z = CarrierPosOnBoard.z + 5
    CarrierPosMoveAway.z = CarrierPosMoveAway.z + 20
    Points[#Points+1] = routines.ground.buildWP( CarrierPosMove, "Cone", 10 )
    Points[#Points+1] = routines.ground.buildWP( CarrierPosOnBoard, "Cone", 10 )
    Points[#Points+1] = routines.ground.buildWP( CarrierPosMoveAway, "Cone", 10 )

  elseif  OnBoardSide == CLIENT.ONBOARDSIDE.BACK then

    self:T( "TransportCargoOnBoard: Onboarding BACK" )
    CarrierPosMove.x = CarrierPosMove.x - 25
    CarrierPosOnBoard.x = CarrierPosOnBoard.x - 5
    CarrierPosMoveAway.x = CarrierPosMoveAway.x - 20
    Points[#Points+1] = routines.ground.buildWP( CarrierPosMove, "Cone", 10 )
    Points[#Points+1] = routines.ground.buildWP( CarrierPosOnBoard, "Cone", 10 )
    Points[#Points+1] = routines.ground.buildWP( CarrierPosMoveAway, "Cone", 10 )

  elseif  OnBoardSide == CLIENT.ONBOARDSIDE.FRONT then

    self:T( "TransportCargoOnBoard: Onboarding FRONT" )
    CarrierPosMove.x = CarrierPosMove.x + 25
    CarrierPosOnBoard.x = CarrierPosOnBoard.x + 5
    CarrierPosMoveAway.x = CarrierPosMoveAway.x + 20
    Points[#Points+1] = routines.ground.buildWP( CarrierPosMove, "Cone", 10 )
    Points[#Points+1] = routines.ground.buildWP( CarrierPosOnBoard, "Cone", 10 )
    Points[#Points+1] = routines.ground.buildWP( CarrierPosMoveAway, "Cone", 10 )

  elseif  OnBoardSide == CLIENT.ONBOARDSIDE.NONE then

    self:T( "TransportCargoOnBoard: Onboarding FRONT" )
    CarrierPosMove.x = CarrierPosMove.x + 25
    CarrierPosOnBoard.x = CarrierPosOnBoard.x + 5
    CarrierPosMoveAway.x = CarrierPosMoveAway.x + 20
    Points[#Points+1] = routines.ground.buildWP( CarrierPosMove, "Cone", 10 )
    Points[#Points+1] = routines.ground.buildWP( CarrierPosOnBoard, "Cone", 10 )
    Points[#Points+1] = routines.ground.buildWP( CarrierPosMoveAway, "Cone", 10 )

  end
  self:T( "Routing " .. CargoHostName )

  SCHEDULER:New( self, routines.goRoute, { CargoHostName, Points }, 4 )

  return Valid

end


function CARGO_PACKAGE:OnBoarded( Client, LandingZone )
  self:F()

  local OnBoarded = false

  if self.CargoClient and self.CargoClient:GetDCSGroup() then
    if routines.IsUnitInRadius( self.CargoClient:GetClientGroupDCSUnit(), self.CargoClient:GetPositionVec3(), 10 ) then

      -- Switch Cargo from self.CargoClient to Client ... Each cargo can have only one client. So assigning the new client for the cargo is enough.
      self:StatusLoaded( Client )

      -- All done, onboarded the Cargo to the new Client.
      OnBoarded = true
    end
  end

  return OnBoarded
end


function CARGO_PACKAGE:UnLoad( Client, TargetZoneName )
  self:F()

  self:T( 'self.CargoName = ' .. self.CargoName )
  --self:T( 'self.CargoHostName = ' .. self.CargoHostName )

  --self.CargoSpawn:FromCarrier( Client:GetDCSGroup(), TargetZoneName, self.CargoHostName )
  self:StatusUnLoaded()

  return Cargo
end


CARGO_SLINGLOAD = {
  ClassName = "CARGO_SLINGLOAD"
}


function CARGO_SLINGLOAD:New( CargoType, CargoName, CargoWeight, CargoZone, CargoHostName, CargoCountryID )
  local self = BASE:Inherit( self, CARGO:New( CargoType, CargoName, CargoWeight ) )
  self:F( { CargoType, CargoName, CargoWeight, CargoZone, CargoHostName, CargoCountryID } )

  self.CargoHostName = CargoHostName

  -- Cargo will be initialized around the CargoZone position.
  self.CargoZone = CargoZone

  self.CargoCount = 0
  self.CargoStaticName = string.format( "%s#%03d", self.CargoName, self.CargoCount )

  -- The country ID needs to be correctly set.
  self.CargoCountryID = CargoCountryID

  CARGOS[self.CargoName] = self

  return self

end


function CARGO_SLINGLOAD:IsLandingRequired()
  self:F()
  return false
end


function CARGO_SLINGLOAD:IsSlingLoad()
  self:F()
  return true
end


function CARGO_SLINGLOAD:Spawn( Client )
  self:F( { self, Client } )

  local Zone = trigger.misc.getZone( self.CargoZone )

  local ZonePos = {}
  ZonePos.x = Zone.point.x + math.random( Zone.radius / 2 * -1, Zone.radius / 2 )
  ZonePos.y = Zone.point.z + math.random( Zone.radius / 2 * -1, Zone.radius / 2 )

  self:T( "Cargo Location = " .. ZonePos.x .. ", " .. ZonePos.y )

  --[[




	-- This does not work in 1.5.2.




	CargoStatic = StaticObject.getByName( self.CargoName )




	if CargoStatic then




		CargoStatic:destroy()




	end




	--]]

  CargoStatic = StaticObject.getByName( self.CargoStaticName )

  if CargoStatic and CargoStatic:isExist() then
    CargoStatic:destroy()
  end

  -- I need to make every time a new cargo due to bugs in 1.5.2.

  self.CargoCount = self.CargoCount + 1
  self.CargoStaticName = string.format( "%s#%03d", self.CargoName, self.CargoCount )

  local CargoTemplate = {
    ["category"] = "Cargo",
    ["shape_name"] = "ab-212_cargo",
    ["type"] = "Cargo1",
    ["x"] = ZonePos.x,
    ["y"] = ZonePos.y,
    ["mass"] = self.CargoWeight,
    ["name"] =  self.CargoStaticName,
    ["canCargo"] = true,
    ["heading"] = 0,
  }

  coalition.addStaticObject( self.CargoCountryID, CargoTemplate )

  --	end

  return self
end


function CARGO_SLINGLOAD:IsNear( Client, LandingZone )
  self:F()

  local Near = false

  return Near
end


function CARGO_SLINGLOAD:IsInLandingZone( Client, LandingZone )
  self:F()

  local Near = false

  local CargoStaticUnit = StaticObject.getByName( self.CargoName )
  if CargoStaticUnit then
    if routines.IsStaticInZones( CargoStaticUnit, LandingZone ) then
      Near = true
    end
  end

  return Near
end


function CARGO_SLINGLOAD:OnBoard( Client, LandingZone, OnBoardSide )
  self:F()

  local Valid = true


  return Valid
end


function CARGO_SLINGLOAD:OnBoarded( Client, LandingZone )
  self:F()

  local OnBoarded = false

  local CargoStaticUnit = StaticObject.getByName( self.CargoName )
  if CargoStaticUnit then
    if not routines.IsStaticInZones( CargoStaticUnit, LandingZone ) then
      OnBoarded = true
    end
  end

  return OnBoarded
end


function CARGO_SLINGLOAD:UnLoad( Client, TargetZoneName )
  self:F()

  self:T( 'self.CargoName = ' .. self.CargoName )
  self:T( 'self.CargoGroupName = ' .. self.CargoGroupName )

  self:StatusUnLoaded()

  return Cargo
end

CARGO_ZONE = {
  ClassName="CARGO_ZONE",
  CargoZoneName = '',
  CargoHostUnitName = '',
  SIGNAL = {
    TYPE = {
      SMOKE = { ID = 1, TEXT = "smoke" },
      FLARE = { ID = 2, TEXT = "flare" }
    },
    COLOR = {
      GREEN = { ID = 1, TRIGGERCOLOR = trigger.smokeColor.Green, TEXT = "A green" },
      RED = { ID = 2, TRIGGERCOLOR = trigger.smokeColor.Red, TEXT = "A red" },
      WHITE = { ID = 3, TRIGGERCOLOR = trigger.smokeColor.White, TEXT = "A white" },
      ORANGE = { ID = 4, TRIGGERCOLOR = trigger.smokeColor.Orange, TEXT = "An orange" },
      BLUE = { ID = 5, TRIGGERCOLOR = trigger.smokeColor.Blue, TEXT = "A blue" },
      YELLOW = { ID = 6, TRIGGERCOLOR = trigger.flareColor.Yellow, TEXT = "A yellow" }
    }
  }
}

--- Creates a new zone where cargo can be collected or deployed.
-- The zone functionality is useful to smoke or indicate routes for cargo pickups or deployments.
-- Provide the zone name as declared in the mission file into the CargoZoneName in the :New method.
-- An optional parameter is the CargoHostName, which is a Group declared with Late Activation switched on in the mission file.
-- The CargoHostName is the "host" of the cargo zone:
--
-- * It will smoke the zone position when a client is approaching the zone.
-- * Depending on the cargo type, it will assist in the delivery of the cargo by driving to and from the client.
--
-- @param #CARGO_ZONE self
-- @param #string CargoZoneName The name of the zone as declared within the mission editor.
-- @param #string CargoHostName The name of the Group "hosting" the zone. The Group MUST NOT be a static, and must be a "mobile" unit.
function CARGO_ZONE:New( CargoZoneName, CargoHostName ) local self = BASE:Inherit( self, ZONE:New( CargoZoneName ) )
  self:F( { CargoZoneName, CargoHostName } )

  self.CargoZoneName = CargoZoneName
  self.SignalHeight = 2
  --self.CargoZone = trigger.misc.getZone( CargoZoneName )


  if CargoHostName then
    self.CargoHostName = CargoHostName
  end

  self:T( self.CargoZoneName )

  return self
end

function CARGO_ZONE:Spawn()
  self:F( self.CargoHostName )

  if self.CargoHostName then -- Only spawn a host in the zone when there is one given as a parameter in the New function.
    if self.CargoHostSpawn then
      local CargoHostGroup = self.CargoHostSpawn:GetGroupFromIndex()
      if CargoHostGroup and CargoHostGroup:IsAlive() then
      else
        self.CargoHostSpawn:ReSpawn( 1 )
      end
  else
    self:T( "Initialize CargoHostSpawn" )
    self.CargoHostSpawn = SPAWN:New( self.CargoHostName ):Limit( 1, 1 )
    self.CargoHostSpawn:ReSpawn( 1 )
  end
  end

  return self
end

function CARGO_ZONE:GetHostUnit()
  self:F( self )

  if self.CargoHostName then

    -- A Host has been given, signal the host
    local CargoHostGroup = self.CargoHostSpawn:GetGroupFromIndex()
    local CargoHostUnit
    if CargoHostGroup and CargoHostGroup:IsAlive() then
      CargoHostUnit = CargoHostGroup:GetUnit(1)
    else
      CargoHostUnit = StaticObject.getByName( self.CargoHostName )
    end

    return CargoHostUnit
  end

  return nil
end

function CARGO_ZONE:ReportCargosToClient( Client, CargoType )
  self:F()

  local SignalUnit = self:GetHostUnit()

  if SignalUnit then

    local SignalUnitTypeName = SignalUnit:getTypeName()

    local HostMessage = ""

    local IsCargo = false
    for CargoID, Cargo in pairs( CARGOS ) do
      if Cargo.CargoType == Task.CargoType then
        if Cargo:IsStatusNone() then
          HostMessage = HostMessage .. " - " .. Cargo.CargoName .. " - " .. Cargo.CargoType .. " (" .. Cargo.Weight .. "kg)" .. "\n"
          IsCargo = true
        end
      end
    end

    if not IsCargo then
      HostMessage = "No Cargo Available."
    end

    Client:Message( HostMessage, 20, SignalUnitTypeName .. ": Reporting Cargo", 10 )
  end
end


function CARGO_ZONE:Signal()
  self:F()

  local Signalled = false

  if self.SignalType then

    if self.CargoHostName then

      -- A Host has been given, signal the host

      local SignalUnit = self:GetHostUnit()

      if SignalUnit then

        self:T( 'Signalling Unit' )
        local SignalVehiclePos = SignalUnit:GetPointVec3()
        SignalVehiclePos.y = SignalVehiclePos.y + 2

        if self.SignalType.ID == CARGO_ZONE.SIGNAL.TYPE.SMOKE.ID then

          trigger.action.smoke( SignalVehiclePos, self.SignalColor.TRIGGERCOLOR )
          Signalled = true

        elseif self.SignalType.ID == CARGO_ZONE.SIGNAL.TYPE.FLARE.ID then

          trigger.action.signalFlare( SignalVehiclePos, self.SignalColor.TRIGGERCOLOR , 0 )
          Signalled = false

        end
      end

    else

      local ZonePointVec3 = self:GetPointVec3( self.SignalHeight ) -- Get the zone position + the landheight + 2 meters

      if self.SignalType.ID == CARGO_ZONE.SIGNAL.TYPE.SMOKE.ID then

        trigger.action.smoke( ZonePointVec3, self.SignalColor.TRIGGERCOLOR  )
        Signalled = true

      elseif self.SignalType.ID == CARGO_ZONE.SIGNAL.TYPE.FLARE.ID then
        trigger.action.signalFlare( ZonePointVec3, self.SignalColor.TRIGGERCOLOR, 0 )
        Signalled = false

      end
    end
  end

  return Signalled

end

function CARGO_ZONE:WhiteSmoke( SignalHeight )
  self:F()

  self.SignalType = CARGO_ZONE.SIGNAL.TYPE.SMOKE
  self.SignalColor = CARGO_ZONE.SIGNAL.COLOR.WHITE

  if SignalHeight then
    self.SignalHeight = SignalHeight
  end

  return self
end

function CARGO_ZONE:BlueSmoke( SignalHeight )
  self:F()

  self.SignalType = CARGO_ZONE.SIGNAL.TYPE.SMOKE
  self.SignalColor = CARGO_ZONE.SIGNAL.COLOR.BLUE

  if SignalHeight then
    self.SignalHeight = SignalHeight
  end

  return self
end

function CARGO_ZONE:RedSmoke( SignalHeight )
  self:F()

  self.SignalType = CARGO_ZONE.SIGNAL.TYPE.SMOKE
  self.SignalColor = CARGO_ZONE.SIGNAL.COLOR.RED

  if SignalHeight then
    self.SignalHeight = SignalHeight
  end

  return self
end

function CARGO_ZONE:OrangeSmoke( SignalHeight )
  self:F()

  self.SignalType = CARGO_ZONE.SIGNAL.TYPE.SMOKE
  self.SignalColor = CARGO_ZONE.SIGNAL.COLOR.ORANGE

  if SignalHeight then
    self.SignalHeight = SignalHeight
  end

  return self
end

function CARGO_ZONE:GreenSmoke( SignalHeight )
  self:F()

  self.SignalType = CARGO_ZONE.SIGNAL.TYPE.SMOKE
  self.SignalColor = CARGO_ZONE.SIGNAL.COLOR.GREEN

  if SignalHeight then
    self.SignalHeight = SignalHeight
  end

  return self
end


function CARGO_ZONE:WhiteFlare( SignalHeight )
  self:F()

  self.SignalType = CARGO_ZONE.SIGNAL.TYPE.FLARE
  self.SignalColor = CARGO_ZONE.SIGNAL.COLOR.WHITE

  if SignalHeight then
    self.SignalHeight = SignalHeight
  end

  return self
end

function CARGO_ZONE:RedFlare( SignalHeight )
  self:F()

  self.SignalType = CARGO_ZONE.SIGNAL.TYPE.FLARE
  self.SignalColor = CARGO_ZONE.SIGNAL.COLOR.RED

  if SignalHeight then
    self.SignalHeight = SignalHeight
  end

  return self
end

function CARGO_ZONE:GreenFlare( SignalHeight )
  self:F()

  self.SignalType = CARGO_ZONE.SIGNAL.TYPE.FLARE
  self.SignalColor = CARGO_ZONE.SIGNAL.COLOR.GREEN

  if SignalHeight then
    self.SignalHeight = SignalHeight
  end

  return self
end

function CARGO_ZONE:YellowFlare( SignalHeight )
  self:F()

  self.SignalType = CARGO_ZONE.SIGNAL.TYPE.FLARE
  self.SignalColor = CARGO_ZONE.SIGNAL.COLOR.YELLOW

  if SignalHeight then
    self.SignalHeight = SignalHeight
  end

  return self
end


function CARGO_ZONE:GetCargoHostUnit()
  self:F( self )

  if self.CargoHostSpawn then
    local CargoHostGroup = self.CargoHostSpawn:GetGroupFromIndex(1)
    if CargoHostGroup and CargoHostGroup:IsAlive() then
      local CargoHostUnit = CargoHostGroup:GetUnit(1)
      if CargoHostUnit and CargoHostUnit:IsAlive() then
        return CargoHostUnit
      end
    end
  end

  return nil
end

function CARGO_ZONE:GetCargoZoneName()
  self:F()

  return self.CargoZoneName
end





