//
//  FDAddFriendViewController.swift
//  WeiCall
//
//  Created by tarena on 16/6/4.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

import UIKit

class FDAddFriendViewController: UIViewController {

    @IBOutlet weak var friendNameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func addFrinedBtnClick(sender: AnyObject) {
        let friendName = self.friendNameField.text!
        let jidStr = friendName + "@" + XMPPDOMAIN
        let fjid = XMPPJID.jidWithString(jidStr)
        //判断好友是否添加
        if FDXMPPTool.getSharedInstance().xmpprosterStore.userExistsWithJID(fjid, xmppStream: FDXMPPTool.getSharedInstance().xmppStream) {
            MBProgressHUD .showError("已经添加过\(friendName)")
            return
        }
        //判断是否添加自己
        if friendName == FDUserInfo.getSharedInstance().userName {
            MBProgressHUD .showError("不能添加自己为好友")
            return
        }
        //添加好友
        FDXMPPTool.getSharedInstance().xmppRoster.subscribePresenceToUser(fjid)
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
