//
//  NetworkMonitor.swift
//  MovieApp
//
//  Created by Malindu on 2026-02-09.
//


import Foundation
import Network

final class NetworkMonitor: ObservableObject {
    @Published private(set) var isOnline: Bool = true

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: AppStrings.Internal.networkMonitorQueue)

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isOnline = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
