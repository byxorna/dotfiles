return {
  "junegunn/fzf.vim",
  dependencies = {
    "junegunn/fzf",
  },
  config = function()
    vim.g.fzf_layout = { down = "20%" }
  end,
}
