local netPocket = require("apis.network.net_pocket")
local netDesktop = require("apis.network.net_desktop")
local netTurtle = require("apis.network.net_turtle")

net = {}

function net.run()
  if pocket then
    netPocket.run()
  elseif turtle then
    netTurtle.run()
  else
    netDesktop.run()
  end
end

return net