//
//  Router.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 17.12.2020.
//

import UIKit

public class AppDelegateRouter: RouterProtocol {

  // MARK: - Instance Properties
  public let window: UIWindow

  // MARK: - Object Lifecycle
  public init(window: UIWindow) {
    self.window = window
  }

  // MARK: - Router
  public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (()->Void)?) {
    window.rootViewController = viewController
    window.makeKeyAndVisible()
  }

  public func dismiss(animated: Bool) {
    // don't do anything
  }
}

public class ModalNavigationRouter: NSObject {
  
  // MARK: - Instance Properties
  public unowned let parentViewController: UIViewController
  
  private let navigationController = UINavigationController()
  private var onDismissForViewController: [UIViewController: (() -> Void)] = [:]
  
  // MARK: - Object Lifecycle
  public init(parentViewController: UIViewController) {
    self.parentViewController = parentViewController
    super.init()
    navigationController.delegate = self
  }
}

// MARK: - Router
extension ModalNavigationRouter: RouterProtocol {
  
  public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
    onDismissForViewController[viewController] = onDismissed
    navigationController.viewControllers.count == 0 ?
      presentModally(viewController, animated: animated)
      : navigationController.pushViewController(viewController, animated: animated)
    
  }
  
  private func presentModally(_ viewController: UIViewController, animated: Bool) {
    addCancelButton(to: viewController)
    navigationController.setViewControllers([viewController], animated: false)
    parentViewController.present(navigationController, animated: animated, completion: nil)
  }
  
  private func addCancelButton(to viewController: UIViewController) {
    viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
  }
  
  @objc private func cancelPressed() {
    //performOnDismissed(for: navigationController.viewControllers.first!)
    dismiss(animated: true)
  }
  
  public func dismiss(animated: Bool) {
    performOnDismissed(for: navigationController.viewControllers.first!)
    parentViewController.dismiss(animated: animated, completion: nil)
  }
  
  private func performOnDismissed(for viewController: UIViewController) {
    guard let onDismiss = onDismissForViewController[viewController] else { return }
    onDismiss()
    onDismissForViewController[viewController] = nil
  }
}

// MARK: - UINavigationControllerDelegate
extension ModalNavigationRouter: UINavigationControllerDelegate {
  
  public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    
    guard let dismissedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(dismissedViewController) else { return }
    
    performOnDismissed(for: dismissedViewController)
  }
}

