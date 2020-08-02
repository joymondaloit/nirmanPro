//
//  LoginViewModel.swift
//  NirmanPro
//
//  Created by Joy Mondal on 24/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import ObjectMapper
class LoginViewModel: NSObject {
    static let shared = LoginViewModel()
    //MARK:- Login post Api Call
    func Login(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (LoginBaseResponse?,Error?)->Void){
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
            if let error = error{
                completion(nil,error)
            }else{
                if let response = response{
                    if let baseModel = Mapper<LoginBaseResponse>().map(JSONObject: response){
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
