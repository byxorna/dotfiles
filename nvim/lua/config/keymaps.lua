local opts = { noremap = true, silent = true }

-- navigation: move by visual line, not file line (matters for wrapped lines)
vim.keymap.set("n", "j", "gj", opts)
vim.keymap.set("n", "k", "gk", opts)

-- tab navigation: shift-h/l to cycle tabs left/right
vim.keymap.set("n", "<S-h>", "gT", opts)
vim.keymap.set("n", "<S-l>", "gt", opts)

-- buffer swap: ctrl-e to jump to last-used buffer
vim.keymap.set("n", "<C-e>", ":e#<CR>", opts)

-- NERDTree: ctrl-t to toggle file tree sidebar
vim.keymap.set("n", "<C-T>", ":NERDTreeToggle<CR>", opts)

-- fzf: ctrl-p for project-wide text search (ag/ripgrep)
vim.keymap.set("n", "<C-p>", ":Ag<CR>", opts)

-- fzf: ctrl-l for fuzzy search across all open buffer lines
vim.keymap.set("n", "<C-l>", ":Lines<CR>", opts)

-- LSP: go to declaration (rarely used, most servers support definition instead)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

-- LSP: go to definition (jump to where the symbol is defined)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

-- LSP: hover docs (show type info / documentation for symbol under cursor)
vim.keymap.set("n", "<C-h>", vim.lsp.buf.hover, opts)

-- LSP: go to implementation (useful for interfaces)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

-- LSP: signature help (show function parameter info)
-- conflicts with blink-cmp's ctrl-k in insert mode, but this is normal mode only
vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

-- LSP: go to type definition (jump to the type of the symbol under cursor)
vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)

-- LSP: rename symbol across the project
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

-- LSP: find all references to the symbol under cursor
vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

-- diagnostics: jump to next/previous error or warning
vim.keymap.set("n", "]g", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, opts)

-- format on save: auto-format buffer using LSP when writing
-- https://www.mitchellhanberg.com/modern-format-on-save-in-neovim/
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  callback = function(args)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
      callback = function()
        vim.lsp.buf.format({ async = false, id = args.data.client_id })
      end,
    })
  end,
})
