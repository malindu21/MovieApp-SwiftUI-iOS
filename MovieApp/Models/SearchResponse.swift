//
//  SearchResponse.swift
//  MovieApp
//
//  Created by Malindu on 2026-02-09.
//


import Foundation

struct SearchResponse: Codable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [Movie]

    init(page: Int, totalPages: Int, totalResults: Int, results: [Movie]) {
        self.page = page
        self.totalPages = totalPages
        self.totalResults = totalResults
        self.results = results
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        page = try container.decode(Int.self, forKey: AnyCodingKey(AppStrings.CodingKeys.page))
        totalPages = try container.decode(Int.self, forKey: AnyCodingKey(AppStrings.CodingKeys.totalPages))
        totalResults = try container.decode(Int.self, forKey: AnyCodingKey(AppStrings.CodingKeys.totalResults))
        results = try container.decode([Movie].self, forKey: AnyCodingKey(AppStrings.CodingKeys.results))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(page, forKey: AnyCodingKey(AppStrings.CodingKeys.page))
        try container.encode(totalPages, forKey: AnyCodingKey(AppStrings.CodingKeys.totalPages))
        try container.encode(totalResults, forKey: AnyCodingKey(AppStrings.CodingKeys.totalResults))
        try container.encode(results, forKey: AnyCodingKey(AppStrings.CodingKeys.results))
    }
}
