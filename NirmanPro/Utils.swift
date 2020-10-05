//
//  Utils.swift
//  NirmanPro
//
//  Created by Joy Mondal on 12/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SystemConfiguration
import SDWebImage
class Utils: NSObject {
    //MARK: - Check internet rechability
    class func isNetworkConnected() -> Bool{
         var zeroAddress = sockaddr_in()
         zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
         zeroAddress.sin_family = sa_family_t(AF_INET)
         
         let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
             $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                 SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
             }
         }
         var flags = SCNetworkReachabilityFlags()
         if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
             return false
         }
         let isReachable = flags.contains(.reachable)
         let needsConnection = flags.contains(.connectionRequired)
         
         return (isReachable && !needsConnection)
     }
     
     //MARK: - Alert Function
    class func showAlert(alert : String , message : String,vc : UIViewController){
         let showAlert = UIAlertController(title: alert, message: message, preferredStyle: UIAlertController.Style.alert)
         showAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
         vc.present(showAlert, animated: true, completion: nil)
     }
     //MARK:- Show Alert with Callback
     class func showAlertWithCallback(alert : String , message : String,vc : UIViewController,completion : @escaping()->()){
          let showAlert = UIAlertController(title: alert, message: message, preferredStyle: UIAlertController.Style.alert)
          showAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: nil))
         showAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
             completion()
         }))
          vc.present(showAlert, animated: true, completion: nil)
      }
     class func showAlertWithCallbackOneAction(alert : String , message : String,vc : UIViewController,completion : @escaping()->()){
          let showAlert = UIAlertController(title: alert, message: message, preferredStyle: UIAlertController.Style.alert)
         showAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
             completion()
         }))
          vc.present(showAlert, animated: true, completion: nil)
      }
     //MARK:--
    class func goToTheDestinationVC(identifier : String){
         let mainVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
         let menuVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideMenuVC")//as! DrawerViewController
         let mainNav = UINavigationController.init(rootViewController: mainVC)
         let menuNav = UINavigationController.init(rootViewController: menuVC)
         mainNav.navigationController?.isNavigationBarHidden = true
         menuNav.navigationController?.isNavigationBarHidden = true
         drawerController.mainViewController = mainNav
         drawerController.drawerViewController = menuNav
         appDelegate.window?.rootViewController = drawerController
         drawerController.setDrawerState(.closed, animated: true)
     }
     class func gotoSelectedTabVC(_ identifier:String){
         let mainVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
         let mainNav = UINavigationController(rootViewController: mainVC)
         drawerController.mainViewController = mainNav
         drawerController.setDrawerState(.closed, animated: true)
     }
    // Email Validation
    class func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" 
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    class func getUserID()-> String{
        if let id = UserDefaults.standard.value(forKey: USERID_KEY) as? String{
            return id
        }else{
            return ""
        }
    }
    class func getUserName()-> String{
           if let name = UserDefaults.standard.value(forKey: USERNAME_KEY) as? String{
               return name
           }else{
               return ""
           }
       }
    class func getUserImage()-> String{
        if let img = UserDefaults.standard.value(forKey: PROFILEIMAGE_KEY) as? String{
            return img
        }else{
            return ""
        }
    }
    class func loadImage(imageView : UIImageView,imageURL : String,placeHolderImage : String,completion :@escaping (UIImage?,Error?,SDImageCacheType?,URL?)->()){
        imageView.sd_setImage(with: URL(string: imageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: placeHolderImage), options: .refreshCached) { (image, error, catcheType, imgURL) in
            completion(image,error,catcheType,imgURL)
        }
    }
    class func getFcmToken() -> String{
        if let token = UserDefaults.standard.value(forKey: FCM_KEY) as? String{
            return token
        }
        return ""
    }
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
