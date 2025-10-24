# 🧩 CSC Config Repository

This repository contains the **official Counter-Strike 2 (CS2)** configuration files for CSC server modes: **Match**, **Scrim**, **Combine**, and **Preseason**.

All configuration files follow a unified, documented structure and are automatically version-stamped using Git commit metadata.

---

## 📂 Repository Structure

```
configs/
├── Match/
│   └── cfg/
│       ├── gamemode_competitive_server.cfg
│       ├── server.cfg
│       └── MatchZy/
│           ├── config.cfg
│           ├── live_override.cfg
│           └── warmup.cfg
├── Scrim/
│   └── cfg/
│       ├── gamemode_competitive_server.cfg
│       ├── server.cfg
│       └── MatchZy/
│           ├── config.cfg
│           ├── live_override.cfg
│           └── warmup.cfg
├── Combine/
│   └── cfg/
│       ├── gamemode_competitive_server.cfg
│       ├── server.cfg
│       └── MatchZy/
│           ├── config.cfg
│           ├── live_override.cfg
│           └── warmup.cfg
└── Preseason/
    └── cfg/
        ├── gamemode_competitive_server.cfg
        ├── server.cfg
        └── MatchZy/
            ├── config.cfg
            ├── live_override.cfg
            └── warmup.cfg
tools/
├── update_headers.sh
├── cfg_linter.sh
└── generate_mode_diffs.sh
```

Each mode is self-contained with its own config chain and MatchZy files.

---

## 🔁 Execution Behavior (What runs when)

- **`server.cfg`** — *automatically loaded* by the server on start.
- **`MatchZy/config.cfg`** — *automatically executed* when the MatchZy plugin loads.
- **`gamemode_competitive_server.cfg`** — executed by the server when the **gamemode** is set (competitive).
- **`MatchZy/live_override.cfg`** — executed **after all players ready up** and MatchZy applies its live settings.
- **`MatchZy/warmup.cfg`** — executed when the plugin loads for warmup.

> Each file includes a standardized header and a final `say` line for on-server version verification.

---

## 🧾 Header Format

All configuration files begin with a standardized header:

```cfg
// =========================================================
// CSC Config File
// Path: Match/cfg/server.cfg
// Version: <commit hash>
// Last Updated: <date>
// =========================================================
```

`<commit hash>` and `<date>` are auto-stamped by our script/hook.

---

## 🔄 Automated Header Updates

All `.cfg` files under `configs/` are version-stamped automatically.

### Manual run

```bash
tools/update_headers.sh
```

### Pre-commit hook

Installs a hook that stamps and stages any changed config headers before every commit:

```bash
chmod +x .git/hooks/pre-commit
```

Skip for a single commit:

```bash
SKIP_HEADER_STAMP=1 git commit -m "skip stamping this time"
```

---

## 🧰 Script Reference

### `tools/update_headers.sh`

* Updates `// Path`, `// Version`, and `// Last Updated` in every `configs/**/*.cfg`.
* Trims leading `configs/` from paths to match in-game expectations.
* Prepends a header if missing.
* Portable across Linux/macOS/WSL.

### `.git/hooks/pre-commit`

* Calls `tools/update_headers.sh`, `tools/cfg_linter.sh`, and `tools/generate_mode_diffs.sh`.
* Auto-stages modified config files under `configs/` and regenerates `modes.md`.

### `tools/cfg_linter.sh`

* Validates header presence, footer `say` lines, and field expectations such as `// Path:`.
* Fails fast when configs drift from the documented structure.

### `tools/generate_mode_diffs.sh`

* Produces `modes.md`, a tabular comparison of per-mode configuration differences.
* Keeps auditors informed of intentional deltas between Match, Scrim, Combine, and Preseason.

---

## ✅ Version Verification In-Game

Every config ends with a line like:

```cfg
say "> CSC Config Loaded | server.cfg | <commit hash> | <date> <"
```

These messages appear in console/GOTV logs and confirm the exact commit that was applied.

---

## ⚙️ Deployment Notes

* Copy the desired mode folder from `configs/<Mode>/cfg/` into the server’s cfg path.
* `server.cfg` and MatchZy’s `config.cfg` will auto-execute on load; `gamemode_competitive_server.cfg` executes when the server sets competitive mode; `MatchZy/live_override.cfg` executes when players ready up.
* The stamped **Version** and **Last Updated** lines reflect the deployed commit.

---

## 🚀 Quick Start

1. **Clone**

   ```bash
   git clone <repo-url> csc-configs && cd csc-configs
   ```

2. **Make helper scripts executable**

   ```bash
   chmod +x tools/*.sh .git/hooks/pre-commit
   ```

3. **Stamp headers (once or anytime)**

   ```bash
   tools/update_headers.sh
   ```

4. **Edit configs** under `configs/<Mode>/cfg/…`

5. **Commit**

   ```bash
   git add -A
   git commit -m "Update Match configs"
   git push
   ```

6. **Deploy** the `configs/<Mode>/cfg/` files to the server.
