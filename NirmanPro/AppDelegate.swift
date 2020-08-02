//
//  AppDelegate.swift
//  NirmanPro
//
//  Created by Joy Mondal on 08/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import KYDrawerController
import SVProgressHUD
import IQKeyboardManagerSwift
var drawerController = KYDrawerController.init(drawerDirection: .left, drawerWidth: (UIScreen.main.bounds.width - (UIScreen.main.bounds.width / 4)))
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1))           //Ring Color
        SVProgressHUD.setBackgroundColor(UIColor.white)        //HUD Color
        IQKeyboardManager.shared.enable = true
        Utils.goToTheDestinationVC(identifier: "HomeViewController")
        return true
    }




}

