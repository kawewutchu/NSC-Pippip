//
//  roomCell.swift
//  Pippip
//
//  Created by Kawewut Chujit on 1/4/2560 BE.
//  Copyright © 2560 Kawewut Chujit. All rights reserved.
//

import UIKit

class roomCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameChat: UILabel!
    @IBOutlet weak var lastmessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    


}
