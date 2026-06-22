/**
 * Side Session Extension
 *
 * Adds a /side command to start a temporary session.
 * The session is automatically deleted when you switch away
 * via /new, /resume, /fork, /clone, or quit pi.
 *
 * Usage:
 *   /side                    Start a temp session with default prompt
 *   /side fix the login bug  Start a temp session with a specific task
 */

import { rmSync } from "node:fs";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const SIDE_MARKER = "side-session";

export default function (pi: ExtensionAPI) {
    // On session shutdown, clean up if this was a side session.
    // Skip reload since the session persists across reloads.
    pi.on("session_shutdown", async (event, ctx) => {
        if (event.reason === "reload") return;

        const isSideSession = ctx.sessionManager
            .getEntries()
            .some(
                (entry) =>
                    entry.type === "custom" && entry.customType === SIDE_MARKER,
            );
        if (!isSideSession) return;

        const sessionFile = ctx.sessionManager.getSessionFile();
        if (sessionFile) {
            try {
                rmSync(sessionFile);
            } catch {
                // Session file may already be gone; ignore errors
            }
        }
    });

    // Register the /side command
    pi.registerCommand("side", {
        description: "Start a temporary session (auto-deleted on switch/quit)",
        handler: async (args, ctx) => {
            const currentSessionFile = ctx.sessionManager.getSessionFile();

            const result = await ctx.newSession({
                parentSession: currentSessionFile,
                setup: (sm) => {
                    // Mark the new session as a side session
                    sm.appendCustomEntry(SIDE_MARKER);
                    sm.appendSessionInfo("Side Session");
                },
                withSession: async (replacementCtx) => {
                    if (args.trim()) {
                        replacementCtx.ui.setEditorText(args.trim());
                    }
                    replacementCtx.ui.notify(
                        "Side session — auto-deleted when you /new, /resume, or quit.",
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
