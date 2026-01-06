# 🤖 AGENTS.md

This document describes all automated processes (agents, scripts, and hooks) used in the **CSC Config Repository** to ensure version consistency, formatting, and reliability across configuration files.

---

## 🧑‍💻 Developer Setup

Follow these steps to get your local environment ready for CSC Config maintenance:

1. **Clone the repository**
   ```bash
   git clone <repo-url> csc-configs && cd csc-configs
   ```

2. **Make scripts executable**
   ```bash
   chmod +x tools/update_headers.sh
   chmod +x tools/cfg_linter.sh
   chmod +x tools/generate_mode_diffs.sh
   ```

3. **Install the pre-commit hook**

   The `.git/hooks/` directory is not tracked by Git, so you must create the hook manually:
   ```bash
   cp tools/pre-commit.hook .git/hooks/pre-commit
   chmod +x .git/hooks/pre-commit
   ```

4. **Verify header stamping manually**
   ```bash
   tools/update_headers.sh
   ```
   You should see:
   ```
   [update_headers] Updated headers for all configs/*.cfg with Version=<hash> Date=<date>
   ```

5. **Test the pre-commit hook**
   ```bash
   echo "// test" >> configs/Match/cfg/test.cfg
   git add configs/Match/cfg/test.cfg
   git commit -m "Test commit"
   ```
   The commit should trigger auto-stamping and stage any changed `.cfg` headers automatically.

6. **Optional: skip stamping for a commit**
   ```bash
   SKIP_HEADER_STAMP=1 git commit -m "Temporary commit"
   ```

That's it — your environment is ready to maintain and version CSC configuration files with automatic consistency and traceability.

---

## 🧩 Overview

CSC Configs uses lightweight automation to:

* Keep headers in all `.cfg` files up to date.
* Stamp each config with the current **Git commit hash** and **last updated date**.
* Prevent configuration drift between game servers.
* Automatically stage updates during commits.
* Generate human-readable diffs of mode differences.

All automation runs locally and does **not** modify Git history or tags.

---

## 🧠 Agents & Scripts

### 🪄 `tools/update_headers.sh`

**Purpose:**
Automatically updates the header metadata at the top of every `.cfg` file under `configs/`.

**Behavior:**

* Detects the latest commit hash using `git rev-parse --short HEAD`.
* Updates three header fields within the first 12 lines:
  ```cfg
  // Path: <relative path>
  // Version: <commit hash>
  // Last Updated: <date>
  ```
* Prepends a standard six-line header block if one is missing.
* Appends a standard footer `say` line if one is missing (except for `MatchZy/config.cfg`).
* Stamps footer `say` lines with current commit hash and date.
* Paths are stored in mode-local notation (e.g., `Match/cfg/server.cfg`), stripping the leading `configs/` prefix.
* Portable across Linux, macOS, and WSL.

**Run manually:**
```bash
tools/update_headers.sh
```

---

### 🧹 `tools/cfg_linter.sh`

**Purpose:**
Validates that every committed configuration carries the expected metadata and structure.

**Checks performed:**

| Check | Description |
|-------|-------------|
| Header delimiter | First 6 lines must contain `// ===...` delimiter |
| Path line | `// Path:` must exist and must NOT start with `configs/` |
| Version line | `// Version:` must exist in first 12 lines |
| Last Updated line | `// Last Updated:` must exist in first 12 lines |
| Legacy banlist references | Fails if `banned_user.cfg`, `banned_ip.cfg`, `writeid`, or `writeip` are found |
| Footer echo | Validates `say` line exists with correct filename |
| Version consistency | Header and footer version must match |

**Footer enforcement scope:**

The footer `say` line is validated for **all config files** except:
* `*/cfg/MatchZy/config.cfg` — Plugin configuration, no console output needed

**Error reporting:**

The linter runs all checks and reports every issue found before exiting. It does **not** fail-fast on the first error — you'll see all problems in a single run.

**Run manually:**
```bash
tools/cfg_linter.sh
```

---

### 📊 `tools/generate_mode_diffs.sh`

**Purpose:**
Produces `modes.md`, a human-readable comparison of settings that differ across Match, Scrim, Combine, and Preseason modes.

**Behavior:**

* Parses these config files from each mode:
  * `cfg/server.cfg`
  * `cfg/gamemode_competitive_server.cfg`
  * `cfg/MatchZy/config.cfg`
  * `cfg/MatchZy/live_override.cfg`
  * `cfg/MatchZy/warmup.cfg`
* Extracts key-value pairs, ignoring comments, `exec`, and `say` lines.
* Compares each setting across all four modes.
* Outputs only settings where **at least one mode differs** from the others.
* Silently skips files that don't exist for a given mode.

**Run manually:**
```bash
tools/generate_mode_diffs.sh
```

---

### 🪝 `.git/hooks/pre-commit`

**Purpose:**
Runs automatically before each commit to keep configs consistent and up to date.

**Behavior:**

1. Executes `tools/update_headers.sh` to stamp headers
2. Runs `tools/cfg_linter.sh` to validate all configs
3. Runs `tools/generate_mode_diffs.sh` and stages the refreshed `modes.md`
4. Stages all modified `.cfg` files under `configs/`
5. Prints a summary of updated files

