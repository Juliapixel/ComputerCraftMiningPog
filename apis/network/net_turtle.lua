local mine = require("apis.mine")

netTurtle = {}

local worker_info = {ID = os.getComputerID(),name = os.getComputerLabel(), role = "miner", progress = mine.progress(), present = false, curTask = ""}
local master = 1

--will wair for received commands and act upon them.
--available commands are:  "amMaster", "sendInfo"
local function waitForCommand()
  rednet.open("left")
  rednet.host("julia", os.getComputerLabel())
  local senderID, command = rednet.receive("julia")
  if command == "sendInfo" then
    rednet.send(senderID, worker_info, "julia")
  elseif command == "amMaster" then
    master = senderID
  end
end

function netTurtle.run()
  waitForCommand()
end
return netTurtle