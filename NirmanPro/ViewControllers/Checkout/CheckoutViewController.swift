//
//  CheckoutViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 15/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
class CheckoutViewController: UIViewController {

    @IBOutlet weak var tableMsgLbl: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var paymentMethodBtn: UIButton!
    @IBOutlet weak var paymentMethodSwitch: UIImageView!
    @IBOutlet weak var shipingAddressLbl: UILabel!
    @IBOutlet weak var bilingAddressLbl: UILabel!
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var couponTF: UITextField!
    @IBOutlet weak var subtotalAmntLbl: UILabel!
    @IBOutlet weak var gstAmntLbl: UILabel!
    @IBOutlet weak var discountAmntLbl: UILabel!
    @IBOutlet weak var deliveryChargeAmntLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var totalAmntLbl: UILabel!
    @IBOutlet weak var totalItems: UILabel!
    //MARK:- @Variable Declaration:-
    var cartItemsArr = [CartItemsResponseData]()
    var totalQuantity = 1
    var cartIDArr = [String]()
    var cardIDs = String()
    var shipingAddressID = String()
    var billingAddressID = String()
    //MARK:- View life cycle:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemsTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    
        getAddressList()
        getCartItems()
        
  
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        itemsTableView.layer.removeAllAnimations()
        tableViewHeight.constant = itemsTableView.contentSize.height
       UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    @IBAction func applyCouponBtnAction(_ sender: Any) {
    }
    //MARK:- @IBActions:-
    @IBAction func bilingAddressChangeAction(_ sender: Any) {
        let addressListVC = STORYBOARD.instantiateViewController(withIdentifier: "AddressListViewController") as! AddressListViewController
        addressListVC.delegate = self
        addressListVC.addressType = "billing"
        self.navigationController?.pushViewController(addressListVC, animated: true)
    }
    @IBAction func shipingAddressChangeAction(_ sender: Any) {
        let addressListVC = STORYBOARD.instantiateViewController(withIdentifier: "AddressListViewController") as! AddressListViewController
        addressListVC.delegate = self
        addressListVC.addressType = "shiping"
        self.navigationController?.pushViewController(addressListVC, animated: true)
    }
    
    
    @IBAction func paymentMethodAction(_ sender: Any) {
        
    }
    
