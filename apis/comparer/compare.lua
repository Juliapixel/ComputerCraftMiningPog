local blockdb = fs.open("ComputerCraftMiningPog/apis/comparer/blocks_db.txt", "r")
local itemdb = fs.open("ComputerCraftMiningPog/apis/comparer/items_db.txt", "r")
local blocks = {}
local items = {}

local function tabulatedb (db, db_table)
    while true do
        local line = db.readLine()
        if not line then
            db.close()
            break end
        -- #db is the ammount of items in the table, so i am adding another item to the table every time this is called
        dbtable[#dbtable + 1] = line
    end
end

tabulatedb(blockdb, blocks)
tabulatedb(itemdb, items)

function debugdb()
    for i=1, #blocks, 1 do
        print(blocks[i])
    end
    for i=1, #items, 1 do
        print(items[i])
    end
end