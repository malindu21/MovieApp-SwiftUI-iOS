//
//  AppStrings.swift
//  MovieApp
//
//  Created by Malindu on 2026-02-09.
//


import Foundation

enum AppStrings {
    enum UI {
        static let empty = ""
        static let searchTabTitle = "Search"
        static let favoritesTabTitle = "Favorites"
        static let searchScreenTitle = "Movie Search"
        static let searchPrompt = "Search by title"
        static let clearButton = "Clear"
        static let loading = "Loading…"
        static let errorTitle = "Something went wrong"
        static let unknownError = "Unknown error"
        static let okButton = "OK"

        static let emptyStateTitle = "Search for movies"
        static let emptyStateMessage = "Results will appear here. Offline results load automatically if available."

        static let offlineBanner = "You are offline. Showing cached results."
        static let cachedResultsTitle = "Cached results"
        static let lastUpdatedPrefix = "Last updated"

        static let favoritesTitle = "Favorites"
        static let favoritesEmptyTitle = "No favorites yet"
        static let favoritesEmptyMessage = "Save movies to find them quickly later."

        static let detailOverviewTitle = "Overview"
        static let detailNoOverview = "No overview available."
        static let addFavorite = "Add Favorite"
        static let removeFavorite = "Remove Favorite"

        static let unknownReleaseDate = "Unknown"
    }

    enum SystemImage {
        static let magnifyingGlass = "magnifyingglass"
        static let heart = "heart"
        static let heartFill = "heart.fill"
        static let film = "film"
        static let wifiSlash = "wifi.slash"
        static let tray = "tray"
    }

    enum API {
        static let baseImageURL = "https://image.tmdb.org/t/p/w500"
        static let searchURL = "https://api.themoviedb.org/3/search/movie"
        static let apiKeyQuery = "api_key"
        static let queryQuery = "query"
        static let pageQuery = "page"
        static let includeAdultQuery = "include_adult"
        static let languageQuery = "language"
        static let includeAdultValue = "false"
        static let languageValue = "en-US"
    }

    enum Errors {
        static let invalidURL = "The request URL was invalid."
        static let invalidResponse = "The server returned an invalid response."
        static let decodingFailed = "Unable to decode the server response."
        static let missingAPIKey = "Missing TMDB API key. Set TMDB_API_KEY in Build Settings."
    }

    enum DateFormat {
        static let tmdbDate = "yyyy-MM-dd"
        static let year = "yyyy"
        static let posixLocale = "en_US_POSIX"
    }

    enum CoreData {
        static let modelName = "MovieApp"
        static let cachedMovieEntity = "CachedMovieEntity"
        static let favoriteMovieEntity = "FavoriteMovieEntity"
        static let appStateEntity = "AppStateEntity"

        static let predicateQueryPage = "query == %@ AND page == %d"
        static let predicateQuery = "query == %@"
        static let predicateMovieId = "movieId == %d"
    }

    enum Internal {
        static let networkMonitorQueue = "NetworkMonitor"
        static let coreDataLoadFailure = "Core Data failed to load:"
        static let coreDataSaveFailure = "Core Data save failed:"
    }

    enum CodingKeys {
        static let id = "id"
        static let title = "title"
        static let overview = "overview"
        static let page = "page"
        static let results = "results"
        static let releaseDate = "release_date"
        static let posterPath = "poster_path"
        static let totalPages = "total_pages"
        static let totalResults = "total_results"
    }

    enum Config {
        static let infoPlistApiKey = "TMDBApiKey"
        static let envApiKey = "TMDB_API_KEY"
    }
}
