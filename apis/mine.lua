function oreAhead()
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

function oreUp()
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

function oreDown()
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

function digOres()
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
