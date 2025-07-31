return {
  'neovim/nvim-lspconfig',
  opts = { },
  config = function()
    vim.lsp.enable("gopls")        -- requires `gopls` installed
    vim.lsp.enable("terraformls") -- requires https://github.com/hashicorp/terraform-ls/blob/main/docs/installation.md
  end
}
