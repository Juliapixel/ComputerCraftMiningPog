fuel = {}

local totaldist = 1

local coal = {name = "minecraft:coal", power = 80}
local coal_block = {name = "minecraft:coal_block", power = 640}
local lava_bucket = {name = "minecraft:lava_bucket", power= 1000}
local sources = {coal, coal_block, lava_bucket}

local function waitForFuel()
  turtle.select(1)
  local ammount_needed = 1
  while true do
    local additional_fuel_needed = totaldist - turtle.getFuelLevel()
    if additional_fuel_needed <= 0 then
      break
    end
    term.clear()
    term.setCursorPos(1,1)
    for i, item in ipairs(sources) do
      ammount_needed = math.ceil(additional_fuel_needed/item["power"])
      print(string.format("you  need %d more %s in order to start the turtle!", ammount_needed, string.gsub(string.gsub(item["name"], "minecraft:", ""), "_", " ")))
    end
    print("please place it in the first inventory slot!")
    local event = os.pullEvent("turtle_inventory")
    local placed_fuel = turtle.getItemDetail(1)
    if placed_fuel then
      --determines fuel ammount certain placed fuel item will provide. will be false if not in list.
      for i, v in ipairs(sources) do
        if placed_fuel["name"] == v["name"] then
          placed_fuel["power"] = v["power"]
        elseif i == #sources and placed_fuel["power"] then
          placed_fuel["power"] = false
        end
      end
      if placed_fuel["power"] ~= false then
        if placed_fuel["power"]*placed_fuel["count"] <= additional_fuel_needed then
          turtle.refuel()
        elseif placed_fuel["power"]*placed_fuel["count"] > additional_fuel_needed then
          turtle.refuel(math.ceil(additional_fuel_needed/placed_fuel["power"]))
        end
      else
        print("not a suitable fuel! try again, dumbass.")
      end
    end
  end
end

--this function will decide whether the turtle should be refueled manually or automatically and for how many blocks should it refuel itself for.
--valid modes: "manual", "auto". REQUIRES FULL PLANNED TRAVERSAL DISTANCE. MUST BE CORRECT OR SOCIETY WILL BE IN SHAMBLES.
function fuel.refuel(varmode, dist)
  local mode = ""
  if varmode == "manual" or "auto" then
    mode = varmode
  else
    error("not a valid mode for refueling! dumbass.")
  end
  totaldist = dist
  if mode =="auto" then
    
  else
    waitForFuel()
  end
end

fuel.refuel("manual", 800)

return fuel