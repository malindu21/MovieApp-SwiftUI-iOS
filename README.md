# MovieApp

A simple iOS movie search app using The Movie Database (TMDB) API.

## Sample Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/1052d3ec-ab93-4b2e-945f-f6e600a83382" width="250"/>
  <img src="https://github.com/user-attachments/assets/6e180fa8-42e9-4fa7-a1ff-4a669cc59d8f" width="250"/>
  <img src="https://github.com/user-attachments/assets/0d9c1627-a018-4662-8c3f-b3729f318c4a" width="250"/>
  <img src="https://github.com/user-attachments/assets/6ceef0e4-98a0-4175-92f9-a17945dcc526" width="250"/>
</p>

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
