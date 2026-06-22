# DIDA CLI — API Reference

Full command-to-API mapping and field documentation.

## API mapping

| 命令 | Endpoint |
|---|---|
| `task get` | `GET /project/{projectId}/task/{taskId}` |
| `task create` | `POST /task` |
| `task update` | `POST /task/{taskId}` |
| `task complete` | `POST /project/{projectId}/task/{taskId}/complete` |
| `task delete` | `DELETE /project/{projectId}/task/{taskId}` |
| `task move` | `POST /task/move` |
| `task completed` | `POST /task/completed` |
| `task filter` | `POST /task/filter` |
| `task comment list` | `GET /project/{projectId}/task/{taskId}/comments` |
| `task comment add` | `POST /project/{projectId}/task/{taskId}/comment` |
| `task comment delete` | `DELETE /project/{projectId}/task/{taskId}/comment/{id}` |
| `project list` | `GET /project` |
| `project get` | `GET /project/{projectId}` |
| `project data` | `GET /project/{projectId}/data` |
| `project create` | `POST /project` |
| `project update` | `POST /project/{projectId}` |
| `project delete` | `DELETE /project/{projectId}` |
| `project group list` | `GET /project/group` |
| `project group create` | `POST /project/group` |
| `project group update` | `POST /project/group/{projectGroupId}` |
| `project group delete` | `DELETE /project/group/{projectGroupId}` |
| `project column list` | `GET /project/{projectId}/column` |
| `project column create` | `POST /project/{projectId}/column` |
| `project column update` | `POST /project/{projectId}/column/{columnId}` |
| `tag list` | `GET /tag` |
| `tag create` | `POST /tag` |
| `habit get` | `GET /habit/{habitId}` |
| `habit list` | `GET /habit` |
| `habit create` | `POST /habit` |
| `habit update` | `POST /habit/{habitId}` |
| `habit checkin` | `POST /habit/{habitId}/checkin` |
| `habit checkins` | `GET /habit/checkins` |
| `focus get` | `GET /focus/{focusId}?type=` |
| `focus list` | `GET /focus?from=&to=&type=` |
| `focus create` | `POST /focus` |
| `focus delete` | `DELETE /focus/{focusId}?type=` |
| `countdown list` | `GET /countdown` |

## Task fields

| 字段 | 含义 | CLI（create / update） |
|---|---|---|
| `id` | 任务 id（ObjectId 十六进制） | 仅 `update`：`<taskId>` 与 `--id` |
| `projectId` | 所属清单 | `--project` |
| `sortOrder` | 列表排序 | `--sort-order` |
| `title` | 标题，宜短；长文用 `content` | `--title` |
| `content` | 普通/笔记类任务的正文 | `--content` |
| `desc` | 清单类任务的说明 | `--desc` |
| `startDate` / `dueDate` | 时间；若不同，表示区间 | `--start-date`、`--due-date` |
| `timeZone` | 时区 | `--time-zone` |
| `isAllDay` | 是否全天 | `--all-day` |
| `priority` | `0` 无，`1` 低，`3` 中，`5` 高 | `--priority` |
| `reminders` | 提醒触发字符串 | `--reminders` |
| `repeatFlag` | 重复规则：`RRULE` 或 `ERULE` | `--repeat` |
| `completedTime` | 完成时间 | — |
| `status` | `0` 未完成，`-1` 已放弃，`2` 已完成 | — |
| `items` | 检查事项 | `--items` |
| `tags` | 标签 | `--tags`（逗号分隔） |
| `columnId` / `columnName` | 看板列 | — |
| `parentId` / `childIds` | 父子任务 | `--parent-id`（`null`/`none` 取消） |
| `focusSummaries` | 专注汇总 | `--estimated-duration`、`--estimated-pomo` |
| `kind` | 如 `TASK`、`NOTE`、`CHECKLIST` | — |

## Reminders format

`TRIGGER(;RELATED=START|END)?:(-)?P[nY][nM][nW][nD][T[nH][nM][nS]]`

| 字符串 | 含义 |
|---|---|
| `TRIGGER:-PT60M` | 参考时间前 60 分钟 |
| `TRIGGER:-P1DT2H` | 参考时间前 1 天 2 小时 |
| `TRIGGER;RELATED=END:-PT15M` | 结束时间前 15 分钟 |
| `TRIGGER:PT0S` | 准时 |

## Repeat format

- `RRULE:FREQ=DAILY`
- `RRULE:FREQ=WEEKLY;BYDAY=MO,WE`
- `RRULE:FREQ=MONTHLY;INTERVAL=1;BYMONTHDAY=1`
- `ERULE:NAME=CUSTOM;BYDATE=20260325,20260330`

## Check items (items[])

| 字段 | 含义 |
|---|---|
| `id` | 检查事项 id |
| `status` | `0` 未完成，`1` 已完成 |
| `title` | 检查事项文案 |
| `sortOrder` | 排序 |

## Focus summaries

| 字段 | 含义 | CLI |
|---|---|---|
| `estimatedDuration` | 预计专注时长（秒） | `--estimated-duration` |
| `estimatedPomo` | 预计番茄数（≤60） | `--estimated-pomo` |
| `pomoCount` | 已完成番茄数 | 只读 |
| `pomoDuration` | 番茄专注时长（秒） | 只读 |
| `stopwatchDuration` | 正计时时长（秒） | 只读 |

## Project fields

| 字段 | 含义 | CLI |
|---|---|---|
| `id` | 清单 id | 参数 |
| `name` | 名称 | `--name` |
| `color` | 颜色 | `--color` |
| `sortOrder` | 侧栏顺序 | — |
| `groupId` | 文件夹 id | — |
| `viewMode` | `list`、`kanban`、`timeline` | `--view-mode` |
| `kind` | `TASK` 或 `NOTE` | `--kind` |

## `project data` root object

| 字段 | 含义 |
|---|---|
| `project` | 清单对象 |
| `tasks` | 未完成任务数组 |
| `columns` | 看板列数组 |

## `task completed` request body

| JSON 字段 | CLI |
|---|---|
| `projectIds` | `--projects`（逗号分隔） |
| `startDate` / `endDate` | `--start-date`、`--end-date`（ISO 8601） |

## `task filter` request body

| JSON 字段 | CLI |
|---|---|
| `projectIds` | `--projects` |
| `startDate` / `endDate` | `--start-date`、`--end-date` |
| `priority` | `--priority`（`0,1,3,5`） |
| `tag` | `--tag`（逗号分隔） |
| `status` | `--status`（`0` 未完成，`2` 已完成） |

## `task move` request body

`--from`、`--to`、`--task` 各写同样次数，每次三元组对应 `fromProjectId`、`toProjectId`、`taskId`。

## Focus record fields

| 字段 | 含义 |
|---|---|
| `type` | `0` = pomodoro，`1` = timing |
| `taskId` | 关联任务 |
| `note` | 备注（≤5000 字符） |
| `startTime` / `endTime` | 时间范围 |
| `pauseDuration` | 暂停时长（秒） |
| `duration` | 专注时长（秒） |
