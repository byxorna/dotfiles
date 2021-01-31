--[[
hs.window.animationDuration = 0
units = {
  right30       = { x = 0.70, y = 0.00, w = 0.30, h = 1.00 },
  right70       = { x = 0.30, y = 0.00, w = 0.70, h = 1.00 },
  left70        = { x = 0.00, y = 0.00, w = 0.70, h = 1.00 },
  left30        = { x = 0.00, y = 0.00, w = 0.30, h = 1.00 },
  top50         = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 },
  bot50         = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 },
  upright30     = { x = 0.70, y = 0.00, w = 0.30, h = 0.50 },
  botright30    = { x = 0.70, y = 0.50, w = 0.30, h = 0.50 },
  upleft70      = { x = 0.00, y = 0.00, w = 0.70, h = 0.50 },
  botleft70     = { x = 0.00, y = 0.50, w = 0.70, h = 0.50 },
  maximum       = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 }
}

mash = { 'shift', 'ctrl', 'cmd' }
hs.hotkey.bind(mash, 'l', function() hs.window.focusedWindow():move(units.right30,    nil, true) end)
hs.hotkey.bind(mash, 'h', function() hs.window.focusedWindow():move(units.left70,     nil, true) end)
hs.hotkey.bind(mash, 'k', function() hs.window.focusedWindow():move(units.top50,      nil, true) end)
hs.hotkey.bind(mash, 'j', function() hs.window.focusedWindow():move(units.bot50,      nil, true) end)
hs.hotkey.bind(mash, ']', function() hs.window.focusedWindow():move(units.upright30,  nil, true) end)
hs.hotkey.bind(mash, '[', function() hs.window.focusedWindow():move(units.upleft70,   nil, true) end)
hs.hotkey.bind(mash, ';', function() hs.window.focusedWindow():move(units.botleft70,  nil, true) end)
hs.hotkey.bind(mash, "'", function() hs.window.focusedWindow():move(units.botright30, nil, true) end)
hs.hotkey.bind(mash, 'm', function() hs.window.focusedWindow():move(units.maximum,    nil, true) end)
--]]
--
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  hs.alert.show("Hello World!")
end)

-- simple window movements
hs.loadSpoon("WindowHalfsAndThirds")
-- TODO(gabe): dont use animation durations when iterm is the window, cause its reflow
-- is mad slow
-- hs.window.animationDuration = 0.05
hs.window.animationDuration = 0 -- aint nobody got time for this
local hyper = {"shift", "cmd"}
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
  max_toggle  = { hyper, "f" },
  max         = { hyper, "Up" },
  --undo        = { hyper, "z" },
  --center      = { hyper, "c" },
  --larger      = { hyper, "Right" },
  --smaller     = { hyper, "Left" },
})

-- https://www.hammerspoon.org/go/#pasteblock

hs.hotkey.bind({"cmd", "alt"}, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)
