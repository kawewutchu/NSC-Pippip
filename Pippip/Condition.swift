//
//  Condition.swift
//  Pippip
//
//  Created by Kawewut Chujit on 1/15/2560 BE.
//  Copyright © 2560 Kawewut Chujit. All rights reserved.
//
import UIKit
import Firebase
class Condition: NSObject {
    var fromId: String?
    var password: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    var longtitude = Double()
    var latitude = Double()
    
    func chatPartnerId() -> String? {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
    
}
