//
//  EditProfileViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 25/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
class EditProfileViewController: UIViewController {
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    var userData : FetchUserResponseData?
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTF.attributedPlaceholder = NSAttributedString(string: "Enter your first name",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        lastNameTF.attributedPlaceholder = NSAttributedString(string: "Enter your last name",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailTF.attributedPlaceholder = NSAttributedString(string: "Enter your email",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        phoneNumberTF.attributedPlaceholder = NSAttributedString(string: "Enter your phone number",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.showUserData(data: userData!)
        // Do any additional setup after loading the view.
    }
    
    func showUserData(data : FetchUserResponseData){
        if let firstName = data.firstname{
            self.firstNameTF.text = firstName
        }
        if let lastname = data.lastname{
            self.lastNameTF.text = lastname
        }
        if let phoneNumber = data.telephone{
            self.phoneNumberTF.text = phoneNumber
        }
        if let email = data.email{
            self.emailTF.text = email
        }
    
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
      
        else{
            /**
             editProfile Api Call
             */
            
            updateProfile()
        }
        
    }

}
//MARK:- Api Call:-
extension EditProfileViewController{
    func updateProfile(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"customer/update_profile"
        let param : [String: Any] = ["user_id" : Utils.getUserID(),
                                     "fname":firstNameTF.text!,
                                     "lname":lastNameTF.text!,
                                     "email":emailTF.text!,
                                     "mobile":phoneNumberTF.text!,
                                     ]
        SignUpViewModel.shared.SignUp(apiName: apiName, param: param, vc: self) { (response, error) in
            if let error = error{
                SVProgressHUD.dismiss()
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                SVProgressHUD.dismiss()
                if let response = response{
                    if response.responseCode == 1{
                        Utils.showAlertWithCallbackOneAction(alert: "", message: response.responseText!, vc: self) {
                            self.navigationController?.popViewController(animated: true)
                        }

                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
        }
    }
}

