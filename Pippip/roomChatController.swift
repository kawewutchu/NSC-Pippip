//
//  roomChatController.swift
//  Pippip
//
//  Created by Kawewut Chujit on 1/5/2560 BE.
//  Copyright © 2560 Kawewut Chujit. All rights reserved.
//

import UIKit
import Firebase
class roomChatController: UITableViewController {
    
    let cellId = "cellId"
    var messages = [Message]()
    let user = User()
    var messagesDictionary = [String: Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        messages.removeAll()
        messagesDictionary.removeAll()
        
        observeUserMessages()

      
    }
    override func viewWillAppear(_ animated: Bool) {
          observeCondition()
    }
    
    func observeCondition() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        //self.senderId = uid
        let userMessagesRef = FIRDatabase.database().reference().child("user-condition").child(uid)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let conditionId = snapshot.key
            let conditionRef = FIRDatabase.database().reference().child("condition").child(conditionId)
            conditionRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let condition = Condition()
                condition.setValuesForKeys(dictionary)
                
                var chatPartnerId =  condition.chatPartnerId()
                print(condition.timestamp)
                let timestamp = Int(Date().timeIntervalSince1970)
                if(condition.timestamp != nil){
                    if(Int(condition.timestamp!) <= timestamp){
                        self.sentCondition(toId: condition.toId!, fromId: condition.fromId! , text: condition.text!)
                         FIRDatabase.database().reference().child("condition").child(conditionId).removeValue()
                    }
                }
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    func sentCondition(toId: String, fromId:String, text: String){
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let timestamp = Int(Date().timeIntervalSince1970)
        let values = ["text": text, "toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toId)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
            
        }
        
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }

    }
   
    
    func observeUserMessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesReference = FIRDatabase.database().reference().child("messages").child(messageId)
            
            messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Message(dictionary : dictionary)
                    message.setValuesForKeys(dictionary)
                    
                    if let chatPartnerId = message.chatPartnerId() {
                        self.messagesDictionary[chatPartnerId] = message
                        
                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            
                            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
                        })
                    }
                    
                    //this will crash because of background thread, so lets call this on dispatch_async main thread
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                    }
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    
    func observeMessages() {
        let ref = FIRDatabase.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary :dictionary)
                message.setValuesForKeys(dictionary)
                //                self.messages.append(message)
                
                if let toId = message.toId {
                    self.messagesDictionary[toId] = message
                    
                    self.messages = Array(self.messagesDictionary.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        
                        return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
                    })
                }
                
                //this will crash because of background thread, so lets call this on dispatch_async main thread
                 DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }
            
        }, withCancel: nil)    }
    
  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! roomCell
        
        let message = messages[indexPath.row]
        cell.message = message
        cell.profileImg.translatesAutoresizingMaskIntoConstraints = false
        cell.profileImg.layer.cornerRadius = 24
        cell.profileImg.layer.masksToBounds = true
        cell.profileImg.contentMode = .scaleAspectFill
        
           
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexuser = indexPath.row
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            self.user.id = chatPartnerId
            self.user.setValuesForKeys(dictionary)
            DispatchQueue.main.async{
                self.performSegue(withIdentifier: "show", sender: self)
            }

            
        }, withCancel: nil)

            }
    
    var indexuser = Int()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "show" {
            if let viewController: chatController = segue.destination as? chatController {
                viewController.userChat = user
            }
        }
    }

}
