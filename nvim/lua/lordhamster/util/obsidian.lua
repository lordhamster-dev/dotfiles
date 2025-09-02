-- Obsidian integration utilities
-- Features:
-- 1. Open current file in Obsidian with proper vault and path format
-- 2. Removes file extensions
-- 3. Uses relative paths within the vault
-- 4. Cross-platform support with robust OS detection
-- 5. Advanced URI support with line numbers

local M = {}

-- OS type enumeration
M.OSType = {
  Linux = "Linux",
  Wsl = "Wsl",
  Windows = "Windows",
  Darwin = "Darwin",
  FreeBSD = "FreeBSD",
}

-- Configuration
M.config = {
  vault_name = "Obsidian",
  vault_path = "~/Sync/Obsidian", -- Default vault path
  use_advanced_uri = false, -- Enable advanced URI with line numbers
  open_app_foreground = false, -- macOS only: bring Obsidian to foreground
}

-- Cache for current OS
M._current_os = nil

-- Setup function for configuration
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- Get the running operating system
function M.get_os()
  if M._current_os ~= nil then
    return M._current_os
  end

  local this_os
  if vim.fn.has("win32") == 1 then
    this_os = M.OSType.Windows
  else
    local sysname = vim.loop.os_uname().sysname
    local release = vim.loop.os_uname().release:lower()
    if sysname:lower() == "linux" and string.find(release, "microsoft") then
      this_os = M.OSType.Wsl
    else
      this_os = sysname
    end
  end

  assert(this_os)
  M._current_os = this_os
  return this_os
end

-- URL encode a string
function M.urlencode(str, opts)
  opts = opts or {}
  local url = str
  url = url:gsub("\n", "\r\n")
  url = url:gsub("([^/%w _%%%-%.~])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)
  if not opts.keep_path_sep then
    url = url:gsub("/", function(c)
      return string.format("%%%02X", string.byte(c))
    end)
  end
  -- Use %20 for spaces instead of +
  url = url:gsub(" ", "%%20")
  return url
end

-- Get vault relative path
function M.get_vault_relative_path(file_path)
  local vault_path = vim.fn.expand(M.config.vault_path)
  local abs_file_path = vim.fn.fnamemodify(file_path, ":p")

  -- Normalize paths for comparison
  vault_path = vim.fn.fnamemodify(vault_path, ":p")

  -- Check if file is within vault directory
  if not vim.startswith(abs_file_path, vault_path) then
    return nil
  end

  -- Get relative path from vault root
  local relative_path = string.sub(abs_file_path, #vault_path + 1)

  -- Remove leading slash if present
  if vim.startswith(relative_path, "/") or vim.startswith(relative_path, "\\") then
    relative_path = string.sub(relative_path, 2)
  end

  return relative_path
end

-- Open file in Obsidian app
function M.open_in_obsidian_app(path)
  local this_os = M.get_os()

  -- Normalize path for Windows
  if this_os == M.OSType.Windows then
    path = string.gsub(path, "/", "\\")
  end

  local encoded_vault = M.urlencode(M.config.vault_name)
  local encoded_path = M.urlencode(path)

  local uri
  if M.config.use_advanced_uri then
    local line = vim.api.nvim_win_get_cursor(0)[1] or 1
    uri = string.format("obsidian://advanced-uri?vault=%s&filepath=%s&line=%d", encoded_vault, encoded_path, line)
  else
    uri = string.format("obsidian://open?vault=%s&file=%s", encoded_vault, encoded_path)
  end

  uri = vim.fn.shellescape(uri)

  local cmd, args
  local run_in_shell = true

  if this_os == M.OSType.Linux or this_os == M.OSType.FreeBSD then
    cmd = "xdg-open"
    args = { uri }
  elseif this_os == M.OSType.Wsl then
    cmd = "wsl-open"
    args = { uri }
  elseif this_os == M.OSType.Windows then
    run_in_shell = false
    cmd = "powershell"
    args = { "Start-Process", uri }
  elseif this_os == M.OSType.Darwin then
    cmd = "open"
    if M.config.open_app_foreground then
      args = { "-a", "/Applications/Obsidian.app", uri }
    else
      args = { "-a", "/Applications/Obsidian.app", "--background", uri }
    end
  else
    vim.notify("Open command does not support OS type '" .. this_os .. "'", vim.log.levels.ERROR)
    return
  end

  assert(cmd)
  assert(args)

  local cmd_with_args
  if run_in_shell then
    cmd_with_args = cmd .. " " .. table.concat(args, " ")
  else
    cmd_with_args = { cmd, unpack(args) }
  end

  vim.fn.jobstart(cmd_with_args, {
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.notify(
          string.format("Open command failed with exit code '%s': %s", exit_code, cmd_with_args),
          vim.log.levels.ERROR
        )
      else
        vim.notify("Opened in Obsidian", vim.log.levels.INFO)
      end
    end,
  })
end

-- Open current file in Obsidian with proper vault and path format
function M.open_in_obsidian()
  local file_path = vim.api.nvim_buf_get_name(0)
  if file_path == "" then
    vim.notify("No file is currently open", vim.log.levels.WARN)
    return
  end

  local relative_path = M.get_vault_relative_path(file_path)
  if relative_path == nil then
    vim.notify(string.format("File '%s' is not within the configured Obsidian vault", file_path), vim.log.levels.WARN)
    return
  end

  -- Remove file extension
  relative_path = vim.fn.fnamemodify(relative_path, ":r")

  M.open_in_obsidian_app(relative_path)
end

return M
