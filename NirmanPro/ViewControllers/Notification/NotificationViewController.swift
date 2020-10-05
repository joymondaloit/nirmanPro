//
//  NotificationViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 30/09/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
class NotificationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var notificationArr = [NotificationResponseData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getNotificationList()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK:- tableview delegate and data source
extension NotificationViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        cell.data = notificationArr[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderID = notificationArr[indexPath.row].id
        let orderDetailsVC = STORYBOARD.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
        orderDetailsVC.orderID = orderID
        self.navigationController?.pushViewController(orderDetailsVC, animated: false)
    }
}
//MARK:- Api call
extension NotificationViewController{
    func getNotificationList(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"login/notification_list"
        let param : [String:Any] = ["customer_id":Utils.getUserID()]
        NotificationViewModel.shared.getNotificationList(apiName: apiName, param: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        if response.responseData!.count > 0{
                            self.notificationArr = response.responseData!
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                
                            }
                        }else{
                            self.notificationArr = []
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                
                            }
                        }
                    }else{
                        self.notificationArr = []
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            
                        }
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
}
