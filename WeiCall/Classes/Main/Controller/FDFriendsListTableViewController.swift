//
//  FDFriendsListTableViewController.swift
//  WeiCall
//
//  Created by tarena on 16/6/3.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

import UIKit
 /**
    1.完成如何添加好友
    2.玩成如何删除好友
    3.
 */

class FDFriendsListTableViewController: UITableViewController,NSFetchedResultsControllerDelegate {
    //结果集 可以随时监控数据的变化
    var resultController : NSFetchedResultsController!
    @IBAction func backBtnClick(sender: AnyObject) {
//        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //界面刷新
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
    //加载好友列表的方法
    func loadFriends() {
        //获取上下文
        let context = FDXMPPTool.getSharedInstance().xmpprosterStore.mainThreadManagedObjectContext
        //关联实体
        let request = NSFetchRequest(entityName: "XMPPUserCoreDataStorageObject")
        //设置谓词 过滤当前用户好友
        let jidStr = FDUserInfo.getSharedInstance().userName! + "@" + XMPPDOMAIN
        let pre = NSPredicate(format:"streamBareJidStr = %@",jidStr)
        request.predicate = pre
        //设置排序
        let sortDes = NSSortDescriptor(key: "displayName", ascending: true)
        request.sortDescriptors = [sortDes]
        //获取数据
        resultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        //设置代理
        resultController.delegate = self
        do {
            try resultController.performFetch()
        }catch {
            print("获取好友列表数据出错")
        }
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //加载好友
        loadFriends()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.resultController.fetchedObjects?.count)!
    
    }

 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : FDFriendTableViewCell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as! FDFriendTableViewCell
        //哈有模型对象 的获取
        let friend : XMPPUserCoreDataStorageObject = self.resultController.fetchedObjects![indexPath.row] as!XMPPUserCoreDataStorageObject
        //通过头像模块获取好友的 头像
        if let p = FDXMPPTool.getSharedInstance().xmppvCardAvata.photoDataForJID(friend.jid) {
            cell.headImageView.image = UIImage.init(data: p)
        }else{
            cell.headImageView.image = UIImage.init(named : "微信")
            cell.friendNameLabel.text = friend.displayName
            switch friend.sectionNum.integerValue {
            case 0:
                cell.onlineLabel.text = "在线"
            case 1:
                cell.onlineLabel.text = "离开"
                cell.onlineLabel.textColor = UIColor.yellowColor()
            case 2:
                cell.onlineLabel.text = "离线"
                cell.onlineLabel.textColor = UIColor.grayColor()
            default:
                cell.onlineLabel.text = "未知"
                cell.onlineLabel.textColor = UIColor.blueColor()
            }
        }
       


        return cell
    }
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 取出好友对象模型
        let friend = self.resultController.fetchedObjects![indexPath.row]
        if editingStyle == .Delete {
           FDXMPPTool.getSharedInstance().xmppRoster.removeUser(friend.jid())
        }
    }
    //点击tableViewCell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //获取好友模型
        let friend : XMPPUserCoreDataStorageObject = self.resultController.fetchedObjects![indexPath.row] as! XMPPUserCoreDataStorageObject
        self.performSegueWithIdentifier("chatSegue", sender: friend.jid)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let desVC = segue.destinationViewController
        if desVC is FDChatViewController {
            let chatVC = desVC as!FDChatViewController
            chatVC.fjid = sender as!XMPPJID
        }
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
