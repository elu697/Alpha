//
//  DependencyViewBuilder.swift
//  Alpha
//
//  Created by Tomoki Hirayama on 2024/05/08.
//

import UIKit
import SwiftUI

protocol DependencyViewBuilderInterface {
    var rootViewController: UIViewController { get }
    var beaconSearch: UIViewController { get }
}

final class DependencyViewBuilder {
    static let shared: DependencyViewBuilderInterface = DependencyViewBuilder(container: DependencyContainer.shared)

    private let container: DependencyContainerInterface

    init(container: DependencyContainerInterface) {
        self.container = container
    }
}

extension DependencyViewBuilder: DependencyViewBuilderInterface {
    var rootViewController: UIViewController {
        RootViewController()
    }
    
    var beaconSearch: UIViewController {
        UIHostingController(rootView: BeaconSearchView())
    }
}
