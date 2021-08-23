fuel = {}

local totaldist = 1

local coal = {name = "minecraft:coal", power = 80}
local coal_block = {name = "minecraft:coal_block", power = 800}
local lava_bucket = {name = "minecraft:lava_bucket", power= 1000}
local sources = {coal, coal_block, lava_bucket}

--this will make the turtle wait for fuel to be placed in its first inventory slot by a player
local function waitForFuel()
  turtle.select(1)
  local ammount_needed = 1
  while true do
    local additional_fuel_needed = totaldist - turtle.getFuelLevel()
    --will end the wait if enough fuel is already inserted.
    if additional_fuel_needed <= 0 then
      term.clear()
      term.setCursorPos(1,1)
      print("fuel sufficient!")
      write("beninging")
      textutils.slowPrint("...", 1)
      break
    end
    term.clear()
    term.setCursorPos(1,1)
    --iterates through the table of available fuel sources and tells you how many of each of the available sources you will need to fill your tank up to an acceptable level
    print("you're gonna need at least:")
    for i, item in ipairs(sources) do
      ammount_needed = math.ceil(additional_fuel_needed/item["power"])
      print(string.format("%d more %s", ammount_needed, string.gsub(string.gsub(item["name"], "minecraft:", ""), "_", " ")))
    end
    print("in order to start the turtle.")
    print("please place it in the first inventory slot.")
    local event = os.pullEvent("turtle_inventory")
    local placed_fuel = turtle.getItemDetail(1)
    if placed_fuel then
      --determines fuel ammount certain placed fuel item will provide. will be false if not in list.
      for i, v in ipairs(sources) do
        if placed_fuel["name"] == v["name"] then
          placed_fuel["power"] = v["power"]
        elseif not placed_fuel["power"] then
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

local function selfRefuel()
  print("refuelling self.")
  for i = 1, 16, 1 do
    local additional_fuel_needed = totaldist - turtle.getFuelLevel()
    --will end the refueling if enough fuel is already inserted.
    if additional_fuel_needed <= 0 then
      print("fuel sufficient!")
      write("beninging")
      textutils.slowPrint("...", 1)
      break
    end
      waitForFuel()
    local curItem = turtle.getItemDetail(i)
    --determines fuel ammount certain slot will provide. will be false if not in list.
    if curItem then
      for j, v in ipairs(sources) do
        if curItem["name"] == v["name"] then
          curItem["power"] = v["power"]
        elseif not curItem["power"] then
          curItem["power"] = false
        end
      end
    end
    if curItem then
      if curItem["power"] then
        if curItem["power"]*curItem["count"] <= additional_fuel_needed then
          turtle.refuel()
        elseif curItem["power"]*curItem["count"] > additional_fuel_needed then
          turtle.refuel(math.ceil(additional_fuel_needed/curItem["power"]))
        end
      end
    end
  end
end
--this function will decide whether the turtle should be refueled manually or automatically and for how many blocks should it refuel itself for.
--valid modes: "manual", "auto". REQUIRES FULL PLANNED TRAVERSAL DISTANCE. MUST BE CORRECT OR SOCIETY WILL BE IN SHAMBLES.
function fuel.refuel(dist)
  totaldist = dist
  selfRefuel()
end

return fuel