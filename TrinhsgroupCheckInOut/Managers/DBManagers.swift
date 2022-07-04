//
//  DBManagers.swift
//  TrinhsgroupCheckInOut
//
//  Created by longnh on 2022/05/10.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

enum InOutRequest: String {
    case checkIn = "checkIn"
    case checkOut = "checkOut"
}

typealias requestLogCompletion = (_ success: Bool, _ log: String?) -> Void
typealias requestUsersCompletion = (_ success: Bool, _ users: [UserModel], _ log: String?) -> Void

class DBManagers {
    
    static let shared = DBManagers()
    
    func onCreateUser(email: String, uid: String, username: String, imageURL: String?, completion: @escaping requestLogCompletion) {
        let db = Firestore.firestore()
        db.collection("users").addDocument(data: ["imageURL": imageURL ?? "", "email": email, "username" : username, "uid": uid, "shop": "TrinhsKitchenGisborne", "isAdmin": false]) { (error) in
            if error != nil {
                print("Account created, but database couldn't save name")
                completion(false, error!.localizedDescription)
            } else {
                completion(true,nil)
            }
        }
    }
    
    func onGetUser(uid: String, completion: @escaping requestLogCompletion) {
        let db = Firestore.firestore()
        db.collection("users").whereField("uid", isEqualTo: "\(uid)").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(false, error.localizedDescription)
            } else {
                for document in snapshot!.documents {
                    GlobalVariables.shared.user?.uid = document.documentID
                    self.onFetchingUser(data: document)
                    completion(true, nil)
                    return
                }
                completion(false, nil)
            }
        }
    }
    
    func onListAllUser(completion: @escaping requestUsersCompletion) {
        let db = Firestore.firestore()
        db.collection("users").whereField("shop", isEqualTo: "TrinhsKitchenGisborne").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(false, [], error.localizedDescription)
            } else {
                if let documents = snapshot?.documents {
                    completion(true, self.onFetchingUserList(data: documents), nil)
                    return
                }
                completion(true, [], nil)
            }
        }
    }
    
    func onSendInOutRequest(type: InOutRequest, uid: String, username: String, time: Date, completion: @escaping requestLogCompletion) {
        let db = Firestore.firestore()
        db.collection("checkinout").addDocument(data: ["uid": uid, "username": username, "time": Utility.onConvertDateToString(date: time, format: nil), "type": type.rawValue]) { (error) in
            if error != nil {
                print("Check In Out failed")
                completion(false, error!.localizedDescription)
            } else {
                completion(true,nil)
            }
        }
    }
    
    func onGetCheckInOutHistory(uid: String, completion: @escaping requestLogCompletion) {
        let db = Firestore.firestore()
        db.collection("checkinout").whereField("uid", isEqualTo: "\(uid)").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(false, error.localizedDescription)
            } else {
                if let snapshot = snapshot {
                    self.onFetchingInOut(data: snapshot.documents)
                    completion(true, nil)
                    return
                }
                completion(false, nil)
            }
        }
    }
    
    func onGetCheckInOutHistoryAll(completion: @escaping requestLogCompletion) {
        let db = Firestore.firestore()
        db.collection("checkinout").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(false, error.localizedDescription)
            } else {
                if let snapshot = snapshot {
                    self.onFetchingInOut(data: snapshot.documents)
                    completion(true, nil)
                    return
                }
                completion(false, nil)
            }
        }
    }
}

extension DBManagers {
    func onFetchingUserList(data: [QueryDocumentSnapshot]) -> [UserModel] {
        var users = [UserModel]()
        for document in data {
            let new = UserModel()
            new.username = document["username"] as? String
            new.email = document["email"] as? String
            new.avatarURL = document["avatarURL"] as? String
            new.isAdmin = document["isAdmin"] as? Bool
            new.shop = document["shop"] as? String
            new.uid = document["uid"] as? String
            users.append(new)
        }
        return users
    }
    
    func onFetchingUser(data: QueryDocumentSnapshot) {
        GlobalVariables.shared.user?.email = data["email"] as? String
        GlobalVariables.shared.user?.username = data["username"] as? String
        GlobalVariables.shared.user?.avatarURL = data["imageURL"] as? String
        GlobalVariables.shared.user?.isAdmin = data["isAdmin"] as? Bool
        GlobalVariables.shared.user?.shop = data["shop"] as? String
        GlobalVariables.shared.user?.uid = data["uid"] as? String
    }
    
    func onFetchingInOut(data: [QueryDocumentSnapshot]) {
        GlobalVariables.shared.inoutHistory.removeAll()
        for document in data {
            guard let uid = document["uid"] as? String, let type = document["type"] as? String, let time = document["time"] as? String else { return }
            GlobalVariables.shared.inoutHistory.append(InOutModel(uid: uid, username: document["username"] as? String ?? "undefined", type: type, time: time))
        }
        GlobalVariables.shared.inoutHistory = GlobalVariables.shared.inoutHistory.sorted(by: { $0.time < $1.time })
    }
}
