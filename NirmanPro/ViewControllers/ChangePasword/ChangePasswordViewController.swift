//
//  ChangePasswordViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 25/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var oldPasswordTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmpasswordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        oldPasswordTF.attributedPlaceholder = NSAttributedString(string: "Enter your old password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTF.attributedPlaceholder = NSAttributedString(string: "Enter your new password",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        confirmpasswordTF.attributedPlaceholder = NSAttributedString(string: "Confirm your password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }

    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
     @IBAction func submitAction(_ sender: UIButton) {
        if oldPasswordTF.text!.count == 0{
            Utils.showAlert(alert: "", message: "Please enter your old password", vc: self)
        }
        if passwordTF.text!.count == 0{
            Utils.showAlert(alert: "", message: "Please enter your new password", vc: self)
        }
        else if confirmpasswordTF.text!.count == 0{
            Utils.showAlert(alert: "", message: "Please confirm your pasword", vc: self)
        }
        else if passwordTF.text! != confirmpasswordTF.text!{
            Utils.showAlert(alert: "", message: "Password and confirm password does not match", vc: self)
        }
        else{
            /**
             Change password Api Call
             */
            self.changePassword()
            
        }

    }
}

//MARK:- Api Call
extension ChangePasswordViewController{
    func changePassword(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"customer/change_password"
        let param :[String:Any] = ["user_id" : Utils.getUserID(),"old_password":oldPasswordTF.text!,"new_password":passwordTF.text!]
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
