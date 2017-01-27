//
//  pictureController.swift
//  Pippip
//
//  Created by Kawewut Chujit on 1/27/2560 BE.
//  Copyright © 2560 Kawewut Chujit. All rights reserved.
//

import UIKit

class pictureController: UIViewController {

    @IBOutlet weak var test: UIImageView!
    var image1 = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        if(image1 != nil){
            test.image = image1
        }
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

    func loadImageUsingCacheWithUrlString(_ urlString: String) -> UIImage {
        
        var image = UIImage()
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            image = cachedImage
        }
        
        return image
    }

}
