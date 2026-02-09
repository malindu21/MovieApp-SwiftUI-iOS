//
//  SearchView.swift
//  MovieApp
//
//  Created by Malindu on 2026-02-09.
//


import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject private var favorites: FavoritesStore
    @EnvironmentObject private var network: NetworkMonitor

    @State private var showError = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.movies.isEmpty && viewModel.query.isEmpty {
                    emptyState
                } else {
                    resultsList
                }
            }
            .navigationTitle(AppStrings.UI.searchScreenTitle)
            .searchable(text: $viewModel.query, prompt: AppStrings.UI.searchPrompt)
            .onSubmit(of: .search) {
                Task { await viewModel.search(reset: true) }
            }
            .onChange(of: viewModel.errorMessage) { _, newValue in
                showError = newValue != nil
            }
            .onChange(of: network.isOnline) { _, isOnline in
                if isOnline, !viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Task { await viewModel.search(reset: true) }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(AppStrings.UI.clearButton) {
                        viewModel.query = AppStrings.UI.empty
                        Task { await viewModel.search(reset: true) }
                    }
                    .disabled(viewModel.query.isEmpty)
                }
            }
            .overlay(alignment: .bottom) {
                if viewModel.isLoading {
                    ProgressView(AppStrings.UI.loading)
                        .padding(12)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .padding(.bottom, 16)
                }
            }
            .alert(AppStrings.UI.errorTitle, isPresented: $showError, actions: {
                Button(AppStrings.UI.okButton, role: .cancel) {}
            }, message: {
                Text(viewModel.errorMessage ?? AppStrings.UI.unknownError)
            })
            .task {
                viewModel.loadLastCachedQueryIfNeeded()
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: AppStrings.SystemImage.magnifyingGlass)
                .font(.system(size: 44))
                .foregroundStyle(Color.secondary)
            Text(AppStrings.UI.emptyStateTitle)
                .font(.title3)
                .fontWeight(.semibold)
            Text(AppStrings.UI.emptyStateMessage)
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var resultsList: some View {
        List {
            if !network.isOnline {
                offlineBanner
            }
            if viewModel.isFromCache {
                cacheBanner
            }

            ForEach(viewModel.movies) { movie in
                NavigationLink(value: movie) {
                    MovieRow(movie: movie)
                }
                .task {
                    await viewModel.loadNextPageIfNeeded(currentMovie: movie)
                }
            }
        }
        .listStyle(.plain)
        .refreshable {
            guard network.isOnline else { return }
            await viewModel.search(reset: true)
        }
        .navigationDestination(for: Movie.self) { movie in
            MovieDetailView(movie: movie)
        }
    }

    private var offlineBanner: some View {
        Section {
            Label(AppStrings.UI.offlineBanner, systemImage: AppStrings.SystemImage.wifiSlash)
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
        }
    }

    private var cacheBanner: some View {
        Section {
            VStack(alignment: .leading, spacing: 4) {
                Label(AppStrings.UI.cachedResultsTitle, systemImage: AppStrings.SystemImage.tray)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
                if let lastUpdated = viewModel.lastUpdated {
                    Text("\(AppStrings.UI.lastUpdatedPrefix) \(lastUpdated.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                }
            }
        }
    }
}
