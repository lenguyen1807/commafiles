# pi sync config

Personal pi coding agent configuration, synced across machines via [commafiles](https://github.com/commafiles).

## Structure

```
.pi/
├── skills/           # Custom pi skills
│   └── tldraw-offline/   # tldraw canvas operator (adapted from codex)
├── extensions/       # Auto-discovered custom pi extensions
├── settings.json     # Global Pi settings (linked to ~/.pi/agent/settings.json)
├── zentui.json                      # Static Zentui configuration (linked to ~/.pi/agent/zentui.json)
├── subagents.json                   # Global pi-subagents settings (linked to ~/.pi/agent/subagents.json)
└── pi-latex.json                    # Global pi-latex rendering settings

pi-latex/                         # Editable offline LaTeX renderer package
pi-zentui/                        # Editable Zentui Pi extension package (git submodule)
pi-subagents/                     # Customized pi-subagents fork (git submodule)
```

## Skills

### tldraw-offline

Operate the tldraw Desktop canvas app via its local HTTP server. Inspect, edit, arrange, connect, lint, and script tldraw canvases.

Adapted from the OpenAI Codex `tldraw-offline` skill. See [SKILL.md](.pi/skills/tldraw-offline/SKILL.md).

## Extensions

### pi-latex

[pi-latex](pi-latex/) renders block LaTeX locally in Ghostty-compatible Pi sessions and leaves inline math as source text by default. It is loaded from the local checkout, and [.pi/pi-latex.json](.pi/pi-latex.json) is linked to `~/.pi/agent/pi-latex.json`; the configured render scale is `1.15`.

### Zentui

[Zentui](pi-zentui/) remains installed as a local package through `.pi/settings.json`. Its static configuration lives in [.pi/zentui.json](.pi/zentui.json); it provides the custom editor, user-message styling, and information-rich footer.

### pi-subagents

[pi-subagents](pi-subagents/) is a customized fork of [@tintinweb/pi-subagents](https://github.com/tintinweb/pi-subagents), kept as a git submodule because it adds features not yet upstream: child session lifecycle events for `@gotgenes/pi-permission-system`, soft model fallback for orchestrator-requested Agent models, and a selective orchestration Agent tool description with Explore/Plan retargeted to `read` + `fff` + `fetch_content`. [.pi/subagents.json](.pi/subagents.json) enables its most informative UI: the widget shows foreground and background agents, FleetView is enabled, full agent-tool descriptions are provided to the parent agent, transcripts are kept, and background results are delivered individually.

Use `/agents` to view running agents, their type, activity, token usage, and live conversations. The FleetView below the editor provides the same visibility while agents run.

```bash
cd config/pi/pi-subagents
npm ci --omit=dev
# edit files, then use /reload (or restart Pi) to apply changes
```

See the [Pi extension documentation](https://pi.dev/docs/latest/extensions) before modifying these extensions.

## Setup

Symlink or add the skills path to `~/.pi/agent/settings.json`:

```json
{
  "skills": [
    "/Users/lenguyen/Documents/Workspace/Github/commafiles/config/pi/.pi/skills"
  ]
}
```

Or symlink the entire config:

```bash
ln -sfn /Users/lenguyen/Documents/Workspace/Github/commafiles/config/pi/.pi/skills ~/.pi/agent/skills
```
