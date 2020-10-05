//
//  AddressViewModel.swift
//  NirmanPro
//
//  Created by Joy Mondal on 10/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import ObjectMapper
class AddressViewModel: NSObject {
static let shared = AddressViewModel()
    /**
     Get Address List:-
     */
    func getAddressList(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (AddressListBaseResponse?,Error?)->Void){
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
            if let error = error{
                completion(nil,error)
            }else{
                if let response = response{
                    if let baseModel = Mapper<AddressListBaseResponse>().map(JSONObject: response){
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
        Get Country List:-
        */
    func getCountryList(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (CountryBaseResponse?,Error?)->Void){
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
            if let error = error{
                completion(nil,error)
            }else{
                if let response = response{
                    if let baseModel = Mapper<CountryBaseResponse>().map(JSONObject: response){
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
        Get State List:-
        */
    func getStateList(apiName: String,param : [String:Any],vc : UIViewController, completion : @escaping (StateBaseResponse?,Error?)->Void){
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: vc) { (response, error) in
            if let error = error{
                completion(nil,error)
            }else{
                if let response = response{
                    if let baseModel = Mapper<StateBaseResponse>().map(JSONObject: response){
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
