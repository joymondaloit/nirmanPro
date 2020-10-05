//
//  ProductReturnViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 21/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD
class ProductReturnViewController: UIViewController {
    //MARK:- @IBOulets:-
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var telephoneLbl: UILabel!
    @IBOutlet weak var orderIDLbl: UILabel!
    @IBOutlet weak var orderDateLbl: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productCodeLbl: UILabel!
    @IBOutlet weak var productQuantityLbl: UILabel!
    @IBOutlet weak var reasonBtn: UIButton!
    @IBOutlet weak var reasonLbl: UILabel!
    @IBOutlet weak var productOpenYesBtn: UIButton!
    @IBOutlet weak var productOpenNoBtn: UIButton!
    @IBOutlet weak var faultDetailsTextView: UITextView!
    @IBOutlet weak var productOpenYesBtnImg: UIImageView!
    @IBOutlet weak var productOpenNoBtnImg: UIImageView!
    
    var productDetails : OrderDetailsProduct?
    var orderDetails : OrderDetailsResponseData?
    var openFlag : String?
    var reasonNameArr = [String]()
    var resonItemArr = [ReturnReasonReasonData]()
    var reasonID : String?
    //MARK:- View Life Cycle:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getReasonList()
        self.showData()
        self.openFlag = "1"
        // Do any additional setup after loading the view.
    }
    
    //MARK:- @IBActions:-
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func enterReasonAction(_ sender: Any) {
        if self.resonItemArr.count > 0{
            self.showDropDownWithCallback(itemArr: self.reasonNameArr, anchorView: sender as! UIButton) { (item, index) in
                self.reasonLbl.text = item
                self.reasonID = self.resonItemArr[index!].id!
            }
        }
    }
    
    @IBAction func productOpenYesAction(_ sender: Any) {
        resetYesNoBtn()
        productOpenYesBtn.isSelected = true
        self.productOpenYesBtnImg.image = UIImage.init(named: "radio-on-white")
        self.openFlag = "1"
    }
    @IBAction func productOpenNoAction(_ sender: Any) {
        resetYesNoBtn()
        productOpenNoBtn.isSelected = true
        self.productOpenNoBtnImg.image = UIImage.init(named: "radio-on-white")
        self.openFlag = "0"
    }
    
    @IBAction func submitAction(_ sender: Any) {
        if reasonLbl.text == "Enter the reason"{
            Utils.showAlert(alert: "", message: "Please enter any valid reason for return", vc: self)
        }else{
            self.submitReturn()
        }
        
    }
    //MARK:- Methods:-
    func showData(){
        if let firstName = orderDetails?.shippingAddress?.firstName{
            self.firstNameLbl.text = firstName
        }
        if let lastName = orderDetails?.shippingAddress?.lastName{
            self.lastNameLbl.text = lastName
        }
        if let email = orderDetails?.shippingAddress?.email{
            self.emailLbl.text = email
        }
        if let phone = orderDetails?.shippingAddress?.phone{
            self.telephoneLbl.text = phone
        }
        if let orderID = orderDetails?.orderId{
            self.orderIDLbl.text = orderID
        }
        if let orderDate = orderDetails?.orderDate{
            self.orderDateLbl.text = orderDate
        }
        if let productName = productDetails?.name{
            self.productNameLbl.text = productName
        }
        if let productCode = productDetails?.model{
            self.productCodeLbl.text = productCode
        }
        if let quantity = productDetails?.quantity{
            self.productQuantityLbl.text = quantity
        }
        
        
    }
    
    func resetYesNoBtn(){
        self.productOpenYesBtn.isSelected = false
        self.productOpenNoBtn.isSelected = false
        self.productOpenYesBtnImg.image = UIImage.init(named: "radio-off-white")
        self.productOpenNoBtnImg.image = UIImage.init(named: "radio-off-white")
    }
    /**
     Method for DropDown Listing And selection:-
     */
    func showDropDownWithCallback(itemArr:[String],anchorView : UIView, completion :@escaping(String?,Int?)->()){
        let dropDown = DropDown()
        dropDown.backgroundColor = .white
        dropDown.textColor = .black
        dropDown.direction = .bottom
        dropDown.anchorView = anchorView // UIView or UIBarButtonItem
        dropDown.dataSource = itemArr
        dropDown.show()
        dropDown.selectionAction = {(index: Int, item: String) in
            completion(item,index)
        }
    }
}
//MARK:- API calling:-
extension ProductReturnViewController{
    func getReasonList(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"order/return_reason_list"
        ReturnViewModel.shared.getReasonList(apiName: apiName, param: [:], vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        self.reasonNameArr.removeAll()
                        if response.reasonData!.count > 0{
                            self.resonItemArr = response.reasonData!
                            for item in self.resonItemArr{
                                self.reasonNameArr.append(item.name!)
                            }
                            
                        }else{
                            
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
    
    func submitReturn(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"order/order_return"
        guard let order_id = productDetails?.productOrderId else {
            return
        }
        let param:[String:Any] = ["order_product_id": order_id,
                                  "return_reason":self.reasonID!,
                                  "is_opened":self.openFlag!,
            "other_description":self.faultDetailsTextView.text!]
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response["responseCode"] as! Int == 1{
                        Utils.showAlertWithCallbackOneAction(alert: "", message: response["responseText"] as! String, vc: self, completion: {
                            Utils.goToTheDestinationVC(identifier: "HomeViewController")
                           })
                    }else{
                        Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
                    }
                }
            }
        }
        
    }
}
