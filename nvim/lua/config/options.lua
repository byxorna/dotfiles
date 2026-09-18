local opt = vim.opt
local g = vim.g

-- search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true -- case-sensitive when search includes uppercase

-- line numbers: absolute in insert mode, relative in normal mode
opt.number = true

local function set_relative()
  if vim.wo.number then vim.wo.relativenumber = true end
end
local function unset_relative()
  if vim.wo.number then vim.wo.relativenumber = false end
end

local number_toggle = vim.api.nvim_create_augroup("NumberToggle", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
  group = number_toggle,
  callback = set_relative,
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
  group = number_toggle,
  callback = unset_relative,
})

-- indentation: 2-space soft tabs everywhere
opt.autoindent = true
opt.expandtab = true
opt.smarttab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

-- disable mouse (use terminal mouse instead)
opt.mouse = ""

-- text formatting (see :help fo-table)
opt.formatoptions = "jtcroqln"

-- disable netrw history file (~/.netrwhist)
g.netrw_dirhistmax = 0

-- window title: show current filename
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.opt.titlestring = "vim(" .. vim.fn.expand("%:t") .. ")"
  end,
})
opt.title = true

-- highlight trailing whitespace in red
vim.api.nvim_create_autocmd("Syntax", {
  pattern = "*",
  callback = function()
    vim.fn.matchadd("ExtraWhitespace", [[\s\+$\| \+\ze\t]])
  end,
})
vim.api.nvim_set_hl(0, "ExtraWhitespace", { bg = "red" })

-- highlight the 101st column to flag long lines
vim.api.nvim_set_hl(0, "OverLength", { bg = "#592929" })
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.fn.matchadd("OverLength", [[\%101v.]])
  end,
})
