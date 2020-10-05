//
//  StaticPageViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 04/09/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
class StaticPageViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    var headerTitle : String?
    var pageID : Int?
    @IBOutlet weak var contentTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLbl.text = headerTitle!
        getData()
        // Do any additional setup after loading the view.
    }
  

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension StaticPageViewController {
    func getData(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"customer/page_details"
        let param :[String:Any] = ["page_id" : self.pageID!]
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response["responseCode"] as! Int == 1{
                        if let data = response["responseData"] as? String{
                            self.contentTextView.text = data
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
                    }
                }
            }
        }
    }
}
