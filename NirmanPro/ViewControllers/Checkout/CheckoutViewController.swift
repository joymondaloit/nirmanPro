//
//  CheckoutViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 15/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController {

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
     @IBOutlet weak var totalAmntLbl: UILabel!
    
    @IBOutlet weak var totalItems: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsTableView.rowHeight = UITableView.automaticDimension
        itemsTableView.estimatedRowHeight = 2000
        // Do any additional setup after loading the view.
    }

    @IBAction func applyCouponBtnAction(_ sender: Any) {
    }
    
    @IBAction func bilingAddressChangeAction(_ sender: Any) {
    }
    @IBAction func shipingAddressChangeAction(_ sender: Any) {
       }
    
    
    @IBAction func paymentMethodAction(_ sender: Any) {
        
    }
    
    @IBAction func placeOrderAction(_ sender: Any) {
        
    }
    
}

//MARK:- TableView Delegate and data source:-
extension CheckoutViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChekoutItemsCell") as! ChekoutItemsCell
        return cell
    }
    
    
}
