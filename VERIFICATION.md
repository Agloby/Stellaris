# Verification

Run date: 24 October 2026. Passed on this Windows host: HUD constructed, displayed, topmost state checked and closed; synthetic ZIP metadata name/date parsed; invalid ZIP rejected. These checks do not establish real-save or gameplay compatibility.

The included `HUD.ps1 -SmokeTest` creates, displays, verifies topmost state and closes the Windows form. This is a bounded startup check, not gameplay verification.

Save metadata support is intentionally narrow: ZIP `.sav` with a `meta` entry up to 2 MB and archive up to 256 MB; reads only name/date/version. No extraction to disk. Unsupported formats fail visibly. Campaign strategy parsing is not implemented.

Steam scan checks registry/default library roots and libraryfolders.vdf, then appmanifest_281990.acf and local DLC directories. This is content inventory only. Entitlements are not established.

Not verified: real Stellaris save compatibility, Steam inventory against this user's installed game, actual speech playback, fullscreen/borderless gameplay behavior, microphone input, DLC strategy correctness, valid empire generation, AI answer grounding, installer or production readiness. No representative save or recovered prototype was available during source inventory.
