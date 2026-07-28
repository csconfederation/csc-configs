# CSC Config Versions

This document tracks releases, plugin dependencies, and breaking changes.

Config files are stamped with **commit hashes** for exact traceability. Human-readable version names are applied via **Git tags**.

---

## Tag Schema

Release tags follow the format `s{season}.{revision}`:

| Component | Description | Example |
|-----------|-------------|---------|
| `s{season}` | CSC season number | `s12` = Season 12 |
| `.{REVISION}` | Incremental release within the season, starting at 0 | `.0`, `.1`, `.2` |

**Examples:**
- `s19.0` — First release of Season 19
- `s19.1` — Second release of Season 19 (bug fix, setting tweak, etc.)
- `s19.2` — Third release of Season 19
- `s20.0` — First release of Season 20

Reset revision to 0 at the start of each season.

### Reference Tags

- `live` (mutable): deployment pointer used by CSC-Core when pulling configs.
- `s{season}` (mutable by maintainer choice): season reference tag for historical grouping.

Only `s{season}.{revision}` tags are release tags. `live` and `s{season}` are operational/reference tags.

---

## Plugin Dependencies

All modes require the same plugin versions.

Source of truth: [`manifest.yaml` in csconfederation/plugin-deploy](https://github.com/csconfederation/plugin-deploy/blob/main/manifest.yaml) — this table mirrors it and is updated at every release.

| Plugin | Version | Required | Notes |
|--------|---------|----------|-------|
| MatchZy | [0.8.15-cssharp-1.0.371](https://github.com/csconfederation/MatchZy/releases/tag/0.8.15-cssharp-1.0.371) | Yes | Core match management — temporary CSC fork of upstream 0.8.15, rebuilt against CS# 1.0.371; revert to shobhit-pathak/MatchZy once upstream releases on CS# ≥ 1.0.371 |
| CSC Plugin | [0.2.1](https://github.com/csconfederation/csc-plugin/releases/tag/v0.2.1) | Yes | CSC server integration |
| Metamod:Source | [2.0.0-git1410](https://github.com/alliedmodders/metamod-source/releases/tag/2.0.0.1410) | Yes | Plugin framework |
| CounterStrikeSharp | [1.0.371](https://github.com/roflmuffin/CounterStrikeSharp/releases/tag/v1.0.371) | Yes | MatchZy dependency; includes the July 9 CS2 update gamedata fix |
| CS2FOW | [0.3.1](https://github.com/karola3vax/CS2FOW/releases/tag/v0.3.1) | No | Server-side fog-of-war visibility culling (anti-wallhack); Combine template only, rollout canary — other modes carry an explicit `remove: [cs2fow]` in plugin-deploy |

---

## Changelog

<!--
Template for new entries:

### s{season}.{revision} — YYYY-MM-DD

**Plugins:**
- MatchZy x.x.x
- CSC Plugin x.x.x
- Metamod:Source x.x.x
- CounterStrikeSharp x.x.x

**Changes:**
- Description of change
- **Breaking:** Description of breaking change (if any)
-->

### Unreleased

**Changes:**
- Add `configs/Combine/cfg/cs2fow.cfg` — the first CSC-owned CS2FOW config. CS2FOW execs
  `cfg/cs2fow.cfg` by name at load and again on every `OnLevelInit`, and plugin-deploy overlays
  csc-configs on top of the plugin archive, so this file now fully overrides the upstream-shipped
  defaults. Previously Combine ran upstream's cfg unmodified.
- Settings are deliberately biased toward failing open (revealing players rather than hiding them)
  and toward lower server cost, not toward maximum anti-wallhack coverage:
  `cs2fow_smoke_occlusion 0`, `cs2fow_visibility_hold_ms 200`,
  `cs2fow_shoulder_base_units`/`cs2fow_max_shoulder_units` both 128, `cs2fow_update_interval_ms 16`.
  Rationale for each is inline in the file.
- `cs2fow_update_interval_ms` is a per-frame floor, not a rate. CS2 runs at 64 tick (15.625ms
  frames), which makes the knob effectively binary: <= 15 captures every tick, 16-31 every other
  tick. 16 halves the per-tick game-thread cost at the price of one tick of reveal latency.
- `sv_enable_donttransmit 0` is carried into this file. It is required by CS2FOW and was previously
  supplied by the upstream cfg; overriding without it would silently revert engine transmit behavior.
- `tools/generate_mode_diffs.sh`: add `cfg/cs2fow.cfg` to the compared file list, so `modes.md`
  reflects it. Mode-local files are skipped silently for modes that don't ship them.
- No change to Match/Scrim/Preseason/1v1 — they carry `remove: [cs2fow]` in plugin-deploy and
  intentionally ship no cs2fow.cfg.

### s20.5 — 2026-07-27

**Plugins:**
- MatchZy 0.8.15-cssharp-1.0.371 (CSC fork)
- CSC Plugin 0.2.1
- Metamod:Source 2.0.0-git1410
- CounterStrikeSharp 1.0.371
- CS2FOW 0.3.1 (Combine only)

**Changes:**
- Sync plugin dependency table with plugin-deploy's `manifest.yaml`: bump CSC Plugin 0.2.0 → 0.2.1 and Metamod:Source git1403 → git1410.
- Add CS2FOW as a tracked plugin dependency (previously untracked here). It ships only on the Combine template as a rollout canary; Match/Scrim/Preseason explicitly remove it.
- No config file changes in this revision — plugin-deploy owns the actual server-side plugin builds this document tracks.

### s20.4 — 2026-07-10

**Plugins:**
- MatchZy 0.8.15-cssharp-1.0.371 (CSC fork)
- CSC Plugin 0.2.0
- Metamod:Source 2.0.0-git1403
- CounterStrikeSharp 1.0.371

**Changes:**
- Add `CscPlugin.json` to Scrim and Preseason templates (`addons/counterstrikesharp/plugins/CscPlugin/`), enabling `MapChangeMode` so players can run `!map <name>` / `!changemap <name>`.
- Map aliases cover the standard pool with common shorthands (`d2`, `anc`, `inf`, `mir`, `op`, `over`, `vert`, plus full names); `office` intentionally excluded.

### s20.3 — 2026-06-12

**Plugins:**
- MatchZy 0.8.15
- CSC Plugin 0.2.0
- Metamod:Source 1401
- CounterStrikeSharp 1.0.368

**Changes:**
- Enable detailed match logging in `server.cfg` across Match, Scrim, Combine, Preseason, and 1v1 modes.
- Add `mp_logdetail 3`, `mp_logmoney 1`, and `mp_logdetail_items 1` to capture damage, money, and item logging.

### s20.2 — 2026-06-02

**Plugins:**
- MatchZy 0.8.15
- CSC Plugin 0.2.0
- Metamod:Source 1401
- CounterStrikeSharp 1.0.368

**Changes:**
- Add CSC Plugin 0.2.0 to tracked plugin dependencies.
- Update plugin dependencies to CounterStrikeSharp 1.0.368.
- Add 1v1 mode config: `server.cfg`, `gamemode_competitive_server.cfg`, `MatchZy/config.cfg`, `MatchZy/live_override.cfg`, `MatchZy/warmup.cfg`.
- 1v1 settings: AK47 + deagle, full armor, no grenades, no economy, 16-round format (first to 9), 10-minute round time, no timeouts, unlimited OT.
- Extend `generate_mode_diffs.sh` to include 1v1 in the mode comparison table.

### s20.1 — 2026-05-07

**Plugins:**
- MatchZy 0.8.15
- Metamod:Source 1401
- CounterStrikeSharp 1.0.367

**Changes:**
- Enable free armor during MatchZy warmup across Match, Scrim, Combine, and Preseason.
- Explicitly disable free armor during live competitive play across Match, Scrim, Combine, and Preseason.
- Update plugin dependencies to Metamod:Source 1401.

### s20.0 — 2026-04-25

**Plugins:**
- MatchZy 0.8.15
- Metamod:Source 2.0.0.1396
- CounterStrikeSharp 1.0.367

**Changes:**
- Start the Season 20 release line.
- Update plugin dependencies to Metamod:Source 2.0.0.1396 and CounterStrikeSharp 1.0.367.

### s19.3 — 2026-03-28

**Plugins:**
- MatchZy 0.8.15
- Metamod:Source 1389
- CounterStrikeSharp 1.0.363

**Changes:**
- Remove the decorative `CSC <Mode> Config Loaded` and `<Mode> is Live` banner lines from all `MatchZy/live_override.cfg` files.
- Stamp `MatchZy/live_override.cfg` footers as `CSC <Mode> is Live` instead of `CSC <Mode> Config Loaded`.
- Update config tooling so header/footer stamping and linting preserve the new `live_override.cfg` footer format.

### s19.2 — 2026-03-18

**Plugins:**
- MatchZy 0.8.15
- Metamod:Source 1389
- CounterStrikeSharp 1.0.363

**Changes:**
- Update plugin dependencies to Metamod:Source 1389 and CounterStrikeSharp 1.0.363.
- Disable player annotations in `gamemode_competitive_server.cfg` across Match, Scrim, Combine, and Preseason.

### s19.1 — 2026-02-17

**Plugins:**
- MatchZy 0.8.15
- Metamod:Source 1383
- CounterStrikeSharp 1.0.362

**Changes:**
- Establish release/ref strategy: immutable `s19.x` releases, `live` deployment pointer, `s19` season reference.

### s19.0 — 2026-01-06

**Plugins:**
- MatchZy 0.8.15
- Metamod:Source 1375
- CounterStrikeSharp 1.0.355

**Changes:**
- Start Season 19.0 release line

### s0.0 — YYYY-MM-DD

**Plugins:**
- MatchZy x.x.x
- CSC Plugin x.x.x
- Metamod:Source x.x.x
- CounterStrikeSharp x.x.x

**Changes:**
- Initial release

---

## Tagging Releases

When ready to mark a release:

```bash
# Tag the current commit
git tag -a s20.0 -m "Season 20.0 - description"

# Push the tag
git push origin s20.0

# Create GitHub release from the release tag
gh release create s20.0 --title "s20.0" --notes "Season 20.0 config release"

# Promote to live after validation
git tag -fa live -m "Promote s20.0 to live" s20.0^{}
git push origin refs/tags/live --force
```

To see all releases:
```bash
git tag -l "s*.*"
```

To check which release a deployed hash belongs to:
```bash
git tag --contains <hash>
```

To see what's changed since last release:
```bash
git log s20.0..HEAD --oneline
```
