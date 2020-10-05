//
//  AddReviewViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 26/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import Cosmos
import SVProgressHUD
class ReviewListViewController: UIViewController {
    
    @IBOutlet weak var reviewTableView: UITableView!
    var reviewArr = [ProductReviewResponseData]()
    var productID : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTableView.dataSource = self
        reviewTableView.rowHeight = UITableView.automaticDimension
        reviewTableView.estimatedRowHeight = 2000
        getReviewList()
     
    }
   
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func wrtiteReviewBtnAction(_ sender: Any) {
        let writeReviewVC = STORYBOARD.instantiateViewController(withIdentifier: "WriteReviewViewController") as! WriteReviewViewController
        writeReviewVC.productID = self.productID!
        writeReviewVC.delegate = self
        self.navigationController?.pushViewController(writeReviewVC, animated: true)
    }
  
    
}
//MARK:- TableView Delegate anad data source:-
extension ReviewListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.reviewArr.count == 0{
            //self.tableMsgLbl.isHidden = false
        }else{
           // self.tableMsgLbl.isHidden = true
        }
        return reviewArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewListCell") as! ReviewListCell
        if let authorName = self.reviewArr[indexPath.row].author{
           cell.authorName.text = authorName
        }
        if let reviewDescription = self.reviewArr[indexPath.row].text{
            cell.reviewDescription.text = reviewDescription
        }
        if let date = self.reviewArr[indexPath.row].date{
            cell.date.text = date
        }
        if let rating = self.reviewArr[indexPath.row].rating{
            cell.rating.rating = Double(rating)!
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
}
//MARK:- API calling:-
extension ReviewListViewController{
    func getReviewList(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"product/prd_wise_review"
        let param :[String:Any] = ["prd_id": self.productID!]
        ReviewViewModel.shared.getReviewList(apiName: apiName, param: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        if response.responseData!.count > 0{
                            self.reviewArr = response.responseData!
                            self.reviewTableView.reloadData()
                        }else{
                            self.reviewArr = []
                            self.reviewTableView.reloadData()
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
}
//MARK:- Success Callback for submit review:-
extension ReviewListViewController : SubmitReviewDelegate{
    func didSuccesReviewSubmit() {
        self.getReviewList()
    }
    
    
}
