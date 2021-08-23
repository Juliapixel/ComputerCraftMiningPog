args = {...}
local mine = require("apis.mine")
local compare = require("apis.comparer.compare")
local fuel = require("apis.fuel")
if type(arg[1]) ~= "number" then
  error("not a number!")
  return false
end
mine.tunnelAhead(arg[1])