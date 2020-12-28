//
//  CoordinatorProtocol.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 17.12.2020.
//


public protocol CoordinatorProtocol: class {

  var children: [CoordinatorProtocol] { get set }
  var router: RouterProtocol { get }

  func present(animated: Bool, onDismissed: (() -> Void)?)
  func dismiss(animated: Bool)
  func presentChild(_ child: CoordinatorProtocol, animated: Bool, onDismissed: (() -> Void)?)
}

extension CoordinatorProtocol {

  public func dismiss(animated: Bool) {
    router.dismiss(animated: true)
  }

  public func presentChild(_ child: CoordinatorProtocol, animated: Bool, onDismissed: (() -> Void)? = nil) {
    children.append(child)
    child.present(animated: animated, onDismissed: { [weak self, weak child] in
      guard let self = self, let child = child else { return }
      self.removeChild(child)
      onDismissed?()
    })
  }

  private func removeChild(_ child: CoordinatorProtocol) {
    guard let index = children.firstIndex(where:  { $0 === child }) else { return }
    children.remove(at: index)
  }
}

