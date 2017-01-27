//
//  addConditionController.swift
//  Pippip
//
//  Created by Kawewut Chujit on 1/11/2560 BE.
//  Copyright © 2560 Kawewut Chujit. All rights reserved.
//

import UIKit
import Firebase
class addConditionController: UIViewController , UITableViewDelegate ,UITableViewDataSource ,UIImagePickerControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var userChat = User()
    var condition = ""
    var dateTime = ""
    var longtitude = Double()
    var latitude = Double()
    let conditionDefaults = Foundation.UserDefaults.standard
    var conditionType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print("date" + dateTime)
        conditionDefaults.set("", forKey: "Key")
        conditionDefaults.set(nil, forKey: "timestamp")
        self.conditionDefaults.set(nil, forKey: "longtitude")
        self.conditionDefaults.set(nil, forKey: "latitude")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if conditionDefaults.string(forKey: "Key") != nil{
            dateTime = conditionDefaults.string(forKey: "Key")!
            conditionType = "time"
            self.tableView.reloadData()
        }
        if conditionDefaults.string(forKey: "longtitude") != nil{
            longtitude = conditionDefaults.double(forKey: "longtitude")
            latitude = conditionDefaults.double(forKey: "latitude")
            print(longtitude)
            conditionType = "place"
            self.tableView.reloadData()
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 2
        }else{
            return 1
        }
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConditionCell", for: indexPath) as! ConditionCell
            if(indexPath.row == 0){
                cell.timeLabel.text = "time"
                cell.timePicker.text = dateTime
            }else if(indexPath.row == 1){
                cell.timeLabel.text = "place"
                cell.timePicker.text = String(longtitude) + String(longtitude)
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addPicture", for: indexPath) as! ConditionCell
            if(indexPath.row == 2){
             
            cell.timeLabel.text = "picture"
            cell.addTime.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            }
            return cell
        }
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var condition = ["time","place"]
        if(indexPath.section == 1){
            self.buttonTapped()
        }else{
            self.performSegue(withIdentifier: condition[indexPath.row], sender: self)
        }
      
    }
    
    @IBAction func addConditionPress(_ sender: Any) {
        let text = "testplaace"
        let ref = FIRDatabase.database().reference().child("condition")
        let childRef = ref.childByAutoId()
        let toId = userChat.id
        let fromId = FIRAuth.auth()!.currentUser!.uid
      
        //let values = Dictionary()
        if(conditionType == "time"){
           let timestamp = self.conditionDefaults.string(forKey: "timestamp")!
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
        else if(conditionType == "place"){
            
            let values = ["text": text,"toId": toId, "fromId": fromId, "latitude":latitude ,"longtitude":longtitude] as [String : Any]
            
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
       
    }
   
   
    func buttonTapped() {
        
     
        let sheet = UIAlertController(title: "Media Massage", message: "Please selecta media", preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancel = UIAlertAction(title: "cancle", style: UIAlertActionStyle.cancel) { (UIAlertAction) in
            
        }
        var photoimage = UIImage()
        let photo = UIAlertAction(title: "Photo Libary", style: UIAlertActionStyle.default) { (UIAlertAction) in
            let picker = UIImagePickerController()
            
            //picker.delegate = self
            picker.allowsEditing = true
            
            self.present(picker, animated: true, completion: nil)
        }
        
        let vedio = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (UIAlertAction) in
          
            
//            self.imagePicker =  UIImagePickerController()
//            //imagePicker.delegate = self
//            self.imagePicker.sourceType = .camera
//            
//           self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        
        
        
        sheet.addAction(photo)
        sheet.addAction(vedio)
        sheet.addAction(cancel)
        self.present(sheet, animated: true, completion: nil)

    }
//      var imagePicker: UIImagePickerController!
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
//        imagePicker.dismissViewControllerAnimated(true, completion: nil)
//        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
//    }
//    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            //userImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }

//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
//        imagePicker.dismiss(animated: true, completion: nil)
//        //imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
//    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    

    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "time" {
        }
    }
    

}
