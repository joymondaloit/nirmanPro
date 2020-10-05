//
//  ReturnListViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 28/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
class ReturnListViewController: UIViewController {

    @IBOutlet weak var returnTableView: UITableView!
    var returnListArr = [ReturnListResponseData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.returnTableView.rowHeight = UITableView.automaticDimension
        self.returnTableView.estimatedRowHeight = 2000
        getReturnList()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
//MARK:- TableView Datasource And Delegates
extension ReturnListViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return returnListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnListCell") as! ReturnListCell
        let data = returnListArr[indexPath.row]
        if let name = data.customerName{
            cell.nameLbl.text = name
        }
        if let date = data.returnDate{
            cell.dateLbl.text = date
        }
        if let status = data.statusName{
            cell.statusLbl.text = status
        }
        if let orderID = data.orderId{
            cell.orderIDLbl.text = orderID
        }
        if let returnID = data.returnId{
            cell.returnIDLbl.text = returnID
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = STORYBOARD.instantiateViewController(withIdentifier: "ReturnDetailsViewController") as! ReturnDetailsViewController
        detailsVC.returnId = returnListArr[indexPath.row].returnId!
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}
//MARK:- API call:-
extension ReturnListViewController{
    func getReturnList(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"order/return_list"
        let param :[String:Any] = ["customer_id" : Utils.getUserID()]
        ReturnViewModel.shared.getReturnItemList(apiName: apiName, param: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        if response.responseData!.count > 0{
                            self.returnListArr = response.responseData!
                            self.returnTableView.reloadData()
                            }
                        else{
                           self.returnListArr = []
                            self.returnTableView.reloadData()
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
}
