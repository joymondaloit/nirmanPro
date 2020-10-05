//
//  ReturnDetailsViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 04/09/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
class ReturnDetailsViewController: UIViewController {

    @IBOutlet weak var returnIDLbl: UILabel!
    @IBOutlet weak var orderIDLbl: UILabel!
    @IBOutlet weak var orderDateAddedLbl: UILabel!
    @IBOutlet weak var orderDateLbl: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productQuantityLbl: UILabel!
    @IBOutlet weak var modelIdLbl: UILabel!
    @IBOutlet weak var reasonLbl: UILabel!
    @IBOutlet weak var openedLbl: UILabel!
    @IBOutlet weak var actionLbl: UILabel!
    @IBOutlet weak var returnDateAddedLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    var returnId: String?
    override func viewDidLoad() {
       super.viewDidLoad()
        self.getReturnDetails()
        // Do any additional setup after loading the view.
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK:- API Call
extension ReturnDetailsViewController {
    func getReturnDetails(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"order/return_details_view"
        let param :[String:Any] = ["return_id":self.returnId!]
        ReturnViewModel.shared.getReturnDetails(apiName: apiName, param: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        self.showData(data: response.responseData!)
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
    func showData(data : ReturnDetailsResponseData){
        if let returnID = data.returnId{
            self.returnIDLbl.text = returnID
        }
        if let orderid = data.orderId{
            self.orderIDLbl.text = orderid
        }
        if let dataAdded = data.dataAdded{
            self.orderDateAddedLbl.text = dataAdded
        }
        if let orderDate = data.orderDate{
            self.orderDateLbl.text = orderDate
        }
        if let productName = data.prdName{
            self.productNameLbl.text = productName
        }
        if let quantity = data.prdQuantity{
            self.productQuantityLbl.text = quantity
        }
        if let model = data.prdModel{
            self.modelIdLbl.text = model
        }
        if let reason = data.reasonName{
            self.reasonLbl.text = reason
        }
        if let opened = data.opened{
            self.openedLbl.text = opened
        }
        if let comment = data.prdComment{
            self.commentLbl.text = comment
        }
        self.actionLbl.text = " "
        self.statusLbl.text = " "
        self.returnDateAddedLbl.text = " "
        
    }
}
