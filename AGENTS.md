# AGENTS.md — csc-configs

CS2 game-server configs for the CSC league. Six modes live under `configs/<Mode>/cfg/`: `Match`, `Scrim`, `Combine`, `Preseason`, `1v1`, `FA-Colo`. Each mode has `server.cfg`, `gamemode_competitive_server.cfg`, and `MatchZy/` plugin configs (`config.cfg`, `live_override.cfg`, `warmup.cfg`). Scrim and Preseason additionally ship `configs/<Mode>/addons/counterstrikesharp/plugins/CscPlugin/CscPlugin.json` — a csc-plugin config enabling player-driven map changes (`MapChangeMode` + `MapAliases`); it is JSON, so the header/lint tooling ignores it. All automation is local shell — no runtime dependencies.

## Setup

```bash
./setup.sh   # chmod tools/*.sh + install pre-commit hook
```

Or manually: `cp tools/pre-commit.hook .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit`.

## Tools

All operate only on `configs/`. Run from repo root.

- `tools/update_headers.sh` — stamps every `.cfg` header (`// Version: <short hash>`, `// Last Updated: <date>`) and footer `say` line with `git rev-parse --short HEAD` + today's date. Prepends the standard 6-line header and appends the footer if missing. Exception: `*/cfg/MatchZy/config.cfg` gets no footer (plugin config, no console output).
- `tools/cfg_linter.sh` — validates all configs; reports every failure in one run (not fail-fast). Checks: 6-line `// ===` header block; `// Path:` present and NOT prefixed with `configs/` (mode-local, e.g. `Match/cfg/server.cfg`); `// Version:` and `// Last Updated:` within first 12 lines; no legacy banlist references (`banned_user.cfg`, `banned_ip.cfg`, `writeid`, `writeip`); footer `say` line present with correct filename (text is `CSC <Mode> Config Loaded`, except `live_override.cfg` uses `CSC <Mode> is Live`); header and footer versions match.
- `tools/generate_mode_diffs.sh` — regenerates `modes.md`: for each of the five per-mode config files, compares key/value settings across all five modes and lists only settings where at least one mode differs. Missing files are skipped silently.

## Pre-commit hook

Runs only when `configs/**/*.cfg` files are staged. Sequence: stamp headers → lint (abort commit on failure) → regenerate `modes.md` → auto-stage `configs/` and `modes.md`.

Skip all automation for one commit: `SKIP_HEADER_STAMP=1 git commit ...`

**Hash timing gotcha:** the stamped hash is the *parent* commit's hash (HEAD at stamp time), always one behind the commit containing the stamp. Expected; use tags or `git log configs/` for exact release verification.

## Versioning & releases

- Config stamps: short commit hash (automatic, see above).
- Release tags: `s{season}.{revision}` (e.g. `s12.1`), immutable, used for GitHub Releases.
- `live` (mutable tag): what CSC-Core pulls for server deployment. `s{season}`: maintainer-managed season pointer.
- Plugin versions (MatchZy, CSC Plugin, Metamod:Source, CounterStrikeSharp) are tracked in `VERSIONS.md`. The source of truth is `manifest.yaml` in the [plugin-deploy repo](https://github.com/csconfederation/plugin-deploy) (local checkout: `/home/debian/plugin-deploy/manifest.yaml`). **At every release**, read the manifest and sync its versions into both the Plugin Dependencies table and the new changelog entry in `VERSIONS.md` before tagging.

Release + promotion:

```bash
git tag -a s20.0 -m "Season 20.0 release" && git push origin s20.0
gh release create s20.0 --title "s20.0" --notes "Season 20.0 config release"
# Promote to live deployment pointer
git tag -fa live -m "Promote s20.0 to live" s20.0^{}
git push origin refs/tags/live --force
```
