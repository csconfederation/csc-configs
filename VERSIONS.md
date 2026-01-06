# CSC Config Versions

This document tracks releases, plugin dependencies, and breaking changes.

Config files are stamped with **commit hashes** for exact traceability. Human-readable version names are applied via **Git tags**.

---

## Tag Schema

Tags follow the format `S{SEASON}.{REVISION}`:

| Component | Description | Example |
|-----------|-------------|---------|
| `S{SEASON}` | CSC season number | `S12` = Season 12 |
| `.{REVISION}` | Incremental release within the season, starting at 0 | `.0`, `.1`, `.2` |

**Examples:**
- `S19.0` — First release of Season 19
- `S19.1` — Second release of Season 19 (bug fix, setting tweak, etc.)
- `S20.0` — First release of Season 20

Reset revision to 0 at the start of each season.

---

## Plugin Dependencies

All modes require the same plugin versions.

| Plugin | Version | Required | Notes |
|--------|---------|----------|-------|
| MatchZy | x.x.x | Yes | Core match management |
| Metamod:Source | x.x.x | Yes | Plugin framework |
| CounterStrikeSharp | x.x.x | Yes | MatchZy dependency |

---

## Changelog

<!--
Template for new entries:

### S{SEASON}.{REVISION} — YYYY-MM-DD

**Plugins:**
- MatchZy x.x.x
- Metamod:Source x.x.x
- CounterStrikeSharp x.x.x

**Changes:**
- Description of change
- **Breaking:** Description of breaking change (if any)
-->

### S0.0 — YYYY-MM-DD

**Plugins:**
- MatchZy x.x.x
- Metamod:Source x.x.x
- CounterStrikeSharp x.x.x

**Changes:**
- Initial release

---

## Tagging Releases

When ready to mark a release:

```bash
# Tag the current commit
git tag -a S19.0 -m "Season 19.0 - description"

# Push the tag
git push origin S19.0
```

To see all releases:
```bash
git tag -l "S*"
```

To check which release a deployed hash belongs to:
```bash
git tag --contains <hash>
```

To see what's changed since last release:
```bash
git log S19.0..HEAD --oneline
```
