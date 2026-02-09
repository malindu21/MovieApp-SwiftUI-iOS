//
//  ContentView.swift
//  MovieApp
//
//  Created by Malindu on 2026-02-09.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SearchView()
                .tabItem {
                    Label(AppStrings.UI.searchTabTitle, systemImage: AppStrings.SystemImage.magnifyingGlass)
                }

            FavoritesView()
                .tabItem {
                    Label(AppStrings.UI.favoritesTabTitle, systemImage: AppStrings.SystemImage.heart)
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(FavoritesStore())
        .environmentObject(NetworkMonitor())
}
