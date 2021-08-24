local display = require("apis.display.display")

netPocket = {}

local worker_info = {}
local initialAmmount = 0

local function noDevices()
  printError("no devices found! try moving closer or restarting program.")
end

--discovers all the turtles in the network and tabulates their base info into the worker_info table
local function discover()
  rednet.broadcast("sendInfo", "julia")
  local senderID = 1
  worker_info = {}
  local workerinfo = {}
  local i = 1
  while true do
    senderID, workerinfo = rednet.receive("julia", 5)
    if workerinfo then
      worker_info[i] = workerinfo
      i = i + 1
    elseif not senderID then
      initialAmmount = #worker_info
      break
    end
  end
end

-- updates the info of the given device. won't update if rednet.receive times out, will change "present" to false
local function updateInfo(turtleID)
  for i = 1 , initialAmmount, 1 do
    rednet.send(turtleID, "sendInfo", "julia")
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
    if worker_info[i] then
      local requestID = worker_info[i]["ID"]
      updateInfo(requestID)
    end
  end
  event = os.pullEvent(timer)
end

-- will return the initial ammount of devices found and their respective info
function netPocket.run()
  discover()
  if next(worker_info) then
    textutils.slowPrint("workers found!")
    while true do
      updateAll()
      parallel.waitForAny(display.requestReload(), display.updateDisplay(worker_info), sleep(2))
    end
  else
    printError("no devices in network!")
  end
end

return netPocket