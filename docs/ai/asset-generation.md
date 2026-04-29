# Asset Generation Rules

Use $imagegen from C:\Users\farha\.codex\skills\.system\imagegen\SKILL.md when new visual assets are needed.

All visual assets must be created specifically for this repository.

Hard rules:
- Do not use assets from outside this project.
- Do not inspect or copy assets from other directories.
- Do not use copyrighted logos, posters, film stills, brand marks, or screenshots.
- Do not copy Netflix visual identity.
- Do not use generated text inside images.
- Store only final optimized assets.
- Do not commit large raw files unless required.

Asset folders:
- App icons: assets/icons/
- Image assets: assets/images/
- SSL certificates: assets/certificates/

Required assets:
- assets/icons/app_icon.png
- assets/images/empty_watchlist.png
- assets/images/empty_search.png
- assets/images/error_state.png
- assets/images/poster_placeholder.png
- assets/images/backdrop_placeholder.png

Naming rules:
- Use lowercase_with_underscores.
- Use meaningful names.
- Do not use names like image1.png, final.png, ai.png, test.png, new.png.

After adding assets:
- Register them in pubspec.yaml.
- Verify there are no missing asset runtime errors.
- Check the app on Android.
- Check empty, error, loading, and success states.

Image generation prompt for app icon:
Create an original app icon for a movie and TV catalog app named Ditonton. Use a dark cinematic streaming style inspired by premium entertainment apps, but do not copy any existing brand. Combine a play button and a film frame symbol. Use a black and deep red color palette with subtle highlights. Clean, modern, premium, rounded-square launcher icon style, no text, no copyrighted logo.

Image generation prompt for empty watchlist:
Create an original empty state illustration for a movie and TV app watchlist. Serious and professional tone. Dark cinematic style, subtle red accent, minimal composition, a clean empty bookmark or saved-list concept, no text, suitable for a mobile app.

Image generation prompt for empty search:
Create an original empty search illustration for a movie and TV catalog app. Dark cinematic theme, subtle red accent, magnifying glass combined with film-related visual language, serious and professional tone, no text, suitable for a mobile app.

Image generation prompt for error state:
Create an original error state illustration for a movie and TV streaming catalog app. Serious and professional tone, dark cinematic palette, subtle red accent, clean warning or broken media concept, no text, suitable for a mobile app.

Image generation prompt for poster placeholder:
Create an original vertical poster placeholder for a movie and TV catalog app. Dark cinematic gradient, subtle film texture, premium streaming style, minimal, no text, no copyrighted content, reusable for Flutter app.

Image generation prompt for backdrop placeholder:
Create an original wide backdrop placeholder for a movie and TV detail page. Dark cinematic theme, subtle red accent, minimal film-inspired texture, premium streaming look, no text, reusable for Flutter app.