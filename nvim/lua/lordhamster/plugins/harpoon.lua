-- List of favorite files/marks per project
return {
  -- https://github.com/ThePrimeagen/harpoon
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    local conf = require("telescope.config").values
    harpoon:setup()

    local function make_finder(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end
      return require("telescope.finders").new_table({
        results = file_paths,
      })
    end

    vim.api.nvim_create_user_command("ToggleHarpoonList", function()
      require("telescope.pickers")
        .new({
          previewer = false,
          initial_mode = "normal",
          layout_config = {
            height = 0.4,
            width = 0.6,
          },
        }, {
          prompt_title = "Harpoon",
          finder = make_finder(harpoon:list()),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(bufnr, map)
            map("n", "dd", function()
              local state = require("telescope.actions.state")
              local selected_query = state.get_selected_entry()
              local current_picker = state.get_current_picker(bufnr)
              harpoon:list():remove_at(selected_query.index)
              current_picker:refresh(make_finder(harpoon:list()))
            end)
            return true
          end,
        })
        :find()
    end, { nargs = 0 })
  end,
}
