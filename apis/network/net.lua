local netPocket = netPocket or require("apis.network.net_pocket")
local netDesktop = netDesktop or require("apis.network.net_desktop")
local netTurtle = netTurtle or require("apis.network.net_turtle")

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