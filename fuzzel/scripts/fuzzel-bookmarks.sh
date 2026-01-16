#!/bin/bash

# --- 配置区 ---
# 书签文件的路径
BOOKMARKS_FILE="$HOME/Sync/Obsidian/3-Permanent/Bookmarks.md"
# 默认浏览器 (或者使用 xdg-open)
BROWSER="xdg-open"

# 检查文件是否存在
if [ ! -f "$BOOKMARKS_FILE" ]; then
    notify-send "Error" "书签文件未找到: $BOOKMARKS_FILE"
    exit 1
fi

# 1. 解析 Markdown 文件中的链接
# 正则说明: 匹配 [标题](链接)，提取出 "标题 | 链接"
# 我们排除掉没有 http 的链接（比如本地锚点）
list=$(grep -oP '\[.*?\]\(http.*?\)' "$BOOKMARKS_FILE" | sed -E 's/\[(.*)\]\((.*)\)/\1 | \2/' | sort -t'|' -k1,1f)

# 2. 调用 fuzzel 让用户选择
# -i: 忽略大小写
choice=$(echo "$list" | fuzzel -d -i -p " ")

# 3. 如果用户做出了选择，提取链接并打开
if [ -n "$choice" ]; then
    # 获取最后一个 '|' 符号之后的内容（即 URL）并去除空格
    url=$(echo "$choice" | awk -F ' | ' '{print $NF}' | tr -d ' ')
    $BROWSER "$url"
fi
