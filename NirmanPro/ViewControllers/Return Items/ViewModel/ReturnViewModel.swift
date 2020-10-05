//
//  ReturnViewModel.swift
//  NirmanPro
//
//  Created by Joy Mondal on 21/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import ObjectMapper
class ReturnViewModel: NSObject {
    static let shared = ReturnViewModel()
    /*
     get reason list
     */
    func getReasonList(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (ReturnReasonBaseResponse?,Error?)->Void){
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
            if let error = error{
                completion(nil,error)
            }else{
                if let response = response{
                    if let baseModel = Mapper<ReturnReasonBaseResponse>().map(JSONObject: response){
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
    
    /*
       get return Item list
       */
      func getReturnItemList(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (ReturnListBaseResponse?,Error?)->Void){
          AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
              if let error = error{
                  completion(nil,error)
              }else{
                  if let response = response{
                      if let baseModel = Mapper<ReturnListBaseResponse>().map(JSONObject: response){
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
    /*
         get return Details
         */
        func getReturnDetails(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (ReturnDetailsBaseResponse?,Error?)->Void){
            AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
                if let error = error{
                    completion(nil,error)
                }else{
                    if let response = response{
                        if let baseModel = Mapper<ReturnDetailsBaseResponse>().map(JSONObject: response){
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
