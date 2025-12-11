return {
  -- https://github.com/mrcjkb/rustaceanvim
  "mrcjkb/rustaceanvim",
  version = "^6", -- Recommended
  lazy = false, -- This plugin is already lazy
  ["rust-analyzer"] = {
    cargo = {
      allFeatures = true,
    },
  },
}
