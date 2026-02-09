//
//  SearchCacheStore.swift
//  MovieApp
//
//  Created by Malindu on 2026-02-09.
//


import Foundation
import CoreData

struct CachedQuery {
    let totalPages: Int
    let lastUpdated: Date
}

final class SearchCacheStore {
    private let stack: CoreDataStack
    private let context: NSManagedObjectContext

    init(stack: CoreDataStack = .shared) {
        self.stack = stack
        self.context = stack.viewContext
    }

    func cache(query: String, page: Int, results: [Movie], totalPages: Int) {
        let fetch = CachedMovieEntity.fetchRequest()
        fetch.predicate = NSPredicate(format: AppStrings.CoreData.predicateQueryPage, query, page)

        if let existing = try? context.fetch(fetch) {
            existing.forEach { context.delete($0) }
        }

        let now = Date()
        for (index, movie) in results.enumerated() {
            let entity = CachedMovieEntity(context: context)
            entity.movieId = Int64(movie.id)
            entity.title = movie.title
            entity.overview = movie.overview
            entity.releaseDate = movie.releaseDate
            entity.posterPath = movie.posterPath
            entity.query = query
            entity.page = Int64(page)
            entity.orderIndex = Int64(index)
            entity.totalPages = Int64(totalPages)
            entity.lastUpdated = now
        }

        let appState = fetchAppState() ?? AppStateEntity(context: context)
        appState.lastQuery = query

        stack.saveContext()
    }

    func cachedPage(query: String, page: Int) -> [Movie]? {
        let fetch = CachedMovieEntity.fetchRequest()
        fetch.predicate = NSPredicate(format: AppStrings.CoreData.predicateQueryPage, query, page)
        fetch.sortDescriptors = [NSSortDescriptor(key: #keyPath(CachedMovieEntity.orderIndex), ascending: true)]

        guard let entities = try? context.fetch(fetch), !entities.isEmpty else { return nil }
        return entities.map { $0.toMovie() }
    }

    func cachedQuery(query: String) -> CachedQuery? {
        let fetch = CachedMovieEntity.fetchRequest()
        fetch.predicate = NSPredicate(format: AppStrings.CoreData.predicateQuery, query)
        fetch.sortDescriptors = [NSSortDescriptor(key: #keyPath(CachedMovieEntity.lastUpdated), ascending: false)]
        fetch.fetchLimit = 1

        guard let entity = try? context.fetch(fetch).first else { return nil }
        return CachedQuery(totalPages: Int(entity.totalPages), lastUpdated: entity.lastUpdated)
    }

    func lastQuery() -> String? {
        fetchAppState()?.lastQuery
    }


    private func fetchAppState() -> AppStateEntity? {
        let fetch = AppStateEntity.fetchRequest()
        fetch.fetchLimit = 1
        return try? context.fetch(fetch).first
    }

}

private extension CachedMovieEntity {
    func toMovie() -> Movie {
        Movie(
            id: Int(movieId),
            title: title,
            overview: overview,
            releaseDate: releaseDate,
            posterPath: posterPath
        )
    }
}
