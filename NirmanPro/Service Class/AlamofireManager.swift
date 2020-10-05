//
//  AlamofireManager.swift
//  Athlexa
//
//  Created by Joy Mondal on 23/06/20.
//  Copyright © 2020 WebGuru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class AlamofireManager: NSObject {
    static let sharedInstance = AlamofireManager()
    
    
    typealias ResponseHandler = (_ responseObj: NSDictionary?, _ error: Error? ) -> Void;
    
    //MARK: - create Headers
    func createHeaders()->HTTPHeaders{
        var headers = HTTPHeaders()
        headers = [CONTENT_TYPE: APPLICATION_JSON]
        // Headers same for all the api calls
        if let authorization = UserDefaults.standard.value(forKey: AUTHORIZATION) as? String {
            headers = [CONTENT_TYPE: APPLICATION_ENCODED,
                       AUTHORIZATION : authorization]
        }
        return headers
    }
    //MARK:- GET Api Request with header
    func getRequest(apiName : String,vc : UIViewController, completion : @escaping ResponseHandler){
        if Utils.isNetworkConnected(){
            let headers = self.createHeaders()
            // Get method
            AF.request(apiName, method:HTTPMethod.get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                case let .success(value):
                    if let dict = value as? NSDictionary{
                        completion(dict,nil)
                    }
                   
                case let .failure(error):
                    completion(nil,error)
                }
            }
        }else{
            Utils.showAlert(alert: "OOPS!!", message: "No Network Connection,please try again.", vc: vc)
        }
    }
      //MARK:- POST Api Request with header
    func postRequest(apiname:String,params:[String:Any],vc: UIViewController,completion : @escaping ResponseHandler){
        if Utils.isNetworkConnected(){
            //let headers = self.createHeaders()
         AF.request(apiname, method:HTTPMethod.post, parameters: params).validate().responseJSON { response in
                switch response.result {
                case let .success(value):
                    if let dict = value as? NSDictionary{
                        print("Api name :- \(apiname)")
                        print("Param :- \(params)")
                        print("Response :- \(JSON(dict))")
                       completion(dict,nil)
                    }

                case let .failure(error):
                   completion(nil,error)
                }
            }
        }
        else{
            Utils.showAlert(alert: "OOPS!!", message: "No Network Connection,please try again.", vc: vc)
            
        }

     }
    func deleteRequest(apiName:String,vc: UIViewController){
        if Utils.isNetworkConnected(){
            
        }
        else{
            Utils.showAlert(alert: "OOPS!!", message: "No Network Connection,please try again.", vc: vc)
        }
    }
    

    //Multipart File Upload Api Request;-
    func uploadFile(imageArr: [UIImage], to apiName: String, params: [String: Any],withName : String,filename : String,completion : @escaping ResponseHandler) {
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in params {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            for item in imageArr{
                let imageData = item.jpegData(compressionQuality: 0.5)
                 multiPart.append(imageData!, withName: withName, fileName: filename, mimeType: "image/png")
            }
           
        }, to: apiName,method: .post)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON{ (response) in
                switch response.result {
                case let .success(value):
                    if let dict = value as? NSDictionary{
                        print("Api name :- \(apiName)")
                        print("Param :- \(params)")
                        print("Response :- \(JSON(dict))")
                        completion(dict,nil)
                    }
                    
                case let .failure(error):
                    completion(nil,error)
                }

            }
    }
    func getImageData(image : UIImage) -> Data {
        
        // Do whatever you want with the image
        return (image.jpegData(compressionQuality: 0.5))!
        
    }
}
