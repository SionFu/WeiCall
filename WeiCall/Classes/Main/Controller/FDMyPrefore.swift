//
//  FDMyPrefore.swift
//  WeiCall
//
//  Created by tarena on 16/6/3.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

import UIKit

class FDMyPrefore: UIViewController {

    @IBOutlet weak var nickNameField: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    //单击返回按钮
    @IBAction func backBtnClick(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func editBtnClick(sender: AnyObject) {
        
        
}
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //获取电子名片的模型对象
        let tempvCard = FDXMPPTool.getSharedInstance().xmppvCard.myvCardTemp
        if let p = tempvCard.photo {
            self.headImageView.image = UIImage.init(data: p)
        }else {
            self.headImageView.image = UIImage.init(named: "微博")
        }
        self.nickNameField.text = tempvCard.nickname
    }
}
