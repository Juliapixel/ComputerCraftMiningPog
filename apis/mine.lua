mine = {}
local compare = require("apis.comparer.compare")
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

local function goForward()
  local shouldStop = false
  turtle.dig()
  turtle.forward()
  digOres()
  if compare.stackInv() then
    if compare.pruneInv() then
      shouldStop = true
    end
  end
  return shouldStop
end

function mine.tunnelAhead(dist)
  dist = tonumber(dist)
  local full_dist = 2*dist
  if turtle.getFuelLevel() < 2 then
    print("no fuel! cancelling...")
    return false
  end
  if full_dist > turtle.getFuelLevel() then
    dist = turtle.getFuelLevel()/2
    print(string.format("not enough fuel, will only mine for %d blocks! proceed anyway? (y/n)", dist))
    write("> ")
    local input = string.lower(read())
    if input == "y" then
      print("proceeding!")
    else
      print("cancelled.")
      return false
    end
  end
  for i=1, dist, 1 do
    goForward()
    curDist = curDist + 1
  end
  turtle.turnLeft()
  turtle.turnLeft()
  for i=1, dist, 1 do
    turtle.forward()
    if turtle.inspect() then
      turtle.dig()
    end
  end
end

return mine