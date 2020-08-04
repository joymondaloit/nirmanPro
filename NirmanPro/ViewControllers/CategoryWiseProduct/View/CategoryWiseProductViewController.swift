//
//  CategoryWiseProductViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 01/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
class CategoryWiseProductViewController: UIViewController {

    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryNameLbl: UILabel!
    var categoryID : String?
    var categoryArr = [CategoryResponseData]()
    var categoryName : String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.categoryNameLbl.text = categoryName!
        self.getdata()
    }


    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- Collection view delegate and dat source:-
extension CategoryWiseProductViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categoryArr.count == 0{
            self.messageLbl.isHidden = false
        }else
        {
            self.messageLbl.isHidden = true
        }
        return categoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryWiseProductCell", for: indexPath) as! CategoryWiseProductCell
        cell.categoryData = self.categoryArr[indexPath.row]
        cell.addToCartBtn.tag = indexPath.row
        cell.wislistBtn.tag = indexPath.row
        cell.wislistBtn.addTarget(self, action: #selector(addToWishlistAction), for: .touchUpInside)
        cell.addToCartBtn.addTarget(self, action: #selector(addToCartAction), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 2
        let height = 286
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        productVC.productID = categoryArr[indexPath.row].productId
        self.navigationController?.pushViewController(productVC, animated: true)
    }

}
//MARK:- Api Call
extension CategoryWiseProductViewController{
    func getdata(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"product/category_wise_product"
        var customerID = ""
        if Utils.getUserID() == ""{
            customerID = "0"
        }else{
            customerID = Utils.getUserID()
        }
        let param : [String:Any] = ["category_id":self.categoryID!,
        "customer_id":customerID]
        
        CategoryWiseProductViewModel.shared.getCategoryList(apiName: apiName, param: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        if response.responseData!.count > 0{
                            self.categoryArr = response.responseData!
                            DispatchQueue.main.async {
                                self.categoryCollectionView.reloadData()
                                
                            }
                        }else{
                            self.categoryArr = []
                            DispatchQueue.main.async {
                                self.categoryCollectionView.reloadData()
                                
                            }
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
    
    func addToWishlist(productID : String){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"product/add_to_wishlist"
        let param :[String:Any] = ["user_id":Utils.getUserID(),"product_id" :productID]
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response["responseCode"] as! Int == 1{
                        Utils.showAlertWithCallbackOneAction(alert: "", message: response["responseText"] as! String, vc: self, completion: {
                            self.getdata()
                           })
                    }else{
                        Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
                    }
                }
            }
        }
    }
    func addToCart(productID : String){
           SVProgressHUD.show()
           let apiName = DEV_BASE_URL+"cart/add_to_cart"
        let param :[String:Any] = ["usreId":Utils.getUserID(),"productid" :productID,"quantity":1,"action_type" : 1]
           AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: self) { (response, error) in
               SVProgressHUD.dismiss()
               if let error = error{
                   Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
               }else{
                   if let response = response{
                       if response["responseCode"] as! Int == 1{
                        Utils.showAlertWithCallbackOneAction(alert: "", message: response["responseText"] as! String, vc: self, completion: {
                            
                            
                        })
                       }else{
                           Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
                       }
                   }
               }
           }
       }
    
    /***
        Add To Cart Action
        */
       @objc func addToCartAction(sender : UIButton){
        if Utils.getUserID() != ""{
            Utils.showAlertWithCallback(alert: "", message: "Are you sure want to cart this item?", vc: self) {
                guard let productID = self.categoryArr[sender.tag].productId else {return}
                self.addToCart(productID: productID)
            }
        }else{
            Utils.showAlertWithCallbackOneAction(alert: "", message: "Please Login to continue", vc: self) {
                let loginVC = STORYBOARD.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        }
           
       }
       /***
          Add To Wishlist Action
          */
         @objc func addToWishlistAction(sender : UIButton){
            if Utils.getUserID() != ""{
                var message = ""
                if categoryArr[sender.tag].productWishlist! == 1{
                    message = "Remove from your wishlist?"
                }else{
                    message = "Are you sure want to wishlist this item?"
                }
                Utils.showAlertWithCallback(alert: "", message: message, vc: self) {
                    guard let productID = self.categoryArr[sender.tag].productId else {return}
                    self.addToWishlist(productID: productID)
                }
            }else{
                Utils.showAlertWithCallbackOneAction(alert: "", message: "Please Login to continue", vc: self) {
                    let loginVC = STORYBOARD.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    self.navigationController?.pushViewController(loginVC, animated: true)
                }
            }
        
         }

}
