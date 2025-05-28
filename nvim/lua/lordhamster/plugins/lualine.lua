-- A blazing fast and easy to configure neovim statusline plugin written in pure lua.
return {
  -- https://github.com/nvim-lualine/lualine.nvim
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- import lualine plugin safely
    local lualine = require("lualine")

    local hide_in_width = function()
      return vim.fn.winwidth(0) > 80
    end

    local diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      sections = { "error", "warn" },
      symbols = { error = " ", warn = " " },
      colored = true,
      update_in_insert = false,
      always_visible = true,
      separator = { left = "", right = "" },
    }

    local diff = {
      "diff",
      colored = false,
      symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
      cond = hide_in_width,
    }

    local mode = {
      "mode",
      -- fmt = function(str)
      -- 	return "-- " .. str .. " --"
      -- end,
      separator = { left = "", right = "" },
    }

    local filetype = {
      "filetype",
      icons_enabled = false,
      icon = nil,
    }

    local branch = {
      "branch",
      icons_enabled = true,
      icon = "",
    }

    local location = {
      "location",
      padding = { left = 0, right = 1 },
      separator = { left = "", right = "" },
    }

    local progress = {
      "progress",
      padding = { left = 1, right = 0 },
      separator = { left = "", right = "" },
    }

    local filename = {
      "filename",
      -- 0: Just the filename
      -- 1: Relative path
      -- 2: Absolute path
      -- 3: Absolute path, with tilde as the home directory
      -- 4: Filename and parent dir, with tilde as the home directory
      path = 1,
      symbols = {
        modified = "", -- Text to show when the file is modified.
        readonly = "[Read Only]", -- Text to show when the file is non-modifiable or readonly.
        unnamed = "[No Name]", -- Text to show for unnamed buffers.
        newfile = "[New]", -- Text to show for newly created file before first write
      },
      fmt = function(str)
        -- 如果是终端缓冲区，返回空字符串
        if vim.bo.buftype == "terminal" then
          return ""
        end
        return str -- 否则返回原始文件名
      end,
    }

    local tabs = {
      "tabs",
      max_length = vim.o.columns,
      -- 0: Shows tab_nr
      -- 1: Shows tab_name
      -- 2: Shows tab_nr + tab_name
      mode = 2,
      -- 0: just shows the filename
      -- 1: shows the relative path and shorten $HOME to ~
      -- 2: shows the full path
      -- 3: shows the full path and shorten $HOME to ~
      path = 0,
    }

    local buffers = {
      "buffers",
      -- 0: Shows buffer name
      -- 1: Shows buffer index
      -- 2: Shows buffer name + buffer index
      -- 3: Shows buffer number
      -- 4: Shows buffer name + buffer number
      mode = 2,
      separator = { left = "", right = "" },
      right_padding = 2,
      symbols = { alternate_file = "" },
      max_length = vim.o.columns * 0.75,
      filetype_names = {
        TelescopePrompt = " Telescope",
        dashboard = " Dashboard",
        packer = " Packer",
        fzf = "FZF",
        alpha = " Alpha",
        oil = "󰏇  Oil",
        checkhealth = "󰥱 Checkhealth",
        harpoon = "󰈺 Harpoon",
        fugitive = "Fugitive",
      },
      buffers_color = {
        active = "lualine_a_normal",
        inactive = "lualine_b_normal",
      },
    }

    local spaces = function()
      return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
    end

    -- configure lualine with modified theme
    lualine.setup({
      options = {
        icons_enabled = true,
        theme = "catppuccin",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "alpha", "dashboard", "Avante", "NvimTree", "Outline", "oil", "", "codecompanion" }, -- "" 表示terminal
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { branch, diagnostics },
        lualine_c = {
          {
            require("noice").api.status.command.get,
            cond = require("noice").api.status.command.has,
            color = { fg = "#ff9e64" },
          },
          {
            require("noice").api.status.mode.get,
            cond = require("noice").api.status.mode.has,
            color = { fg = "#ff9e64" },
          },
        },
        lualine_x = { diff, spaces, "encoding", filetype },
        lualine_y = { location },
        lualine_z = { progress },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {
        lualine_a = { tabs },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { filename },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { filename },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = {},
    })
  end,
}
