//
//  ViewController.swift
//  ipgwlogin
//
//  Created by 李昂 on 15/10/10.
//  Copyright (c) 2015年 mytest. All rights reserved.
//

import UIKit

let wid=UIScreen.mainScreen().bounds.width-20

class ViewController: UIViewController {
    var ipgw=IpgwClass()
    
    var UsernameTextField:UITextField=UITextField(frame: CGRectMake(10, 86, UIScreen.mainScreen().bounds.width-20, 30))
    var PasswordTextField:UITextField=UITextField(frame: CGRectMake(10, 120, UIScreen.mainScreen().bounds.width-20, 30))
    
    var ConnectButton:UIButton=UIButton.buttonWithType(UIButtonType.System) as! UIButton
    var DisconnectButton:UIButton=UIButton.buttonWithType(UIButtonType.System) as! UIButton
    var DisconnectAllButton:UIButton=UIButton.buttonWithType(UIButtonType.System) as! UIButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="东北大学IP控制网关"
        UsernameTextField.keyboardType=UIKeyboardType.NumberPad
        UsernameTextField.placeholder="用户名"
        PasswordTextField.secureTextEntry=true
        PasswordTextField.placeholder="密码"
        
        UsernameTextField.borderStyle=UITextBorderStyle.RoundedRect
        PasswordTextField.borderStyle=UITextBorderStyle.RoundedRect
        
        ConnectButton.frame=CGRectMake(10, 154, UIScreen.mainScreen().bounds.width-20, 35)
        DisconnectButton.frame=CGRectMake(10, 193, UIScreen.mainScreen().bounds.width-20, 35)
        DisconnectAllButton.frame=CGRectMake(10, 232, wid, 35)
        
        ConnectButton.backgroundColor=UIColor.blueColor()
        DisconnectButton.backgroundColor=UIColor.redColor()
        DisconnectAllButton.backgroundColor=UIColor.greenColor()
        
        ConnectButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        DisconnectButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        DisconnectAllButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        ConnectButton.addTarget(self, action: "connect", forControlEvents: UIControlEvents.TouchUpInside)
        DisconnectButton.addTarget(self, action: "disconnect", forControlEvents: UIControlEvents.TouchUpInside)
        DisconnectAllButton.addTarget(self, action: "disconnectall", forControlEvents: UIControlEvents.TouchUpInside)
        
        ConnectButton.setTitle("连接网络", forState: UIControlState.Normal)
        DisconnectButton.setTitle("断开连接", forState: UIControlState.Normal)
        DisconnectAllButton.setTitle("断开全部连接", forState: UIControlState.Normal)
        
        ipgw.getUserandPasswdfromLocal()
        if ipgw.user != nil && ipgw.passwd != nil {
            UsernameTextField.text=ipgw.user
            PasswordTextField.text=ipgw.passwd
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(UsernameTextField)
        self.view.addSubview(PasswordTextField)
        self.view.addSubview(ConnectButton)
        self.view.addSubview(DisconnectButton)
        self.view.addSubview(DisconnectAllButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 网络连接相关操作
    func connect() {
        ipgw.user=UsernameTextField.text
        ipgw.passwd=PasswordTextField.text
        ipgw.ipgw(usage: "connect")
        if ipgw.loginStatus.SUCCESS == "YES" {
            var alv=UIAlertView()
            alv.title="连接成功"
            alv.message="状态：已连接\n用户：\(ipgw.loginStatus.USERNAME)\n包月状态：\(ipgw.loginStatus.FIXRATE)\n访问范围：国内\n欠费状态：\(ipgw.loginStatus.DEFICIT)\n余额：\(ipgw.loginStatus.BALANCE)\nIP地址：\(ipgw.loginStatus.IP)"
            alv.addButtonWithTitle("OK")
            alv.show()
            ipgw.storeUserandPasswd()
        }
        else {
            var alv=UIAlertView()
            alv.title="连接失败"
            alv.message="连接数超过1"
            alv.addButtonWithTitle("OK")
            alv.show()
        }
    }
    
    func disconnect() {
        ipgw.ipgw(usage: "disconnect")
        if ipgw.loginStatus.SUCCESS == "YES" {
            var alv=UIAlertView()
            alv.title="网络断开成功"
            alv.message="IP地址：\(ipgw.loginStatus.IP)"
            alv.addButtonWithTitle("OK")
            alv.show()
        }
    }
    
    func disconnectall() {
        ipgw.user=UsernameTextField.text
        ipgw.passwd=PasswordTextField.text
        ipgw.ipgw(usage: "disconnectall")
        if ipgw.loginStatus.SUCCESS == "YES" {
            var alv=UIAlertView()
            alv.title="断开全部连接成功"
            alv.message="IP地址：\(ipgw.loginStatus.IP)"
            alv.addButtonWithTitle("OK")
            alv.show()
        }
    }
}

