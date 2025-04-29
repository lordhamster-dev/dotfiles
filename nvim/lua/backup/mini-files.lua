return {
  "echasnovski/mini.files",
  opts = {
    -- Module mappings created only inside explorer.
    -- Use `''` (empty string) to not create one.
    mappings = {
      close = "<esc>",
      go_in = "L",
      go_in_plus = "l",
      go_out = "h",
      go_out_plus = "H",
      mark_goto = "'",
      mark_set = "m",
      reset = "<BS>",
      reveal_cwd = "@",
      show_help = "g?",
      synchronize = "<space>w",
      trim_left = "<",
      trim_right = ">",
    },
  },
  config = function(_, opts)
    -- Set up mini.files
    require("mini.files").setup(opts)
  end,
}
