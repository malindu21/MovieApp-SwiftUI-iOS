//
//  Config.swift
//  MovieApp
//
//  Created by Malindu on 2026-02-09.
//


import Foundation

enum Config {
    static var tmdbApiKey: String {
        if let value = Bundle.main.object(forInfoDictionaryKey: AppStrings.Config.infoPlistApiKey) as? String,
           !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return value
        }
        if let env = ProcessInfo.processInfo.environment[AppStrings.Config.envApiKey],
           !env.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return env
        }
        return AppStrings.UI.empty
    }
}
