//
//  FavoritesView.swift
//  MovieApp
//
//  Created by Malindu on 2026-02-09.
//


import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favorites: FavoritesStore

    var body: some View {
        NavigationStack {
            Group {
                if favorites.favorites.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(favorites.favorites) { movie in
                            NavigationLink(value: movie) {
                                MovieRow(movie: movie)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle(AppStrings.UI.favoritesTitle)
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: AppStrings.SystemImage.heart)
                .font(.system(size: 44))
                .foregroundStyle(Color.secondary)
            Text(AppStrings.UI.favoritesEmptyTitle)
                .font(.title3)
                .fontWeight(.semibold)
            Text(AppStrings.UI.favoritesEmptyMessage)
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
