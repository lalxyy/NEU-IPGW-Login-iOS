//
//  IpgwClass.swift
//  ipgwlogin
//
//  Created by 李昂 on 15/10/11.
//  Copyright (c) 2015年 mytest. All rights reserved.
//

import Foundation

struct loginst {
    var SUCCESS:String=""
    var STATE:String="" // connected
    var USERNAME:String="" // 201xxxxx
    var FIXRATE:String="" // 包月状态
    var SCOPE:String="" // 访问范围（国内）
    var DEFICIT:String="" // 欠费状态
    var BALANCE:String="" // 余额
    var IP:String="" // ip地址
}

class IpgwClass: NSObject {
    var user:String?
    var passwd:String?
    
    var loginStatus:loginst=loginst()
    var failMessage:String?
    
    // 连接网络
    func ipgw(#usage:String) {
        self.loginStatus=loginst()
        
        // 检查用户名与密码是否为空
        if usage != "disconnect" {
            if self.user == nil {
                self.failMessage="用户名为空"
                return
            }
            if self.passwd == nil {
                self.failMessage="密码为空"
                return
            }
        }
        
        // 连接至ip控制网关
        var loginurl:NSURL=NSURL()
        if usage == "connect" {
            loginurl=NSURL(string: "http://ipgw.neu.edu.cn/ipgw/ipgw.ipgw?uid=\(self.user!)&password=\(self.passwd!)&operation=connect&range=2&timeout=0")!
        }
        if usage == "disconnect" {
            loginurl=NSURL(string: "http://ipgw.neu.edu.cn/ipgw/ipgw.ipgw?uid=&password=&operation=disconnect&range=2&timeout=1")!
        }
        if usage == "disconnectall" {
            loginurl=NSURL(string: "http://ipgw.neu.edu.cn/ipgw/ipgw.ipgw?uid=\(self.user!)&password=\(self.passwd!)&operation=disconnectall&range=2&timeout=0")!
        }
        var loginreq:NSURLRequest=NSURLRequest(URL: loginurl)
        var backdata:NSData?=NSURLConnection.sendSynchronousRequest(loginreq, returningResponse: nil, error: nil)
        
        
        // 判断为空处理
        if backdata == nil {
            self.failMessage="数据返回为空" // 这个自己改改吧这样不太接地气。。
            return
        }
        
        var backstring:String=NSString(data: backdata!, encoding: NSASCIIStringEncoding) as! String // 得到返回的html页面
        println(backstring)
        //var LoginStatusPattern:String="<!--IPGWCLIENT_START([A-Za-z0-9\\s\\w=]*)IPGWCLIENT_END-->"
        //var regex1:NSRegularExpression=NSRegularExpression(pattern: LoginStatusPattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!
        //var LoginStat:[String]=regex1.matchesInString(backstring, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, (backstring as NSString).length)) as! [String]
        backstring=(backstring.componentsSeparatedByString("<!--IPGWCLIENT_START "))[1]
        backstring=(backstring.componentsSeparatedByString(" IPGWCLIENT_END-->"))[0]
        if usage == "connect" {
            // 事实上只有0
            var Loginst1:[String]=backstring.componentsSeparatedByString(" ")
            for i in 0...7 {
                var stt:[String]=Loginst1[i].componentsSeparatedByString("=")
                if i == 0 && stt[1] == "NO" {
                    self.loginStatus.SUCCESS=stt[1]
                    break
                }
                if stt.count != 2 {
                    continue
                }
                switch (i) {
                case 0:
                    self.loginStatus.SUCCESS=stt[1]
                case 1:
                    self.loginStatus.STATE=stt[1]
                case 2:
                    self.loginStatus.USERNAME=stt[1]
                case 3:
                    self.loginStatus.FIXRATE=stt[1]
                case 4:
                    self.loginStatus.SCOPE=stt[1]
                case 5:
                    self.loginStatus.DEFICIT=stt[1]
                case 6:
                    self.loginStatus.BALANCE=stt[1]
                case 7:
                    self.loginStatus.IP=stt[1]
                default:
                    break
                }
            }
            if self.loginStatus.SUCCESS == "NO" {
                self.failMessage="连接失败"
            }
        }
        else if usage == "disconnectall" {
            var Loginst1:[String]=backstring.componentsSeparatedByString(" ")
            for i in 0...1 {
                var stt:[String]=Loginst1[i].componentsSeparatedByString("=")
                switch (i) {
                case 0:
                    self.loginStatus.SUCCESS=stt[1]
                case 1:
                    self.loginStatus.IP=stt[1]
                default:
                    break
                }
            }
        }
        else if usage == "disconnect" {
            var Loginst1:[String]=backstring.componentsSeparatedByString(" ")
            for i in 0...1 {
                var stt:[String]=Loginst1[i].componentsSeparatedByString("=")
                switch (i) {
                case 0:
                    self.loginStatus.SUCCESS=stt[1]
                case 1:
                    self.loginStatus.IP=stt[1]
                default:
                    break
                }
            }
        }
    }
    
    func storeUserandPasswd() {
        if (self.user == nil || self.passwd == nil) {
            return
        }
        var store:NSUserDefaults=NSUserDefaults.standardUserDefaults()
        store.setObject(self.user!, forKey: "ipgwlogin_user")
        store.setObject(self.passwd!, forKey: "ipgwlogin_passwd")
        store.synchronize()
    }
    
    func getUserandPasswdfromLocal() {
        var store:NSUserDefaults=NSUserDefaults.standardUserDefaults()
        var usr:String?=store.objectForKey("ipgwlogin_user") as? String
        var pass:String?=store.objectForKey("ipgwlogin_passwd") as? String
        if usr == nil || pass == nil {
            return
        }
        else {
            self.user=usr!
            self.passwd=pass!
        }
    }
}
