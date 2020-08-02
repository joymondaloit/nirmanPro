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
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmpasswordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.attributedPlaceholder = NSAttributedString(string: "Enter your new password",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        confirmpasswordTF.attributedPlaceholder = NSAttributedString(string: "Confirm your password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }

    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
     @IBAction func submitAction(_ sender: UIButton) {
        if passwordTF.text!.count == 0{
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
             Change password Api Call
             */
            
            
        }

    }
}

//MARK:- Api Call
extension ChangePasswordViewController{
    func changePassword(){
        //SVProgressHUD.show()

    }
}
