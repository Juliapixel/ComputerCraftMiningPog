local netTurtle = require("apis.network.net_turtle")
local compare = require("apis.comparer.compare")
local fuel = require("apis.fuel")

mine = {}


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
  repeat
    turtle.dig()
  until turtle.forward() == true
  digOres()
  local isFull = compare.pruneInv()
  if isFull then
    isFull = compare.stackInv()
  end
  return isFull
end

local function mineCycle(length, cycles)

  local full_dist = length * 2 * cycles + 6 * cycles + 1
  local traversed = 1
  local progress = traversed / full_dist

  local function downLevel(way)
    turtle.digDown()
    turtle.down()
    turtle.digDown()
    turtle.down()
    if way == "in" then
      turtle.turnLeft()
      repeat turtle.dig() until turtle.forward() == true
      traversed = traversed + 3
      netTurtle.updateInfo("progress", progress)
      turtle.turnLeft()
    elseif way == "out" then
      turtle.turnRight()
      repeat turtle.dig() until turtle.forward() == true
      traversed = traversed + 3
      netTurtle.updateInfo("progress", progress)
      turtle.turnRight()
    end
  end

  for i = 1, cycles do
    for j = 1, length do
      goForward()
      traversed = traversed + 1
      netTurtle.updateInfo("progress", progress)
    end
    downLevel("in")
    for j = 1, length do
      goForward()
      traversed = traversed + 1
      netTurtle.updateInfo("progress", progress)
    end
    if i ~= cycles then
      downLevel("out")
    end
  end
end

local function goBack(cycles)
  turtle.turnLeft()
  for i =  1, cycles * 2 - 1 do
    repeat turtle.dig() until turtle.forward() == true
    repeat turtle.digUp() until turtle.up() == true
    repeat turtle.digUp() until turtle.up() == true
  end
  turtle.turnRight()
end


function mine.tunnelAhead(dist)
  dist = tonumber(dist)
  local full_dist = 2*dist
  fuel.refuel(full_dist)
  netTurtle.updateInfo("curTask", "mining")
  for i=1, dist, 1 do
    goForward()
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

function mine.smartTunnel(dist, times)
  print("ready to receive start command!")
  netTurtle.updateInfo("curTask", "ready")
  local event, shouldStart = os.pullEvent("startMining")
  if shouldStart then
    netTurtle.updateInfo("curTask", "mining")
    repeat turtle.dig() until turtle.forward() == true
    mineCycle(dist, times)
    netTurtle.updateInfo("curTask", "returning")
    goBack(times)
  end
end

return mine