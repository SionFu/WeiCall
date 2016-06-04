//
//  FDUserInfo.swift
//  WeiCall
//
//  Created by tarena on 16/6/2.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

import UIKit

class FDUserInfo: NSObject {
    /**用户名*/
    var userName : String?          //类中的属性必须初始化 或者 为可选值
    /**用户密码*/
    var userPassword : String?
    /**
     存储注册用户名
     */
    var userRegisterName : String?
    /**
     存储注册密码
     */
    var userReginterPadssword : String?
    var isLogin : Bool?
    class func getSharedInstance() ->FDUserInfo {
        struct Singleton {
        static var disspatchOne : dispatch_once_t = 0
        static var instance : FDUserInfo?
        }
        dispatch_once(&Singleton.disspatchOne){
            () ->Void in Singleton.instance = FDUserInfo()
        }
        return Singleton.instance!
    }
}
