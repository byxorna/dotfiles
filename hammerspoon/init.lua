-- simple window movements
hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall.use_syncinstall = true
spoon.SpoonInstall:andUse("WindowHalfsAndThirds")
--hs.loadSpoon("WindowHalfsAndThirds")

-- TODO(gabe): dont use animation durations when iterm is the window, cause its reflow
-- is mad slow
-- hs.window.animationDuration = 0.05
hs.window.animationDuration = 0 -- aint nobody got time for this
local hyper = {"cmd"}
win = spoon.WindowHalfsAndThirds:bindHotkeys({
  left_half   = { hyper, "Left" },
  right_half  = { hyper, "Right" },
  max_toggle  = { hyper, "Up" },
})

-- https://www.hammerspoon.org/go/#pasteblock
hs.hotkey.bind({"cmd", "shift"}, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

-- focus finder, and if focused, open a finder window
hs.hotkey.bind({"cmd", "shift"}, "F", function() 
  finder = hs.application.find("Finder")
  wasActive = finder:isFrontmost()
  if not wasActive then
    --hs.alert.show("is NOT frontmost")
    finder:activate(true)
  end
  win = finder:focusedWindow()
  -- if finder was active, or no window is front
  -- create a new window
  if win == nil or win:title() == "" or wasActive then
    --hs.alert.show("no focused window")
    res = finder:selectMenuItem({"File","New Finder Window"})
  end
end)

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
