//
//  HomeViewModel.swift
//  NirmanPro
//
//  Created by Joy Mondal on 27/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import ObjectMapper
class HomeViewModel: NSObject {
    static let shared = HomeViewModel()
    
    /**
     Get Banner list
     */
    func getBannerList(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (BannerRootClass?,Error?)->Void){
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
            if let error = error{
                completion(nil,error)
            }else{
                if let response = response{
                    if let baseModel = Mapper<BannerRootClass>().map(JSONObject: response){
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
     Get Category list
     */
    func getCategoryList(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (HomeCategoryResponseModel?,Error?)->Void){
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
            if let error = error{
                completion(nil,error)
            }else{
                if let response = response{
                    if let baseModel = Mapper<HomeCategoryResponseModel>().map(JSONObject: response){
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
     Get Featured product list:-
     */
    func getFeatureProducts(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (HomeFeaturedProductResponseModel?,Error?)->Void){
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
            if let error = error{
                completion(nil,error)
            }else{
                if let response = response{
                    if let baseModel = Mapper<HomeFeaturedProductResponseModel>().map(JSONObject: response){
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
     Get Brand list:-
     */
    func getBrandsList(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (BrandsBaseResponse?,Error?)->Void){
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
            if let error = error{
                completion(nil,error)
            }else{
                if let response = response{
                    if let baseModel = Mapper<BrandsBaseResponse>().map(JSONObject: response){
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
     Get New Product list:-
     */
    func getNewProductList(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (NewProductBaseResponse?,Error?)->Void){
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
            if let error = error{
                completion(nil,error)
            }else{
                if let response = response{
                    if let baseModel = Mapper<NewProductBaseResponse>().map(JSONObject: response){
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
     Get New Special Banner:-
     */
    func getSpecialBannerList(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (SpecialBannerBaseResponse?,Error?)->Void){
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
            if let error = error{
                completion(nil,error)
            }else{
                if let response = response{
                    if let baseModel = Mapper<SpecialBannerBaseResponse>().map(JSONObject: response){
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
