//
//  WriteReviewViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 28/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import Cosmos
import SVProgressHUD
class WriteReviewViewController: UIViewController {
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var authorName: UITextField!
    
    var productID : String?
    var delegate : SubmitReviewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func submitBtnAction(_ sender : UIButton){
        let trimmedName = authorName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = reviewTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedName.count == 0{
           Utils.showAlert(alert: "", message: "Please write your name", vc: self)
        }else if trimmedDescription.count == 0{
            Utils.showAlert(alert: "", message: "Please write something about this product", vc: self)
        }else{
            self.submitReview()
        }
        
    }
    @IBAction func backBtnAction(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- API call
extension WriteReviewViewController{
    func submitReview(){
        SVProgressHUD.show()
        var userid = String()
        if Utils.getUserID() == ""{
            userid = "0"
        }else{
            userid = Utils.getUserID()
        }
        let apiName = DEV_BASE_URL+"product/add_rating"
        let param : [String:Any] = ["product_id":self.productID!,
                                    "name": authorName.text!,
                                    "review": reviewTextView.text!,
                                    "rating": self.ratingView.rating,
                                    "customer_id":userid]
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response["responseCode"] as! Int == 1{
                        Utils.showAlertWithCallbackOneAction(alert: "", message: response["responseText"] as! String, vc: self, completion: {
                            self.delegate?.didSuccesReviewSubmit()
                            self.navigationController?.popViewController(animated: true)
                           })
                    }else{
                        Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
                    }
                }
            }
        }
        
    }
}
//Protocol Declaration for callback
protocol SubmitReviewDelegate {
    func didSuccesReviewSubmit()
}
