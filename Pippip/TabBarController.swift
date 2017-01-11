//
//  TabBarController.swift
//  Pippip
//
//  Created by Kawewut Chujit on 1/10/2560 BE.
//  Copyright © 2560 Kawewut Chujit. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    var titles = ["friend","chat","condition","setting"]
    var arrayOfImageNameForSelectedState = ["group-buttonse","conversationse","sentse","settingsse"]
    var arrayOfImageNameForUnselectedState = ["group-buttonunse","conversationunse","sentunse","settingsunse"]
    override func viewDidLoad() {
        super.viewDidLoad()

        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                let imageNameForSelectedState   = arrayOfImageNameForSelectedState[i]
                let imageNameForUnselectedState = arrayOfImageNameForUnselectedState[i]
                
                self.tabBar.items?[i].selectedImage = UIImage(named: imageNameForSelectedState)?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = UIImage(named: imageNameForUnselectedState)?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].title = titles[i]
               
                 
            }
        }
        
        let selectedColor   =  UIColor(red:255.0/255.0, green: 159.0/255.0, blue: 28/255.0, alpha: 1.0)
        let unselectedColor = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 0.5)
        
    
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: selectedColor], for: .selected)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
