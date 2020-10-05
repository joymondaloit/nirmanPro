//
//  AddressListViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 10/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
class AddressListViewController: UIViewController {
    @IBOutlet weak var addreesTableView: UITableView!
    var addressArr = [AddressListResponseData]()
    var delegate : AddressSelectDelegate?
    var addressType = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addreesTableView.rowHeight = UITableView.automaticDimension
        self.addreesTableView.estimatedRowHeight = 2000
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getAddressList()
    }
    @IBAction func backbtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addNewAddressAction(_ sender: Any) {
        let addAddressVC = STORYBOARD.instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
        addAddressVC.commingFrom = ""
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
    
    @objc func deleteAddressAction(sender : UIButton){
        Utils.showAlertWithCallback(alert: "", message: "Are you sure you want to delete this address?", vc: self) {
            self.deleteAddress(addressID: self.addressArr[sender.tag].addressId!)
        }
    }
    @objc func editAddressAction(sender : UIButton){
        let addAddressVC = STORYBOARD.instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
        addAddressVC.commingFrom = "update"
        addAddressVC.addressData = addressArr[sender.tag]
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
}
//MARK:- TableView Delegate And Data source:-
extension AddressListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addressArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressListCell") as! AddressListCell
        cell.addressData = addressArr[indexPath.row]
        cell.deleteAddressBtn.tag = indexPath.row
        cell.deleteAddressBtn.addTarget(self, action: #selector(deleteAddressAction), for: .touchUpInside)
        cell.editAddressBtn.tag = indexPath.row
        cell.editAddressBtn.addTarget(self, action: #selector(editAddressAction), for: .touchUpInside)
        cell.defaultAddressBtn.tag = indexPath.row
        cell.defaultAddressBtn.addTarget(self, action: #selector(changeDefaultAddressAction), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if addressType == "billing"{
            self.delegate?.didTapBillingAddress(data: addressArr[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
        else if addressType == "shiping"{
            self.delegate?.didTapShippingAddress(data: addressArr[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func changeDefaultAddressAction(sender : UIButton) {
        if addressArr[sender.tag].defaultAddress != 1{
            DispatchQueue.main.async {
                Utils.showAlertWithCallback(alert: "", message: "Are you want to change your default address?", vc: self) {
                    self.changeDefaultAddress(addressID: self.addressArr[sender.tag].addressId!)
                }
                
            }
        }
    }
    
}
//MARK:- Api Calling:-
extension AddressListViewController {
    /**
     Get address List
     */
    func getAddressList(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"address/getAddress"
        let param:[String:Any] = ["customer_id" : Utils.getUserID()]
        AddressViewModel.shared.getAddressList(apiName: apiName, param: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        if response.responseData!.count > 0{
                            self.addressArr = response.responseData!
                            DispatchQueue.main.async {
                                self.addreesTableView.reloadData()
                            }
                        }else{
                            self.addressArr = []
                            DispatchQueue.main.async {
                                self.addreesTableView.reloadData()
                                
                            }
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
    
    /**
     deleteAddress Api Call:-
     */
    func deleteAddress(addressID : String){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"address/deleteAddress"
        let param : [String:Any] = ["address_id" : addressID,"customer_id" : Utils.getUserID()]
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response["responseCode"] as! Int == 1{
                        Utils.showAlertWithCallbackOneAction(alert: "", message: response["responseText"] as! String, vc: self, completion: {
                            self.getAddressList()
                           })
                    }else{
                        Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
                    }
                }
            }
        }
    }
    
    /*
        change Default address:-
     */
    func changeDefaultAddress(addressID : String){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"address/add_default_address"
        let param:[String:Any] = ["address_id" :addressID,"customer_id": Utils.getUserID()]
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response["responseCode"] as! Int == 1{
                        Utils.showAlertWithCallbackOneAction(alert: "", message: response["responseText"] as! String, vc: self, completion: {
                            self.getAddressList()
                           })
                    }else{
                        Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
                    }
                }
            }
        }
    }
}
//MARK:- Declare protocol for change shipping and billing address:-
protocol AddressSelectDelegate {
    func didTapBillingAddress(data : AddressListResponseData)
    func didTapShippingAddress(data : AddressListResponseData)
}
