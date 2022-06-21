//
//  UIViewController+Extensions.swift
//  TrinhsgroupCheckInOut
//
//  Created by longnh on 2022/05/09.
//

import UIKit

extension UIViewController {
    
    static var identifier: String {
        return String(describing: self.self)
    }
    
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)

        if let frame = frame {
            child.view.frame = frame
        }

        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func presentOverlay(_ controller: UIViewController) {
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async {
            if let tabbarController = self.tabBarController {
                tabbarController.present(controller, animated: true, completion: nil)
            } else if let navigationController = self.navigationController {
                navigationController.present(controller, animated: true, completion: nil)
            } else {
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
}
