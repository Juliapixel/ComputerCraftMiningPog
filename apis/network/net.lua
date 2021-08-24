net = {}

function net.run()
  if pocket then
    local netPocket = require("apis.network.net_pocket")
    netPocket.run()
  elseif turtle then
    local netTurtle = require("apis.network.net_turtle")
    netTurtle.run()
  else
    local netDesktop = require("apis.network.net_desktop")
    netDesktop.run()
  end
end

return net