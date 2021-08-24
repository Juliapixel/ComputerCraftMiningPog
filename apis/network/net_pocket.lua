netPocket = {}

rednet.open("back")
rednet.host("julia", os.getComputerLabel())
local worker_info = {}
local initialAmmount = 0

--discovers all the turtles in the network and tabulates their base info into the worker_info table
local function discover()
  rednet.broadcast("listWorkers", "julia")
  local senderID = 1
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

local function updateInfo(turtleID)
  for i =1 , #worker_info, 1 do
    rednet.send(turtleID, "worker_info", "julia")
    info = rednet.receive("julia", 2)
    if not info then
      worker_info[i]["present"] = false
    else
      worker_info[i] = info
    end
  end
end

local function updateAll()
  for i = 1, initialAmmount do
    if worker_info[i]["ID"] then 
      updateInfo(worker_info[i]["ID"])
    end
  end
end

local function heartbeatAll()
  for i = 1, initialAmmount do
    if worker_info[i]["ID"] then
      rednet.send(worker_info[i]["ID"], "heartbeat")
      if not rednet.receive("julia", 3) then
        worker_info[i]["present"] = false
      end
    end
  end
end

-- will return the initial ammount of devices found and their respective info
function netPocket.run()
  discover()
  while true do
    updateAll()
  end
end

return netPocket