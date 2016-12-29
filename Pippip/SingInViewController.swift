//
//  SingInViewController.swift
//  Pippip
//
//  Created by Kawewut Chujit on 12/25/2559 BE.
//  Copyright © 2559 Kawewut Chujit. All rights reserved.
//

import UIKit
import Firebase
class SingInViewController: UIViewController {

    
    @IBOutlet weak var logoappLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = FIRAuth.auth()?.currentUser{
            self.logoutButton.alpha = 1.0
            self.logoappLabel.text = user.email
        }
        else{
            self.logoutButton.alpha = 0.0
            self.logoappLabel.text = ""
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func singinAction(_ sender: AnyObject) {
        if self.usernameTextField.text == "" || self.passwordTextField.text == ""{
            
            let alert = UIAlertController(title: "Oops!",
                                          message: "plase enter username oand password",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,
                                          handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            FIRAuth.auth()?.signIn(withEmail: self.usernameTextField.text! ,
                                   password: self.passwordTextField.text!,
                                   completion: { (user , Error) in
                                    
                                    if Error == nil{
                                        self.logoutButton.alpha = 1.0
                                        self.logoappLabel.text = user!.email
                                        self.usernameTextField.text = ""
                                        self.passwordTextField.text = ""
                                    }
                                    else{
                                        let alert = UIAlertController(title: "Oops!",
                                                                      message: Error?.localizedDescription,
                                                                      preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,
                                                                      handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    }
                                    
            })

        }
    }

    
    @IBAction func logoutAction(_ sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
        self.logoappLabel.text = ""
        self.logoutButton.alpha = 0.0
        self.usernameTextField.text = ""
        self.passwordTextField.text = ""
        
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
