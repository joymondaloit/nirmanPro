//
//  OTPViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 24/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
class OTPViewController: UIViewController {

    @IBOutlet weak var OTPLbl: UILabel!
    @IBOutlet weak var firstTF: UITextField!
    @IBOutlet weak var secondTF: UITextField!
    @IBOutlet weak var thirdTF: UITextField!
    @IBOutlet weak var fourthTF: UITextField!
    
    var phoneNumber : String?
    var OTPString : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.OTPLbl.text = "Please enter the OTP send to \(self.phoneNumber!)"
        firstTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        secondTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        thirdTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        fourthTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        setOTPIntoFields()
        // Do any additional setup after loading the view.
    }
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case firstTF:
                secondTF.becomeFirstResponder()
            case secondTF:
                thirdTF.becomeFirstResponder()
            case thirdTF:
                fourthTF.becomeFirstResponder()
            case fourthTF:
                fourthTF.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case firstTF:
                firstTF.becomeFirstResponder()
            case secondTF:
                firstTF.becomeFirstResponder()
            case thirdTF:
                secondTF.becomeFirstResponder()
            case fourthTF:
                thirdTF.becomeFirstResponder()
            default:
                break
            }
        }
        else{

        }
    }
    func setOTPIntoFields(){
        let otpArr = OTPString?.digits
        if otpArr?.count == 4{
            firstTF.text! = "\(otpArr![0])"
            secondTF.text! = "\(otpArr![1])"
            thirdTF.text! = "\(otpArr![2])"
            fourthTF.text! = "\(otpArr![3])"
        }
    }
    @IBAction func verifyAction(_ sender: Any) {
        let first = firstTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let second = secondTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let third = thirdTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let fourth = fourthTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if first.count == 0 || second.count == 0 || third.count == 0 || fourth.count == 0{
            Utils.showAlert(alert: "", message: "Please enter a valid OTP to verify", vc: self)
        }else{
            verifyOTP()
        }
    }
    
    @IBAction func resendOtpAction(_ sender: Any) {
        self.sendOTP(mobile: self.phoneNumber!)
    }
    
}
//MARK:- TextField Delegates:-
extension OTPViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField.text!.count < 1  && string.count > 0{
            let nextTag = textField.tag + 1

            // get next responder
            var nextResponder = textField.superview?.viewWithTag(nextTag)

            if (nextResponder == nil){

                nextResponder = textField.superview?.viewWithTag(1)
            }
            textField.text = string
            nextResponder?.becomeFirstResponder()
            return false
        }
        else if textField.text!.count >= 1  && string.count == 0{
            // on deleting value from Textfield
            let previousTag = textField.tag - 1

            // get next responder
            var previousResponder = textField.superview?.viewWithTag(previousTag)

            if (previousResponder == nil){
                previousResponder = textField.superview?.viewWithTag(1)
            }
            textField.text = ""
            previousResponder?.becomeFirstResponder()
            return false
        }
        return true

    }
}
//MARK:- API call:-
extension OTPViewController{
func verifyOTP(){
    SVProgressHUD.show()
    let otp = firstTF.text!+secondTF.text!+thirdTF.text!+fourthTF.text!
    let apiName = DEV_BASE_URL+"login/otp_verify"
    let param: [String:Any] = ["mobile" :self.phoneNumber!,"otp": otp]
    AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: self) { (response, error) in
        SVProgressHUD.dismiss()
        if let error = error{
            Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
        }else{
            if let response = response{
                if response["responseCode"] as! Int == 1{
                    Utils.goToTheDestinationVC(identifier: "HomeViewController")
                }else{
                    Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
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
                       if let otp = response["responseData"] as? String{
                        self.OTPString = otp
                        self.setOTPIntoFields()
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
                    }
                }
            }
        }
    }
}
