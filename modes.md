# Mode Differences

_Generated automatically. Shows only settings where at least one mode differs._

## cfg/server.cfg

| Setting | Match | Scrim | Combine | Preseason | 1v1 |
|---|---|---|---|---|---|
| `say` | "> CSC Match Config Loaded \| server.cfg \| 29dae7f \| 2026-06-12 <" | "> CSC Scrim Config Loaded \| server.cfg \| 29dae7f \| 2026-06-12 <" | "> CSC Combine Config Loaded \| server.cfg \| 29dae7f \| 2026-06-12 <" | "> CSC Preseason Config Loaded \| server.cfg \| 29dae7f \| 2026-06-12 <" | "> CSC 1v1 Config Loaded \| server.cfg \| 29dae7f \| 2026-06-12 <" |
| `tv_delay` | 120 // Broadcast delay in seconds. Default: 10–30; CSC: 0 for scrim/combine/preseason, 120 for match | 0 // Broadcast delay in seconds. CSC non-match standard: zero delay. Default: 10–30 | 0 // Broadcast delay in seconds. CSC non-match standard: zero delay. Default: 10–30 | 0 // Broadcast delay in seconds. CSC non-match standard: zero delay. Default: 10–30 | 0 // Broadcast delay in seconds. CSC non-match standard: zero delay. Default: 10–30 |

## cfg/gamemode_competitive_server.cfg

