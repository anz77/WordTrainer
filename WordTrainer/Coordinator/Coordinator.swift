//
//  Coordinator.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 17.12.2020.
//

import UIKit

public class Coordinator: CoordinatorProtocol {
    
    // MARK: - Instance Properties
    public var children: [CoordinatorProtocol] = []
    public let router: RouterProtocol
    
    var storageManager = CoreDataManager()
    
    // MARK: - Object Lifecycle
    public init(router: RouterProtocol) {
        self.router = router
    }
    
    // MARK: - Instance Methods
    public func present(animated: Bool, onDismissed: (() -> Void)?) {
        
        let viewController = ModulesBuilder.configureBookViewController(storageManager: storageManager)
        //.instantiate(delegate: self)
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
}

// MARK: - HomeViewControllerDelegate
//extension Coordinator: HomeViewControllerDelegate {
//
//  public func homeViewControllerDidPressScheduleAppointment(_ viewController: HomeViewController) {
//    let router = ModalNavigationRouter(parentViewController: viewController)
//    let coordinator = PetAppointmentBuilderCoordinator(router: router)
//    presentChild(coordinator, animated: true)
//  }
//}
