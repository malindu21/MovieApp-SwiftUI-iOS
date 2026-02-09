//
//  CachedAsyncImage.swift
//  MovieApp
//
//  Created by Malindu on 2026-02-09.
//


import SwiftUI

final class ImageLoader: ObservableObject {
    @Published var image: Image?
    @Published var isLoading = false

    private var task: Task<Void, Never>?

    func load(from url: URL?) {
        guard let url else { return }
        task?.cancel()
        isLoading = true

        task = Task {
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
            if let cached = URLCache.shared.cachedResponse(for: request),
               let cachedImage = UIImage(data: cached.data) {
                await MainActor.run {
                    self.image = Image(uiImage: cachedImage)
                    self.isLoading = false
                }
                return
            }

            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                if let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode,
                   let uiImage = UIImage(data: data) {
                    let cached = CachedURLResponse(response: response, data: data)
                    URLCache.shared.storeCachedResponse(cached, for: request)
                    await MainActor.run {
                        self.image = Image(uiImage: uiImage)
                        self.isLoading = false
                    }
                } else {
                    await MainActor.run { self.isLoading = false }
                }
            } catch {
                await MainActor.run { self.isLoading = false }
            }
        }
    }

    func cancel() {
        task?.cancel()
    }
}

struct CachedAsyncImage<Placeholder: View>: View {
    let url: URL?
    let placeholder: Placeholder

    @StateObject private var loader = ImageLoader()

    init(url: URL?, @ViewBuilder placeholder: () -> Placeholder) {
        self.url = url
        self.placeholder = placeholder()
    }

    var body: some View {
        ZStack {
            if let image = loader.image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
            }
        }
        .onAppear { loader.load(from: url) }
        .onChange(of: url) { _, newValue in
            loader.load(from: newValue)
        }
        .onDisappear { loader.cancel() }
    }
}
