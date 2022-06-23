//
//  InOutModel.swift
//  TrinhsgroupCheckInOut
//
//  Created by longnh on 2022/05/10.
//

import Foundation

class InOutModel: NSObject {

    var type : String = ""
    var time: String = ""
    var username: String = ""
    var uid: String = ""
  
    override init() { }
    
    init(uid: String, username: String, type: String, time: String) {
        self.uid = uid
        self.username = username
        self.type = type
        self.time = time
    }
}
