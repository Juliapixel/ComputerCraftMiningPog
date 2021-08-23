compare = {}
local itemdb = fs.open(fs.getDir(shell.getRunningProgram()) .. "/apis/comparer/items_db.txt", "r")
local items = {}

while true do
  local line = itemdb.readLine()
  if not line then
    itemdb.close()
    break
  end
  -- #items is the ammount of items in the table, so i am adding another item to the table every time this is called
  items[#items + 1] = line
end

function compare.debugdb()
  for i=1, #items, 1 do
    print(items[i])
  end
end

--This function will stack the items in the inventory in a way so that they will take the smallest space possible
--will return true if last inventory slot is empty, will return false if not.
function compare.stackInv()
  local inv = {}
  for i=1, 16, 1 do
    local data = turtle.getItemDetail(i)
    inv[i] = data
  end
  for i=1, 16 ,1 do
    if turtle.getItemDetail(i) then
      local name = inv[i]["name"]
      for j=1, i, 1 do
        if turtle.getItemDetail(j) then
          if name == inv[j]["name"] then
            turtle.select(i)
            turtle.transferTo(j)
          end
        end
      end
    end
  end
  turtle.select(1)
  if turtle.getItemCount(16) < 1 then
    return true
  else
    return false
  end
end

--will compare the block in front of the turtle to the database of valuable blocks.
--function compareBlock()
--  local h, data = turtle.inspect()
--  local i = 1
--  while true do
--  if not blocks[i] then
--    digDrop()
--    break
--  elseif data[name] == blocks[i] then
--    digKeep()
--    break
--  elseif data[name] ~= blocks[i] then
--    i = i + 1
--  end
--  end
--end

--Drops any items that are not in the item whitelist.
function compare.pruneInv()
  local inv = {}
  for i=1, 16, 1 do
    local data = turtle.getItemDetail(i)
    inv[i] = data
  end
  for i = 1, 16, 1 do
    local success = false
    if turtle.getItemDetail(i) then
      turtle.select(i)
      local name = inv[i]["name"]
      for j = 1, #items, 1 do
        if name == items[j] then
          success = true
          break
        end
      end
      if not success then
        turtle.drop()
      end
    end
  end
  turtle.select(1)
end

return compare