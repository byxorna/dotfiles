return {
  "hashivim/vim-terraform",
  ft = { "terraform", "terraform-vars" },
  config = function()
    vim.g.terraform_align = 1
    vim.g.terraform_fmt_on_save = 1

    -- auto-initialize terraform when opening .tf files in an uninitialized dir.
    -- runs `terraform init -backend=false` to fetch providers (from cache) so
    -- terraform-ls can provide hover docs and go-to-definition immediately.
    -- disable with: vim.g.terraform_auto_init = false (in options.lua or init.lua)
    local init_in_progress = {}
    local init_declined = {}

    local function terraform_auto_init()
      if vim.g.terraform_auto_init == false then
        return
      end
      local dir = vim.fn.expand("%:p:h")
      if init_in_progress[dir] or init_declined[dir] or vim.fn.isdirectory(dir .. "/.terraform") == 1 then
        return
      end
      local answer = vim.fn.input("terraform init -backend=false (" .. dir .. ")? [y/N] ")
      if answer ~= "y" then
        init_declined[dir] = true
        return
      end
      init_in_progress[dir] = true
      vim.fn.jobstart({ "terraform", "init", "-backend=false" }, {
        cwd = dir,
        on_exit = function(_, code)
          init_in_progress[dir] = nil
          if code == 0 then
            vim.schedule(function()
              print("terraform init complete, restarting LSP")
              for _, client in ipairs(vim.lsp.get_clients({ name = "terraformls" })) do
                client:stop(true)
              end
              vim.lsp.enable("terraformls")
            end)
          else
            vim.schedule(function()
              print("terraform init failed (exit " .. code .. ")")
            end)
          end
        end,
      })
    end

    vim.api.nvim_create_autocmd("BufReadPost", {
      pattern = "*.tf",
      group = vim.api.nvim_create_augroup("TerraformAutoInit", { clear = true }),
      callback = terraform_auto_init,
    })

    -- run immediately for the buffer that triggered this plugin to load
    terraform_auto_init()
  end,
}
