/**
 * Temporary Session Extension
 *
 * Adds a /tmp command to start a temporary session.
 * The session is automatically deleted when you switch away
 * via /new, /resume, /fork, /clone, or quit pi.
 *
 * Usage:
 *   /tmp                    Start a temp session with default prompt
 *   /tmp fix the login bug  Start a temp session with a specific task
 */

import { rmSync } from "node:fs";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const TMP_MARKER = "tmp-session";

export default function (pi: ExtensionAPI) {
    // On session shutdown, clean up if this was a temporary session.
    // Skip reload since the session persists across reloads.
    pi.on("session_shutdown", async (event, ctx) => {
        if (event.reason === "reload") return;

        const isTempSession = ctx.sessionManager
            .getEntries()
            .some(
                (entry) =>
                    entry.type === "custom" && entry.customType === TMP_MARKER,
            );
        if (!isTempSession) return;

        const sessionFile = ctx.sessionManager.getSessionFile();
        if (sessionFile) {
            try {
                rmSync(sessionFile);
            } catch {
                // Session file may already be gone; ignore errors
            }
        }
    });

    // Register the /tmp command
    pi.registerCommand("tmp", {
        description: "Start a temporary session (auto-deleted on switch/quit)",
        handler: async (args, ctx) => {
            const currentSessionFile = ctx.sessionManager.getSessionFile();

            const result = await ctx.newSession({
                parentSession: currentSessionFile,
                setup: (sm) => {
                    // Mark the new session as temporary
                    sm.appendCustomEntry(TMP_MARKER);
                    sm.appendSessionInfo("Temporary Session");
                },
                withSession: async (replacementCtx) => {
                    if (args.trim()) {
                        replacementCtx.ui.setEditorText(args.trim());
                    }
                    replacementCtx.ui.notify(
                        "Temporary session — auto-deleted when you /new, /resume, or quit.",
                        "info",
                    );
                },
            });

            if (result.cancelled) {
                ctx.ui.notify("Cancelled", "info");
            }
        },
    });
}
