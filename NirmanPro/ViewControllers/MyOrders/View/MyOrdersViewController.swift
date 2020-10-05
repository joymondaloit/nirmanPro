//
//  MyOrdersViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 17/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
class MyOrdersViewController: UIViewController {
    
    @IBOutlet weak var ordersTableView: UITableView!
    var ordersArr = [OrdersResponseData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersTableView.rowHeight = UITableView.automaticDimension
        ordersTableView.estimatedRowHeight = 2000
        NotificationCenter.default.addObserver(self, selector: #selector(goToSelectedVC), name: Notification.Name(GoToVCNotificationKey), object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getOrderList()
    }
    @objc func goToSelectedVC(notification : Notification){
        if let controller = notification.userInfo?["controller"] as? UIViewController{
            if self.isViewLoaded && (self.view.window != nil)
            {
                self.navigationController?.pushViewController(controller, animated: true)
                // NotificationCenter.default.removeObserver(self, name: Notification.Name(GoToVCNotificationKey), object: nil)
            }
        }
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension MyOrdersViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrdersCell") as! MyOrdersCell
        cell.orderData = ordersArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderDetailsVC = STORYBOARD.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
        orderDetailsVC.orderID = ordersArr[indexPath.row].orderId!
        orderDetailsVC.orderStatus = ordersArr[indexPath.row].statusName!
        self.navigationController?.pushViewController(orderDetailsVC, animated: true)
    }
}
//MARK:- Api Call:-
extension MyOrdersViewController{
    func getOrderList(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"order/order_list"
        let param :[String:Any] = ["customer" : Utils.getUserID()]
        OrdersViewModel.shared.getOrderList(apiName: apiName, param: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let _ = error{
                Utils.showAlertWithCallbackOneAction(alert: "Error", message: "Please try gain", vc: self) {
                    self.getOrderList()
                }
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        if let ordersItems = response.responseData{
                            if ordersItems.count != 0{
                                self.ordersArr = ordersItems
                                self.ordersTableView.reloadData()
                                
                            }else{
                                self.ordersTableView.reloadData()
                            }
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
}
