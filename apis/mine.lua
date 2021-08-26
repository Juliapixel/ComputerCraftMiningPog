local netTurtle = require("apis.network.net_turtle")
local compare = require("apis.comparer.compare")
local fuel = require("apis.fuel")

mine = {}

local curDist = 1

local function oreAhead()
  local has_block, data = turtle.inspect()
  if has_block then
    if string.find(textutils.serialise(data), "forge:ores") then
      return true
    else
      return false
    end
  else
    return false
  end
end

local function oreUp()
  local has_block, data = turtle.inspectUp()
  if has_block then
    if string.find(textutils.serialise(data), "forge:ores") then
      return true
    else
      return false
    end
  else
    return false
  end
end

local function oreDown()
  local has_block, data = turtle.inspectDown()
  if has_block then
    if string.find(textutils.serialise(data), "forge:ores") then
      return true
    else
      return false
    end
  else
    return false
  end
end

local function digOres()
  local up, down, left, right
  up = oreUp()
  down = oreDown()
  if up then
    turtle.digUp()
  end
  if down then
    turtle.digDown()
  end
  turtle.turnLeft()
  left = oreAhead()
  if left then 
    turtle.dig()
  end
  turtle.turnRight()
  turtle.turnRight()
  right = oreAhead()
  if right then
    turtle.dig()
  end
  turtle.turnLeft()
end

--makes turtle go forward and mine for ores around itself every time it does so.
local function goForward()
  local block_ahead = turtle.inspect()
  repeat
    turtle.dig()
  until block_ahead == false
  repeat 
    local has_moved = turtle.forward()
  until has_moved == true
  digOres()
  local isFull = compare.pruneInv()
  if isFull then
    isFull = compare.stackInv()
  end
  return isFull
end

function mine.tunnelAhead(dist)
  dist = tonumber(dist)
  local full_dist = 2*dist
  fuel.refuel(full_dist)
  netTurtle.updateInfo("curTask", "mining")
  for i=1, dist, 1 do
    goForward()
    curDist = curDist + 1
  end
  netTurtle.updateInfo("curTask", "returning")
  turtle.turnLeft()
  turtle.turnLeft()
  for i=1, dist, 1 do
    turtle.forward()
    if turtle.inspect() then
      turtle.dig()
    end
  end
  netTurtle.updateInfo("curTask", "")
end

return mine