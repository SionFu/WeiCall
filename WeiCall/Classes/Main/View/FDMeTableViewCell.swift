//
//  FDMeTableViewCell.swift
//  WeiCall
//
//  Created by tarena on 16/6/4.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

import UIKit

class FDMeTableViewCell: UITableViewCell {

    @IBOutlet weak var meImageView: UIImageView!
    @IBOutlet weak var meMsgTextField: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
