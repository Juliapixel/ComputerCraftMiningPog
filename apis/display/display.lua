display = {}

local devices = {}
local w, h = term.getSize()
local dev_windows = {}

local mainwindow = window.create(term.current(), 1, 2, w, h - 2)

-- initializes windows for all devices in network
local function initWindows()
  dev_windows = {}
  for i = 1, #devices do
    dev_windows[i] = window.create(mainwindow, 1, i * 2 - 1, w, 2)
  end
end

-- prints device name and current task on the first line with correct colors
local function printDeviceStatus()
  for i = 1,#dev_windows do
    local col = ""
    if devices[i]["present"] == true then
      col = colors.green
    end
    if devices[i]["curTask"] == "" then
      col = colors.gray
    end
    if devices[i]["present"] ~= true then
      col = colors.red
    end

    dev_windows[i].setBackgroundColor(col)
    dev_windows[i].clearLine()
    dev_windows[i].write(devices[i]["name"])
    dev_windows[i].setCursorPos(w - #devices[i]["curTask"] + 1, 1)
    dev_windows[i].write(devices[i]["curTask"])
  end
end

-- takes table of wokers and their info and updates all the windows and their info
function display.updateDisplay(worker_info)
  os.startTimer(2)
  devices = worker_info
  initWindows()
  printDeviceStatus()
  local event = os.pullEvent("timer")
end

function display.requestReload()

end

return display