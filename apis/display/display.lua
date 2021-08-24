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


-- returns the color for the background of the first line of each devices window
local function colorizeFirstLine()
  local col = ""
  for i = 1, #devices do
    if devices[i]["present"] == false then
      col = colors.red
    else
      col = colors.green
    end
    return col
  end
end

-- prints device name and current task on the first line with correct colors
local function printDeviceStatus()
  for i = 1,#dev_windows do
    dev_windows[i].setBackgroundColor(colorizeFirstLine())
    dev_windows[i].clearLine()
    dev_windows[i].write(devices[i]["name"])
    dev_windows[i].setCursorPos(w - #devices[i]["curTask"] + 1, 1)
    dev_windows[i].write(devices[i]["curTask"])
  end
end

-- takes table of wokers and their info and updates all the windows and their info
function display.updateDisplay(worker_info)
  devices = worker_info
  while true do
  print(textutils.serialise(devices))
  initWindows()
  printDeviceStatus()
  sleep (2)
  end
end

function display.requestReload()

end

return display