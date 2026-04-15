---
name: obsidian
description: This skill should be used when working with Obsidian, a personal knowledge management and note-taking application. Use when the user wants to manage notes, search the vault, create or edit files, manage tasks, handle daily notes, work with tags/properties/links, or control Obsidian itself via the CLI.
---

## Overview

Obsidian CLI (`obsidian`) is a command-line interface that communicates with a running Obsidian instance to manage vaults, notes, tasks, bookmarks, plugins, themes, and more. All operations require Obsidian to be running.

## Command Syntax

```
obsidian <command> [options]
```

Options are passed as `key=value` pairs (quote values with spaces: `name="My Note"`). Use `\n` for newline, `\t` for tab in content values.

**Vault targeting:** Add `vault=<name>` to any command to target a specific vault.

**File resolution:**
- `file=<name>` resolves by note name (like wikilinks), searches entire vault
- `path=<path>` is exact path relative to vault root (e.g., `folder/note.md`)
- Most commands default to the active file when omitted

## Command Categories

### Vault & File Management

```bash
# Vault info
obsidian vault
obsidian vault info=name
obsidian vault info=path
obsidian vault info=files
obsidian vaults
obsidian vaults verbose

# List files and folders
obsidian files
obsidian files folder=Projects ext=md
obsidian files total
obsidian folders
obsidian folders folder=Projects

# File info
obsidian file file="My Note"
obsidian file path=folder/note.md

# Create, open, move, rename, delete
obsidian create name="New Note" content="# Title\nContent here"
obsidian create name="New Note" template="Daily Template" open
obsidian open file="My Note" newtab
obsidian move file="Old Name" to=Archive/
obsidian rename file="Old Name" name="New Name"
obsidian delete file="My Note"
obsidian delete path=folder/note.md permanent
```

### Reading & Writing Content

```bash
# Read note content
obsidian read file="My Note"
obsidian read path=Projects/todo.md

# Append / prepend content
obsidian append file="My Note" content="New line of content"
obsidian append file="Journal" content="- [ ] Task item" inline
obsidian prepend file="My Note" content="# Header\n"

# Word count
obsidian wordcount file="My Note"
obsidian wordcount file="My Note" words
obsidian wordcount file="My Note" characters
```

### Daily Notes

```bash
obsidian daily                          # Open today's daily note
obsidian daily paneType=tab
obsidian daily:path                     # Get path to today's daily note
obsidian daily:read                     # Read today's daily note
obsidian daily:append content="- [ ] Task for today"
obsidian daily:prepend content="## Morning\n"
```

### Search

```bash
obsidian search query="meeting notes"
obsidian search query="TODO" path=Projects limit=20
obsidian search query="keyword" case total
obsidian search query="term" format=json

# Search with surrounding context lines
obsidian search:context query="important decision"
obsidian search:context query="bug" path=Dev format=json

# Open search panel in Obsidian
obsidian search:open query="my query"
```

### Tasks

```bash
# List tasks
obsidian tasks
obsidian tasks todo
obsidian tasks done
obsidian tasks file="My Note"
obsidian tasks path=Projects/todo.md verbose
obsidian tasks format=json
obsidian tasks daily                    # Tasks from today's daily note

# Toggle / update a task (ref format: path:line)
obsidian task ref="Projects/todo.md:5" toggle
obsidian task ref="Projects/todo.md:5" done
obsidian task ref="Projects/todo.md:5" todo
obsidian task file="todo" line=5 toggle
obsidian task file="todo" line=5 status="/"   # Custom status char
```

### Tags & Properties

```bash
# Tags
obsidian tags
obsidian tags counts sort=count
obsidian tags file="My Note"
obsidian tag name="project" verbose     # Files using this tag

# Properties (frontmatter)
obsidian properties
obsidian properties file="My Note"
obsidian properties counts sort=count format=json

# Read / set / remove a specific property
obsidian property:read name="status" file="My Note"
obsidian property:set name="status" value="done" file="My Note"
obsidian property:set name="priority" value="high" type=text file="My Note"
obsidian property:set name="count" value="3" type=number file="My Note"
obsidian property:set name="done" value="true" type=checkbox file="My Note"
obsidian property:set name="due" value="2025-12-31" type=date file="My Note"
obsidian property:remove name="status" file="My Note"
```

### Links & Graph

```bash
obsidian links file="My Note"           # Outgoing links
obsidian links file="My Note" total
obsidian backlinks file="My Note"       # Incoming links
obsidian backlinks file="My Note" counts format=json
obsidian aliases                        # All aliases in vault
obsidian aliases file="My Note" verbose
obsidian unresolved                     # Broken/unresolved links
obsidian orphans                        # Notes with no incoming links
obsidian deadends                       # Notes with no outgoing links
```

