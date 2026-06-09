/**
 * Pi Notify-Send Extension
 *
 * Sends a desktop notification via `notify-send` (libnotify) when the Pi agent
 * finishes processing and is waiting for input.
 *
 * Requires: libnotify (`notify-send` command available on PATH)
 */

import { execFile } from "node:child_process";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

function sendNotification(title: string, body: string): Promise<void> {
    return new Promise((resolve) => {
        execFile("notify-send", [title, body], (error) => {
            if (error && (error as NodeJS.ErrnoException).code === "ENOENT") {
                // notify-send not installed — silently ignore
            }
            resolve();
        });
    });
}

export default function (pi: ExtensionAPI) {
    pi.on("agent_end", async () => {
        await sendNotification("Pi", "🥳 Task completed!");
    });
}
