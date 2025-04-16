-- Basic Chat Bot for ComputerCraft with Animation on the Left Monitor

-- helpers
local function getrandomnum()
  local function OST_RNDM()
      local rnd = math.random(64)
      if rnd <= 0 then rnd = math.random(5,32) end
      return math.random(math.random(1,64), rnd * 64)
  end
  math.randomseed(os.time())
  return OST_RNDM()
end
math.randomseed(getrandomnum()) -- beholder's advanced randomized seed generator

-- Wrap the top monitor
local monitor = peripheral.wrap("top")
if not monitor then
  print("[o7] Top mon not found!")
  return
end
local chatmon = peripheral.wrap("left")
if not chatmon then
  print("[o7] Chatmon mon not found!")
  return
end
local statusmon = peripheral.wrap("right")
if not statusmon then
  print("[o7] Statusmon not found!")
  return
end


local restarts = 0

-- Adjust monitor text scale and clear the screen
monitor.setTextScale(0.5)
chatmon.setTextScale(0.5)
statusmon.setTextScale(0.5)
monitor.clear()
chatmon.clear()
statusmon.clear()


-- Attributes and functions for the beholder
local frame = 1
local status
local stress = {incoming = 0, outgoing = 0}
local neutralfaces = {"=O", "=o"}
local sadfaces = {"=|", "=("}
local angryfaces = {">=(", ">=0"}  -- added missing closing bracket
local suicidalfaces = {"X(", "<("}
local happyfaces = {"=D", "=)"}
local status_list = {"$UICIDAL", "ANGRY", "SAD", "NEUTRAL", "HAPPY", "PERFECT"}

local function statusChecker()
  -- add status effects later - default for now is HAPPY!
  -- if data income is low, all good; if it’s high, raise stress LVL.
  -- stress lvl determines emotion / status.
  while true do
    if stress.incoming == 0 then
      status = status_list[6]
      return status
    end
    if stress.incoming > 64 and stress.incoming < 128 then
      status = status_list[5]
      return status
    end
    if stress.incoming > 128 and stress.incoming < 256 then
      status = status_list[4]
      return status
    end
    if stress.incoming > 256 and stress.incoming < 512 then
      status = status_list[3]
      return status
    end
    if stress.incoming > 512 and stress.incoming < 1024 then
      status = status_list[2]
      return status
    end
    if stress.incoming > 1024 then
      status = status_list[1]
      return status
    end
  end
end

-- Animation function to be run in parallel with chat
local function animate()
  while true do
    monitor.setCursorPos(1, 1)
    monitor.clearLine()  -- clear the current line
    statusChecker() -- update status
    monitor.write("!BEHOLDER! - status: " .. tostring(status)) -- concatenate string with status

    monitor.setCursorPos(1, 2)
    monitor.clearLine()  -- clear the line to avoid leftover characters
    frame = (frame % #happyfaces) + 1
    monitor.write(happyfaces[frame])
    sleep(0.5) -- computercraft sleep function
  end
end

local function chat()
  while true do
    -- Prompt user input; this runs on the computer terminal (not on the monitor)
    -- fix this chat system to display command history in a monitor on the right
    write(":#:: ")
    local input = read()
    if not input then break end  -- continue if no input
    chatmon.setCursorPos(1,1)
    chatmon.write(":#:: " .. input)  -- concatenate the prompt with input
    chatmon.write(response)
  end
end

-- Main Loop and thread initializer.
-- right monitor will be mostly for st
local function CORETICKER()
  while true do
    print("!STARTING! Restarts: ", restarts)
    parallel.waitForAny(animate, chat)
    restarts = restarts + 1
  end
end

-- Run both functions concurrently using the parallel API
CORETICKER()
