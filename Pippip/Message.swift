//
//  Message.swift
//  Pippip
//
//  Created by Kawewut Chujit on 1/5/2560 BE.
//  Copyright © 2560 Kawewut Chujit. All rights reserved.
//

import UIKit
import Firebase
class Message: NSObject {
    
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    
    
    func chatPartnerId() -> String? {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
    
}

