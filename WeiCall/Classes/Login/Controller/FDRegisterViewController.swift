//
//  FDRegisterViewController.swift
//  WeiCall
//
//  Created by tarena on 16/6/2.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

import UIKit
/**
 1.拖拽注册界面  和 控制器建立关联
 2.去XMPP工具类中写注册相关的逻辑
 并提供注册接口  并且使用协议获取
 注册状态
 3.在注册控制器中 完成注册逻辑
 4.如果还有余力 尝试把协议改成闭包完成注册
 typedef 不能使用了 可以使用 typealias
 */

class FDRegisterViewController: UIViewController {
    //注册用户名
    @IBOutlet weak var userNameRegisterField: UITextField!
    
    //注册密码
    @IBOutlet weak var userpasswordRegisterField: UITextField!

    @IBAction func registerBtnClick(sender: AnyObject) {
        FDUserInfo.getSharedInstance().userRegisterName = userNameRegisterField.text
        FDUserInfo.getSharedInstance().userReginterPadssword = userpasswordRegisterField.text
        FDUserInfo.getSharedInstance().isLogin = false
        //调用xmpp 工具类的注册方法完成注册
        weak var weakVC = self
        FDXMPPTool.getSharedInstance().userRegister { (result) -> Void in
            //处理注册结果result
            weakVC?.handleRegisterResult(result)

            }
        }
    //处理结构处理
        func handleRegisterResult(type : XMPPResultType) {
            switch type {
            case  .XMPPResultTypeRegisterSuccess:
                dismissViewControllerAnimated(true, completion: nil)
            case .XMPPResultTypeRegisterFaild:
                print("注册控制器 获取到注册失败")
            case .XMPPResultTypeNetError:
                print("注册控制器 获取到注册网络错误")
            }
        //设置代理方法
       // FDXMPPTool.getSharedInstance().registerDelegate = self
        
    }
    
    @IBAction func backBtnClick(sender: AnyObject) {
       dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    func registerSuccess() {
        print("注册成功@来自代理")
    }
    func registerFaied() {
        print("注册失败@来自代理")
    }
    func registerNetError() {
        print("注册时网络错误@来自代理")
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
