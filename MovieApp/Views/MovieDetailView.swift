//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by Malindu on 2026-02-09.
//


import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @EnvironmentObject private var favorites: FavoritesStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top, spacing: 16) {
                    PosterImage(url: movie.posterURL, width: 140, height: 210)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(movie.title)
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text(movie.releaseDateText)
                            .font(.subheadline)
                            .foregroundStyle(Color.secondary)

                        Button(action: { favorites.toggleFavorite(movie) }) {
                            Label(
                                favorites.isFavorite(movie) ? AppStrings.UI.removeFavorite : AppStrings.UI.addFavorite,
                                systemImage: favorites.isFavorite(movie) ? AppStrings.SystemImage.heartFill : AppStrings.SystemImage.heart
                            )
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }

                Text(AppStrings.UI.detailOverviewTitle)
                    .font(.headline)

                Text(movie.overview.isEmpty ? AppStrings.UI.detailNoOverview : movie.overview)
                    .font(.body)
                    .foregroundStyle(Color.secondary)
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
