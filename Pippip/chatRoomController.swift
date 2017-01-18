//
//  chatRoomController.swift
//  Pippip
//
//  Created by Kawewut Chujit on 1/4/2560 BE.
//  Copyright © 2560 Kawewut Chujit. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces
class chatRoomController: UITableViewController, CLLocationManagerDelegate{
    
    var locationManager = CLLocationManager()
    
    let cellId = "cellId"
    
    var users = [User]()

    var placesClient: GMSPlacesClient!
    
    var condition = [Condition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
    }
    
 
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.id = snapshot.key
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
                
            }
            
        }, withCancel: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! roomCell
        
        let user = users[indexPath.row]
        cell.usernameChat?.text = user.name
        cell.lastmessage?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImg.loadImageUsingCacheWithUrlString(profileImageUrl)
            cell.profileImg.translatesAutoresizingMaskIntoConstraints = false
            cell.profileImg.layer.cornerRadius = 24
            cell.profileImg.layer.masksToBounds = true
            cell.profileImg.contentMode = .scaleAspectFill

        }
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexuser = indexPath.row
        self.performSegue(withIdentifier: "show", sender: self)
    }

    var indexuser = Int()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "show" {
            if let viewController: chatController = segue.destination as? chatController {
                viewController.userChat = users[indexuser]
            }
        }
    }

}
