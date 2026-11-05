# Network Inspection

Inspect the requests a page made, then drill into one entry. This is the replacement for the old `network` command, which no longer exists.

## List requests

```bash
playwright-cli requests                  # XHR/fetch/document requests since load
playwright-cli requests --static         # include images, fonts, scripts, styles
playwright-cli requests --filter="/api/.*user"   # regex on the URL
playwright-cli requests --clear          # clear the list, then keep recording
```

Each entry is printed with a 1-based index. `request`, `request-headers`, `request-body`, `response-headers` and `response-body` all take that index.

## Inspect one request

```bash
playwright-cli request 3                       # headers + body + response
playwright-cli request 3 --filename=req3.json  # save instead of printing
playwright-cli request-headers 3
playwright-cli request-body 3
playwright-cli response-headers 3
playwright-cli response-body 3
```

Textual bodies are inlined. Binary bodies (images, PDFs, archives) are written to a file and the path is printed.

## Simulate connectivity

```bash
playwright-cli network-state-set offline
playwright-cli network-state-set online
```

Useful for testing retry banners, offline caches, and service-worker fallbacks.

## Typical debugging flow

```bash
playwright-cli open https://app.example.com
playwright-cli click e12
playwright-cli requests --filter="/api/"
playwright-cli response-body 4
playwright-cli console warning
playwright-cli close
```

## Related

- [`request-mocking.md`](request-mocking.md) — intercept, modify, or block requests with `route` / `unroute`
- [`tracing.md`](tracing.md) — full trace with network waterfall and timings
