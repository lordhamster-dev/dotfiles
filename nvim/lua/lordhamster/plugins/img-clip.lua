return {
  -- https://github.com/HakonHarnes/img-clip.nvim
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    default = {
      dir_path = "Attachments",
      extension = "png",
      insert_mode_after_paste = false,
    },
    filetypes = {
      markdown = {
        url_encode_path = true,
        template = "![[Attachments/$FILE_NAME]]",
        download_images = false,
      },
    },
  },
  keys = {},
}
