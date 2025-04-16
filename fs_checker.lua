-- fs_checker.lua
-- Run this on your “master” computer to poll every slave.

local function scan(timeout)
  rednet.open("left")                   -- same side as above
  rednet.broadcast("FS?", "FS?")        -- ask everyone
  local timer = os.startTimer(timeout or 3)
  local results = {}

  while true do
    local ev, a,b,c = os.pullEvent()
    if ev == "rednet_message" and c == "FS!" then
      local id, info = a, b
      results[id] = info
    elseif ev == "timer" and a == timer then
      break
    end
  end

  rednet.close("left")
  return results
end

-- example usage
local data = scan(5)
for id,info in pairs(data) do
  print(("Computer %d → total: %d B, free: %d B"):format(id, info.total, info.free))
end
