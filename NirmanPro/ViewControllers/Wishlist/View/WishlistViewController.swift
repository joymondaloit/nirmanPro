//
//  WishlistViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 20/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
class WishlistViewController: UIViewController {

    @IBOutlet weak var wishlistCollectionView: UICollectionView!
    var wishlistArr = [Wishlist]()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(goToSelectedVC), name: Notification.Name(GoToVCNotificationKey), object: nil)
    
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getWishlist()
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

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /***
          Add To Wishlist Action
          */
         @objc func removeFromWishlistAction(sender : UIButton){
            Utils.showAlertWithCallback(alert: "", message: "Are you sure want to remove this item from your wishlist?", vc: self) {
            guard let productID = self.wishlistArr[sender.tag].productID else {return}
                self.removeFromWishlist(productID: productID)
             }
            
         }
      /***
        Add To Cart Action
        */
       @objc func addToCartAction(sender : UIButton){
           Utils.showAlertWithCallback(alert: "", message: "Are you sure want to cart this item?", vc: self) {
               guard let productID = self.wishlistArr[sender.tag].productID else {return}
            self.addToCart(productID: productID)
           }
       }
}
//MARK:- Collection view delegate and data source:-
extension WishlistViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishlistArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistCell", for: indexPath) as! WishlistCell
        cell.wishlistData = self.wishlistArr[indexPath.row]
        cell.addToCartBtn.tag = indexPath.row
        cell.removeBtn.tag = indexPath.row
        cell.removeBtn.addTarget(self, action: #selector(removeFromWishlistAction), for: .touchUpInside)
        cell.addToCartBtn.addTarget(self, action: #selector(addToCartAction), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 2
        let height = 305
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        productVC.productID = wishlistArr[indexPath.row].productID
        self.navigationController?.pushViewController(productVC, animated: true)
    }
}
//MARK:- Api Call
extension WishlistViewController{
    func getWishlist(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"product/all_wish_list"
        let param :[String:Any] = ["customerid" : Utils.getUserID()]
        WishlistViewModel.shared.getWishlist(apiName: apiName, param: param, vc: self) { (response, error) in
            if let error = error{
                SVProgressHUD.dismiss()
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                SVProgressHUD.dismiss()
                if let response = response{
                    if response.responseCode == 1{
                        if response.wishlist!.count > 0{
                            self.wishlistArr = response.wishlist!
                            self.wishlistCollectionView.reloadData()
                        }else{
                            self.wishlistArr = []
                            self.wishlistCollectionView.reloadData()
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
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
    
    func removeFromWishlist(productID : String){
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
                            self.getWishlist()
                            
                        })
                    }else{
                        Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
                    }
                }
            }
        }
    }
}
