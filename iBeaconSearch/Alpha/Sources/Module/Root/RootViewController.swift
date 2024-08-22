//
//  RootViewController.swift
//  Alpha
//
//  Created by Tomoki Hirayama on 2024/08/22.
//

import UIKit

final class RootViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let viewController = DependencyViewBuilder.shared.beaconSearch
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .coverVertical
        present(viewController, animated: true)
    }
}
