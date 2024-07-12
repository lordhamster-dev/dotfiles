-- Obsidian 🤝 Neovim
return {
  -- https://github.com/epwalsh/obsidian.nvim
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = function()
    vim.opt.conceallevel = 1
    vim.keymap.set("n", "gd", function()
      if require("obsidian").util.cursor_on_markdown_link() then
        return "<cmd>ObsidianFollowLink<CR>"
      else
        return "gd"
      end
    end, { noremap = false, expr = true })
    return {
      dir = "/Users/jacob/Library/Mobile Documents/iCloud~md~obsidian/Documents/LordHamster", -- no need to call 'vim.fn.expand' here
      notes_subdir = "3-Permanent",
      new_notes_location = "notes_subdir",
      -- Optional, customize how note IDs are generated given an optional title.
      ---@param title string|?
      ---@return string
      note_id_func = function(title)
        if title ~= nil then
          return title
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          local suffix = ""
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
          return tostring(os.time()) .. "-" .. suffix
        end
      end,
      templates = {
        subdir = "Z-Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M:%S",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {},
      },
      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "1-Daily",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        -- alias_format = "%B %-d, %Y",
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = "DailyTemplate",
      },
      completion = {
        -- If using nvim-cmp, otherwise set to false
        nvim_cmp = true,
        -- Trigger completion at 2 chars
        min_chars = 2,
        -- Where to put new notes created from completion. Valid options are
        --  * "current_dir" - put new notes in same directory as the current buffer.
        --  * "notes_subdir" - put new notes in the default notes subdirectory.
      },
      -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
      open_app_foreground = true,

      -- Optional, set to true if you don't want obsidian.nvim to manage frontmatter.
      disable_frontmatter = true,

      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        -- ["gf"] = require("obsidian.mapping").gf_passthrough(),
      },
      ui = {
        checkboxes = {
          -- [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          -- ["x"] = { char = "", hl_group = "ObsidianDone" },
          -- [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          -- ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
          -- Replace the above with this if you don't have a patched font:
          [" "] = { char = "", hl_group = "ObsidianTodo" },
          ["x"] = { char = "󰸞", hl_group = "ObsidianDone" },
          ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
          -- You can also add more custom ones...
        },
      },
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart({ "open", url }) -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
      end,
    }
  end,
}
