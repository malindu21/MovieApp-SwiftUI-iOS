//
//  PosterImage.swift
//  MovieApp
//
//  Created by Malindu on 2026-02-09.
//


import SwiftUI

struct PosterImage: View {
    let url: URL?
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        CachedAsyncImage(url: url) {
            placeholder
        }
        .frame(width: width, height: height)
        .background(Color.secondary.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
        )
    }

    private var placeholder: some View {
        ZStack {
            Color.secondary.opacity(0.15)
            Image(systemName: AppStrings.SystemImage.film)
                .foregroundStyle(Color.secondary)
        }
    }
}
