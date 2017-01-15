//
//  addConditionController.swift
//  Pippip
//
//  Created by Kawewut Chujit on 1/11/2560 BE.
//  Copyright © 2560 Kawewut Chujit. All rights reserved.
//

import UIKit
import Firebase
class addConditionController: UIViewController , UITableViewDelegate ,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var userChat = User()
    var condition = ""
    var dateTime = ""
    
    let userDefaults = Foundation.UserDefaults.standard
    let timestamp = Foundation.UserDefaults.standard
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print("date" + dateTime)
        userDefaults.set("", forKey: "Key")
        timestamp.set(nil, forKey: "timestamp")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userDefaults.string(forKey: "Key") != nil{
            dateTime = userDefaults.string(forKey: "Key")!
            
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConditionCell", for: indexPath) as! ConditionCell
        if(indexPath.row == 0){
            cell.timeLabel.text = "time"
            cell.timePicker.text = dateTime
        }else if(indexPath.row == 1){
            cell.timeLabel.text = "place"
            cell.timePicker.text = dateTime
        }
        return cell
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var condition = ["time","place"]
        self.performSegue(withIdentifier: condition[indexPath.row], sender: self)
    }
    
    @IBAction func addConditionPress(_ sender: Any) {
        let text = "testtime"
        let ref = FIRDatabase.database().reference().child("condition")
        let childRef = ref.childByAutoId()
        let toId = userChat.id
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp = self.timestamp.string(forKey: "timestamp")!
        let values = ["text": text,"toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            
            let userMessagesRef = FIRDatabase.database().reference().child("user-condition").child(fromId)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
                        
            

        }

    }
   
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "time" {
        }
    }
    

}
