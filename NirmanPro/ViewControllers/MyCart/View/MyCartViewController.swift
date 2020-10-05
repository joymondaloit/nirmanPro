//
//  MyCartViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 14/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
class MyCartViewController: UIViewController {

    @IBOutlet weak var tableMsgLbl: UILabel!
    @IBOutlet weak var totalItems: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var myCartTableView: UITableView!
    
    //MARK:- @Variable Declaration:-
    var cartItemsArr = [CartItemsResponseData]()
    var totalQuantity = 1
    //MARK:- View Life Cycle:-
    override func viewDidLoad() {
        super.viewDidLoad()
        myCartTableView.delegate = self
        myCartTableView.dataSource = self
        myCartTableView.rowHeight = UITableView.automaticDimension
        myCartTableView.estimatedRowHeight = 2000
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getCartItems()
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkOutAction(_ sender: Any) {
        if cartItemsArr.count > 0{
            let checkoutVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
            self.navigationController?.pushViewController(checkoutVC, animated: true)
        }else{
            Utils.showAlert(alert: "Empty Cart", message: "Please add some products to make an order", vc: self)
        }
       
    }
    @objc func plusCartBtnAction(sender : UIButton){
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let cell = myCartTableView.cellForRow(at: indexpath) as! MyCartCell
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
        let cell = myCartTableView.cellForRow(at: indexpath) as! MyCartCell
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
    
}

extension MyCartViewController : UITableViewDataSource,UITableViewDelegate{
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCartCell") as! MyCartCell
        if let productName = data.productName{
            cell.productName.text! = productName
        }
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
extension MyCartViewController {
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
                                self.myCartTableView.reloadData()
                                if let totalAmnt = response.cartTotalAmount{
                                    self.totalPrice.text = "₹ \(totalAmnt)"
                                }
                                self.totalItems.text = "(\(self.cartItemsArr.count) item)"
                            }else{
                                self.cartItemsArr = []
                                self.totalPrice.text = ""
                                self.totalItems.text = ""
                               self.myCartTableView.reloadData()
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
    
}
