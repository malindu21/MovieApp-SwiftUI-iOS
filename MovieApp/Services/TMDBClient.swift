//
//  TMDBClient.swift
//  MovieApp
//
//  Created by Malindu on 2026-02-09.
//


import Foundation

struct TMDBClient {
    enum TMDBError: LocalizedError {
        case invalidURL
        case invalidResponse
        case decodingFailed
        case missingAPIKey
        case transport(Error)

        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return AppStrings.Errors.invalidURL
            case .invalidResponse:
                return AppStrings.Errors.invalidResponse
            case .decodingFailed:
                return AppStrings.Errors.decodingFailed
            case .missingAPIKey:
                return AppStrings.Errors.missingAPIKey
            case .transport(let error):
                return error.localizedDescription
            }
        }
    }

    private let session: URLSession
    private let apiKey: String

    init(session: URLSession = .shared, apiKey: String = Config.tmdbApiKey) {
        self.session = session
        self.apiKey = apiKey
    }

    func searchMovies(query: String, page: Int) async throws -> SearchResponse {
        guard !apiKey.isEmpty else {
            throw TMDBError.missingAPIKey
        }

        guard var components = URLComponents(string: AppStrings.API.searchURL) else {
            throw TMDBError.invalidURL
        }
        components.queryItems = [
            URLQueryItem(name: AppStrings.API.apiKeyQuery, value: apiKey),
            URLQueryItem(name: AppStrings.API.queryQuery, value: query),
            URLQueryItem(name: AppStrings.API.pageQuery, value: String(page)),
            URLQueryItem(name: AppStrings.API.includeAdultQuery, value: AppStrings.API.includeAdultValue),
            URLQueryItem(name: AppStrings.API.languageQuery, value: AppStrings.API.languageValue)
        ]
        guard let url = components.url else {
            throw TMDBError.invalidURL
        }

        var request = URLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                throw TMDBError.invalidResponse
            }
            do {
                return try JSONDecoder().decode(SearchResponse.self, from: data)
            } catch {
                throw TMDBError.decodingFailed
            }
        } catch {
            throw TMDBError.transport(error)
        }
    }
}
