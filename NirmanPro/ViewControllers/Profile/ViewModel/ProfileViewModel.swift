//
//  ProfileViewModel.swift
//  NirmanPro
//
//  Created by Joy Mondal on 24/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import ObjectMapper
class ProfileViewModel: NSObject {
    static let shared = ProfileViewModel()
    //MARK:- Fetch User Data Api Call
      func fetchUserData(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (FetchUserBaseModel?,Error?)->Void){
          AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
              if let error = error{
                  completion(nil,error)
              }else{
                  if let response = response{
                      if let baseModel = Mapper<FetchUserBaseModel>().map(JSONObject: response){
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
