local opts = { noremap=true, silent=true }
--vim.keymap.set("n", "<leader>o", "o<Esc>", { desc = "Open new line below" })

vim.keymap.set( 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
vim.keymap.set( 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
vim.keymap.set( 'n', '<C-h>', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
vim.keymap.set( 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
-- this isnt super useful, and overlaps with insert mapping ctrl-k for showing blink
vim.keymap.set( 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
vim.keymap.set( 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
vim.keymap.set( 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
vim.keymap.set( 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
vim.keymap.set( 'n', ']g', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.keymap.set( 'n', '[g', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)

-- https://www.mitchellhanberg.com/modern-format-on-save-in-neovim/
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  callback = function(args)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
      callback = function()
        vim.lsp.buf.format {async = false, id = args.data.client_id }
      end,
    })
  end
})
