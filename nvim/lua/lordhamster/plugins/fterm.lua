return {
  "numToStr/FTerm.nvim",
  config = function()
    local fterm = require("FTerm")

    fterm.setup({
      border = "double",
      blend = 5,
      dimensions = {
        height = 0.90,
        width = 0.90,
        x = 0.5,
        y = 0.5,
      },
    })

    local btop = fterm:new({
      ft = "fterm_btop",
      cmd = "btop",
    })

    local lazygit = fterm:new({
      ft = "fterm_lazygit",
      cmd = "lazygit",
    })

    vim.keymap.set("n", "<A-b>", function()
      btop:toggle()
    end)
    vim.keymap.set("n", "<A-g>", function()
      lazygit:toggle()
    end)

    -- vim.api.nvim_create_user_command("NPMRunBuild", function()
    -- 	require("FTerm").scratch({ cmd = { "npm", "run", "build" } })
    -- end, { bang = true })
    --
    -- vim.api.nvim_create_user_command("NPMRunDeploy", function()
    -- 	require("FTerm").scratch({ cmd = { "npm", "run", "deploy" } })
    -- end, { bang = true })
  end,
}
