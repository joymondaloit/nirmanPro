//
//  ForgotPasswordViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 13/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.attributedPlaceholder = NSAttributedString(string: "Enter your registered email",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        // Do any additional setup after loading the view.
    }
 
    @IBAction func continueAction(_ sender: Any) {
        let trimmedEmail = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedEmail.count == 0{
            Utils.showAlert(alert: "", message: "Please enter your email", vc: self)
        }else if !Utils.isValidEmailAddress(emailAddressString: trimmedEmail){
            Utils.showAlert(alert: "", message: "Please enter a valid email", vc: self)
        }else{
            sendPasswordToEmail()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func sendPasswordToEmail(){
        let apiName = DEV_BASE_URL+"customer/forget_password"
        let param:[String:Any] = ["email" : emailTF.text!]
        SVProgressHUD.show()
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response["responseCode"] as! Int == 1{
                        Utils.showAlertWithCallbackOneAction(alert: "", message: response["responseText"] as! String, vc: self, completion: {
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
