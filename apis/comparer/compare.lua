local itemdb = fs.open("ComputerCraftMiningPog/apis/comparer/items_db.txt", "r")
local items = {}

local function tabulatedb (db, db_table)
    while true do
        local line = db.readLine()
        if not line then
            db.close()
            break end
        -- #db is the ammount of items in the table, so i am adding another item to the table every time this is called
        db_table[#db_table + 1] = line
    end
end

tabulatedb(itemdb, items)

function debugdb()
    for i=1, #blocks, 1 do
        print(blocks[i])
    end
    for i=1, #items, 1 do
        print(items[i])
    end
end

--This function will stack the items in the inventory in a way so that they will take the smallest space possible
--will return true if last inventory slot is empty, will return false if not.
function stackInv()
    local inv = {}
    for i=1, 16, 1 do
        local data = turtle.getItemDetail(i)
        inv[i] = data
    end
    for i=1, 16 ,1 do
        local name = inv[i][name]
        for j=1, i, 1 do
            if name == inv[j][name] then
                turtle.select(i)
                turtle.transferTo(j)
            end
        end
    end
    turtle.select(1)
    if turtle.getItemCount(16) < 1 then
        return(true)
    else
        return (false)
    end
end

--will compare the block in front of the turtle to the database of valuable blocks.
--function compareBlock()
--    local h, data = turtle.inspect()
--    local i = 1
--    while true do
--        if not blocks[i] then
--            digDrop()
--            break
--        elseif data[name] == blocks[i] then
--            digKeep()
--            break
--        elseif data[name] ~= blocks[i] then
--            i = i + 1
--        end
--    end
--end

function compareInv()
    for i=1, 16, 1 do
        data = turtle.getItemDetail(i)
        local j = 1
        while true do
            if not items[j] then
                turtle.dropUp()
                break
            elseif data[name] ~= items[j] then
                break
            else
                j = j + 1
            end
        end
    end
end