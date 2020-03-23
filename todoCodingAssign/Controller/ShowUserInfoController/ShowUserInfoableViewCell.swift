//
//  ShowUserInfoTableViewCell.swift
//  todoCodingAssign
//
//  Created by Ruoming Gao on 3/21/20.
//  Copyright © 2020 Ruoming Gao. All rights reserved.
//

import UIKit

class ShowUserInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func getConfigure(model: Person?) {
        genderLabel.text = model?.gender
        nameLabel.text = model?.name
        if model?.status == true {
            statusLabel.text = "Complete"
        } else if model?.status == false {
            statusLabel.text = "Incomplete"
        } else {
            statusLabel.isHidden = true
        }
    }
}

