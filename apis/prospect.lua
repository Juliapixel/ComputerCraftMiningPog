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
