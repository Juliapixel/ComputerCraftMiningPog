
local function oreAhead()
    local has_block, data = turtle.inspect()
    if has_block then
        if string.find(textutils.serialise(data), "forge:ores") then
            return(true)
        else
            return(false)
        end
    else
        return(false)
    end
end

local function oreUp()
    local has_block, data = turtle.inspectUp()
    if has_block then
        if string.find(textutils.serialise(data), "forge:ores") then
            return(true)
        else
            return(false)
        end
    else
        return(false)
    end
end

local function oreDown()
    local has_block, data = turtle.inspectDown()
    if has_block then
        if string.find(textutils.serialise(data), "forge:ores") then
            return(true)
        else
            return(false)
        end
    else
        return(false)
    end
end

local function digOres()
    local up, down, left, right
    up = oreUp()
    down = oreDown()
    if up then
        turtle.digUp()
    end
    if down then
        turtle.digDown()
    end
    turtle.turnLeft()
    left = oreAhead()
    if left then 
        turtle.dig()
    end
    turtle.turnRight()
    turtle.turnRight()
    right = oreAhead()
    if right then
        turtle.dig()
    end
    turtle.turnLeft()
end

local function goForward()
    turtle.dig()
    turtle.forward()
end

function tunnelAhead(dist)
    turtle.refuel()
    if dist < turtle.getFuelLevel() then
        dist = turtle.getFuelLevel()
        print("not enough fuel, will only mine for %d blocks! proceed anyway? (y/n)")
        write("> ")
        local input = string.lower(read())
        if input == "y" then
            print("proceeding!")
        else
            print("cancelled.")
            return(false)
        end
    for i=1, dist, 1 do
        goForward()
        digOres()
    end
    turtle.turnLeft()
    turtle.turnLeft()
    for i=1, dist, 1 do
        goForward()
    end