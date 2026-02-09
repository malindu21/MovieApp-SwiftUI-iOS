//
//  MovieAppTests.swift
//  MovieApp
//
//  Created by Malindu on 2026-02-09.
//


import XCTest
@testable import MovieApp

final class MovieAppTests: XCTestCase {
    func testReleaseYearParsing() {
        let movie = Movie(id: 1, title: "Test", overview: "", releaseDate: "2024-01-15", posterPath: nil)
        XCTAssertEqual(movie.releaseYearText, "2024")
    }

    func testSearchCacheStorePersists() {
        let stack = CoreDataStack(inMemory: true)
        let store = SearchCacheStore(stack: stack)
        let movie = Movie(id: 99, title: "Cache", overview: "", releaseDate: "2023-10-10", posterPath: nil)

        store.cache(query: "cache", page: 1, results: [movie], totalPages: 3)

        let cached = store.cachedPage(query: "cache", page: 1)
        XCTAssertEqual(cached, [movie])

        let cachedQuery = store.cachedQuery(query: "cache")
        XCTAssertEqual(cachedQuery?.totalPages, 3)
        XCTAssertNotNil(cachedQuery?.lastUpdated)
    }

    func testFavoritesStoreToggle() {
        let stack = CoreDataStack(inMemory: true)
        let store = FavoritesStore(stack: stack)
        let movie = Movie(id: 7, title: "Favorite", overview: "", releaseDate: nil, posterPath: nil)

        XCTAssertFalse(store.isFavorite(movie))
        store.toggleFavorite(movie)
        XCTAssertTrue(store.isFavorite(movie))
        store.toggleFavorite(movie)
        XCTAssertFalse(store.isFavorite(movie))
    }

    func testTMDBClientMissingAPIKeyThrows() async {
        let client = TMDBClient(apiKey: "")
        do {
            _ = try await client.searchMovies(query: "test", page: 1)
            XCTFail("Expected missing API key error")
        } catch let error as TMDBClient.TMDBError {
            switch error {
            case .missingAPIKey:
                XCTAssertTrue(true)
            default:
                XCTFail("Expected missingAPIKey, got \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
