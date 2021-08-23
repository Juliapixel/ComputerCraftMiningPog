fuel = {}
local mode = ""
local totaldist = 1
sources = {"minecraft:coal" = 80, "minecraft:coal_block"= 640, "minecraft:lava_bucket" = 1000}
--this function will decide whether the turtle should be refueled manually or automatically and for how many blocks should it refuel itself for.
--valid modes: "manual", "auto". REQUIRES FULL PLANNED TRAVERSAL DISTANCE. MUST BE CORRECT OR SOCIETY WILL BE IN SHAMBLES.
function fuel.refuel(varmode, dist)
  if varmode == "manual" or "auto" then
    mode = varmode
  else
    error("not a valid mode for refueling! dumbass.")
  end
  totaldist = dist
end

local function decideAmmount()
  
end

for i, line in ipairs(sources) do
  print(line)
end

return fuel