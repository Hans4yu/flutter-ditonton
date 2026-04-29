# Watchlist Feature Rules

Watchlist must feel stable and trustworthy.

Rules:
- Show saved movies and TV series clearly.
- If movie and TV series are both supported, separate them with tabs or clear sections.
- Use serious and professional empty state.
- Do not show broken blank pages.
- Do not crash when local database is empty.
- Use consistent card style.
- Watchlist add/remove behavior must be reflected immediately or after safe refresh.
- Do not duplicate watchlist logic across pages.

Detail interaction:
- Add to Watchlist button must clearly show current status.
- Removing from watchlist must update the UI.
- Snackbar or short feedback is allowed if already used by the app.

Testing:
- Test add watchlist.
- Test remove watchlist.
- Test watchlist status.
- Test empty watchlist view.