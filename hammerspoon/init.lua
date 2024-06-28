------------------------------------------------------------------------------------------------
---------   Don't use local or it will goes out of scope and gets garbage collected.   ---------
------------------------------------------------------------------------------------------------

-- -- 自动重新加载config
function ReloadConfig(files)
  local doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end

ConfigWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", ReloadConfig)
ConfigWatcher:start()

function SearchFromClipboard(url)
  -- 获取剪贴板内容
  local clipboardContent = hs.pasteboard.getContents()
  if clipboardContent then
    -- 对剪贴板内容进行 URL 编码
    local encodedContent = hs.http.encodeForQuery(clipboardContent)
    -- 构造谷歌搜索 URL
    local searchURL = url .. encodedContent
    -- 在默认浏览器中打开 URL
    hs.urlevent.openURL(searchURL)
  else
    -- 如果剪贴板为空，则显示通知
    hs.notify.new({ title = "Hammerspoon", informativeText = "Clipboard is empty" }):send()
  end
end

function SearchGoogleFromClipboard()
  SearchFromClipboard("https://www.google.com/search?q=")
end

function SearchYoutubeFromClipboard()
  SearchFromClipboard("https://www.youtube.com/results?search_query=")
end

hs.hotkey.bind({ "cmd", "ctrl" }, "g", SearchGoogleFromClipboard)
hs.hotkey.bind({ "cmd", "ctrl" }, "y", SearchYoutubeFromClipboard)

-- 从剪贴板获取内容并模仿打字出来
hs.hotkey.bind({ "cmd", "ctrl" }, "v", function()
  hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)

-- 加载 Caffeine.spoon
hs.loadSpoon("Caffeine")

hs.hotkey.bind({ "cmd", "ctrl" }, "c", function()
  spoon.Caffeine:start()
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "s", function()
  spoon.Caffeine:stop()
end)

-- 当选中某窗口按下 ctrl+command+. 时会显示应用的路径、名字等信息
hs.hotkey.bind({ "ctrl", "cmd" }, ".", function()
  hs.pasteboard.setContents(hs.window.focusedWindow():application():path())
  hs.alert.show(
    "App path:        "
      .. hs.window.focusedWindow():application():path()
      .. "\n"
      .. "App name:      "
      .. hs.window.focusedWindow():application():name()
      .. "\n"
      .. "IM source id:  "
      .. hs.keycodes.currentSourceID(),
    hs.alert.defaultStyle,
    hs.screen.mainScreen(),
    3
  )
end)

-- 这里指定中文和英文输入法的 ID
function Chinese()
  hs.keycodes.currentSourceID("im.rime.inputmethod.Squirrel.Hans")
end
function English()
  hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
end

local appInputMethod = {
  ["Alacritty"] = English,
  ["WezTerm"] = English,
  ["Google Chrome"] = English,
  ["WeChat"] = Chinese,
  ["QQ"] = Chinese,
}

-- activated 时切换到指定的输入法，deactivated 时恢复之前的状态
function ApplicationWatcher(appName, eventType, _)
  if eventType == hs.application.watcher.activated then
    for app, fn in pairs(appInputMethod) do
      if app == appName then
        fn()
      end
    end
  end
end

AppWatcher = hs.application.watcher.new(ApplicationWatcher)
AppWatcher:start()

-- 显示通知以确认配置已加载
hs.notify.new({ title = "Hammerspoon", informativeText = "Configuration Loaded" }):send()
