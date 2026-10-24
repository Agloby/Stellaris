# Project plan

## Priority 0: usable Windows HUD tonight

Delivered starting point: dependency-free WinForms HUD with topmost toggle, read-only bounded save metadata inspection, local Steam content scan, planning checklist and interruptible Windows TTS. Run the included launcher. This is a useful shell, not the finished adviser.

Next implementation order: real save parser and player selection; fresh/stale snapshot display; deterministic actionable advice with evidence; save-folder watcher with debounce and atomic snapshots; then push-to-talk. Do not delay basic usability for animated avatars, paid services or an installer.

Tonight's release gate: representative real save loads without modifying it; selected player identity is confirmed; three recommendations cite parsed facts; failed/partial autosave retains the last good snapshot and marks it stale; HUD works beside borderless Stellaris; close, mute and speech interrupt work. The current starter does not yet meet this gate.

## Priority 1: trustworthy campaign assistant

Build a bounded Clausewitz tokenizer/parser with nested structures, quoted strings, repeated keys, comments and resource limits. Separate save adapters by supported version. Maintain immutable snapshots and facts with source paths, game date and observation time. Never infer precise economy/fleet/diplomacy facts from metadata. Support modded/unsupported saves with explicit limitations. Test compressed/uncompressed and corrupt inputs, incomplete writes, multiple player empires and localization.

## Priority 2: DLC and pre-game setup

Reconcile Steam libraries, app manifests, local DLC descriptors, launcher activation and save-active DLC as different signals. Mark ownership unknown unless independently confirmed. Add user corrections with provenance. Create a versioned DLC library with sources, review dates, requirements, conflicts, combinations and playstyle relevance. Refresh official prices by region before buying guidance; never equate local content with a purchase entitlement. No automatic buying.

Wizard: ask fantasy, experience, playstyle, pace, challenge, session length, multiplayer/mod constraints and owned DLC. Explain and validate species, traits, ethics, authority, civics, origins and galaxy settings against the installed patch. Provide at least two tradeoff-aware builds and a concise in-game setup checklist. Unknown compatibility must be visible.

## Priority 3: voice and coaching

Push-to-talk microphone capture with visible listening status, transcription, cancellation and barge-in. Windows/local speech fallback. Original Admiral S.A.S.S. with adjustable sarcasm/profanity and commentary frequency. Defaults: 75%, enabled, frequent. Quiet mode, cooldowns, mute and urgent-event prioritization are mandatory. Coach progression Captain -> Commodore -> Admiral -> Grand Admiral uses demonstrated skills and optional review, not invented win probabilities.

## Priority 4: production release

Select a maintainable desktop stack after comparing recovered prototypes, if available. Keep parsing, strategy, UI and speech separable. Add CI, sanitized fixtures, dependency lockfiles, privacy controls, structured redacted logs, accessibility, keyboard navigation, multi-monitor/DPI tests and signed installer/update strategy. Document provider costs and offline behavior. Never promise production readiness from a single smoke test.

## Risks and dependencies

Missing prototypes and assistant documentation block historical consolidation. A representative user save is needed for real campaign verification. Installed patch/mod details are needed for accurate mechanics. Verified DLC entitlements and current regional prices are needed for purchase advice. Microphone/device testing and gameplay overlay verification require an interactive Windows session. No dates or costs are guaranteed before these inputs are known.
