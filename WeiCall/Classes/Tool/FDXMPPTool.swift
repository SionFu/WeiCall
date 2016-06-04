
//
//  FDXMPPTool.swift
//  WeiCall
//
//  Created by tarena on 16/6/2.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

import UIKit
//自定义协议 获取登陆状态
protocol FDXMPPLoginProtocol : NSObjectProtocol {
    //登陆成功
    func loginSuccess()
    //登陆失败
    func loginFailed()
    //登陆时的网络错误
    func loginNetError()
}
//自定义协议获取注册状态
protocol FDXMPPRegisterProtocol : NSObjectProtocol {
    //注册成功
    func registerSuccess()
    //注册失败
    func registerFaied()
    //注册时网络错误
    func registerNetError()
}
//闭包传值
enum XMPPResultType {
    case XMPPResultTypeRegisterSuccess
    case XMPPResultTypeRegisterFaild
    case XMPPResultTypeNetError
}
//不使用协议传值 换成闭包 注册协议去掉
//这个闭包函数 能将XMPPResultType 传递出来
typealias XMPPClosureType = (result : XMPPResultType) -> Void
class FDXMPPTool: NSObject,XMPPStreamDelegate {
    //和 服务器 交互的核心对象
    // var xmppStream : MX 
    //导入桥接文件 bridge
    var xmppStream : XMPPStream!
    
    //登陆对应的代理属性
   weak var loginDelegate : FDXMPPLoginProtocol!
   //注册时对应的代理属性
  //  weak var registerDelegate : FDXMPPRegisterProtocol?
    //用来接收别人传入的闭包
    private var resultClosure : XMPPClosureType!
    //增加电子名片和头像模块
    var xmppvCard : XMPPvCardTempModule!
    var xmppvCardStore : XMPPvCardCoreDataStorage!
    var xmppvCardAvata : XMPPvCardAvatarModule!
    //增加花名册模块和 对应的存储
    var xmppRoster : XMPPRoster!
    var xmpprosterStore : XMPPRosterCoreDataStorage!
    //增加消息模块 和对应的存储
    var xmppMsgArch : XMPPMessageArchiving!
    var xmppMsgArchStore : XMPPMessageArchivingCoreDataStorage!
    
    
    class func getSharedInstance() -> FDXMPPTool{
        struct Singleton {
            static var dispatchOne : dispatch_once_t = 0
            static var instance : FDXMPPTool?
        }
        dispatch_once(&Singleton.dispatchOne) {
            () -> Void in Singleton.instance = FDXMPPTool()
        }
        return Singleton.instance!
    }
    //保证xmpp用的时候不是nil
   override init() {
        super.init()
        setupXmppStream()
    }
    
    //设置流
    private func setupXmppStream () {
        xmppStream = XMPPStream()
         xmppStream.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        //给电子名片模块对应的存储地址
        xmppvCardStore = XMPPvCardCoreDataStorage.sharedInstance()
        //给电子名片模块赋值
        xmppvCard = XMPPvCardTempModule.init(withvCardStorage: xmppvCardStore)
        //给电子名片头像赋值
        xmppvCardAvata = XMPPvCardAvatarModule.init(withvCardTempModule: xmppvCard)
        //给花名侧模块赋值
        xmpprosterStore = XMPPRosterCoreDataStorage.sharedInstance()
        //给花名册模块赋值
        xmppRoster = XMPPRoster.init(rosterStorage: xmpprosterStore)
        //给消息模存储块赋值
        xmppMsgArchStore = XMPPMessageArchivingCoreDataStorage.sharedInstance()
        //给名片赋值
        xmppMsgArch = XMPPMessageArchiving.init(messageArchivingStorage: self.xmppMsgArchStore)
        //激活花名册
        xmppRoster.activate(xmppStream)
        //激活电子名片
        xmppvCard.activate(xmppStream)
        //激活头像信息
        xmppvCardAvata.activate(xmppStream)
        //激活消息模块
        xmppMsgArch.activate(self.xmppStream)
        
        }
    
    //连接服务器
    private func connectToHost(){
        //断开上一次连接
        xmppStream.disconnect()
        //判断是nil 就设置流
        if xmppStream == nil {
            setupXmppStream()
        }
        var userName : String?
        //判断是登录名登录 还是注册名
        if FDUserInfo.getSharedInstance().isLogin! {
            userName = FDUserInfo.getSharedInstance().userName
        } else {
            userName = FDUserInfo.getSharedInstance().userRegisterName
        }

        //构建jid
        xmppStream.myJID = XMPPJID.jidWithUser(userName, domain: XMPPDOMAIN, resource: "iphone10")
        //设置 主机和端口
        xmppStream.hostName = XMPPHOSTNAME
        xmppStream.hostPort = XMPPPORT
        do {
           try xmppStream.connectWithTimeout(XMPPStreamTimeoutNone)
        }catch let error as NSError{
            print(error.debugDescription)
        }
    }
    
    //连接成功 还是失败 (代理方法)
    func xmppStreamDidConnect(sender: XMPPStream!) {
        print("win")
        //是登录就发登录密码 是注册就发注册密码
        if FDUserInfo.getSharedInstance().isLogin! {
             sendLoginPrassword()
        }else {
            sengRegisterPasseord()
        }
        
    }
    //网络连接失败
    func xmppStreamDidDisconnect(sender: XMPPStream!, withError error: NSError!) {
        if error != nil {
            print(error.description)
            if FDUserInfo.getSharedInstance().isLogin! {
                  //调用网络连接失败方法
                loginDelegate?.loginNetError()
            } else {
                //调用注册网络连接错误方法
              //  registerDelegate?.registerNetError()
                resultClosure!(result: XMPPResultType.XMPPResultTypeNetError)
            }
          
        }
    }
    //发注册送密码到服务器
    private func sendLoginPrassword() {
        do {
       try xmppStream.authenticateWithPassword(FDUserInfo.getSharedInstance().userPassword)
        }catch let error as NSError{
            print(error.description)
        }
    }
    //发送注册密码
    private func sengRegisterPasseord(){
        do {
            try xmppStream.registerWithPassword(FDUserInfo.getSharedInstance().userReginterPadssword)
        }catch let error as NSError {
            print(error.description)
        }
    }
    //授权成功(发送在线消息) 授权失败(代理方法)
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        //授权成功发送在线消息
        print("success Login")
        xmppStream.sendElement(XMPPPresence())
        //登陆成功 调用代码的登陆成功代理方法
        loginDelegate?.loginSuccess()
    }
    //注册成功
    func xmppStreamDidRegister(sender: XMPPStream!) {
        print("注册成功")
      //  registerDelegate?.registerSuccess()
        //实现闭包接收的参数
        resultClosure!(result:XMPPResultType.XMPPResultTypeRegisterSuccess)

    }
    //注册失败
    func xmppStream(sender: XMPPStream!, didNotRegister error: DDXMLElement!) {
       // registerDelegate?.registerFaied()
        resultClosure!(result: XMPPResultType.XMPPResultTypeRegisterFaild)
        print("注册失败\(error)")
    }
    func xmppStream(sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
        //授权失败 打印错误消息
        print(error.description)
        //登陆失败调用登陆失败代理方法
        loginDelegate?.loginNetError()
    }
    //对外提供一个登陆接口
    func userLogin () {
        connectToHost()
    }
    //对外提供一个注册接口 谁要获取注册状态 谁就传入一个闭包
    func userRegister(function : XMPPClosureType) {
        resultClosure = function
        connectToHost()
    }
}






























