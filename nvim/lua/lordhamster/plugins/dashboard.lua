return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  config = function()
    local logo = [[
       ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
       ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
       ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
       ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
       ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
       ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           
    ]]
    logo = string.rep("\n", 8) .. logo .. "\n"
    require("dashboard").setup({
      theme = "doom",
      config = {
        header = vim.split(logo, "\n"),
        center = {
          {
            action = "Telescope find_files",
            desc = " Find file",
            icon = " ",
            key = "<leader>ff",
          },
          {
            action = "Telescope oldfiles",
            desc = " Recent files",
            icon = " ",
            key = "<leader>fr",
          },
          {
            action = "Telescope find_files cwd=~/.config/nvim",
            desc = " Config files",
            icon = " ",
            key = "<leader>cc",
          },
          {
            action = "Lazy",
            desc = " Lazy",
            icon = "󰒲 ",
            key = "<leader>lz",
          },
          { action = "qa", desc = " Quit", icon = " ", key = "<leader>q" },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            -- stylua: ignore
            return { "⚡ Neovim loaded "..stats.loaded.."/"..stats.count.." plugins in "..ms.."ms" }
        end,
      },
    })
  end,
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
