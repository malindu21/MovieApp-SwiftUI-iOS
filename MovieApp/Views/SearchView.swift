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
                } else if viewModel.movies.isEmpty && viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines).count < 3 {
                    typingState
                } else {
                    resultsList
                }
            }
            .navigationTitle(AppStrings.UI.searchScreenTitle)
            .searchable(text: $viewModel.query, prompt: AppStrings.UI.searchPrompt)
            .onChange(of: viewModel.query) { _, _ in
                viewModel.onQueryChanged()
            }
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
                EmptyView()
            }
            .overlay {
                if viewModel.isLoading {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .frame(width: 180, height: 180)
                        VStack(spacing: 8) {
                            LottieView(name: AppStrings.UI.lottieLoadingName, loopMode: .loop)
                                .frame(width: 120, height: 120)
                            Text(AppStrings.UI.loading)
                                .font(.subheadline)
                                .foregroundStyle(Color.secondary)
                        }
                    }
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

    private var typingState: some View {
        VStack(spacing: 10) {
            Image(systemName: AppStrings.SystemImage.magnifyingGlass)
                .font(.system(size: 34))
                .foregroundStyle(Color.secondary)
            Text(AppStrings.UI.typingHint)
                .font(.headline)
            Text(AppStrings.UI.typingHintDetail)
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
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
