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
    senderID, workerinfo = rednet.receive("julia", 2)
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
local function updateInfo(request_ID, index)
  rednet.send(request_ID, "sendInfo", "julia")
  local ID, info = rednet.receive("julia", 2)
  if not info then
    worker_info[index]["present"] = false
  else
    worker_info[index] = info
  end
end

-- calls updateInfo() for every device it has ever come into contact with
local function updateAll()
  for i = 1, initialAmmount do
    if worker_info[i] then
      updateInfo(worker_info[i]["ID"], i)
    end
  end
end

-- will loop and end when requested to. finds devices in the network and keeps updating their info
-- will also call the display api to display it on the pocket computer's screen
function netPocket.run()
  term.clear()
  local shouldKeepRunning = false
  local command = ""
  while true do
    worker_info = {}
    discover()
    if command ~= "quit" then
      if next(worker_info) then
        shouldKeepRunning = true
        while true do
          command = ""
          local function wrapperUpdateDisplay()
            return display.updateDisplay(worker_info)
          end
          local function wrapperWaitForButtons()
            command = display.waitForButtons()
          end
          updateAll()
          parallel.waitForAny(wrapperUpdateDisplay, wrapperWaitForButtons, display.sendCommands)
          if command ~= "" then 
            break
          end
        end
      elseif shouldKeepRunning == false then
        print("no devices found! keep searching? (y/n)")

        local event, key = os.pullEvent("key")
        if key == keys.y then
          shouldKeepRunning = true
          print("continuing search...")
        else
          print("search cancelled.")
          sleep(1)
        end
      end
    else
      term.clear()
      term.setCursorPos(1,1)
      print("Goodbye.")
      term.setCursorPos(1,2)
      break
    end
    if shouldKeepRunning == false then
      break
    end
  end
end

return netPocket