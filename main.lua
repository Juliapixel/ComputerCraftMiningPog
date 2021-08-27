args = {...}
local net = require("apis.network.net")
local mine = require("apis.mine")
local compare = require("apis.comparer.compare")
local fuel = require("apis.fuel")
-- tells the turtle to mine according to received arguments and runs its networking functions in parallel
if turtle then
  local mine_dist = tonumber(args[1])
  if type(mine_dist) ~= "number" then
    error("depth not a number!")
    return false
  end
  local cycles = tonumber(args[2])
  if type(cycles) ~= "number" then
    error("cycles not a number!")
    return false
  end
  local function wrapper()
    mine.smartTunnel(mine_dist, cycles)
  end
  parallel.waitForAny(net.run, wrapper)
  rednet.close()
end
-- will simply work as a tool to monitor turtles
if pocket then
  net.run()
  rednet.close()
end