### Outline & Structure

```bash
obsidian outline file="My Note"
obsidian outline file="My Note" format=json
obsidian outline file="My Note" format=md total
```

### Bookmarks

```bash
obsidian bookmarks
obsidian bookmarks verbose format=json
obsidian bookmark file=Projects/todo.md title="Project Tasks"
obsidian bookmark search="query" title="My Search"
obsidian bookmark url="https://example.com" title="Reference"
```

### History & Diff (Sync)

```bash
obsidian history file="My Note"
obsidian history:list
obsidian history:read file="My Note" version=2
obsidian history:restore file="My Note" version=2
obsidian diff file="My Note"
obsidian diff file="My Note" from=1 to=3
```

### Recents & Random

```bash
obsidian recents
obsidian recents total
obsidian random                         # Open a random note
obsidian random folder=Projects newtab
obsidian random:read                    # Read content of a random note
```

### Plugins & Themes

```bash
# Plugins
obsidian plugins
obsidian plugins filter=community versions format=json
obsidian plugins:enabled
obsidian plugin id=dataview
obsidian plugin:enable id=dataview
obsidian plugin:disable id=dataview
obsidian plugin:install id=dataview enable
obsidian plugin:uninstall id=dataview
obsidian plugin:reload id=dataview      # For developers
obsidian plugins:restrict on            # Enable restricted mode
obsidian plugins:restrict off

# Themes
obsidian themes
obsidian themes versions
obsidian theme                          # Show active theme
obsidian theme name="Minimal"
obsidian theme:set name="Minimal"
obsidian theme:set name=""              # Reset to default
obsidian theme:install name="Minimal" enable
obsidian theme:uninstall name="Minimal"

# CSS Snippets
obsidian snippets
obsidian snippets:enabled
obsidian snippet:enable name="my-snippet"
obsidian snippet:disable name="my-snippet"
```

### Commands & Hotkeys

```bash
obsidian commands
obsidian commands filter=editor
obsidian command id="editor:toggle-bold"
obsidian hotkeys
obsidian hotkeys all verbose format=json
obsidian hotkey id="editor:toggle-bold" verbose
```

### Workspaces & Tabs

```bash
obsidian workspaces
obsidian workspace
obsidian workspace:save name="My Layout"
obsidian workspace:load name="My Layout"
obsidian workspace:delete name="My Layout"
obsidian tabs
obsidian tabs ids
obsidian tab:open file=Projects/todo.md
```

### Bases (Database views)

```bash
obsidian bases
obsidian base:views file="My Base"
obsidian base:query file="My Base" view="Table" format=md
obsidian base:create file="My Base" view="Table" name="New Item"
```

### App Control

```bash
obsidian version
obsidian reload                         # Reload vault
obsidian restart                        # Restart Obsidian
obsidian web url="https://example.com" newtab
```

## Common Workflows

### Create a note from a template and append content
```bash
obsidian create name="Meeting 2025-01-15" template="Meeting Template" open
obsidian append file="Meeting 2025-01-15" content="## Notes\n- Discussed roadmap"
```

### Find all incomplete tasks across vault, then complete one
```bash
obsidian tasks todo verbose
obsidian task ref="Projects/todo.md:12" done
```

### Search for notes and read the best match
```bash
obsidian search query="project kickoff" format=json
obsidian read file="Project Kickoff"
```

### Bulk-tag notes via property:set
```bash
obsidian property:set name="status" value="active" type=text file="My Project"
```

### Add to today's daily note
```bash
obsidian daily:append content="- [ ] Review PR #42"
obsidian daily:read
```

### Explore vault structure
```bash
obsidian vault
obsidian files total
obsidian folders
obsidian tags counts sort=count
obsidian orphans
obsidian deadends
```

## Output Formats

Most list commands support `format=json|tsv|csv` (default: tsv). Use `format=json` when piping to other tools or when structured data is needed. Add `total` to return just the count.

## Tips

- Obsidian must be running for CLI commands to work.
- `file=<name>` uses fuzzy/wikilink-style resolution — prefer `path=<path>` for precision.
- Use `\n` in `content=` to insert real newlines.
- Chain multiple commands to build workflows (read → modify → append).
- Use `vault=<name>` when multiple vaults are open to avoid ambiguity.
- `obsidian help <command>` shows detailed help for any specific command.
