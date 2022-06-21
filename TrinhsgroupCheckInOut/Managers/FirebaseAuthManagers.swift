//
//  FirebaseAuthManagers.swift
//  TrinhsgroupCheckInOut
//
//  Created by longnh on 2022/05/09.
//

import FirebaseAuth
import UIKit

class FirebaseAuthManager {
    
    static let shared = FirebaseAuthManager()
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool,_ error: String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                print(user)
                GlobalVariables.shared.user = UserModel(uid: user.uid, email: user.email ?? "")
                completionBlock(true, nil)
            } else {
                completionBlock(false, error?.localizedDescription ?? "")
            }
        }
    }
    
    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool, _ errror: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false, error.localizedDescription)
            } else {
                if let user = result?.user {
                    print(user)
                    GlobalVariables.shared.user = UserModel(uid: user.uid, email: user.email ?? "")
                }
                completionBlock(true, nil)
            }
        }
    }
    
    func signOut(completionBlock: @escaping (_ success: Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completionBlock(true)
        } catch {
            print("already logged out")
            completionBlock(true)
        }
    }
}
