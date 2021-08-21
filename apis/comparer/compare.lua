local dir = fs.find("/* /comparer*")
local blockdb = fs.open(dir .. "/blocks_db.txt", "r")
local itemdb = fs.open(dir .. "/items_db.txt", "r")
local blocks = {}
local items = {}

local function tabulatedb (db)
    while true do
        local line = db.readLine()
        if not line then
            db.close()
            break end
        -- #db is the ammount of items in the table, so i am adding another item to the table every time this is called
        db[#db + 1] = line
    end
end

tabulatedb(blockdb)
tabulatedb(itemdb)

function debugdb()
    for i=1, #blocks, 1 do
        print(blocks[i])
    end
    for i=1, #items, 1 do
        print(items[i])
    end
end