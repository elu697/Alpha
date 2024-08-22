//
//  DependencyContainer.swift
//  Alpha
//
//  Created by Tomoki Hirayama on 2024/05/02.
//

import UIKit

protocol DependencyContainerInterface {
    var apiClient: APIClientInterface { get }
}

final class DependencyContainer: DependencyContainerInterface {
    static let shared = DependencyContainer()

    private init() {}

    var apiClient: APIClientInterface {
        APIClient()
    }
}
