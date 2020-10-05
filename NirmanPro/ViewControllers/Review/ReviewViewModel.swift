//
//  ReviewViewModel.swift
//  NirmanPro
//
//  Created by Joy Mondal on 28/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import ObjectMapper
class ReviewViewModel: NSObject {
    static let shared = ReviewViewModel()
    /**
     get all review list:-
    */
    
    func getReviewList(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (ProductReviewBaseResponse?,Error?)->Void){
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
            if let error = error{
                completion(nil,error)
            }else{
                if let response = response{
                    if let baseModel = Mapper<ProductReviewBaseResponse>().map(JSONObject: response){
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
