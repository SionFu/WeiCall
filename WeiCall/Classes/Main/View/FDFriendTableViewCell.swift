//
//  FDFriendTableViewCell.swift
//  WeiCall
//
//  Created by tarena on 16/6/3.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

import UIKit

class FDFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var onlineLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
