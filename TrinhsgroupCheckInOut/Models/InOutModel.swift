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
    var documentId: String = ""
  
    override init() { }
    
    init(documentId: String, type: String, time: String) {
        self.documentId = documentId
        self.type = type
        self.time = time
    }
}
