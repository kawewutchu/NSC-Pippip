//
//  addConditionController.swift
//  Pippip
//
//  Created by Kawewut Chujit on 1/11/2560 BE.
//  Copyright © 2560 Kawewut Chujit. All rights reserved.
//
//pull 1
import UIKit
import Firebase
class addConditionController: UIViewController , UITableViewDelegate ,UITableViewDataSource ,UIImagePickerControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var userChat = User()
    var condition = ""
    var dateTime = ""
    var longtitude = Double()
    var latitude = Double()
    let conditionDefaults = Foundation.UserDefaults.standard
    var conditionType = ""
    var text = ""
    var password = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print("date" + dateTime)
        conditionDefaults.set("", forKey: "Key")
        conditionDefaults.set(nil, forKey: "timestamp")
        self.conditionDefaults.set(nil, forKey: "longtitude")
        self.conditionDefaults.set(nil, forKey: "latitude")
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource  = self
        self.hideKeyboardWhenTappedAround()
        
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
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 2
        }else if(section == 1){
            return 1
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
                cell.addTime.addTarget(self, action: #selector(addtime), for: .touchUpInside)
            }else if(indexPath.row == 1){
                cell.timeLabel.text = "place"
                cell.timePicker.text = String(longtitude) + String(longtitude)
                cell.addTime.addTarget(self, action: #selector(addplace), for: .touchUpInside)
            }
            return cell
        }else if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "addPicture", for: indexPath) as! ConditionCell
            if(indexPath.row == 2){
             
            cell.timeLabel.text = "picture"
            cell.addPicture.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            }
            return cell
        }else if(indexPath.section == 2){
            if(indexPath.row == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "password", for: indexPath) as! ConditionCell
                cell.timeLabel.text = "password"
                cell.textField.placeholder = "password"
                cell.textField.delegate = self
                cell.textField.tag = 1
                return cell
            }
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! ConditionCell
            cell.textField2.delegate = self
            cell.textField2.tag = 2
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! ConditionCell
        return cell

    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
       
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 3){
            return 150
        }else
        {
            return 44
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if(textField.tag == 2){
             self.text = textField.text!
        }else{
             self.password = textField.text!
             self.conditionType = "password"
        }
       
    }
    
    
    
    // MARK: - to Firebase
    //--------------------------------------------------------//
    @IBAction func addConditionPress(_ sender: Any) {
        
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
                
                let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-condition").child(toId!)
                recipientUserMessagesRef.updateChildValues([messageId: 1])
                
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
                
                let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-condition").child(toId!)
                recipientUserMessagesRef.updateChildValues([messageId: 1])
                
                
            }
        }else if(conditionType == "password"){
            let values = ["text": text,"toId": toId, "fromId": fromId, "password":self.password] as [String : Any]
            
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error)
                    return
                }
                
                let userMessagesRef = FIRDatabase.database().reference().child("user-condition").child(fromId)
                
                let messageId = childRef.key
                userMessagesRef.updateChildValues([messageId: 1])
                
                let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-condition").child(toId!)
                recipientUserMessagesRef.updateChildValues([messageId: 1])
                
                
            }
        }
       sendtext()
    }
    
    func sendtext(){
        var text2 = ""
        if(conditionType == "place"){
            text2 = "คุณมีข้อความในรูปแบบสถานที่"
        }else if(conditionType == "password"){
            text2 = "คุณมีข้อความในรูป password"
        }
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = userChat.id
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        let values = ["text": text2, "toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toId!)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
            
        }
    }
    
    //MARK: - add condition type
    //----------------------------------------------------------------//
    func addtime() {
        self.performSegue(withIdentifier: "time", sender: self)
    }
    func addplace() {
        self.performSegue(withIdentifier: "place", sender: self)
    }
    

    
    
    //MARK: - IMAGEPICKER
    //----------------------------------------------------------------//
   
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
          
        }
        sheet.addAction(photo)
        sheet.addAction(vedio)
        sheet.addAction(cancel)
        self.present(sheet, animated: true, completion: nil)
    }

    
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


    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "time" {
        }
        if segue.identifier == "place" {
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
