//
//  SearchViewModel.swift
//  MovieApp
//
//  Created by Malindu on 2026-02-09.
//


import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query: String = AppStrings.UI.empty
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var isFromCache: Bool = false
    @Published private(set) var lastUpdated: Date?
    @Published private(set) var totalPages: Int = 1
    @Published private(set) var currentPage: Int = 1

    private let client: TMDBClient
    private let cache: SearchCacheStore

    init(client: TMDBClient = TMDBClient(), cache: SearchCacheStore = SearchCacheStore()) {
        self.client = client
        self.cache = cache
    }

    private var searchTask: Task<Void, Never>?
    private let minimumQueryLength = 3

    func onQueryChanged() {
        searchTask?.cancel()
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            movies = []
            errorMessage = nil
            isFromCache = false
            lastUpdated = nil
            isLoading = false
            return
        }

        guard trimmed.count >= minimumQueryLength else {
            movies = []
            errorMessage = nil
            isFromCache = false
            lastUpdated = nil
            isLoading = false
            return
        }

        searchTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            await search(reset: true)
        }
    }

    func loadLastCachedQueryIfNeeded() {
        guard movies.isEmpty, let lastQuery = cache.lastQuery() else { return }
        query = lastQuery
        if let cached = cache.cachedQuery(query: lastQuery) {
            var page = 1
            var aggregated: [Movie] = []
            while let pageResults = cache.cachedPage(query: lastQuery, page: page) {
                aggregated.append(contentsOf: pageResults)
                page += 1
            }
            movies = aggregated
            totalPages = cached.totalPages
            currentPage = max(page - 1, 1)
            lastUpdated = cached.lastUpdated
            isFromCache = true
        }
    }

    func search(reset: Bool = true) async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            movies = []
            errorMessage = nil
            isFromCache = false
            lastUpdated = nil
            return
        }

        guard trimmed.count >= minimumQueryLength else {
            movies = []
            errorMessage = nil
            isFromCache = false
            lastUpdated = nil
            return
        }

        if reset {
            currentPage = 1
            totalPages = 1
            movies = []
        }

        await loadPage(page: currentPage, query: trimmed, reset: reset)
    }

    func loadNextPageIfNeeded(currentMovie: Movie) async {
        guard !isLoading else { return }
        guard currentPage < totalPages else { return }
        guard movies.last?.id == currentMovie.id else { return }
        currentPage += 1
        await loadPage(page: currentPage, query: query, reset: false)
    }

    private func loadPage(page: Int, query: String, reset: Bool) async {
        isLoading = true
        errorMessage = nil

        do {
            if Task.isCancelled {
                isLoading = false
                return
            }
            let response = try await client.searchMovies(query: query, page: page)
            if Task.isCancelled {
                isLoading = false
                return
            }
            if reset {
                movies = response.results
            } else {
                movies.append(contentsOf: response.results)
            }
            totalPages = response.totalPages
            lastUpdated = Date()
            isFromCache = false
            cache.cache(query: query, page: page, results: response.results, totalPages: response.totalPages)
        } catch {
            if error is CancellationError {
                isLoading = false
                return
            }
            if let cached = cache.cachedPage(query: query, page: page) {
                if reset {
                    movies = cached
                } else {
                    movies.append(contentsOf: cached)
                }
                totalPages = cache.cachedQuery(query: query)?.totalPages ?? totalPages
                lastUpdated = cache.cachedQuery(query: query)?.lastUpdated
                isFromCache = true
            } else {
                errorMessage = error.localizedDescription
            }
        }

        isLoading = false
    }
}
