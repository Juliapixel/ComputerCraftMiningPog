local display = require("apis.display.display")

netPocket = {}

rednet.open("back")
rednet.host("julia", os.getComputerLabel())
local worker_info = {}
local initialAmmount = 0

--discovers all the turtles in the network and tabulates their base info into the worker_info table
local function discover()
  rednet.broadcast("sendInfo", "julia")
  local senderID = 1
  worker_info = {}
  local workerinfo = {}
  local i = 1
  while true do
    senderID, workerinfo = rednet.receive("julia", 5)
    if workerinfo["ID"] then
      worker_info[i] = workerinfo
      i = i + 1
    elseif not workerinfo then
      initialAmmount = #worker_info
      break
    end
  end
end

-- updates the info of the given device. won't update if rednet.receive times out, will change "present" to false
local function updateInfo(turtleID)
  for i =1 , #worker_info, 1 do
    rednet.send(turtleID, "worker_info", "julia")
    info = rednet.receive("julia", 1)
    if not info then
      worker_info[i]["present"] = false
    else
      worker_info[i] = info
    end
  end
end

-- calls updateInfo() for every device it has ever come into contact with
local function updateAll()
  os.startTimer(5)
  for i = 1, initialAmmount do
    if worker_info[i]["ID"] then 
      updateInfo(worker_info[i]["ID"])
    end
  end
  event = os.pullEvent(timer)
end

-- will return the initial ammount of devices found and their respective info
function netPocket.run()
  discover()
  while true do
    parallel.waitForAny(updateAll(), display.requestReload())
  end
end

-- returns the ammount of workers as a number and their info in a table
function netPocket.display()
  return worker_info
end

return netPocket