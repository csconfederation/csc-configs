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
│       └── ...
├── Combine/
│   └── cfg/
│       └── ...
└── Preseason/
    └── cfg/
        └── ...
tools/
├── update_headers.sh
├── cfg_linter.sh
├── generate_mode_diffs.sh
└── pre-commit.hook
```

Each mode is self-contained with its own config chain and MatchZy files.

---

## 🔁 Execution Behavior (What runs when)

- **`server.cfg`** — *automatically loaded* by the server on start.
- **`MatchZy/config.cfg`** — *automatically executed* when the MatchZy plugin loads.
- **`gamemode_competitive_server.cfg`** — executed by the server when the **gamemode** is set (competitive).
- **`MatchZy/live_override.cfg`** — executed **after all players ready up** and MatchZy applies its live settings.
- **`MatchZy/warmup.cfg`** — executed when the plugin loads for warmup.

> Each Counter-Strike config includes a standardized header and a final `say` line for on-server version verification, except `MatchZy/config.cfg`.

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

`<commit hash>` and `<date>` are auto-stamped by `tools/update_headers.sh`.

---

## 🔖 Footer Verification

Counter-Strike config files end with a `say` line that echoes version info to the server console (excluding `MatchZy/config.cfg`):

```cfg
say "> CSC Config Loaded | server.cfg | f5a42a2 | 2025-10-23 <"
```

This is also auto-stamped, allowing match admins to verify deployed versions in console or GOTV logs.

---

## 🚀 Quick Start

1. **Clone**
   ```bash
   git clone https://github.com/csconfederation/csc-configs.git csc-configs && cd csc-configs
   ```

2. **Run setup script**
   ```bash
   ./setup.sh
   ```

   Or manually:
   ```bash
   chmod +x tools/*.sh
   cp tools/pre-commit.hook .git/hooks/pre-commit
   chmod +x .git/hooks/pre-commit
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

---

## 🔄 Automated Header & Footer Updates

All `.cfg` files under `configs/` are version-stamped automatically.

### Manual run

```bash
tools/update_headers.sh
```

### Pre-commit hook

The hook stamps headers/footers, lints configs, and regenerates `modes.md` before every commit:

```bash
cp tools/pre-commit.hook .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

Skip for a single commit:

```bash
SKIP_HEADER_STAMP=1 git commit -m "skip stamping this time"
```

---

## 🧰 Script Reference

| Script | Purpose |
|--------|---------|
| `tools/update_headers.sh` | Stamps headers and footers; adds missing headers/footers automatically |
| `tools/cfg_linter.sh` | Validates headers, footers, paths, version consistency, and flags legacy references |
| `tools/generate_mode_diffs.sh` | Produces `modes.md`, a tabular comparison of per-mode configuration differences |
| `tools/pre-commit.hook` | Pre-commit hook template — copy to `.git/hooks/pre-commit` |
| `setup.sh` | One-command developer environment setup |

See [AGENTS.md](AGENTS.md) for detailed documentation of each script's behavior.

---

## 🔧 Editor Configuration

This repo includes an `.editorconfig` file for consistent formatting across editors. Most editors support it natively or via plugin — see [editorconfig.org](https://editorconfig.org) for details.

---

## ✅ Version Verification In-Game

Every Counter-Strike config (excluding `MatchZy/config.cfg`) ends with a line like:

```cfg
say "> CSC Config Loaded | server.cfg | f5a42a2 | 2025-10-23 <"
```

These messages appear in console/GOTV logs and confirm the exact commit that was applied.

Because stamping happens during `git commit`, the hash written into a config is normally the current `HEAD` at commit time, not the newly created commit's hash. Use release tags such as `s20.0` and `live` for final release verification.

---

## ⚙️ Deployment

1. Copy `configs/<Mode>/cfg/` to the server's `csgo/cfg/` directory
2. Verify in console — look for the footer echo confirming hash and date

**Execution behavior:**
* `server.cfg` and MatchZy's `config.cfg` auto-execute on load
* `gamemode_competitive_server.cfg` executes when competitive mode is set
* `MatchZy/live_override.cfg` executes when players ready up

The stamped **Version** and **Last Updated** lines in both headers and footers reflect the deployed commit.

---

## 🏷️ Versioning

Configs are stamped with **commit hashes** for exact traceability. Human-readable releases use immutable **season release tags**:

- `s20.0` — first Season 20 release
- `s20.1` — second Season 20 release
- `s20.2` — third Season 20 release

Operational/reference tags:
- `live` — mutable deployment pointer used by CSC-Core when pulling configs
- `s{season}` — season reference tag (historical helper; not the deployment pointer)

```bash
# Create immutable release tag + release
git tag -a s20.0 -m "Season 20.0 release"
git push origin s20.0
gh release create s20.0 --title "s20.0" --notes "Season 20.0 config release"

# Move live pointer to selected release
git tag -fa live -m "Promote s20.0 to live" s20.0^{}
git push origin refs/tags/live --force

# Check which release tag contains a commit
git tag --contains f5a42a2
```

Plugin versions (MatchZy, Metamod:Source, CounterStrikeSharp) are tracked in [VERSIONS.md](VERSIONS.md) — both current versions and historical versions for each release.

---

## 📚 Additional Documentation

* [AGENTS.md](AGENTS.md) — Detailed automation and script documentation
* [VERSIONS.md](VERSIONS.md) — Release history, plugin dependencies, and tagging workflow
* [modes.md](modes.md) — Auto-generated diff of settings across modes
