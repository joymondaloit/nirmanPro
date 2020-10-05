//
//  NotificationViewModel.swift
//  NirmanPro
//
//  Created by Joy Mondal on 30/09/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import ObjectMapper
class NotificationViewModel: NSObject {
    static let shared = NotificationViewModel()
    func getNotificationList(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (NotificationBaseResponse?,Error?)->Void){
         AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
             if let error = error{
                 completion(nil,error)
             }else{
                 if let response = response{
                     if let baseModel = Mapper<NotificationBaseResponse>().map(JSONObject: response){
                         completion(baseModel,nil)
                     }else{
                         completion(nil,nil)
                     }
                 }else{
                     completion(nil,error)
                 }
             }
         }
         
     }
}
