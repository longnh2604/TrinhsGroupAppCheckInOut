//
//  UserModel.swift
//  TrinhsgroupCheckInOut
//
//  Created by longnh on 2022/05/10.
//

import Foundation

class UserModel: NSObject {

    var uid : String?
    var email: String?
    var isAdmin: Bool?
    var shop: String?
    var avatarURL: String?
    var username: String?
  
    override init() { }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
