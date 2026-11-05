# Video Recording

Capture browser automation sessions as video for debugging, documentation, or verification. Produces WebM (VP8/VP9 codec).

## Basic Recording

```bash
# Start recording
playwright-cli video-start

# Perform actions
playwright-cli open https://example.com
playwright-cli snapshot
playwright-cli click e1
playwright-cli fill e2 "test input"

# Stop and save
playwright-cli video-stop demo.webm
```

## Chapters and action annotations

```bash
playwright-cli video-start

# Mark a section of the recording
playwright-cli video-chapter "Login" --description="credential entry" --duration=1500

# Overlay each action with its name and a highlighted target
playwright-cli video-show-actions --duration=500 --position=top-right --cursor=pointer

playwright-cli video-hide-actions
playwright-cli video-stop demo.webm
```

`--position` accepts `top-left`, `top`, `top-right`, `bottom-left`, `bottom`, `bottom-right`; `--cursor` accepts `pointer` or `none`.

## Best Practices

### 1. Use Descriptive Filenames

```bash
# Include context in filename
playwright-cli video-stop recordings/login-flow-2024-01-15.webm
playwright-cli video-stop recordings/checkout-test-run-42.webm
```

## Tracing vs Video

| Feature | Video | Tracing |
|---------|-------|---------|
| Output | WebM file | Trace file (viewable in Trace Viewer) |
| Shows | Visual recording | DOM snapshots, network, console, actions |
| Use case | Demos, documentation | Debugging, analysis |
| Size | Larger | Smaller |

## Limitations

- Recording adds slight overhead to automation
- Large recordings can consume significant disk space
