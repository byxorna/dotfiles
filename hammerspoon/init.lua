-- simple window movements
hs.loadSpoon("WindowHalfsAndThirds")
-- TODO(gabe): dont use animation durations when iterm is the window, cause its reflow
-- is mad slow
-- hs.window.animationDuration = 0.05
hs.window.animationDuration = 0 -- aint nobody got time for this
local hyper = {"cmd"}
win = spoon.WindowHalfsAndThirds:bindHotkeys({
  left_half   = { hyper, "Left" },
  right_half  = { hyper, "Right" },
  --top_half    = { hyper, "Up" },
  --bottom_half = { hyper, "Down" },
  --third_left  = { hyper, "Left" },
  --third_right = { hyper, "Right" },
  --third_up    = { hyper, "Up" },
  --third_down  = { hyper, "Down" },
  --top_left    = { hyper, "1" },
  --top_right   = { hyper, "2" },
  --bottom_left = { hyper, "3" },
  --bottom_right= { hyper, "4" },
  --max_toggle  = { hyper, "f" },
  max_toggle  = { hyper, "Up" },
  --undo        = { hyper, "z" },
  --center      = { hyper, "c" },
  --larger      = { hyper, "Right" },
  --smaller     = { hyper, "Left" },
})

-- https://www.hammerspoon.org/go/#pasteblock

hs.hotkey.bind({"cmd", "alt"}, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

--[[
-- If AppGate is running, try to figure out which connection we are on
function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        if (appName == "AppGate SDP") then
          hs.alert.show("AppGate Focused" .. appName .. "--" )
        end
    end
end
appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
--]]
