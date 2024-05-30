------------------------------------------------------------------------------------------------
---------   Don't use local or it will goes out of scope and gets garbage collected.   ---------
------------------------------------------------------------------------------------------------

-- -- 自动重新加载config
function reloadConfig(files)
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

hsConfigWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig)
hsConfigWatcher:start()

function searchFromClipboard(url)
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

function searchGoogleFromClipboard()
	searchFromClipboard("https://www.google.com/search?q=")
end

function searchYoutubeFromClipboard()
	searchFromClipboard("https://www.youtube.com/results?search_query=")
end

hs.hotkey.bind({ "cmd", "ctrl" }, "g", searchGoogleFromClipboard)
hs.hotkey.bind({ "cmd", "ctrl" }, "y", searchYoutubeFromClipboard)

-- 从剪贴板获取内容并模仿打字出来
hs.hotkey.bind({ "cmd", "ctrl" }, "v", function()
	hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)

-- -- 加载 Caffeine.spoon
-- hs.loadSpoon("Caffeine")
--
-- -- 在菜单栏添加一个图标来控制 Caffeine.spoon
-- spoon.Caffeine:bindHotkeys({
-- 	toggle = { { "cmd", "ctrl" }, "C" },
-- })
--
-- -- 启动 Caffeine.spoon 并设置默认状态
-- spoon.Caffeine:start()

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
	hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
end
function English()
	hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
end

-- activated 时切换到指定的输入法，deactivated 时恢复之前的状态
function applicationWatcher(appName, eventType, _)
	if eventType == hs.application.watcher.activated then
		if appName == "Alacritty" then
			English()
		else
			Chinese()
		end
	end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

-- 显示通知以确认配置已加载
hs.notify.new({ title = "Hammerspoon", informativeText = "Configuration Loaded" }):send()
