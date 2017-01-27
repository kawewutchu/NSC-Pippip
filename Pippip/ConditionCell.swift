//
//  ConditionCell.swift
//  Pippip
//
//  Created by Kawewut Chujit on 1/11/2560 BE.
//  Copyright © 2560 Kawewut Chujit. All rights reserved.
//

import UIKit

class ConditionCell: UITableViewCell {

  
    @IBOutlet weak var timePicker: UILabel!
    @IBOutlet weak var addTime: UIButton!
    @IBOutlet weak var addPicture: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
