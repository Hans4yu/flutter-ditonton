# Integration Test Rules

This folder contains end-to-end app flow tests.

Purpose:
Integration tests verify major user flows in the running app.

Important flows:
- App launches successfully.
- Home page appears.
- Movie detail opens.
- TV series detail opens if supported.
- Search can be used.
- Watchlist add/remove works.
- Empty states are reachable where practical.
- Error states do not crash the app.

Rules:
- Do not depend on unstable real network responses when avoidable.
- Use testable setup if the project supports it.
- Keep flows short and reliable.
- Prefer stable keys for important widgets.
- Add keys only where useful for tests.
- Do not add keys everywhere without purpose.