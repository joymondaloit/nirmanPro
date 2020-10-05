//
//  OrdersViewModel.swift
//  NirmanPro
//
//  Created by Joy Mondal on 13/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import ObjectMapper
class OrdersViewModel: NSObject {
    static let shared = OrdersViewModel()
    /**
     Get Orders list:-
     */
    func getOrderList(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (OrdersBaseResponse?,Error?)->Void){
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
            if let error = error{
                completion(nil,error)
            }else{
                if let response = response{
                    if let baseModel = Mapper<OrdersBaseResponse>().map(JSONObject: response){
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
    
    /**
     Get Order Details:-
     */
    func getOrderDetails(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (OrderDetailsBaseResponse?,Error?)->Void){
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
            if let error = error{
                completion(nil,error)
            }else{
                if let response = response{
                    if let baseModel = Mapper<OrderDetailsBaseResponse>().map(JSONObject: response){
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