| Setting | Match | Scrim | Combine | Preseason | 1v1 |
|---|---|---|---|---|---|
| `ammo_grenade_limit_default` |  |  |  |  | "0" // No grenades. Default: 1 |
| `ammo_grenade_limit_flashbang` |  |  |  |  | "0" // No flashbangs. Default: 2 |
| `ammo_grenade_limit_total` |  |  |  |  | "0" // No grenades total. Default: 4 |
| `mp_autoteambalance` |  |  |  |  | "0" // Do not auto-balance teams. Default: 1 |
| `mp_ct_default_primary` | "" // Default CT primary weapon (none). Default: "" | "" // Default CT primary weapon (none). Default: "" | "" // Default CT primary weapon (none). Default: "" | "" // Default CT primary weapon (none). Default: "" | weapon_ak47 // CT default primary. Default: "" |
| `mp_ct_default_secondary` | weapon_hkp2000 // Default CT pistol. Default: weapon_hkp2000 | weapon_hkp2000 // Default CT pistol. Default: weapon_hkp2000 | weapon_hkp2000 // Default CT pistol. Default: weapon_hkp2000 | weapon_hkp2000 // Default CT pistol. Default: weapon_hkp2000 | weapon_deagle // CT default pistol. Default: weapon_hkp2000 |
| `mp_free_armor` | "0" // No free armor during live competitive play. Default: 0 | "0" // No free armor during live competitive play. Default: 0 | "0" // No free armor during live competitive play. Default: 0 | "0" // No free armor during live competitive play. Default: 0 | "2" // Full armor + helmet. Default: 0 |
| `mp_freezetime` | "20" // Time before each round starts (seconds). Default: 15 | "20" // Time before each round starts (seconds). Default: 15 | "20" // Time before each round starts (seconds). Default: 15 | "20" // Time before each round starts (seconds). Default: 15 | "2" // Short freeze time. Default: 15 |
| `mp_halftime` |  |  |  |  | "1" // Enable halftime. Default: 1 |
| `mp_halftime_duration` |  |  |  |  | "5" // Short halftime (seconds). Default: 15 |
| `mp_maxrounds` |  |  |  |  | "16" // First to 9 wins. Default: 24 |
| `mp_overtime_enable` |  |  |  |  | "1" // Enable overtime. Default: 1 |
| `mp_overtime_limit` | "0" // Number of OT halves before match ends. 0 = unlimited. Default: 0 | "1" // Limit overtime to a single set. Default: 0 | "1" // Limit overtime to a single set. Default: 0 | "1" // Limit overtime to a single set. Default: 0 | "0" // Unlimited OT halves. Default: 0 |
| `mp_overtime_maxrounds` |  |  |  |  | "4" // OT is first to 3. Default: 6 |
| `mp_round_restart_delay` | "7" // Delay before next round starts (seconds). Default: 7 | "7" // Delay before next round starts (seconds). Default: 7 | "7" // Delay before next round starts (seconds). Default: 7 | "7" // Delay before next round starts (seconds). Default: 7 | "2" // Short delay between rounds (seconds). Default: 7 |
| `mp_roundtime` |  |  |  |  | "600" // Round time in seconds (10 min). Default: 1.92 |
| `mp_startmoney` |  |  |  |  | "0" // No starting money — economy disabled. Default: 800 |
| `mp_t_default_primary` | "" // Default T primary weapon (none). Default: "" | "" // Default T primary weapon (none). Default: "" | "" // Default T primary weapon (none). Default: "" | "" // Default T primary weapon (none). Default: "" | weapon_ak47 // T default primary. Default: "" |
| `mp_t_default_secondary` | weapon_glock // Default T pistol. Default: weapon_glock | weapon_glock // Default T pistol. Default: weapon_glock | weapon_glock // Default T pistol. Default: weapon_glock | weapon_glock // Default T pistol. Default: weapon_glock | weapon_deagle // T default pistol. Default: weapon_glock |
| `mp_team_timeout_max` | "4" // Max timeouts per team per match. Default: 4 | "4" // Max timeouts per team per match. Default: 4 | "4" // Max timeouts per team per match. Default: 4 | "4" // Max timeouts per team per match. Default: 4 | "0" // No timeouts in 1v1. Default: 4 |
| `mp_team_timeout_ot_add_each` | "0" // Extra timeouts granted per OT half. Default: 0 | "0" // Extra timeouts granted per OT half. Default: 0 | "0" // Extra timeouts granted per OT half. Default: 0 | "0" // Extra timeouts granted per OT half. Default: 0 | "0" // No extra OT timeouts. Default: 0 |
| `mp_team_timeout_ot_add_once` | "0" // Grant OT timeouts only once? Default: 0 | "0" // Grant OT timeouts only once? Default: 0 | "0" // Grant OT timeouts only once? Default: 0 | "0" // Grant OT timeouts only once? Default: 0 | "0" // No one-time OT timeout grant. Default: 0 |
| `mp_team_timeout_ot_max` | "4" // Max OT timeouts per team. Default: 4 | "4" // Max OT timeouts per team. Default: 4 | "4" // Max OT timeouts per team. Default: 4 | "4" // Max OT timeouts per team. Default: 4 | "0" // No OT timeouts in 1v1. Default: 4 |
| `mp_teammates_are_enemies` | "0" // Teammates can damage each other? 0 = no. Default: 0 | "0" // Teammates can damage each other? 0 = no. Default: 0 | "0" // Teammates can damage each other? 0 = no. Default: 0 | "0" // Teammates can damage each other? 0 = no. Default: 0 | "0" // Teammates cannot damage each other. Default: 0 |
| `say` | "> CSC Match Config Loaded \| gamemode_competitive_server.cfg \| 29dae7f \| 2026-06-12 <" | "> CSC Scrim Config Loaded \| gamemode_competitive_server.cfg \| 29dae7f \| 2026-06-12 <" | "> CSC Combine Config Loaded \| gamemode_competitive_server.cfg \| 29dae7f \| 2026-06-12 <" | "> CSC Preseason Config Loaded \| gamemode_competitive_server.cfg \| 29dae7f \| 2026-06-12 <" | "> CSC 1v1 Config Loaded \| gamemode_competitive_server.cfg \| 29dae7f \| 2026-06-12 <" |
| `sv_auto_full_alltalk_during_warmup_half_end` | "0" // Disable all-talk during warmup and half-end. Default: 0 | "1" // Enable all-talk during warmup and halftime. Default: 0 | "1" // Enable all-talk during warmup and halftime. Default: 0 | "1" // Enable all-talk during warmup and halftime. Default: 0 | "0" // Disable all-talk during halftime. Default: 0 |
| `sv_deadtalk` | "0" // Dead players can’t talk to living players. Default: 1 | "0" // Dead players can’t talk to living players. Default: 1 | "0" // Dead players can’t talk to living players. Default: 1 | "0" // Dead players can’t talk to living players. Default: 1 | "0" // Dead players can't talk to living players. Default: 1 |
| `tv_delay` | "120" // GOTV broadcast delay (seconds). CSC standard for matches. Default: ~10–30 | "0" // GOTV broadcast delay (seconds). CSC non-match standard: zero delay. Default: ~10–30 | "0" // GOTV broadcast delay (seconds). CSC non-match standard: zero delay. Default: ~10–30 | "0" // GOTV broadcast delay (seconds). CSC non-match standard: zero delay. Default: ~10–30 | "0" // GOTV broadcast delay (seconds). Default: ~10–30 |

## cfg/MatchZy/config.cfg

| Setting | Match | Scrim | Combine | Preseason | 1v1 |
|---|---|---|---|---|---|
| `matchzy_hostname_format` | "CSC Match - {MATCH_ID} \| {MAP} Map {MAPNUMBER} \| {TEAM1} vs {TEAM2} \| Powered by Dathost" | "CSC Match - {MATCH_ID} \| {MAP} Map {MAPNUMBER} \| {TEAM1} vs {TEAM2} \| Powered by Dathost" | "CSC Match - {MATCH_ID} \| {MAP} Map {MAPNUMBER} \| {TEAM1} vs {TEAM2} \| Powered by Dathost" | "CSC Match - {MATCH_ID} \| {MAP} Map {MAPNUMBER} \| {TEAM1} vs {TEAM2} \| Powered by Dathost" | "CSC 1v1 \| {TEAM1} vs {TEAM2}" |
| `matchzy_kick_when_no_match_loaded` | true | false | true | false | false |
| `matchzy_minimum_ready_required` | 8 | 8 | 8 | 8 | 2 |
| `matchzy_playout_enabled_default` | false | true | false | false | false |

