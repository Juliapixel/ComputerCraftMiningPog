args = {...}
local net = require("apis.network.net")
local mine = require("apis.mine")
local compare = require("apis.comparer.compare")
local fuel = require("apis.fuel")
arg[1] = tonumber(arg[1])
-- tells the turtle to mine according to received arguments and runs its networking functions in parallel
if turtle then
  if type(arg[1]) ~= "number" then
    error("not a number!")
    return false
  end
  local function wrapper()
    mine.tunnelAhead(args[1])
  end
  parallel.waitForAny(net.run, wrapper)
  rednet.close()
end
-- will simply work as a tool to monitor turtles
if pocket then
  net.run()
  rednet.close()
end
