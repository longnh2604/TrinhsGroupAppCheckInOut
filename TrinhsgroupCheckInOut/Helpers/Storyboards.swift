//
//  Storyboards.swift
//  TrinhsgroupCheckInOut
//
//  Created by longnh on 2022/05/09.
//

import UIKit

enum Storyboards {
    case login
    case main
    case admin

    /// Respective story board name
    private var boardName: String {
        switch self {
        case .login, .main, .admin:
            return "Main"
        }
    }
    
    /// Respective controller identifier
    private var identifier: String {
        switch self {
        // Welcome
        case .login: return LoginVC.identifier
        case .main: return MainVC.identifier
        case .admin: return AdminVC.identifier
        }
    }
    
    /// Intantiate from the given boardname and controller identifier
    /// - Returns: Base view controller
    func instantiate() -> UIViewController {
        let storyboard = UIStoryboard(name: boardName, bundle: Bundle.main)
        if #available(iOS 13.0, *) {
            let controller = storyboard.instantiateViewController(identifier: identifier)
            return controller
        } else {
            let controller = storyboard.instantiateViewController(withIdentifier: identifier)
            return controller
        }
        
    }
}
