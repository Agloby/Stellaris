# Stellaris Command Buddy

New Windows HUD starter, 24 October 2026. This is not recovered v1-v5 code and is not a complete production application.

## Play tonight

1. Open `Start-HUD.cmd` on Windows. It uses built-in Windows PowerShell, WinForms and Windows speech; no API key or package install.
2. Use borderless/windowed Stellaris. Always-on-top is implemented, but exclusive fullscreen compatibility is not guaranteed.
3. Load a `.sav` to display available name/date/version metadata. Reload after saving. The starter does not parse campaign state or provide save-grounded strategy.
4. Scan Steam for installed game and local DLC folder names. Content presence does not establish ownership or enabled status.
5. Use the planning checklist and text-to-speech buttons. Stop speech interrupts speech immediately; microphone input is not implemented.

The window can be moved, resized, minimized or closed normally. No game injection, save writes, telemetry, purchases or cloud AI requests. Startup does not scan files until you click the relevant button. Local paths are displayed only in the local window.

## Handoff

- `CODEX_IMPLEMENTATION_PROMPT.md`: complete build brief and acceptance criteria.
- `PROJECT_PLAN.md`: ordered milestones and release gates.
- `SOURCE_INVENTORY.md`: provenance and missing prototypes.
- `VERIFICATION.md`: bounded checks and remaining verification.

Persona target: Admiral S.A.S.S.; sarcasm 75%; profanity enabled; frequent commentary. The starter has a short original greeting and Windows TTS only. Voice conversation, persona controls and commentary scheduling remain future work.
