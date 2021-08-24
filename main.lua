args = {...}
local net = require("apis.network.net")
local mine = require("apis.mine")
local compare = require("apis.comparer.compare")
local fuel = require("apis.fuel")
arg[1] = tonumber(arg[1])
if turtle then
  if type(arg[1]) ~= "number" then
    error("not a number!")
    return false
  end
  parallel.waitForAny(mine.tunnelAhead(arg[1]), net.run())
end
