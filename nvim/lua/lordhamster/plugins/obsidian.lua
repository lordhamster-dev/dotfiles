-- Obsidian 🤝 Neovim
return {
  -- https://github.com/epwalsh/obsidian.nvim
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  cmd = { "ObsidianQuickSwitch", "ObsidianNew", "ObsidianSearch", "ObsidianDailies" },
  -- lazy = true,
  -- ft = "markdown",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = function()
    vim.keymap.set("n", "gd", function()
      if require("obsidian").util.cursor_on_markdown_link() then
        return "<cmd>ObsidianFollowLink<CR>"
      else
        return "gd"
      end
    end, { noremap = false, expr = true })
    return {
      dir = "~/Sync/Obsidian/LordHamster", -- no need to call 'vim.fn.expand' here
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
        nvim_cmp = false,
        -- Trigger completion at 2 chars
        min_chars = 2,
        -- Where to put new notes created from completion. Valid options are
        --  * "current_dir" - put new notes in same directory as the current buffer.
        --  * "notes_subdir" - put new notes in the default notes subdirectory.
      },
      -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
      open_app_foreground = true,

      -- Optional, set to true if you don't want obsidian.nvim to manage frontmatter.
      disable_frontmatter = false,

      -- Optional, alternatively you can customize the frontmatter data.
      ---@return table
      note_frontmatter_func = function(note)
        -- Add the title of the note as an alias.
        if note.title then
          note:add_alias(note.title)
        end

        local out = { related = "" }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,

      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        -- ["gf"] = require("obsidian.mapping").gf_passthrough(),
      },
      ui = {
        enable = false,
        checkboxes = {
          -- [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          -- ["x"] = { char = "", hl_group = "ObsidianDone" },
          -- [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          -- ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
          -- Replace the above with this if you don't have a patched font:
          [" "] = { char = "", hl_group = "ObsidianTodo" },
          ["x"] = { char = "󰸞", hl_group = "ObsidianDone" },
          -- You can also add more custom ones...
        },
      },
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart({ "open", url }) -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
      end,
      attachments = {
        -- The default folder to place images in via `:ObsidianPasteImg`.
        -- If this is a relative path it will be interpreted as relative to the vault root.
        -- You can always override this per image by passing a full path to the command instead of just a filename.
        img_folder = "Z-Attachments",
        -- A function that determines the text to insert in the note when pasting an image.
        -- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
        -- This is the default implementation.
        img_text_func = function(client, path)
          path = client:vault_relative_path(path) or path
          return string.format("![[%s]]", path.name)
        end,
      },
    }
  end,
  config = function(_, opts)
    require("obsidian").setup(opts)

    -- HACK: fix error, disable completion.nvim_cmp option, manually register sources
    local cmp = require("cmp")
    cmp.register_source("obsidian", require("cmp_obsidian").new())
    cmp.register_source("obsidian_new", require("cmp_obsidian_new").new())
    cmp.register_source("obsidian_tags", require("cmp_obsidian_tags").new())
  end,
}
