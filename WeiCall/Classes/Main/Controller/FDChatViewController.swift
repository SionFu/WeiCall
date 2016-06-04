//
//  FDChatViewController.swift
//  WeiCall
//
//  Created by tarena on 16/6/4.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

import UIKit

class FDChatViewController: UIViewController ,NSFetchedResultsControllerDelegate,UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //和谁聊天
    var fjid : XMPPJID!
    
    @IBAction func imageBtnClick(sender: AnyObject) {
        headImageTap()
    }
    func headImageTap() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.editing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    // 选择图片
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let  image  = info[UIImagePickerControllerOriginalImage]
        let oriImage = image as? UIImage
        print(UIImagePNGRepresentation(oriImage!)?.length)
        let newImage = thumbnailWithImage(oriImage!, size: CGSize(width: 100, height: 100))
        print(UIImagePNGRepresentation(newImage!)?.length)
        let sendData = UIImageJPEGRepresentation(newImage!, 0.05)
        print(sendData?.length)
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    // 压缩图片
    func thumbnailWithImage(image : UIImage, size : CGSize) -> UIImage?{
        var newImage : UIImage? = nil;
        if newImage == nil {
            UIGraphicsBeginImageContext(size);
            //    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
            image.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        return newImage;
    }

    
    @IBOutlet weak var msgField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightForBottom: NSLayoutConstraint!
    //结果集控制器
    var fetchController : NSFetchedResultsController!
    @IBAction func sendTextMsg(sender: AnyObject) {
        // 构建消息
        let  msg = XMPPMessage.init(type: "chat", to: self.fjid)
        msg.addBody(self.msgField.text)
        // 发送消息
        FDXMPPTool.getSharedInstance().xmppStream .sendElement(msg)
    }
    /**
     获取聊天信息
     */
    func loadMsg(){
        //获取上下文
        let context = FDXMPPTool.getSharedInstance().xmpprosterStore.mainThreadManagedObjectContext
        //关联实体
        let request = NSFetchRequest(entityName: "XMPPMessageArchiving_Message_CoreDataObject")
        //设置谓词
        let jidStr = FDUserInfo.getSharedInstance().userName! + "@" + XMPPDOMAIN
        let pre = NSPredicate(format: "streamBareJidStr = %@ and bareJidStr = %@", jidStr,self.fjid.bare())
        request.predicate = pre
        //设置排序
        let sort = NSSortDescriptor(key: "timestamp", ascending: true)
        request.sortDescriptors = [sort]
        //获取数据
        self.fetchController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchController.delegate = self
        do {
            try self.fetchController.performFetch()
        }catch{
            print("获取消息出错")
        }
        
    }
    func  loadMsg1(){
        // 获取上下文
        let  context = FDXMPPTool.getSharedInstance().xmppMsgArchStore.mainThreadManagedObjectContext
        // 关联实体
        let  request = NSFetchRequest(entityName: "XMPPMessageArchiving_Message_CoreDataObject")
        // 设置谓词
        let jidStr = FDUserInfo.getSharedInstance().userName! + "@" + XMPPDOMAIN
        let pre = NSPredicate(format: "streamBareJidStr = %@ and bareJidStr = %@", jidStr,self.fjid.bare())
        request.predicate = pre
        // 设置排序
        let sort = NSSortDescriptor(key: "timestamp", ascending: true)
        request.sortDescriptors = [sort]
        // 获取数据
        self.fetchController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchController.delegate = self
        do {
            try self.fetchController.performFetch()
        }catch {
            print("获取聊天消息 出错!")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(fjid.description)
        // Do any additional setup after loading the view.
        loadMsg1()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //用通知弹键盘和 收回通知
    override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openKeyboard:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "colseKayboard:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    func openKeyboard(notifaction:NSNotification){
        let keyFrame = notifaction.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue
        let options = UIViewAnimationOptions(rawValue:UInt(( notifaction.userInfo![UIKeyboardAnimationCurveUserInfoKey] as!NSNumber).integerValue))
        let durations = notifaction.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        self.heightForBottom.constant = (keyFrame?.size.height)!
        UIView.animateWithDuration(durations!, delay: 0, options: options, animations: { () -> Void in
            self.view.reloadInputViews()
            }, completion: nil)
        
    }
    func colseKayboard(notifaction:NSNotification){
        let options = UIViewAnimationOptions(rawValue:UInt(( notifaction.userInfo![UIKeyboardAnimationCurveUserInfoKey] as!NSNumber).integerValue))
        let durations = notifaction.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        self.heightForBottom.constant = 0
        UIView.animateWithDuration(durations!, delay: 0, options: options, animations: { () -> Void in
            self.view.reloadInputViews()
            }, completion: nil)
        
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return (self.fetchController.fetchedObjects?.count)!
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : FDMeTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("meCell") as!FDMeTableViewCell
        //获取聊天模型对象
        let msgObj : XMPPMessageArchiving_Message_CoreDataObject = self.fetchController.fetchedObjects![indexPath.row] as! XMPPMessageArchiving_Message_CoreDataObject
        cell.meImageView.image = UIImage.init(named: "微信")
        cell.meMsgTextField.text = msgObj.body
        return cell
    }
    //数据发生变化的时候刷新表格
    func  controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }

}
