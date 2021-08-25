netTurtle = {}

local worker_info = {
  ID = os.getComputerID(),
  name = os.getComputerLabel(),
  role = "miner",
  progress = 0,
  present = true,
  curTask = "idle"
}
local master = 1

--will wair for received commands and act upon them.
--available commands are:  "amMaster", "sendInfo"
local function waitForCommand()
  while true do
    local senderID, command = rednet.receive("julia")
    if command == "sendInfo" then
      rednet.send(senderID, worker_info, "julia")
    elseif command == "amMaster" then
      master = senderID
    end
  end
end

local function isForbiddenName(name)
  local forbiddenNames = {ID = 1, name = 1, present = 1}
  return forbiddenNames[name] ~= nil
end

-- updates the worker_info table to send up to date info to receivers
-- available names: role, progress, curTask
function netTurtle.updateInfo(name, value)
  if isForbiddenName(name) then
    error("tried to change forbidden value in turtle info!", 2)
  end
  worker_info[name] = value
end

function netTurtle.run()
  waitForCommand()
end

return netTurtle