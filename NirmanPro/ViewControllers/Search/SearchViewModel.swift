//
//  SearchViewModel.swift
//  NirmanPro
//
//  Created by Joy Mondal on 21/09/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import ObjectMapper
class SearchViewModel: NSObject {
    static let shared = SearchViewModel()
    func getSearchItemList(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (CategoryResponseModel?,Error?)->Void){
         AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
             if let error = error{
                 completion(nil,error)
             }else{
                 if let response = response{
                     if let baseModel = Mapper<CategoryResponseModel>().map(JSONObject: response){
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
