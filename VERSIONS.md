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

| Plugin | Version | Required | Notes |
|--------|---------|----------|-------|
| MatchZy | [0.8.15](https://github.com/shobhit-pathak/MatchZy/releases/tag/0.8.15) | Yes | Core match management |
| CSC Plugin | [0.2.0](https://github.com/csconfederation/csc-plugin/releases/tag/v0.2.0) | Yes | CSC server integration |
| Metamod:Source | [1401](https://github.com/alliedmodders/metamod-source/tree/efeabcf63d26889af54f298e2a68ea43) | Yes | Plugin framework |
| CounterStrikeSharp | [1.0.368](https://github.com/roflmuffin/CounterStrikeSharp/releases/tag/v1.0.368) | Yes | MatchZy dependency |

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

### s20.2 — 2026-05-17

**Plugins:**
- MatchZy 0.8.15
- CSC Plugin 0.2.0
- Metamod:Source 1401
- CounterStrikeSharp 1.0.368

**Changes:**
- Add CSC Plugin 0.2.0 to tracked plugin dependencies.
- Update plugin dependencies to CounterStrikeSharp 1.0.368.

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
