//
//  MyCartViewModel.swift
//  NirmanPro
//
//  Created by Joy Mondal on 28/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import ObjectMapper
class MyCartViewModel: NSObject {
   static let shared = MyCartViewModel()
    /**
     Get Cart list:-
     */
    func getCartList(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (CartItemsBaseResponse?,Error?)->Void){
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
            if let error = error{
                completion(nil,error)
            }else{
                if let response = response{
                    if let baseModel = Mapper<CartItemsBaseResponse>().map(JSONObject: response){
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
