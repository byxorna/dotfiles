return {
  'vim-airline/vim-airline',
  -- Optional: If you use themes, add them here
  -- 'vim-airline/vim-airline-themes',
  -- Optional: Configuration for airline
  config = function()
    vim.g.airline_powerline_fonts = 0 -- Enable Powerline fonts if you use them
    -- Add other airline configurations here
  end,
  -- Optional: If you want to lazy-load, but be aware of the implications
  -- lazy = true, -- This is generally NOT recommended for vim-airline
}
