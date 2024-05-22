-- improve neovim lsp experience
return {
  -- https://github.com/nvimdev/lspsaga.nvim
  "glepnir/lspsaga.nvim",
  config = function()
    -- import lspsaga safely
    local saga = require("lspsaga")

    -- https://nvimdev.github.io/lspsaga/
    saga.setup({
      ui = {
        kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
      },
      outline = {
        keys = {
          toggle_or_jump = "l",
        },
      },
    })
  end,
}
