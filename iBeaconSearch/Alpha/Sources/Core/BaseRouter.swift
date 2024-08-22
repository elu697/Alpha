//
//  BaseRouter.swift
//  Alpha
//
//  Created by Tomoki Hirayama on 2024/05/02.
//

import UIKit

@MainActor
class BaseRouter {
    weak var moduleViewController: UIViewController?

    init(moduleViewController: UIViewController) {
        self.moduleViewController = moduleViewController
    }

    func presentNavigation(_ targetViewController: UIViewController, completion: (() -> Void)? = nil) {
        let viewController = UINavigationController(rootViewController: targetViewController)
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .coverVertical
        moduleViewController?.present(viewController, animated: true, completion: completion)
    }

    func present(_ targetViewController: UIViewController, completion: (() -> Void)? = nil) {
        moduleViewController?.present(targetViewController, animated: true, completion: completion)
    }

    func push(_ targetViewController: UIViewController) {
        guard let navigationController = moduleViewController?.navigationController else {
            assertionFailure("NavigationController is not set.")
            return
        }
        navigationController.pushViewController(targetViewController, animated: true)
    }

    func dismiss() {
        moduleViewController?.dismiss(animated: true)
    }

    func pop() {
        guard let navigationController = moduleViewController?.navigationController else {
            dismiss()
            return
        }
        navigationController.popViewController(animated: true)
    }
}