## cfg/MatchZy/live_override.cfg

| Setting | Match | Scrim | Combine | Preseason | 1v1 |
|---|---|---|---|---|---|
| `say` | "> CSC Match is Live \| live_override.cfg \| 29dae7f \| 2026-06-12 <" | "> CSC Scrim is Live \| live_override.cfg \| 29dae7f \| 2026-06-12 <" | "> CSC Combine is Live \| live_override.cfg \| 29dae7f \| 2026-06-12 <" | "> CSC Preseason is Live \| live_override.cfg \| 29dae7f \| 2026-06-12 <" | "> CSC 1v1 is Live \| live_override.cfg \| 29dae7f \| 2026-06-12 <" |

## cfg/MatchZy/warmup.cfg

| Setting | Match | Scrim | Combine | Preseason | 1v1 |
|---|---|---|---|---|---|
| `mp_autokick` | 0 // Don’t kick idle players during warmup. Default: 1 | 0 // Don’t kick idle players during warmup. Default: 1 | 0 // Don’t kick idle players during warmup. Default: 1 | 0 // Don’t kick idle players during warmup. Default: 1 | 0 // Don't kick idle players during warmup. Default: 1 |
| `mp_autoteambalance` | 0 // Don’t auto-balance teams. Default: 1 | 0 // Don’t auto-balance teams. Default: 1 | 0 // Don’t auto-balance teams. Default: 1 | 0 // Don’t auto-balance teams. Default: 1 | 0 // Don't auto-balance teams. Default: 1 |
| `mp_ct_default_primary` | "weapon_m4a1" // CT default primary (warmup testing). Default: "" | "weapon_m4a1" // CT default primary (warmup testing). Default: "" | "weapon_m4a1" // CT default primary (warmup testing). Default: "" | "weapon_m4a1" // CT default primary (warmup testing). Default: "" | "weapon_ak47" // CT default primary (warmup). Default: "" |
| `mp_death_drop_gun` | 0 // Do not drop guns on death (keeps flow). Default: 1 | 0 // Do not drop guns on death (keeps flow). Default: 1 | 0 // Do not drop guns on death (keeps flow). Default: 1 | 0 // Do not drop guns on death (keeps flow). Default: 1 | 0 // Do not drop guns on death. Default: 1 |
| `mp_free_armor` | 2 // Free armor during warmup. Default: 0 | 2 // Free armor during warmup. Default: 0 | 2 // Free armor during warmup. Default: 0 | 2 // Free armor during warmup. Default: 0 | 2 // Free armor + helmet during warmup. Default: 0 |
| `mp_maxrounds` | 24 // Max rounds if warmup transitions into live play. Default: 30 | 24 // Max rounds if warmup transitions into live play. Default: 30 | 24 // Max rounds if warmup transitions into live play. Default: 30 | 24 // Max rounds if warmup transitions into live play. Default: 30 | 24 // Max rounds. Default: 30 |
| `mp_t_default_primary` | "weapon_ak47" // T default primary (warmup testing). Default: "" | "weapon_ak47" // T default primary (warmup testing). Default: "" | "weapon_ak47" // T default primary (warmup testing). Default: "" | "weapon_ak47" // T default primary (warmup testing). Default: "" | "weapon_ak47" // T default primary (warmup). Default: "" |
| `mp_teammates_are_enemies` | "0" // Friendly fire/TSK disabled. Default: 0 | "0" // Friendly fire/TSK disabled. Default: 0 | "0" // Friendly fire/TSK disabled. Default: 0 | "0" // Friendly fire/TSK disabled. Default: 0 | "0" // No friendly fire. Default: 0 |
| `say` | "> CSC Match Config Loaded \| warmup.cfg \| 29dae7f \| 2026-06-12 <" | "> CSC Scrim Config Loaded \| warmup.cfg \| 29dae7f \| 2026-06-12 <" | "> CSC Combine Config Loaded \| warmup.cfg \| 29dae7f \| 2026-06-12 <" | "> CSC Preseason Config Loaded \| warmup.cfg \| 29dae7f \| 2026-06-12 <" | "> CSC 1v1 Config Loaded \| warmup.cfg \| 29dae7f \| 2026-06-12 <" |
| `sv_full_alltalk` | 0 // No always-on full alltalk. Default: 0 | 1 // Enable full all-talk during warmup. Default: 0 | 1 // Enable full all-talk during warmup. Default: 0 | 1 // Enable full all-talk during warmup. Default: 0 | 1 // Enable full all-talk during warmup. Default: 0 |

