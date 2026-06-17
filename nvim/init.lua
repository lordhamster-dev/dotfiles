require("vim._core.ui2").enable({})

-- ==============================================================
-- 通用 Neovim 设置
-- ==============================================================
require("options")

-- ==============================================================
-- 插件配置
-- ==============================================================
require("plugins.common")
require("plugins.theme")
require("plugins.lsp")
require("plugins.treesitter")
require("plugins.mini")
require("plugins.snacks")
require("plugins.lualine")
require("plugins.blink")
require("plugins.git")
require("plugins.which-key")
