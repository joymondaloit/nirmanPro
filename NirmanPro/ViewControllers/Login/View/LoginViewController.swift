//
//  LoginViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 16/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    func setup(){
        self.navigationController?.isNavigationBarHidden = true
        passwordTF.attributedPlaceholder = NSAttributedString(string: "Enter your password",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailTF.attributedPlaceholder = NSAttributedString(string: "Enter your email/phone number",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
    }
    @IBAction func loginBtnAction(_ sender: Any) {
        let trimmedEmail = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedEmail.count == 0{
            Utils.showAlert(alert: "", message: "Please enter your emailID", vc: self)
        }else if passwordTF.text?.count == 0{
            Utils.showAlert(alert: "", message: "Please enter your password", vc: self)
        }else{
            self.login()
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let signUpVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController")
        self.navigationController?.pushViewController(signUpVC, animated: true)
        
    }
}
//MARK:- API Call:-
extension LoginViewController{
    func login(){
        SVProgressHUD.show()
        let apiname = DEV_BASE_URL+"login/login_attempt"
        let param :[String:Any] = ["email" : emailTF.text!,"password" : passwordTF.text!]
        LoginViewModel.shared.Login(apiName: apiname, param: param, vc: self) { (response, error) in
            if let error = error{
                SVProgressHUD.dismiss()
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                SVProgressHUD.dismiss()
                if let response = response{
                    if response.responseCode == 1{
                        UserDefaults.standard.set(response.responseData?.customerId, forKey: USERID_KEY)
                        UserDefaults.standard.set(response.responseData!.firstname!+" "+(response.responseData?.lastname!)!, forKey: USERNAME_KEY)
                        if let userImg = response.responseData?.profileImg{
                            UserDefaults.standard.set(userImg, forKey: PROFILEIMAGE_KEY)

                        }
                        if response.phoneVerify == "Y"{
                            Utils.goToTheDestinationVC(identifier: "HomeViewController")

                        }else{
                            self.sendOTP(mobile: response.responseData!.telephone!)
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
