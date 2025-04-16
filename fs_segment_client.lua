-- fs_segment_client.lua
-- Segments clusters: left→downstream slaves, right→upstream master
 
-- Rename this computer for easy identification on the network
os.setComputerLabel("ACCESS_RELAY")
 
-- open both wired modems
rednet.open("left")
rednet.open("right")
 
-- poll all downstream slaves for FS?
local function scan_downstream(timeout)
  rednet.broadcast("FS?", "FS?")
  local timer = os.startTimer(timeout or 3)
  local results = {}
 
  while true do
    local ev, a, b, proto = os.pullEvent()
    if ev == "rednet_message" and proto == "FS!" then
      -- a = senderID, b = { total=…, free=… }
      results[a] = b
    elseif ev == "timer" and a == timer then
      break
    end
  end
 
  return results
end
 
-- main loop: wait for upstream query, then forward & reply
while true do
  local sender, msg, proto = rednet.receive("FS?")  -- listen on right
  if msg == "FS?" then
    local data = scan_downstream(5)                  -- wait up to 5s
    rednet.send(sender, data, "FS!")                 -- reply upstream
  end
end
 
RAW Paste Data 
-- fs_segment_client.lua
-- Segments clusters: left→downstream slaves, right→upstream master

-- Rename this computer for easy identification on the network
os.setComputerLabel("ACCESS_RELAY")

-- open both wired modems
rednet.open("left")
rednet.open("right")

-- poll all downstream slaves for FS?
local function scan_downstream(timeout)
  rednet.broadcast("FS?", "FS?")
  local timer = os.startTimer(timeout or 3)
  local results = {}

  while true do
    local ev, a, b, proto = os.pullEvent()
    if ev == "rednet_message" and proto == "FS!" then
      -- a = senderID, b = { total=…, free=… }
      results[a] = b
    elseif ev == "timer" and a == timer then
      break
    end
  end

  return results
end

-- main loop: wait for upstream query, then forward & reply
while true do
  local sender, msg, proto = rednet.receive("FS?")  -- listen on right
  if msg == "FS?" then
    local data = scan_downstream(5)                  -- wait up to 5s
    rednet.send(sender, data, "FS!")                 -- reply upstream
  end
end
