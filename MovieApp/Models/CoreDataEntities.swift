//
//  CoreDataEntities.swift
//  MovieApp
//
//  Created by Malindu on 2026-02-09.
//


import Foundation
import CoreData

@objc(CachedMovieEntity)
final class CachedMovieEntity: NSManagedObject {
    @NSManaged var movieId: Int64
    @NSManaged var title: String
    @NSManaged var overview: String
    @NSManaged var releaseDate: String?
    @NSManaged var posterPath: String?
    @NSManaged var query: String
    @NSManaged var page: Int64
    @NSManaged var orderIndex: Int64
    @NSManaged var totalPages: Int64
    @NSManaged var lastUpdated: Date
}

@objc(FavoriteMovieEntity)
final class FavoriteMovieEntity: NSManagedObject {
    @NSManaged var movieId: Int64
    @NSManaged var title: String
    @NSManaged var overview: String
    @NSManaged var releaseDate: String?
    @NSManaged var posterPath: String?
    @NSManaged var createdAt: Date
}

@objc(AppStateEntity)
final class AppStateEntity: NSManagedObject {
    @NSManaged var lastQuery: String?
}

extension CachedMovieEntity {
    static func fetchRequest() -> NSFetchRequest<CachedMovieEntity> {
        NSFetchRequest<CachedMovieEntity>(entityName: AppStrings.CoreData.cachedMovieEntity)
    }
}

extension FavoriteMovieEntity {
    static func fetchRequest() -> NSFetchRequest<FavoriteMovieEntity> {
        NSFetchRequest<FavoriteMovieEntity>(entityName: AppStrings.CoreData.favoriteMovieEntity)
    }
}

extension AppStateEntity {
    static func fetchRequest() -> NSFetchRequest<AppStateEntity> {
        NSFetchRequest<AppStateEntity>(entityName: AppStrings.CoreData.appStateEntity)
    }
}
