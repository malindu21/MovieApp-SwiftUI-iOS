//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by Malindu on 2026-02-09.
//


import SwiftUI

@main
struct MovieAppApp: App {
    @StateObject private var favorites = FavoritesStore()
    @StateObject private var network = NetworkMonitor()

    init() {
        let memoryCapacity = 50 * 1024 * 1024
        let diskCapacity = 200 * 1024 * 1024
        URLCache.shared = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favorites)
                .environmentObject(network)
        }
    }
}
