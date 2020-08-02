//
//  SignUpViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 16/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmpasswordTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    func setup(){
        firstNameTF.attributedPlaceholder = NSAttributedString(string: "Enter your first name",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        lastNameTF.attributedPlaceholder = NSAttributedString(string: "Enter your last name",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailTF.attributedPlaceholder = NSAttributedString(string: "Enter your email",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        phoneNumberTF.attributedPlaceholder = NSAttributedString(string: "Enter your phone number",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTF.attributedPlaceholder = NSAttributedString(string: "Enter your password",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        confirmpasswordTF.attributedPlaceholder = NSAttributedString(string: "Confirm your password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitAction(_ sender: UIButton) {
        let trimmedFirstName = firstNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLastName = lastNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPhoneNumber = phoneNumberTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedFirstName.count == 0{
            Utils.showAlert(alert: "", message: "Please enter your first name", vc: self)
        }
        else if trimmedLastName.count == 0{
            Utils.showAlert(alert: "", message: "Please enter your last name", vc: self)
        }
        else if trimmedEmail.count == 0{
            Utils.showAlert(alert: "", message: "Please enter your email", vc: self)
        }
        else if trimmedEmail.count == 0{
            Utils.showAlert(alert: "", message: "Please enter your email", vc: self)
        }
        else if !Utils.isValidEmailAddress(emailAddressString: trimmedEmail){
            Utils.showAlert(alert: "", message: "Please enter a valid email", vc: self)
        }
        else if trimmedPhoneNumber.count == 0{
            Utils.showAlert(alert: "", message: "Please enter your phoneNumber", vc: self)
        }else if trimmedPhoneNumber.count != 10{
            Utils.showAlert(alert: "", message: "Please enter a valid phone number", vc: self)
            
        }
        else if passwordTF.text!.count == 0{
            Utils.showAlert(alert: "", message: "Please enter your password", vc: self)
        }
        else if confirmpasswordTF.text!.count == 0{
            Utils.showAlert(alert: "", message: "Please confirm your pasword", vc: self)
        }
        else if passwordTF.text! != confirmpasswordTF.text!{
            Utils.showAlert(alert: "", message: "Password and confirm password does not match", vc: self)
        }
        else{
            /**
             SignUp Api Call
             */
            self.signup()
            
        }
        
    }
}
//MARK:- Api Call:-
extension SignUpViewController{
    func signup(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"login/register_attempt"
        let param : [String: Any] = ["fname":firstNameTF.text!,
                                     "lname":lastNameTF.text!,
                                     "email":emailTF.text!,
                                     "password":passwordTF.text!,
                                     "mobile":phoneNumberTF.text!,
                                     "newsletter":"true"]
        SignUpViewModel.shared.SignUp(apiName: apiName, param: param, vc: self) { (response, error) in
            if let error = error{
                SVProgressHUD.dismiss()
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                SVProgressHUD.dismiss()
                if let response = response{
                    if response.responseCode == 1{
                        if let phoneNumber = response.responseData?.telephone{
                            self.sendOTP(mobile: phoneNumber)
                        }

                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
        }
    }
    
    func sendOTP(mobile : String){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"login/otp_send"
        let param :[String:Any] = ["mobile" : mobile]
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response["responseCode"] as! Int == 1{
                        let otpVC = STORYBOARD.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                        otpVC.phoneNumber = mobile
                        if let otp = response["responseData"] as? String{
                            otpVC.OTPString = otp
                        }
                        self.navigationController?.pushViewController(otpVC, animated: true)
                    }else{
                        Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
                    }
                }
            }
        }
    }
}
