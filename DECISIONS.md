# Implementation Notes

## Key Decisions
- **SwiftUI + MVVM**: SwiftUI gives fast iteration for a two-screen app, and a lightweight MVVM structure keeps view logic separate from networking and caching.
- **TMDB API Client**: A small `TMDBClient` handles API construction and decoding. The API key is pulled from Info.plist via a build setting to avoid hardcoding in source.
- **Offline Cache**: Search results are persisted as JSON in the Documents directory. This keeps offline support simple and deterministic.
- **Favorites Persistence**: Favorites are stored locally as a JSON array of `Movie` objects for quick retrieval and minimal schema work.
- **Network Status**: `NWPathMonitor` reports offline mode, and the UI clearly indicates when cached data is being used.

## Challenges & Solutions
- **Offline data shape**: Caching search results by query and page keeps pagination consistent even without connectivity.
- **Pagination correctness**: The view model tracks `currentPage` and `totalPages`, and fetches the next page only when the last item appears.
- **Error handling**: Errors surface as alerts, and cached fallback is used whenever possible.

## Future Improvements
- Expand unit tests for caching and networking edge cases.
- Add UI tests that cover real search flows.
- Replace the inline API key with a build-time or plist-based configuration.