    @IBAction func placeOrderAction(_ sender: Any) {
        if cartItemsArr.count == 0{
            Utils.showAlert(alert: "", message: "Your cart list is empty please add some product for order", vc: self)
        }
        else if shipingAddressLbl.text == "Enter your shiping address"{
            Utils.showAlert(alert: "", message: "Shiping Address can not be empty", vc: self)
            
        }else if bilingAddressLbl.text == "Enter your billing address"{
            Utils.showAlert(alert: "", message: "Billing Address can not be empty", vc: self)
        }else{
            if cartIDArr.count > 0{
                self.makeAnOrder()
            }
        }
        
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- TableView Delegate and data source:-
extension CheckoutViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cartItemsArr.count == 0{
            self.tableMsgLbl.isHidden = false
        }else{
            self.tableMsgLbl.isHidden = true
        }
        return cartItemsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = cartItemsArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChekoutItemsCell") as! ChekoutItemsCell
        self.tableViewHeight.constant = CGFloat((Int(cell.frame.size.height) * cartItemsArr.count) - 10)
        //Color
        if let colorArr = data.color{
            if colorArr.count > 0{
                cell.colorView.isHidden = false
                cell.colorViewHeight.constant = 30
                cell.colorLbl.backgroundColor = Utils.hexStringToUIColor(hex: colorArr[0].code!)
            }else{
                cell.colorView.isHidden = true
                cell.colorViewHeight.constant = 0
            }
        }
        if let productName = data.productName{
            cell.productName.text! = productName
        }
        if let productDescription = data.productDescription{
            cell.productDescription.text! = productDescription
        }
        if let productImg = data.productImage{
            cell.productImg.sd_setImage(with: URL(string: productImg.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: PlaceHolderImg), options: .refreshCached) { (image, error, catcheType, imgURL) in
                
            }
        }
        if let specialPrice = data.productSpecialPrice{
            if specialPrice != ""{
                cell.mrpPrice.isHidden = false
                if let actualPrice = data.productPrice{
                    cell.mrpPrice.attributedText = actualPrice.strikeThrough()
                }
                cell.actualPrice.text = specialPrice
            }else{
                if let actualPrice = data.productPrice{
                    cell.actualPrice.text = "₹\(actualPrice)"
                }
                cell.mrpPrice.isHidden = true
                cell.mrpPrice.text = ""
            }
        }

        if let totalItem = data.productQuantity{
            cell.itemCountLbl.text = totalItem
        }
        
        cell.deleteItemBtn.tag = indexPath.row
        cell.deleteItemBtn.addTarget(self, action: #selector(deleteCartItemAction), for: .touchUpInside)
        cell.plusItemBtn.tag = indexPath.row
        cell.minusItemBtn.tag = indexPath.row
        cell.plusItemBtn.addTarget(self, action: #selector(plusCartBtnAction), for: .touchUpInside)
        cell.minusItemBtn.addTarget(self, action: #selector(minusCartBtnAction), for: .touchUpInside)
        return cell
    }
    
    
}

//MARK:- API call:-
extension CheckoutViewController {
    func getCartItems(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"cart/cart_list"
        let param : [String:Any] = ["usreId" : Utils.getUserID()]
        MyCartViewModel.shared.getCartList(apiName: apiName, param: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        if let cartItems = response.responseData{
                            if cartItems.count != 0{
                                self.cartItemsArr = cartItems
                                self.itemsTableView.reloadData()
                                if let totalAmnt = response.cartTotalAmount{
                                    self.subtotalAmntLbl.text = "₹ \(totalAmnt)"
                                    let total_Amount = Float(totalAmnt)!+5.0
                                    self.totalLbl.text = "₹ \(total_Amount)"
                                    self.totalAmntLbl.text = "₹ \(total_Amount)"
                                }
                                self.totalItems.text = "(\(self.cartItemsArr.count) item)"
                                self.cartIDArr.removeAll()
                                for item in self.cartItemsArr{
                                    if let cartID = item.cartId{
                                        self.cartIDArr.append(cartID)
                                        
                                    }
                                }
                            }else{
                                self.itemsTableView.reloadData()

                            }
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
    
    @objc func deleteCartItemAction(sender : UIButton){
        Utils.showAlertWithCallback(alert: "", message: "Are you sure you want to remove this item from cart?", vc: self) {
            SVProgressHUD.show()
            let apiName = DEV_BASE_URL+"cart/cart_delete"
            let param :[String:Any] = ["user_id":Utils.getUserID(),
                                       "cart_id":self.cartItemsArr[sender.tag].cartId!]
            AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: self) { (response, error) in
                SVProgressHUD.dismiss()
                if let error = error{
                    Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
                }else{
                    if let response = response{
                        if response["responseCode"] as! Int == 1{
                            Utils.showAlertWithCallbackOneAction(alert: "", message: response["responseText"] as! String, vc: self) {
                                self.getCartItems()
                            }
                        }else{
                            Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
                        }
                    }
                }
            }
        }
    }
    
    func addToCart(productID : String,quantity: Int,actionType: Int){
           SVProgressHUD.show()
           let apiName = DEV_BASE_URL+"cart/add_to_cart"
        let param :[String:Any] = ["usreId":Utils.getUserID(),"productid" :productID,"quantity":quantity,"action_type" : actionType]
           AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: self) { (response, error) in
               SVProgressHUD.dismiss()
               if let error = error{
                   Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
               }else{
                   if let response = response{
                       if response["responseCode"] as! Int == 1{
                        self.getCartItems()
                       }else{
                           Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
                       }
                   }
               }
           }
       }
    @objc func plusCartBtnAction(sender : UIButton){
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let cell = itemsTableView.cellForRow(at: indexpath) as! ChekoutItemsCell
        self.totalQuantity = Int(cartItemsArr[sender.tag].productQuantity!)!
        self.totalQuantity = self.totalQuantity + 1
        if totalQuantity < 10{
            cell.itemCountLbl.text = "0\(self.totalQuantity)"
        }else{
            cell.itemCountLbl.text = "\(self.totalQuantity)"
        }
        self.addToCart(productID: cartItemsArr[sender.tag].productId!, quantity:
        1, actionType: 1)
        
    }
    @objc func minusCartBtnAction(sender : UIButton){
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let cell = itemsTableView.cellForRow(at: indexpath) as! ChekoutItemsCell
        self.totalQuantity = Int(cartItemsArr[sender.tag].productQuantity!)!
        if totalQuantity > 1{
           self.totalQuantity = self.totalQuantity - 1
            if totalQuantity < 10{
                cell.itemCountLbl.text = "0\(self.totalQuantity)"
            }else{
                cell.itemCountLbl.text = "\(self.totalQuantity)"
            }
            self.addToCart(productID: cartItemsArr[sender.tag].productId!, quantity:
            1, actionType: 0)
        }
        
    }
    
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
                            let addArr = response.responseData!
                            if let index = addArr.firstIndex(where: {$0.defaultAddress == 1}){
                                let data = response.responseData![index]
                                if let addressID = data.addressId{
                                    self.shipingAddressID = addressID
                                    self.billingAddressID = addressID
                                }
                                if let address = data.address1{
                                    if let address2 = data.address2{
                                        if address2 != ""{
                                            self.shipingAddressLbl.text = address+" "+address2
                                            self.bilingAddressLbl.text = address+" "+address2
                                        }else{
                                            self.bilingAddressLbl.text = address
                                            self.shipingAddressLbl.text = address
                                        }
                                    }else{
                                        self.bilingAddressLbl.text = address
                                        self.shipingAddressLbl.text = address
                                    }
                                }
                            }else{
                                self.shipingAddressLbl.text = "Enter your shiping address"
                                self.bilingAddressLbl.text = "Enter your billing address"
                            }
                            
                        }else{
                            self.shipingAddressLbl.text = "Enter your shiping address"
                            self.bilingAddressLbl.text = "Enter your billing address"
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
    
    /**
     Make an order api call
     */
    
    func makeAnOrder(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"order/make_order"
        self.cardIDs = self.cartIDArr.joined(separator: ",")
        let param:[String:Any] = ["customer_id":Utils.getUserID(),
                                  "cart_id": self.cardIDs,
                                  "shipping_rate":5.00,
                                  "order_description":"test description",
                                  "address_id": self.billingAddressID,
                                  "shipping_address_id":self.shipingAddressID,
                                  "coupon_code":1111]
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response["responseCode"] as! Int == 1{
                        Utils.showAlertWithCallbackOneAction(alert: "", message: response["responseText"] as! String, vc: self) {
                             Utils.goToTheDestinationVC(identifier: "HomeViewController")
                        }
                        
                    }else{
                        Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
                    }
                }
            }
        }
    }
}
//MARK:- Address selection Delagtes
extension CheckoutViewController: AddressSelectDelegate{
    func didTapBillingAddress(data: AddressListResponseData) {
        if let id = data.addressId{
            self.billingAddressID = id
        }
        if let address = data.address1{
            if let address2 = data.address2{
                if address2 != ""{
                    self.bilingAddressLbl.text = address+" "+address2
                    
                }else{
                    self.bilingAddressLbl.text = address
                }
            }else{
                self.bilingAddressLbl.text = address
            }
        }
    }
    
    func didTapShippingAddress(data: AddressListResponseData) {
        if let id = data.addressId{
            self.shipingAddressID = id
        }
        if let address = data.address1{
            if let address2 = data.address2{
                if address2 != ""{
                    self.shipingAddressLbl.text = address+" "+address2
                    
                }else{
                    self.shipingAddressLbl.text = address
                }
            }else{
                self.shipingAddressLbl.text = address
            }
        }
    }

}
