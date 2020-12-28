//
//  RoutrerProtocol.swift
//  WordTrainer
//
//  Created by ANDRII ZUIOK on 17.12.2020.
//

import UIKit

public protocol RouterProtocol: class {
    func present(_ viewController: UIViewController, animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool, onDismissed: (()->Void)?)
    func dismiss(animated: Bool)
}

extension RouterProtocol {
    public func present(_ viewController: UIViewController, animated: Bool) {
        present(viewController, animated: animated, onDismissed: nil)
    }
}
