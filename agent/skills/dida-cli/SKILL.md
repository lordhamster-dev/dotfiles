---
name: dida-cli
description: Manage Dida365 (滴答清单) tasks, projects, habits, focus records, tags, and countdowns from the terminal. Use this skill whenever the user asks to interact with Dida/滴答清单, manage tasks, list today's tasks, create/complete/delete tasks or projects, track habits, record pomodoro sessions, check reminders, or mention dida/dida365/dida-cli. Wraps the @suibiji/dida-cli npm package.
---

# DIDA CLI

Use the `dida` CLI to manage 滴答清单 (Dida365) from the terminal. Requires prior authentication (`dida auth login` or `dida auth token <token>`).

## Quick start

Always check auth status first. If not logged in, guide the user to authenticate:

```bash
dida auth status              # check login state
dida auth login               # OAuth browser login (recommended)
dida auth token <token>       # paste token directly (from web → Settings → API Token)
```

## Key concepts

- **Project** = 清单 (list/board/timeline). Every task belongs to one.
- **Project ID** = a 24-char hex ObjectId string. Required for most task operations.
- **Priority**: `0`=none, `1`=low, `3`=medium, `5`=high.
- **Status**: `0`=incomplete, `2`=completed, `-1`=abandoned.
- **Date format**: `yyyy-MM-ddTHH:mm:ss+ZZZZ` (ISO 8601). Use `+0800` for China time.
- **Date stamp format**: `YYYYMMDD` for habit checkins.
- All commands accept `--json` for machine-readable output.

## Command reference

Run `dida --help` or `dida <command> --help` for the latest options. Below is the practical reference.

### Auth

```bash
dida auth login               # OAuth PKCE, opens browser
dida auth token <token>       # set token directly
dida auth status              # check if logged in
dida auth logout              # clear local token
```

### Projects (清单)

```bash
dida project list --json                     # list all projects
dida project data <projectId> --json         # project + tasks + columns (most useful for overview)
dida project create --name "工作" --color "#F18181" --view-mode list --kind TASK
dida project update <projectId> --name "新名字"
dida project delete <projectId>

# Groups (folders)
dida project group list
dida project group create --name "工作"

# Columns (kanban)
dida project column list <projectId>
dida project column create <projectId> --name "进行中"
```

### Tasks (任务)

```bash
# List/filter tasks — the primary way to find tasks
dida task filter --projects <id1,id2,...> --status 0 --json    # all incomplete
dida task filter --projects <ids> --priority 3,5 --status 0     # high-priority
dida task filter --projects <ids> --tag 工作,紧急 --status 0     # by tag

# Get/completed
dida task get <projectId> <taskId>
dida task completed --projects <id> --start-date "2026-06-01T00:00:00+0800" --end-date "2026-06-22T23:59:59+0800"

# Create
dida task create --title "买牛奶" --project <projectId>
dida task create --title "开会" --project <projectId> --priority 5 --due-date "2026-03-10T09:00:00+0800" --tags 工作,紧急
dida task create --title "日检" --project <projectId> --repeat "RRULE:FREQ=DAILY"

# Update — note: both positional <taskId> AND --id <taskId> are required
dida task update <taskId> --id <taskId> --project <projectId> --title "新标题"
dida task update <taskId> --id <taskId> --project <projectId> --tags 工作,紧急
dida task update <taskId> --id <taskId> --project <projectId> --parent-id null  # break parent-child link
dida task update <taskId> --id <taskId> --project <projectId> --estimated-pomo 5

# Complete/delete/move
dida task complete <projectId> <taskId>
dida task delete <projectId> <taskId>
dida task move --from <srcProjectId> --to <dstProjectId> --task <taskId>

# Comments
dida task comment list <projectId> <taskId>
dida task comment add <projectId> <taskId> --content "处理完成"
dida task comment delete <projectId> <taskId> <commentId>
```

### Tags (标签)

```bash
dida tag list
dida tag create --name urgent --label urgent
```

### Habits (习惯)

```bash
dida habit list
dida habit get <habitId>
dida habit create --name "喝水" --repeat "RRULE:FREQ=DAILY;INTERVAL=1" --goal 8 --unit 杯
dida habit update <habitId> --goal 2000 --unit ml
dida habit checkin <habitId> --stamp 20260424 --value 1
dida habit checkins --habits <id> --from 20260401 --to 20260430
```

### Focus (专注/番茄钟)

```bash
dida focus list --from "2026-06-01T00:00:00+0800" --to "2026-06-22T23:59:59+0800" --type pomodoro
dida focus create --type pomodoro --task-id <taskId> --start-time "2026-06-22T09:00:00+0800" --end-time "2026-06-22T09:25:00+0800" --duration 1500
dida focus delete <focusId> --type pomodoro
```

- `--duration` is in seconds (1500 = 25 min)
- `--type`: `0` or `pomodoro`, `1` or `timing`

### Countdown (倒数日)

```bash
dida countdown list
```

# Common workflows

## List today's tasks across all projects

```bash
# Step 1: get all project IDs
dida project list --json

# Step 2: filter all incomplete tasks
dida task filter --projects <comma-separated-ids> --status 0 --json

# Then examine dueDate/startDate fields to identify today/overdue tasks.
# Tasks with dueDate < today are overdue.
# Tasks with no dates are unscheduled.
```

## Check what's due this week

Same as above, but pay attention to tasks where `dueDate` falls within the current week. For recurring tasks with `repeatFlag`, the displayed date is the current occurrence.

## Create a task with reminder

```bash
dida task create --title "周报" --project <projectId> \
  --due-date "2026-06-22T17:00:00+0800" \
  --reminders "TRIGGER:-PT30M"
```

## Complete a task found by title

When you have a task ID (from filter output), complete it directly:

```bash
dida task complete <projectId> <taskId>
```

## Important notes

- `task update` requires the task ID **twice**: once as positional arg `<taskId>` and once as `--id <taskId>`. This mirrors the API body requirement.
- `--parent-id null` or `--parent-id none` breaks parent-child task links.
- Habit checkin uses `--stamp YYYYMMDD` (not ISO).
- Focus `--duration` is in seconds, not minutes.
- ISO dates use `+0800` for China Standard Time (CST), not `+08:00`.
- The API returns dates in UTC (`+0000`). Convert mentally when reading: add 8 hours for CST.

## Timezone handling

Dida stores dates in UTC. When creating tasks in CST (UTC+8):

- Midnight CST = `16:00:00.000+0000` UTC of the **previous** day
- Setting `isAllDay` + a date typically uses `yyyy-MM-ddT16:00:00.000+0000` for China-based accounts

When reading task dates in JSON output:

- UTC `2026-06-21T16:00:00.000+0000` = 2026-06-22 00:00 CST
- A task with `isAllDay: true` and `dueDate: "2026-06-21T16:00:00.000+0000"` is due on June 22 in CST

Full API field reference: [references/api-reference.md](references/api-reference.md)
