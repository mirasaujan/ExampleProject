//
//  FavoriteCoordinator.swift
//  MemeLog
//
//  Created by Miras Karazhigitov on 07.03.2022.
//

import UIKit

final class FavoriteCoordinator {
    var navigationController: UINavigationController?
    private let flow: FavoriteCoordinatorFlowProtocol

    init(navigationController: UINavigationController, flow: FavoriteCoordinatorFlowProtocol) {
        self.navigationController = navigationController
        self.flow = flow
    }
    
    func start() {
        navigationController?.viewControllers = [flow.postListViewController(onSelect: { [weak self] post in
            guard let self = self else { return }
            self.navigationController?.pushViewController(self.flow.postDetailViewController(post: post), animated: true)
        })]
    }
}
