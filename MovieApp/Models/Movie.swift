//
//  Movie.swift
//  MovieApp
//
//  Created by Malindu on 2026-02-09.
//


import Foundation

struct Movie: Identifiable, Codable, Equatable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String?
    let posterPath: String?

    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "\(AppStrings.API.baseImageURL)\(posterPath)")
    }

    var releaseYearText: String {
        guard let releaseDate, let date = DateParser.tmdbDateFormatter.date(from: releaseDate) else {
            return AppStrings.UI.unknownReleaseDate
        }
        return DateParser.yearFormatter.string(from: date)
    }

    var releaseDateText: String {
        guard let releaseDate, let date = DateParser.tmdbDateFormatter.date(from: releaseDate) else {
            return AppStrings.UI.unknownReleaseDate
        }
        return DateParser.displayFormatter.string(from: date)
    }

    init(id: Int, title: String, overview: String, releaseDate: String?, posterPath: String?) {
        self.id = id
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.posterPath = posterPath
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        id = try container.decode(Int.self, forKey: AnyCodingKey(AppStrings.CodingKeys.id))
        title = try container.decode(String.self, forKey: AnyCodingKey(AppStrings.CodingKeys.title))
        overview = try container.decode(String.self, forKey: AnyCodingKey(AppStrings.CodingKeys.overview))
        releaseDate = try container.decodeIfPresent(String.self, forKey: AnyCodingKey(AppStrings.CodingKeys.releaseDate))
        posterPath = try container.decodeIfPresent(String.self, forKey: AnyCodingKey(AppStrings.CodingKeys.posterPath))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyCodingKey.self)
        try container.encode(id, forKey: AnyCodingKey(AppStrings.CodingKeys.id))
        try container.encode(title, forKey: AnyCodingKey(AppStrings.CodingKeys.title))
        try container.encode(overview, forKey: AnyCodingKey(AppStrings.CodingKeys.overview))
        try container.encodeIfPresent(releaseDate, forKey: AnyCodingKey(AppStrings.CodingKeys.releaseDate))
        try container.encodeIfPresent(posterPath, forKey: AnyCodingKey(AppStrings.CodingKeys.posterPath))
    }
}

enum DateParser {
    static let tmdbDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: AppStrings.DateFormat.posixLocale)
        formatter.dateFormat = AppStrings.DateFormat.tmdbDate
        return formatter
    }()

    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    static let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = AppStrings.DateFormat.year
        return formatter
    }()
}
