//
//  FDEditMyprofileViewController.swift
//  WeiCall
//
//  Created by tarena on 16/6/3.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

import UIKit

class FDEditMyprofileViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nikenameField: UITextField!
    //MARK 这是个人信息更新方式
    @IBAction func updataMyInfoBtnClick(sender: AnyObject) {
        let vcardTemp = FDXMPPTool.getSharedInstance().xmppvCard.myvCardTemp
        vcardTemp.photo = UIImagePNGRepresentation(self.headImageView.image!)
        vcardTemp.nickname = self.nikenameField.text
        //调取电子名片更新模块的更新方法
        FDXMPPTool.getSharedInstance().xmppvCard.updateMyvCardTemp(vcardTemp)
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //获取电子名片的模型对象
        let tempvCard = FDXMPPTool.getSharedInstance().xmppvCard.myvCardTemp
        if let p = tempvCard.photo {
            self.headImageView.image = UIImage.init(data : p)
        }else {
            self.headImageView.image = UIImage.init(named: "人人")
        }
        //添加头像识别
        headImageView.userInteractionEnabled = true
        let gestureRec = UITapGestureRecognizer.init(target: self, action: "headImageTap")
        //将手势添加到图片
        headImageView.addGestureRecognizer(gestureRec)
        self.nikenameField.text = tempvCard.nickname
        headImageView.userInteractionEnabled = true
    }
    
    func headImageTap() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.editing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage]
        headImageView.image = image as?UIImage
        dismissViewControllerAnimated(true, completion: nil)
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
