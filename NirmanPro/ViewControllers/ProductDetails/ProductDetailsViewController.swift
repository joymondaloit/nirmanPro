//
//  ProductDetailsViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 22/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import Cosmos
import SVProgressHUD
class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var productImage: UIImageViewX!
    @IBOutlet weak var productImgCollectionView: UICollectionView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ratingCountLbl: UILabel!
    @IBOutlet weak var actualPrice: UILabel!
    @IBOutlet weak var offerPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productDescription1: UILabel!
    @IBOutlet weak var productCountLbl: UILabel!
    @IBOutlet weak var tileSizeLbl: UILabel!
    @IBOutlet weak var avgWaitPerCartoon: UILabel!
    @IBOutlet weak var releatedProductCollectionView: UICollectionView!
     @IBOutlet weak var wishlistImg: UIImageView!
    var relatedProductsArr = [ProductDetailsRelatedProduct]()
    var productImgArr = [ProductDetailsProductImage]()
    var totalQuantity = 1
    var productID : String?
    var customerID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Utils.getUserID() == ""{
            customerID = "0"
        }else{
            customerID = Utils.getUserID()
        }
        getProductDetails()
        // Do any additional setup after loading the view.
    }

//MARK:- @IBActions:-
    
    @IBAction func itemMinusAction(_ sender: Any) {
        if totalQuantity != 1{
            self.totalQuantity = self.totalQuantity - 1
            if totalQuantity < 10{
              self.productCountLbl.text = "0\(self.totalQuantity)"
            }else{
               self.productCountLbl.text = "\(self.totalQuantity)"
            }
            
        }
    }
    @IBAction func itemPlusAction(_ sender: Any) {
        self.totalQuantity = self.totalQuantity + 1
        if totalQuantity < 10{
            self.productCountLbl.text = "0\(self.totalQuantity)"
        }else{
            self.productCountLbl.text = "\(self.totalQuantity)"
        }
    }
    @IBAction func writeReviewBtnAction(_ sender: Any) {
    }
    
    @IBAction func productDescriptionBtnAction(_ sender: Any) {
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
       }
    @IBAction func addToCartAction(_ sender: Any) {
        if Utils.getUserID() != ""{
            self.addToCart(productID: self.productID!, quantity: self.totalQuantity, actionType: 1)
        }else{
            Utils.showAlertWithCallbackOneAction(alert: "", message: "Please Login to continue", vc: self) {
                let loginVC = STORYBOARD.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        }
    }
    @IBAction func addToWishlistAction(_ sender: Any) {
        if Utils.getUserID() != ""{
            self.addToWishlist(productID: self.productID!)
        }else{
            Utils.showAlertWithCallbackOneAction(alert: "", message: "Please Login to continue", vc: self) {
                let loginVC = STORYBOARD.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        }
    }
    /***
      Add To Cart Action
      */
     @objc func relatedProductAddToWishlistAction(sender : UIButton){
        if Utils.getUserID() != ""{
            var message = ""
            if relatedProductsArr[sender.tag].productWishlist! == 1{
                message = "Remove from your wishlist?"
            }else{
                message = "Are you sure want to wishlist this item?"
            }
            Utils.showAlertWithCallback(alert: "", message: message, vc: self) {
                guard let productID = self.relatedProductsArr[sender.tag].productId else {return}
                self.addToWishlist(productID: productID)
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
       @objc func relatedProductAddToCartAction(sender : UIButton){
        if Utils.getUserID() != ""{
            Utils.showAlertWithCallback(alert: "", message: "Are you sure want to cart this item?", vc: self) {
                guard let productID = self.relatedProductsArr[sender.tag].productId else {return}
                self.addToCart(productID: productID, quantity: self.totalQuantity, actionType: 1)
            }
        }else{
            Utils.showAlertWithCallbackOneAction(alert: "", message: "Please Login to continue", vc: self) {
                let loginVC = STORYBOARD.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(loginVC, animated: true)
                
            }
            
        }
       
        
       }
}
extension ProductDetailsViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.productImgCollectionView{
            return productImgArr.count
        }else{
            return relatedProductsArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if collectionView == self.productImgCollectionView{
          let imgCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImgesCell", for: indexPath) as! ProductImgesCell
            if let imgeUrl = productImgArr[indexPath.row].image{
                imgCell.productImg.sd_setImage(with: URL(string: imgeUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: "userPlaceholderImg"), options: .refreshCached) { (image, error, catcheType, imgURL) in
                                 
                             }
            }
            cell = imgCell
        }else{
            let relatedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedProductsItemCell", for: indexPath) as! RelatedProductsItemCell
            let data = relatedProductsArr[indexPath.row]

            if let imgUrl = data.productImage{
                relatedCell.productImg.sd_setImage(with: URL(string: imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: "userPlaceholderImg"), options: .refreshCached) { (image, error, catcheType, imgURL) in
                    
                }
            }
            if let name = data.productName{
                relatedCell.productName.text! = name
                
            }
            if let rating = data.productRating{
                relatedCell.rating.rating = Double(rating)
            }
            if let specialPrice = data.productSpecialPrice{
                if specialPrice != ""{
                    relatedCell.actualPriceLbl.isHidden = false
                    if let actualPrice = data.productPrice{
                        relatedCell.actualPriceLbl.attributedText = actualPrice.strikeThrough()
                    }
                    relatedCell.specialPriceLbl.text = specialPrice
                }else{
                    if let actualPrice = data.productPrice{
                        relatedCell.specialPriceLbl.text = "₹\(actualPrice)"
                    }
                    relatedCell.actualPriceLbl.isHidden = true
                    relatedCell.actualPriceLbl.text = ""
                }
            }
            if let isProductWishlisted = data.productWishlist{
                if isProductWishlisted == 1{
                    relatedCell.wislistImg.image = UIImage.init(named: "heartFull")
                }else{
                    relatedCell.wislistImg.image = UIImage.init(named: "heart-pop")
                    
                }
            }
            relatedCell.addToCartBtn.tag = indexPath.row
            relatedCell.wislistBtn.tag = indexPath.row
            relatedCell.wislistBtn.addTarget(self, action: #selector(relatedProductAddToWishlistAction), for: .touchUpInside)
            relatedCell.addToCartBtn.addTarget(self, action: #selector(relatedProductAddToCartAction), for: .touchUpInside)
            cell = relatedCell
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width/2
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    
}
extension ProductDetailsViewController{
    func getProductDetails(){
        SVProgressHUD.show()
        let api = DEV_BASE_URL+"product/product_details"
        let param :[String:Any] = ["product_id" : self.productID!,"customer_id": self.customerID!]
        ProductDetailsViewModel.shared.getProductDetails(apiName: api, param: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        if response.responseData?.count == 1{
                            self.showData(data: response.responseData![0])
                            if response.responseData![0].productImages!.count > 0{
                                self.productImgArr = response.responseData![0].productImages!
                            }
                            
                            if response.responseData![0].relatedProduct!.count > 0{
                                self.relatedProductsArr = response.responseData![0].relatedProduct!
                            }
                            self.productImgCollectionView.reloadData()
                            self.releatedProductCollectionView.reloadData()
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
    func showData(data : ProductDetailsResponseData){
        if let productImg = data.productImage{
            self.productImage.sd_setImage(with: URL(string: productImg.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: "userPlaceholderImg"), options: .refreshCached) { (image, error, catcheType, imgURL) in
                              
                          }
        }
        if let productName = data.productName{
            self.productName.text = productName
        }
        if let description =  data.productDescription{
            self.productDescription.text = description
            self.productDescription1.text = description

        }
        
        if let specialPrice = data.productSpecialPrice{
            if specialPrice != ""{
                if let actualPrice = data.productPrice{
                    self.actualPrice.attributedText = actualPrice.strikeThrough()
                }
                self.offerPrice.text = specialPrice
            }else{
                if let actualPrice = data.productPrice{
                    self.offerPrice.text = "₹\(actualPrice)"
                }
                self.actualPrice.text = ""
            }
        }
        if let rating = data.productRating{
            self.ratingView.rating = Double(rating)
        }
        if let reviewCount = data.productReview{
            self.ratingCountLbl.text = "(\(reviewCount) review)"
        }
        if let productWeight = data.productWeight{
            self.avgWaitPerCartoon.text = productWeight
        }
        if let size = data.productSize{
            self.tileSizeLbl.text = size
        }
        if let isProductWishlisted = data.productWishlist{
            if isProductWishlisted == 1{
                self.wishlistImg.image = UIImage.init(named: "heartFull")
            }else{
                self.wishlistImg.image = UIImage.init(named: "heart-pop")
                
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
                            self.getProductDetails()
                            
                        })
                    }else{
                        Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
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
                        Utils.showAlertWithCallbackOneAction(alert: "", message: response["responseText"] as! String, vc: self, completion: {
                            
                        })
                       }else{
                           Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
                       }
                   }
               }
           }
       }
}
