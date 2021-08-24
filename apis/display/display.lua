local netPocket = require("apis.network.net_pocket")

display = {}

local devices = netPocket.display()
local w, h = term.getSize()
local dev_windows = {}

local mainwindow = window.create(term.current, 1, 2, w, h - 2)

local function initWindows()
  dev_windows = {}
  for i = 1, #devices do
    dev_windows[i] = window.create(mainwindow, 1, i * 2 - 1, w, 2)
  end
end

local function printDeviceStatus()
  local isWorkingText = ""
  for i = 1,#dev_windows do
    write(devices[i]["name"])
    windows[i].setCursorPos(w - #devices[i]["curTask"], 1)
    write(devices[i]["curTask"])
  end
end

-- sets color for the background of the first line of each devices window
local function colorizeWindows()
  for i = 1, #dev_windows do
    dev_windows[i].setCursorPos(1,1)
    if devices[i]["present"] then
      dev_windows[i].setBackgroundColor(colors.gray)
      printDeviceStatus()
    elseif devices[i]["working"] then
      dev_windows[i].setBackgroundColor(colors.green)
      printDeviceStatus()
    elseif not devices[i]["present"] then
      dev_windows[i].setBackgroundColor(colors.red)
      printDeviceStatus()
    end
  end
end

function display.updateDisplay()
  initWindows()
  printDeviceStatus()
  colorizeWindows()
  sleep(2)
end

function display.requestReload()
  
end

return display