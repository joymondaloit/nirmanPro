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
import Firebase
import UserNotifications
import FirebaseMessaging
import SwiftyJSON

var ORDER_ID = ""
var commingFromNotification = Bool()
var drawerController = KYDrawerController.init(drawerDirection: .left, drawerWidth: (UIScreen.main.bounds.width - (UIScreen.main.bounds.width / 4)))
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.7450980392, green: 0.168627451, blue: 0.1529411765, alpha: 1))           //Ring Color
        SVProgressHUD.setBackgroundColor(UIColor.white)        //HUD Color
        IQKeyboardManager.shared.enable = true
        Utils.goToTheDestinationVC(identifier: "HomeViewController")
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        return true
    }
    
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: FCM_KEY)
        UserDefaults.standard.synchronize()
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
  
    
}
// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        ///*************************  when app is in background stage *************************
        let userInfo = response.notification.request.content.userInfo
         print(JSON(userInfo))
        let userInfoDict = JSON(userInfo)
         guard let orderID = userInfoDict["order_id"].string else{return}
        goToOrderDetails(orderID: orderID)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print full message.
        print(JSON(userInfo))
        let userInfoDict = JSON(userInfo)
        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
      
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
    }
}
//Go to Order details page
extension AppDelegate {
    func goToOrderDetails(orderID : String){
        commingFromNotification = true
        ORDER_ID = orderID
        Utils.goToTheDestinationVC(identifier: "HomeViewController")

    }
}
