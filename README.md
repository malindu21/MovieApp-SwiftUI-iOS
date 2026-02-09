# MovieApp

A simple iOS movie search app using The Movie Database (TMDB) API.

## Sample Screenshots

![Uploading Simulator Screenshot - iPhone 16 Pro - 2026-02-09 at 18.38.56.png…]()
![Uploading Simulator Screenshot - iPhone 16 Pro - 2026-02-09 at 18.38.56.png…]()

<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2026-02-09 at 18 38 54" src="https://github.com/user-attachments/assets/e3b6c9d5-629f-40f3-8b19-d4d9fe8c9bed" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2026-02-09 at 18 38 54" src="https://github.com/user-attachments/assets/e3b6c9d5-629f-40f3-8b19-d4d9fe8c9bed" />
[Uploading Simulator Screenshot - iPhone 16 Pro - 2026-02-09 at 18.38.52.png…]()
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2026-02-09 at 18 38 52" src="https://github.com/user-attachments/assets/520620cc-809e-4103-b047-e23953ca16b3" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2026-02-09 at 18 38 52" src="https://github.com/user-attachments/assets/520620cc-809e-4103-b047-e23953ca16b3" />

## Features
- Search movies by title
- Movie details screen (title, release date, poster, overview)
- Pagination
- Offline cache for previously fetched results
- Favorites list
- Graceful error handling

## Requirements
- Xcode 16.2+
- iOS 17+
- A TMDB API key

## Setup
1. Open the project: `MovieApp.xcodeproj`
2. Add your TMDB API key in the build settings:
   - `TMDB_API_KEY` in the MovieApp target (Debug/Release).
   - The key is injected into Info.plist as `TMDBApiKey`.
3. Build and run on a simulator or device.

## Offline Mode
- Search results and favorites are cached locally in Core Data.
- When offline, cached results (including the last query) are shown.

## Notes
- Poster images rely on TMDB’s image service and are cached by `URLCache`.
- Favorites are stored locally and persist across app launches.

## Running Tests
Unit tests and UI tests are included. Run them from Xcode’s Test navigator or with `Cmd+U`.
