//
//  FavoritesStore.swift
//  MovieApp
//
//  Created by Malindu on 2026-02-09.
//


import Foundation
import CoreData

final class FavoritesStore: ObservableObject {
    @Published private(set) var favorites: [Movie] = []

    private let stack: CoreDataStack
    private let context: NSManagedObjectContext

    init(stack: CoreDataStack = .shared) {
        self.stack = stack
        self.context = stack.viewContext
        load()
    }

    func isFavorite(_ movie: Movie) -> Bool {
        fetchFavorite(movieId: movie.id) != nil
    }

    func toggleFavorite(_ movie: Movie) {
        if let existing = fetchFavorite(movieId: movie.id) {
            context.delete(existing)
        } else {
            let entity = FavoriteMovieEntity(context: context)
            entity.movieId = Int64(movie.id)
            entity.title = movie.title
            entity.overview = movie.overview
            entity.releaseDate = movie.releaseDate
            entity.posterPath = movie.posterPath
            entity.createdAt = Date()
        }

        stack.saveContext()
        load()
    }

    private func load() {
        let fetch = FavoriteMovieEntity.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: #keyPath(FavoriteMovieEntity.createdAt), ascending: false)]

        let entities = (try? context.fetch(fetch)) ?? []
        favorites = entities.map { $0.toMovie() }
    }

    private func fetchFavorite(movieId: Int) -> FavoriteMovieEntity? {
        let fetch = FavoriteMovieEntity.fetchRequest()
        fetch.predicate = NSPredicate(format: AppStrings.CoreData.predicateMovieId, movieId)
        fetch.fetchLimit = 1
        return try? context.fetch(fetch).first
    }
}

private extension FavoriteMovieEntity {
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
