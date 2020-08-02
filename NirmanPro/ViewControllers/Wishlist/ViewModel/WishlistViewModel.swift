//
//  WishlistViewModel.swift
//  NirmanPro
//
//  Created by Joy Mondal on 31/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import ObjectMapper
class WishlistViewModel: NSObject {
    static let shared = WishlistViewModel()
    //MARK:- Fetch wishlist Api Call
      func getWishlist(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (WishlistBaseResponse?,Error?)->Void){
          AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
              if let error = error{
                  completion(nil,error)
              }else{
                  if let response = response{
                      if let baseModel = Mapper<WishlistBaseResponse>().map(JSONObject: response){
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
