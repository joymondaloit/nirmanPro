//
//  OrderDetailsViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 17/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
class OrderDetailsViewController: UIViewController {

    @IBOutlet weak var itemTablviewHeight: NSLayoutConstraint!
    @IBOutlet weak var productItemTableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var statustableView: UITableView!
    @IBOutlet weak var billingAddressLbl: UILabel!
    @IBOutlet weak var shippingAddressLbl: UILabel!
    @IBOutlet weak var paymentModeLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var gstLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var deleveryChargeLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    var statusArr = [OrderDetailsHistory]()
    var itemArr = [OrderDetailsProduct]()
    var orderID : String?
    var orderStatus : String?
    var tableViewHeight: CGFloat = 0
    var orderDetails : OrderDetailsResponseData?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statustableView.layer.borderColor = UIColor.lightGray.cgColor
        self.statustableView.layer.borderWidth = 0.5
        self.statustableView.layer.cornerRadius = 22.0
        self.productItemTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        self.getOrderDetails()
      

        // Do any additional setup after loading the view.
    }
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
      productItemTableView.layer.removeAllAnimations()
      itemTablviewHeight.constant = productItemTableView.contentSize.height
      UIView.animate(withDuration: 0.5) {
          self.updateViewConstraints()
      }

  }
    override func viewDidLayoutSubviews() {
        self.productItemTableView.rowHeight = UITableView.automaticDimension
        self.productItemTableView.estimatedRowHeight = 2000
       
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reorderBtnAction(_ sender: Any) {
        Utils.showAlertWithCallback(alert: "Re-Order", message: "Are you sure you want to reorder this item?", vc: self) {
             self.reorder()
        }
       
    }
    //Return product
    @objc func returnItemAction(sender:UIButton){
        Utils.showAlertWithCallback(alert: "Order Return", message: "Are you sure you want to return this product?", vc: self) {
            let returnVC = STORYBOARD.instantiateViewController(withIdentifier: "ProductReturnViewController") as! ProductReturnViewController
            returnVC.productDetails = self.itemArr[sender.tag]
            returnVC.orderDetails = self.orderDetails!
            self.navigationController?.pushViewController(returnVC, animated: true)
        }
        
    }

}
extension OrderDetailsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.statustableView{
            return statusArr.count
        }else{
          return itemArr.count
        }
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == productItemTableView{
            return UITableView.automaticDimension

        }
        else{
            return 70
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == statustableView{
            let statusCell =  tableView.dequeueReusableCell(withIdentifier: "OrderStatusCell", for: indexPath) as! OrderStatusCell
            if indexPath.row == 0{
                statusCell.upperLbl.isHidden = true
            }
            if indexPath.row == 0 && statusArr.count == 1{
                statusCell.upperLbl.isHidden = true
                statusCell.lowerLbl.isHidden = true
                statusCell.statusView.layer.borderWidth = 0
                statusCell.statusView.layer.borderColor = UIColor.clear.cgColor
                statusCell.statusView.backgroundColor = #colorLiteral(red: 0.07240971178, green: 0.1877696812, blue: 0.4908896685, alpha: 1)
            }
                
            else if indexPath.row == statusArr.count - 1{
                statusCell.lowerLbl.isHidden = true
                statusCell.upperLbl.isHidden = false
                statusCell.statusView.layer.borderWidth = 0
                statusCell.statusView.layer.borderColor = UIColor.clear.cgColor
                statusCell.statusView.backgroundColor = #colorLiteral(red: 0.07240971178, green: 0.1877696812, blue: 0.4908896685, alpha: 1)
            }else{
                statusCell.statusView.layer.borderWidth = 1.5
                statusCell.statusView.layer.borderColor = #colorLiteral(red: 0.07240971178, green: 0.1877696812, blue: 0.4908896685, alpha: 1)
                statusCell.statusView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            statusCell.statusName.text = statusArr[indexPath.row].statusName
            statusCell.orderDate.text = "Order at:\(statusArr[indexPath.row].date!)"
            statusCell.selectionStyle = .none
            cell = statusCell
        }else{
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsItemCell", for: indexPath) as! OrderDetailsItemCell
            let data = itemArr[indexPath.row]
            //Color
            if let colorArr = data.color{
                if colorArr.count > 0{
                    itemCell.colorView.isHidden = false
                    itemCell.colorViewHeight.constant = 30
                    itemCell.colorLbl.backgroundColor = Utils.hexStringToUIColor(hex: colorArr[0].code!)
                }else{
                    itemCell.colorView.isHidden = true
                    itemCell.colorViewHeight.constant = 0
                }
            }
            if let productName = data.name{
                itemCell.productName.text! = productName
            }
            if let productDescription = data.productDescription{
                itemCell.productDescription.text! = productDescription
            }
            if let productImg = data.productImage{
                itemCell.productImg.sd_setImage(with: URL(string: productImg.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: PlaceHolderImg), options: .refreshCached) { (image, error, catcheType, imgURL) in
                    
                }
            }
            if let quantity = data.quantity{
                itemCell.quantityLbl.text = "Quantity :\(quantity)"
            }
            if let price = data.price{
                itemCell.productPrice.text = "₹"+price
            }
           
            if let isOrderReturn = data.orderReturn{
                DispatchQueue.main.async {
                    if isOrderReturn == "N"{
                        itemCell.returnBtnView.backgroundColor = .systemRed
                        itemCell.returnBtn.isUserInteractionEnabled = true
                       itemCell.returnBtn.tag = indexPath.row
                        itemCell.returnBtn.addTarget(self, action: #selector(self.returnItemAction), for: .touchUpInside)
                        itemCell.selectionStyle = .none
                    }else if isOrderReturn == "Y"{
                       itemCell.returnBtnView.backgroundColor = .systemGray
                       itemCell.returnBtn.isUserInteractionEnabled = false
                    }
                }
               
            }
            itemCell.selectionStyle = .none
            cell = itemCell
        }
       
        return cell
    }
    
    
}

//MARK:- API Call:-
extension OrderDetailsViewController{
    func getOrderDetails(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"order/order_details"
        let param:[String:Any] = ["order_id" :self.orderID!]
        OrdersViewModel.shared.getOrderDetails(apiName: apiName, param: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        self.orderDetails = response.responseData!
                        if let statusArr = response.responseData?.history{
                            if statusArr.count > 0{
                                self.statusArr = statusArr
                                self.tableHeight.constant = CGFloat(statusArr.count * 70)
                                self.statustableView.reloadData()
                            }else{
                                self.statusArr = []
                                self.statustableView.reloadData()
                            }
                        }
                        if let itemArr = response.responseData?.product{
                            if itemArr.count > 0{
                                self.itemArr = itemArr
                                var subtotal = Float()
                                
                                for item in self.itemArr{
                                    let sub = Float(item.total!)
                                    subtotal = subtotal + sub!
                                }
                                self.subTotalLbl.text = "₹\(subtotal)"
                                self.productItemTableView.reloadData()
                            }else{
                                self.itemArr = []
                                self.productItemTableView.reloadData()
                            }
                        }
                        if let shippingAddress = response.responseData?.shippingAddress{
                            self.shippingAddressLbl.text = shippingAddress.firstName!+" "+shippingAddress.lastName!+"\n"+shippingAddress.address!+"\n"+shippingAddress.city!+" "+shippingAddress.state!+"\n"+shippingAddress.postCode!
                        }
                        if let billingAddress = response.responseData?.paymentAddress{
                            self.billingAddressLbl.text = billingAddress.firstName!+" "+billingAddress.lastName!+"\n"+billingAddress.address!+"\n"+billingAddress.city!+" "+billingAddress.state!+"\n"+billingAddress.postCode!
                        }
                        if let totalAmount = response.responseData?.ordTotalAmnt{
                            self.totalLbl.text = "₹\(totalAmount)"
                        }
                        if let paymentMode = response.responseData?.paymentMethod{
                            self.paymentModeLbl.text = paymentMode
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
    
    func reorder(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"order/ReOrder"
        let param:[String:Any] = ["OrderId" :self.orderID!]
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response["responseCode"] as! Int == 1{
                        Utils.showAlertWithCallbackOneAction(alert: "", message: response["responseText"] as! String, vc: self) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
                    }
                }
            }
        }
    }
}
