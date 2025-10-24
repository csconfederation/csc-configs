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
   chmod +x .git/hooks/pre-commit
   ```

3. **Verify header stamping manually**

   ```bash
   tools/update_headers.sh
   ```

   * You should see:

     ```
     [update_headers] Updated headers for all configs/*.cfg with Version=<hash> Date=<date>
     ```

4. **Test the pre-commit hook**

   ```bash
   echo "// test" >> configs/Match/cfg/test.cfg
   git add configs/Match/cfg/test.cfg
   git commit -m "Test commit"
   ```

   * The commit should trigger auto-stamping and stage any changed `.cfg` headers automatically.

5. **Optional: skip stamping for a commit**

   ```bash
   SKIP_HEADER_STAMP=1 git commit -m "Temporary commit"
   ```

That’s it — your environment is ready to maintain and version CSC configuration files with automatic consistency and traceability.

---

## 🧩 Overview

CSC Configs uses lightweight automation to:

* Keep headers in all `.cfg` files up to date.
* Stamp each config with the current **Git commit hash** and **last updated date**.
* Prevent configuration drift between game servers.
* Automatically stage updates during commits.

All automation runs locally and does **not** modify Git history or tags.

---

## 🧠 Agents & Scripts

### 🪄 `tools/update_headers.sh`

**Purpose:**
Automatically updates the header metadata at the top of every `.cfg` file under `configs/`.

**Behavior:**

* Detects the latest commit hash using `git rev-parse --short HEAD`.
* Updates:

  ```cfg
  // Path: <relative path>
  // Version: <commit hash>
  // Last Updated: <date>
  ```
* Prepends a standard header if one is missing.
* Portable across Linux, macOS, and WSL.

**Run manually:**

```bash
tools/update_headers.sh
```

---

### 🪝 `.git/hooks/pre-commit`

**Purpose:**
Runs automatically before each commit to keep headers current.

**Behavior:**

1. Executes `tools/update_headers.sh`
2. Stages all modified `.cfg` files under `configs/`
3. Prints a summary of updated files

**Install:**

```bash
chmod +x .git/hooks/pre-commit
```

**Skip for a single commit:**

```bash
SKIP_HEADER_STAMP=1 git commit -m "Temporary commit"
```

---

### 🧾 Header Standardization

Every config file begins with a six-line header for traceability:

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

## 🔍 Verification Flow

Each config file ends with a `say` echo line printed to the server console:

```cfg
say "> CSC Config Loaded | server.cfg | <commit hash> | <date> <"
```

This confirms the exact revision loaded by the running server, allowing match admins or developers to verify deployed versions in console or GOTV logs.

---

## ⚙️ Planned Automations

| Task                       | Description                                           | Status     |
| -------------------------- | ----------------------------------------------------- | ---------- |
| **Mode diff tool**         | Highlight per-mode differences for audit              | 🔜 Planned |
| **Config schema linter**   | Warn if missing header, echo line, or outdated format | 🔜 Planned |

---

## 🧰 Maintenance Notes

* Scripts and hooks operate only on the `configs/` directory.
* No server runtime dependencies are required — all automation is local Git-based.
* The pre-commit hook is optional but strongly recommended for anyone making config changes.

---

## ✅ Example Run

```bash
$ tools/update_headers.sh
[update_headers] Updated headers for all configs/*.cfg with Version=f5a42a2 Date=2025-10-23
```

```bash
$ git commit -am "Update scrim GOTV settings"
[pre-commit] Stamping headers in configs/...
[pre-commit] Auto-stamped header changes have been staged.
[main f5a42a2] Update scrim GOTV settings
 4 files changed, 12 insertions(+), 12 deletions(-)
```

---

## 📜 Summary

| Component                 | Function                                | Trigger            |
| ------------------------- | --------------------------------------- | ------------------ |
| `tools/update_headers.sh` | Stamps config headers with version/date | Manual or via hook |
| `.git/hooks/pre-commit`   | Runs header updater automatically       | Before each commit |
| Config footer echo        | Prints commit/date in-game              | At runtime         |
| Warmup and live configs   | Ensure in-server traceability           | During execution   |

---

CSC Configs automation ensures every deployed configuration can be traced, verified, and reproduced precisely — maintaining parity across all CSC servers and event environments.

