# 依赖、测试与安全细则

添加或更新依赖、编写测试、处理安全敏感代码或进行代码交付验证时读取；按任务选择适用章节与检查范围。

## 依赖管理

优先执行项目认可的命令；在 `uv` 项目中通常使用：

```bash
uv sync                         # 按项目锁文件同步环境
uv add <package>                # 添加运行依赖
uv add --dev <package>          # 添加开发依赖
uv add --group <name> <package> # 添加命名开发组依赖
```

- 运行依赖放在 `[project.dependencies]`，公开可选功能放在 `[project.optional-dependencies]`，内部开发工具放在 `[dependency-groups]`。
- 使用依赖管理器更新锁文件，不手动编辑锁文件；依赖改动后检查清单与锁文件是否一致。

## 测试与质量检查

- 修复缺陷时补充可复现的回归测试；行为变化时更新相应测试，不通过删除断言掩盖问题。
- 使用小而明确的 pytest 测试、fixture 与 `pytest.mark.parametrize`；fixture 不隐藏业务控制流。
- 单元测试隔离网络、时间与外部服务；文件操作优先使用临时目录。明确标记和配置需要真实服务的集成测试，不意外访问生产资源。
- 数据模型、日期边界和输入组合较多时，复用项目的 Hypothesis 属性测试。
- Typer 命令按需使用 `typer.testing.CliRunner`，检查参数、输出及失败退出码。
- 优先运行受影响的测试，再按项目完成定义扩展范围。无既定命令时使用：

```bash
uv run pytest <相关测试路径>
uv run ruff check <相关路径>
uv run ruff format --check <相关路径>
uv run pyright
```

- 项目要求全量检查时运行 `uv run pytest`、`uv run ruff check .`、`uv run ruff format --check .`；pyright 遵循项目检查范围。
- `ruff check --fix` 和 `ruff format` 会修改文件，只对明确范围使用并审查差异；交付验证默认使用只读检查。

## 安全检查

- 子进程优先使用 `subprocess.run([...], shell=False, check=True, timeout=...)`；不将不可信输入传给 `shell=True`。
- 不对不可信数据使用 `pickle` 或不安全的 YAML 反序列化。
- 用户可控路径在读写、删除、归档解压前验证边界，防止路径穿越及越界操作。
- 复查日志、异常、CLI 输出、测试快照和配置示例，确保未泄漏凭据。
