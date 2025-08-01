-- https://www.lazyvim.org/extras/coding/blink
return {
      'saghen/blink.cmp',
      -- optional: provides snippets for the snippet source
      dependencies = { 'rafamadriz/friendly-snippets' },

      -- use a release tag to download pre-built binaries
      version = '1.*',
      -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
      -- build = 'cargo build --release',
      -- If you use nix, you can build from source using latest nightly rust with:
      -- build = 'nix run .#build-plugin',

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = {
          --preset = 'none' 
          --
           ['<C-enter>'] = { 'show', 'show_documentation', 'hide_documentation' },
           ['<C-e>'] = { 'hide' },
           --['<CR>'] = { 'select_and_accept' },
           ['<C-y>'] = { 'select_and_accept' },
           ['<Up>'] = { 'select_prev', 'fallback' },
           ['<Down>'] = { 'select_next', 'fallback' },
           ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
           ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
           ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
           ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
           ['<Tab>'] = { 'snippet_forward', 'fallback' },
           ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
           ['<C-h>'] = { 'show_signature', 'hide_signature', 'fallback' },

          -- https://github.com/chrisgrieser/.config/blob/8a9b98f450e71b92ac10aec6084769d710d6dbb0/nvim/lua/plugins/completion-and-snippets.lua
          --["<C-h>"] = { "show_documentation", "fallback" },
				  --["<C-Esc>"] = { "hide_documentation", "fallback" },
				  --["<CR>"] = { "select_and_accept", "fallback" },
				  --["<Tab>"] = { "select_next", "fallback" },
				  --["<S-Tab>"] = { "select_prev", "fallback" },
				  --["<Down>"] = { "select_next", "fallback" },
				  --["<Up>"] = { "select_prev", "fallback" },
				  --["<PageDown>"] = { "scroll_documentation_down" },
				  --["<PageUp>"] = { "scroll_documentation_up" },
        },

        appearance = {
          -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono'
        },

        completion = {
          documentation = {
            -- (Default) Only show the documentation popup when manually triggered
            auto_show = true,
          },
          list = {
            -- https://github.com/Saghen/blink.cmp/issues/702
            selection = {
              preselect = true,
              auto_insert = true,
            }
          },
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" }
      },
      opts_extend = { "sources.default" }
    }
