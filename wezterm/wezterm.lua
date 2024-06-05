local wezterm = require("wezterm")
local config = {
  font_size = 11,
  color_scheme = "Catppuccin Mocha",
  font = wezterm.font("CaskaydiaCove Nerd Font Mono", { weight = "Bold" }),
  use_fancy_tab_bar = true,
  show_new_tab_button_in_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  window_decorations = "RESIZE",
  -- window_background_opacity = 0.8,
  -- macos_window_background_blur = 10,
  -- text_background_opacity = 0.8,
  adjust_window_size_when_changing_font_size = false,
  window_close_confirmation = "NeverPrompt",
  warn_about_missing_glyphs = false,
  window_padding = {
    left = 7,
    right = 5,
    top = 10,
    bottom = 5,
  },
  window_background_image = "/Users/jacob/Library/Mobile Documents/com~apple~CloudDocs/Wallpapers/nasa.jpg",
  window_background_image_hsb = {
    -- Darken the background image by reducing it to 1/3rd
    brightness = 0.3,
    -- You can adjust the hue by scaling its value.
    -- a multiplier of 1.0 leaves the value unchanged.
    hue = 1.0,
    -- You can adjust the saturation also.
    saturation = 1.0,
  },
}

return config
