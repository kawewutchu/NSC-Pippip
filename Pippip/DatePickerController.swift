//
//  DatePickerController.swift
//  Pippip
//
//  Created by Kawewut Chujit on 1/11/2560 BE.
//  Copyright © 2560 Kawewut Chujit. All rights reserved.
//

import UIKit

class DatePickerController: UIViewController  {

    @IBOutlet weak var datePicker: UIDatePicker!
    var dateTime = ""
    let userDefaults = Foundation.UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.addTarget(self, action: Selector("datePickerChanged:"), for: UIControlEvents.valueChanged)
        datePicker.datePickerMode = .dateAndTime
        
        
            // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.performSegue(withIdentifier: "show", sender: self)
    }

    
    func datePickerChanged(_ sender: UIDatePicker) {
        let componenets = Calendar.current.dateComponents([.year, .month, .day , .hour , .minute ], from: sender.date)
        if let day = componenets.day, let month = componenets.month, let year = componenets.year ,let hour = componenets.hour , let min = componenets.minute {
            dateTime = "\(day)/\(month)/\(year) \(hour):\(min)"
            print("\(day) \(month) \(year) \(hour) \(min)")
            
            userDefaults.set(dateTime, forKey: "Key")
        }
        let timestamp = datePicker.date.timeIntervalSince1970
        
        print(timestamp)
        userDefaults.set(timestamp, forKey: "timestamp")
        
        
    }
    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?){
//         if segue.identifier == "show" {
//            if let viewController = segue.destination as? addConditionController {
//                viewController.dateTime = dateTime
//            }
//        }
    }
    

 

}
