//
//  SingUpController.swift
//  Pippip
//
//  Created by Kawewut Chujit on 12/29/2559 BE.
//  Copyright © 2559 Kawewut Chujit. All rights reserved.
//

import UIKit
import Firebase
class SingUpController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func singupAction(_ sender: AnyObject) {
        guard let email = usernameTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        if self.usernameTextField.text == "" || self.passwordTextField.text == "" || self.nameTextField.text == ""{
            
            let alert = UIAlertController(title: "Oops!",
                                          message: "plase enter username oand password",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,
                                          handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
                
                if error != nil {
                    let alert = UIAlertController(title: "Oops!",
                                                  message: error?.localizedDescription,
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,
                                                  handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                guard let uid = user?.uid else {
                    return
                }
                
                //successfully authenticated user
                let ref = FIRDatabase.database().reference(fromURL: "https://pippip-5a92a.firebaseio.com/")
                let usersReference = ref.child("users").child(uid)
                let values = ["name": name, "email": email]
                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    
                    if err != nil {
                        print(err)
                        return
                    }
                    
                    let alert = UIAlertController(title: "Oops!",
                                                  message: "sing up ok",
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,
                                                  handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    

                })
           
            })
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
