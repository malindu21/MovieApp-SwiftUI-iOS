//
//  MovieRow.swift
//  MovieApp
//
//  Created by Malindu on 2026-02-09.
//


import SwiftUI

struct MovieRow: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            PosterImage(url: movie.posterURL, width: 60, height: 90)

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundStyle(Color.primary)
                    .lineLimit(2)

                Text(movie.releaseDateText)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}