If the linter fails, the commit is aborted.

**Installation:**

Since `.git/hooks/` is not tracked by Git, copy the hook template:
```bash
cp tools/pre-commit.hook .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

**Skip for a single commit:**
```bash
SKIP_HEADER_STAMP=1 git commit -m "Temporary commit"
```

---

## 🧾 Header Format

Every config file begins with a six-line header block for traceability:

```cfg
// =========================================================
// CSC Config File
// Path: Match/cfg/server.cfg
// Version: <commit hash>
// Last Updated: <date>
// =========================================================
```

`update_headers.sh` replaces `<commit hash>` and `<date>` with live values during each commit.

---

## 🔖 Footer Verification

Config files end with a `say` line for in-game verification:

```cfg
say "> CSC Config Loaded | server.cfg | f5a42a2 | 2025-10-23 <"
```

The `update_headers.sh` script automatically stamps these footer lines with the current commit hash and date. This allows match admins and developers to verify the exact deployed version directly in the server console or GOTV logs.

The linter validates that the footer `say` line exists and references the correct filename.

---

## 🔍 Verification Flow

Each config file includes version information in two locations:

| Location | Content | Stamped Automatically? |
|----------|---------|------------------------|
| Header line 4 | `// Version: <hash>` | ✅ Yes |
| Header line 5 | `// Last Updated: <date>` | ✅ Yes |
| Footer `say` | Commit hash and date | ✅ Yes |

Both the raw config file (header) and in-game console output (footer) can be used to verify the exact Git revision deployed to a server.

---

## ⚙️ Maintenance Notes

* Scripts and hooks operate only on the `configs/` directory.
* No server runtime dependencies are required — all automation is local Git-based.
* The pre-commit hook is optional but strongly recommended for anyone making config changes.
* If a mode is missing a config file, `generate_mode_diffs.sh` skips it silently — `modes.md` only reflects files that exist.

---

## ✅ Example Run

```bash
$ tools/update_headers.sh
[update_headers] Updated headers for all configs/*.cfg with Version=f5a42a2 Date=2025-10-23
```

```bash
$ git commit -am "Update scrim GOTV settings"
[pre-commit] Stamping headers in configs/...
[pre-commit] Linting configs...
[pre-commit] Generating mode diffs (modes.md)...
[pre-commit] Auto-stamped header changes have been staged.
[main f5a42a2] Update scrim GOTV settings
 4 files changed, 12 insertions(+), 12 deletions(-)
```

---

## 📜 Summary

| Component | Function | Trigger |
|-----------|----------|---------|
| `tools/update_headers.sh` | Stamps config headers with version/date | Manual or via hook |
| `tools/cfg_linter.sh` | Validates headers, paths, footers, and legacy references | Manual or via hook |
| `tools/generate_mode_diffs.sh` | Regenerates `modes.md` diff overview | Manual or via hook |
| `tools/pre-commit.hook` | Template for Git pre-commit hook | Copy to `.git/hooks/` |
| `.git/hooks/pre-commit` | Runs stamp, lint, and diff automations | Before each commit |

---

---

## 🏷️ Versioning Strategy

CSC Configs uses a hybrid versioning approach:

| Component | Format | Purpose |
|-----------|--------|---------|
| Config stamps | Commit hash (`f5a42a2`) | Exact traceability in logs |
| Git tags | `S{SEASON}.{REVISION}` | Human-readable release names |
| VERSIONS.md | Changelog + plugin deps | Documentation and history |

### Tag Schema

Tags follow the format `S{SEASON}.{REVISION}`:

- `S{SEASON}` — CSC season number (e.g., `S12` = Season 12)
- `.{REVISION}` — Incremental release within the season, starting at 1

Examples: `S12.1` (first release of Season 12), `S12.2` (second release), `S13.1` (first release of Season 13)

### Hash Timing Behavior

The stamped hash is always the **parent commit's hash**, not the commit that contains the stamped files. This is inherent to how Git works:

1. You're on commit `abc123`
2. You edit configs and run `git commit`
3. Pre-commit hook stamps files with `abc123` (current HEAD at that moment)
4. Commit is created → new hash `def456`
5. Files in `def456` contain hash `abc123`

**This is expected behavior.** The hash answers: "What was the repo state when these configs were last touched?"

In practice this doesn't matter because:

- The behavior is consistent and predictable (always one behind)
- Git tags point to the actual commit — use tags for release verification
- `git log --oneline configs/` shows the true commit history
- `git tag --contains <hash>` still returns the correct release

### Why commit hashes in configs?

- Fully automatic — no manual version bumps
- Unambiguous — maps to exact Git state
- Log-reviewable — verify deployments precisely

### Why Git tags for releases?

- Bind human-readable names to commits
- `git describe --tags` shows current version
- No chicken-and-egg problem with hash generation

### Plugin Version Tracking

Plugin versions (MatchZy, Metamod:Source, CounterStrikeSharp) are documented in [VERSIONS.md](VERSIONS.md):

- **Current versions** in the Plugin Dependencies table
- **Historical versions** in each changelog entry

This ensures you can determine exactly which plugin versions were in use for any given config release.

---

CSC Configs automation ensures every deployed configuration can be traced, verified, and reproduced precisely — maintaining parity across all CSC servers and event environments.