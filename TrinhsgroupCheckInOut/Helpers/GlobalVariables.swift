//
//  GlobalVariables.swift
//  TrinhsgroupCheckInOut
//
//  Created by longnh on 2022/05/10.
//

import Foundation

class GlobalVariables: NSObject {
    
    static let shared: GlobalVariables = GlobalVariables()
    var user: UserModel?
    var inoutHistory = [InOutModel]()
    var userList = [UserModel]()
    
    func resetAllData() {
        self.user = nil
        self.inoutHistory = []
        self.userList = []
    }
}
