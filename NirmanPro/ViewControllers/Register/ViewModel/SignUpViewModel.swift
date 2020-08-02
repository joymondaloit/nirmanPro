//
//  SignUpViewModel.swift
//  NirmanPro
//
//  Created by Joy Mondal on 23/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import ObjectMapper
class SignUpViewModel: NSObject {
    static let shared = SignUpViewModel()
    //MARK:- SignUp post Api Call
    func SignUp(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (RegisterBaseModel?,Error?)->Void){
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
            if let error = error{
                completion(nil,error)
            }else{
                if let response = response{
                    if let baseModel = Mapper<RegisterBaseModel>().map(JSONObject: response){
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

