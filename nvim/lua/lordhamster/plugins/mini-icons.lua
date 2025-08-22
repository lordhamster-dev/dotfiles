-- Icon provider. Part of 'mini.nvim' library.
return {
  -- https://github.com/echasnovski/mini.icons
  "echasnovski/mini.icons",
  version = "*",
  config = function()
    require("mini.icons").setup() -- Set up mini.icons
    require("mini.icons").mock_nvim_web_devicons()
  end,
}
