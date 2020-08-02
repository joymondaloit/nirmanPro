//
//  ProductDetailsViewModel.swift
//  NirmanPro
//
//  Created by Joy Mondal on 29/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import ObjectMapper
class ProductDetailsViewModel: NSObject {
    static let shared = ProductDetailsViewModel()
    /**
        getProductDetails:-
     */
    
    func getProductDetails(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (ProductDetailsBaseResponse?,Error?)->Void){
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
            if let error = error{
                completion(nil,error)
            }else{
                if let response = response{
                    if let baseModel = Mapper<ProductDetailsBaseResponse>().map(JSONObject: response){
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
