# Mode Differences

_Generated automatically. Shows only settings where at least one mode differs._

## cfg/server.cfg

| Setting | Match | Scrim | Combine | Preseason |
|---|---|---|---|---|
| `tv_delay` | 120 // Broadcast delay in seconds. Default: 10–30; CSC: 0 for scrim/combine/preseason, 120 for match | 0 // Broadcast delay in seconds. Scrim requirement: zero delay. Default: 10–30 | 0 // Broadcast delay in seconds. Scrim requirement: zero delay. Default: 10–30 | 0 // Broadcast delay in seconds. Scrim requirement: zero delay. Default: 10–30 |
| `say` | "> CSC Match Config Loaded \| server.cfg \| e88d37b \| 2026-02-01 <" | "> CSC Scrim Config Loaded \| server.cfg \| e88d37b \| 2026-02-01 <" | "> CSC Combine Config Loaded \| server.cfg \| e88d37b \| 2026-02-01 <" | "> CSC Preseason Config Loaded \| server.cfg \| e88d37b \| 2026-02-01 <" |

## cfg/gamemode_competitive_server.cfg

| Setting | Match | Scrim | Combine | Preseason |
|---|---|---|---|---|
| `say` | "> CSC Match Config Loaded \| gamemode_competitive_server.cfg \| e88d37b \| 2026-02-01 <" | "> CSC Scrim Config Loaded \| gamemode_competitive_server.cfg \| e88d37b \| 2026-02-01 <" | "> CSC Combine Config Loaded \| gamemode_competitive_server.cfg \| e88d37b \| 2026-02-01 <" | "> CSC Preseason Config Loaded \| gamemode_competitive_server.cfg \| e88d37b \| 2026-02-01 <" |
| `tv_delay` | "120" // GOTV broadcast delay (seconds). CSC standard for matches. Default: ~10–30 | "0" // GOTV broadcast delay (seconds). Scrim requirement: zero delay. Default: ~10–30 | "0" // GOTV broadcast delay (seconds). Scrim requirement: zero delay. Default: ~10–30 | "0" // GOTV broadcast delay (seconds). Scrim requirement: zero delay. Default: ~10–30 |
| `mp_overtime_limit` | "0" // Number of OT halves before match ends. 0 = unlimited. Default: 0 | "1" // Limit overtime to a single set for scrims. Default: 0 | "1" // Limit overtime to a single set for scrims. Default: 0 | "1" // Limit overtime to a single set for scrims. Default: 0 |
| `sv_auto_full_alltalk_during_warmup_half_end` | "0" // Disable all-talk during warmup and half-end. Default: 0 | "1" // Enable all-talk during warmup and halftime for scrims. Default: 0 | "1" // Enable all-talk during warmup and halftime for scrims. Default: 0 | "1" // Enable all-talk during warmup and halftime for scrims. Default: 0 |

## cfg/MatchZy/config.cfg

| Setting | Match | Scrim | Combine | Preseason |
|---|---|---|---|---|
| `matchzy_playout_enabled_default` | false | true | false | false |
| `matchzy_kick_when_no_match_loaded` | true | false | true | false |

## cfg/MatchZy/live_override.cfg

| Setting | Match | Scrim | Combine | Preseason |
|---|---|---|---|---|
| `say` | "> CSC Match Config Loaded \| live_override.cfg \| e88d37b \| 2026-02-01 <" | "> CSC Scrim Config Loaded \| live_override.cfg \| e88d37b \| 2026-02-01 <" | "> CSC Combine Config Loaded \| live_override.cfg \| e88d37b \| 2026-02-01 <" | "> CSC Preseason Config Loaded \| live_override.cfg \| e88d37b \| 2026-02-01 <" |

## cfg/MatchZy/warmup.cfg

| Setting | Match | Scrim | Combine | Preseason |
|---|---|---|---|---|
| `sv_full_alltalk` | 0 // No always-on full alltalk. Default: 0 | 1 // Enable full all-talk during scrim warmup. Default: 0 | 1 // Enable full all-talk during scrim warmup. Default: 0 | 1 // Enable full all-talk during scrim warmup. Default: 0 |
| `say` | "> CSC Match Config Loaded \| warmup.cfg \| e88d37b \| 2026-02-01 <" | "> CSC Scrim Config Loaded \| warmup.cfg \| e88d37b \| 2026-02-01 <" | "> CSC Combine Config Loaded \| warmup.cfg \| e88d37b \| 2026-02-01 <" | "> CSC Preseason Config Loaded \| warmup.cfg \| e88d37b \| 2026-02-01 <" |

