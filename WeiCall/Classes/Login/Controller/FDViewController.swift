//
//  FDViewController.swift
//  WeiCall
//
//  Created by tarena on 16/6/2.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

import UIKit

class FDViewController: UIViewController,FDXMPPLoginProtocol {
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!

    @IBAction func LoginBtnClick(sender: AnyObject) {
        //将界面上的数据传给单例对象
        FDUserInfo.getSharedInstance().userName =  self.userNameField.text
        FDUserInfo.getSharedInstance().userPassword = self.userPasswordField.text
        //调用XMPP工具类的登录方法  完成登录
        //将登陆状态置为真, 原来的值为nil
        FDUserInfo.getSharedInstance().isLogin = true
        FDXMPPTool.getSharedInstance().userLogin()
        
        FDXMPPTool.getSharedInstance().loginDelegate = self
    }
    //登陆成功
    func loginSuccess() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        UIApplication.sharedApplication().keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
    }
    //登陆失败
    func loginFailed() {
        print("登陆失败")
        
    }
    //登陆时的网络错误
    func loginNetError() {
        print("网络错误")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
