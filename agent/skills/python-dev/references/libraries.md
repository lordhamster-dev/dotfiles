# 常用库使用细则

选择依赖或编写涉及相关库的代码时读取；可根据任务定位到对应章节，不要求使用所有偏好库。

## 日志：`loguru`

- 未统一使用标准库 `logging` 时，优先使用 `loguru`；优先复用项目绑定上下文的 logger，如 `self.logger`，而不是另建全局日志入口。
- 日志包含操作、对象标识等必要上下文，但不能包含凭据或敏感载荷。
- 在需要保留堆栈的异常边界使用 `logger.exception("处理数据失败")`；记录后重新抛出或显式转换为失败状态，避免吞错后继续成功流程。
- 应用运行日志不用 `print()`；CLI 的有意输出、机器可读结果与日志分离。
- 库代码避免擅自配置全局日志，也不要在每一层重复记录同一异常。

## 终端输出：`rich`

- 面向人的表格、进度、面板和错误提示优先使用 `Console`、`Table`、`Progress`、`Panel` 等。
- `loguru` 负责运行日志，`rich` 负责终端呈现；Typer 命令按需要组合使用。
- 管道、重定向及机器解析场景保持输出稳定，不添加装饰、颜色或混入日志；沿用项目的纯文本或 JSON 输出契约。

## 配置：`pydantic-settings`

- 结构化应用配置优先使用 `pydantic-settings`，在配置边界统一读取、解析和校验，避免业务代码散落 `os.getenv()`。
- Pydantic v2 使用 `from pydantic_settings import BaseSettings, SettingsConfigDict`。
- 需要本地 `.env` 时显式配置 `SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")`；按需设置 `env_prefix`、`env_nested_delimiter`。
- 敏感字段优先使用 `SecretStr` / `SecretBytes`，但仍须审查日志、序列化与异常输出，不能将其视为完整脱敏保障。
- 真实密钥由项目认可的外部配置注入；不提交 `.env` 或将凭据写入代码、命令示例、调度文件和日志。新增配置同步 `.env.example` 及语义说明，仅用占位值。
- 仅需把本地 `.env` 加载到环境的小脚本，可使用 `python-dotenv`；不要为轻量脚本强加完整配置模型。

## 通知：`notifiers`

- 显式的完成、失败或运维通知可使用 `notifiers`；凭据与端点放在外部配置中。
- 普通通知失败不能覆盖原始任务结果；若告警可靠性本身是需求，则显式定义失败、重试和升级策略。

## HTTP 客户端：`httpx`

- 优先复用项目请求封装；无既定方案时使用 `httpx.Client` / `httpx.AsyncClient` 复用连接，并通过上下文管理器或显式关闭释放资源。
- 请求显式设置超时；除非有意处理状态码，否则调用 `response.raise_for_status()`。
- 重试、退避、限流与幂等边界必须明确；不要盲目重试有副作用的请求。
- 不关闭 TLS 校验，除非存在明确记录且仅限本地开发的理由。

## 表格数据：`polars`

- DataFrame 变换及 CSV / Parquet 处理优先考虑 `polars`；已有 pandas 工作流不因偏好而迁移。
- 大数据使用 `scan_*` 或延迟执行，小型简单变换可用立即执行；优先表达式而非逐行 Python 循环。
- 显式处理 schema、空值、类型转换及时间精度；仅在外部接口要求时转换到 pandas。

## 命令行应用：`typer`

- 使用带类型的参数定义命令契约，必要时用 `typer.Option` / `typer.Argument` 提供中文帮助与约束说明。
- 命令函数保持轻量，业务逻辑下沉到可测试函数或服务。
- 明确成功与失败退出码；有意失败可抛出 `typer.Exit(code=...)`，不得捕获异常后以成功码退出。
- 新增命令同步项目命令文档；影响常驻进程或调度时检查部署配置。

## 校验与模型：`pydantic`

- 在配置、API、抓取记录、消息和持久化边界使用模型；内部简单变换不必把每个字典模型化。
- 遵循已安装主版本：v2 使用 `field_validator` 等 API；v1 项目保持兼容，不顺手升级。
- 将字段归一化与校验放在合适的模型边界，错误保留必要上下文，不静默丢弃坏数据。
- 数据结构与校验规则尽量维护单一事实来源，复用现有模型和生成机制，避免重复定义后逐渐漂移。
- 涉及严格输入、赋值校验或时间约束时，按项目要求使用 `extra="forbid"`、`validate_assignment=True`、`AwareDatetime` 等，不能随意放宽既有约束。

## 文件系统：`pathlib`

- 新代码优先使用 `Path`，公共边界按需接受 `str | Path`，内部统一转换。
- 简单路径拼接用 `/`，文本读写显式指定编码，如 `path.read_text(encoding="utf-8")`。
- 权限、进程、环境变量或复制等操作按需保留 `os`、`shutil` 等，不为统一风格而强行替换。
