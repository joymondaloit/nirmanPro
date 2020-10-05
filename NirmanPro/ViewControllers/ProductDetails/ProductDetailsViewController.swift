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

    @IBOutlet weak var atributeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var productImgCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var colorCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var releatedColectionHeight: NSLayoutConstraint!
    @IBOutlet weak var releateProductsView: UIView!
    @IBOutlet weak var atributeView: UIView!
    @IBOutlet weak var productDescriptionTableHeight: NSLayoutConstraint!
    @IBOutlet weak var compatibilityCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var productDetailsView: UIView!
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
    @IBOutlet weak var releatedProductCollectionView: UICollectionView!
    @IBOutlet weak var wishlistImg: UIImageView!
    @IBOutlet weak var wishlistLbl: UILabel!
    @IBOutlet weak var productCompatibilityCollectionView: UICollectionView!
    @IBOutlet weak var productDesriptionTableView: UITableView!
    var relatedProductsArr = [ProductDetailsRelatedProduct]()
    var productImgArr = [ProductDetailsProductImage]()
    var totalQuantity = 1
    var productID : String?
    var customerID : String?
    var reviewArr = [ProductDetailsProductReview]()
    var compatibilityArr = [ProductDetailsProductAttributeList]()
    var productDescriptionArr = [ProductDetailsProductAttributeList]()
    var colorVariantArr = [ProductDetailsColorVariant]()
    var selectedColourIndex = -1
    var colorSelectID = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Utils.getUserID() == ""{
            customerID = "0"
        }else{
            customerID = Utils.getUserID()
        }
         self.productDesriptionTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        getProductDetails()
        // Do any additional setup after loading the view.
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        productDesriptionTableView.layer.removeAllAnimations()
        productDescriptionTableHeight.constant = productDesriptionTableView.contentSize.height
        self.atributeViewHeight.constant = productDescriptionTableHeight.constant + 200
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }

    }
    override func viewDidLayoutSubviews() {
        self.productImgCollectionView.layer.cornerRadius = 10
           self.productDesriptionTableView.rowHeight = UITableView.automaticDimension
           self.productDesriptionTableView.estimatedRowHeight = 2000
          
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
        guard let PRODUCT_ID = self.productID else {
            return
        }
        let reviewListVC = STORYBOARD.instantiateViewController(withIdentifier: "ReviewListViewController") as! ReviewListViewController
        reviewListVC.productID = PRODUCT_ID
        self.navigationController?.pushViewController(reviewListVC, animated: true)
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
                self.releatedProductAddToCart(productID: productID, quantity: self.totalQuantity, actionType: 1)
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
        }else if collectionView == releatedProductCollectionView{
            return relatedProductsArr.count
        }
        else if collectionView == productCompatibilityCollectionView{
            return compatibilityArr.count
        }
        else{
            return colorVariantArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if collectionView == self.productImgCollectionView{
          let imgCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImgesCell", for: indexPath) as! ProductImgesCell
            if let imgeUrl = productImgArr[indexPath.row].image{
                imgCell.productImg.sd_setImage(with: URL(string: imgeUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: PlaceHolderImg), options: .refreshCached) { (image, error, catcheType, imgURL) in
                                 
                             }
            }
            cell = imgCell
        }else if collectionView == releatedProductCollectionView{
            let relatedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedProductsItemCell", for: indexPath) as! RelatedProductsItemCell
            let data = relatedProductsArr[indexPath.row]

            if let imgUrl = data.productImage{
                relatedCell.productImg.sd_setImage(with: URL(string: imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: PlaceHolderImg), options: .refreshCached) { (image, error, catcheType, imgURL) in
                    
                }
            }
            if let name = data.productName{
                relatedCell.productName.text! = name
                
            }
            if let rating = data.productRating{
                relatedCell.rating.rating = Double(rating)!
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
        else if collectionView == productCompatibilityCollectionView{
            let compatibilityCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCompatibilityCell", for: indexPath) as! ProductCompatibilityCell
            if let name = compatibilityArr[indexPath.row].attrText{
                compatibilityCell.compatibilityName.text = name
            }
            cell = compatibilityCell
        }else{
           let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
            colorCell.colorView.backgroundColor = Utils.hexStringToUIColor(hex: self.colorVariantArr[indexPath.row].code!)
            if selectedColourIndex == indexPath.row{
                colorCell.colorView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                colorCell.colorView.layer.borderWidth = 2
            }else{
                colorCell.colorView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                colorCell.colorView.layer.borderWidth = 0
            }
            cell = colorCell
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productImgCollectionView{
            let height = collectionView.frame.size.height
            let width = collectionView.frame.size.width/4
            return CGSize(width: CGFloat(width), height: CGFloat(height))
        }
        else if collectionView == releatedProductCollectionView{
            let height = collectionView.frame.size.height
            let width = collectionView.frame.size.width/2
            return CGSize(width: CGFloat(width), height: CGFloat(height))
        }else if collectionView == productCompatibilityCollectionView{
            let height = collectionView.frame.size.height
            let width = collectionView.frame.size.width/3
            return CGSize(width: CGFloat(width), height: CGFloat(height))
        }else{
          return CGSize(width: CGFloat(40), height: CGFloat(40))
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colorCollectionView{
            self.selectedColourIndex = indexPath.row
            self.colorSelectID = self.colorVariantArr[indexPath.row].productOptionValueId!
            self.colorCollectionView.reloadData()
        }
    }
    
}

//MARK:- TableView Delegate And DataSource
extension ProductDetailsViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productDescriptionArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDescriptionCell") as! ProductDescriptionCell
        if let atributeName = productDescriptionArr[indexPath.row].attrName{
           cell.descriptionName.text = atributeName
        }
        if let atributeValue = productDescriptionArr[indexPath.row].attrText{
           cell.descriptionValue.text = atributeValue
        }
        return cell
    }
    
    
}
//MARK:- API call
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
                            }else{
                                self.productImgCollectionHeight.constant = 0
                            }
                            if let reviewArr = response.responseData![0].productReview{
                                if reviewArr.count > 0{
                                    self.reviewArr = reviewArr
                                }else{
                                    self.reviewArr = []
                                }
                            }
                            if response.responseData![0].relatedProduct!.count > 0{
                                self.relatedProductsArr = response.responseData![0].relatedProduct!
                            }else{
                                self.releateProductsView.isHidden = true
                                self.releatedColectionHeight.constant = 0
                                self.releateProductsView.frame.size.height = 0
                            }
                            let data = response.responseData![0]
                            if let colorArr = data.colorVariant{
                                if colorArr.count > 0{
                                    self.colorVariantArr = colorArr
                                    self.colorCollectionView.reloadData()
                                }else{
                                    //No color variant
                                    self.colorView.isHidden = true
                                    self.colorCollectionHeight.constant = 0
                                }
                            }
                            if let attributeArr = data.productAttributeList{
                                if attributeArr.count > 0{
                                    for item in attributeArr{
                                        if item.attrName!.contains("Compatibility"){
                                            self.compatibilityArr.append(item)
                                            }else{
                                            self.productDescriptionArr.append(item)
                                        }
                                    }
                                    self.productCompatibilityCollectionView.reloadData()
                                    self.productDesriptionTableView.reloadData()
                                }else{
                                    DispatchQueue.main.async {
                                        self.atributeView.isHidden = true
                                        self.atributeViewHeight.constant = 0
                                        self.view.layoutIfNeeded()
                                    }
                                  
                                }
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
            self.productImage.sd_setImage(with: URL(string: productImg.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: PlaceHolderImg), options: .refreshCached) { (image, error, catcheType, imgURL) in
                              
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
                self.actualPrice.isHidden = false
                if let actualPrice = data.productPrice{
                    self.actualPrice.attributedText = actualPrice.strikeThrough()
                }
                self.offerPrice.text = specialPrice
            }else{
                if let actualPrice = data.productPrice{
                    self.offerPrice.text = "₹\(actualPrice)"
                }
                self.actualPrice.isHidden = true
                self.actualPrice.text = ""
            }
        }
        if let rating = data.productRating{
            self.ratingView.rating = Double(rating)!
        }
        if let reviewArr = data.productReview{
            self.ratingCountLbl.text = "(\(reviewArr.count) review)"
        }
     
        if let isProductWishlisted = data.productWishlist{
            if isProductWishlisted == 1{
                self.wishlistLbl.text = "Remove from wishlist"
                self.wishlistImg.image = UIImage.init(named: "heartFull")
            }else{
                self.wishlistImg.image = UIImage.init(named: "heart-pop")
                self.wishlistLbl.text = "Add to wishlist"
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
        let param :[String:Any] = ["usreId":Utils.getUserID(),"productid" :productID,"quantity":quantity,"action_type" : actionType,"product_option_value_id" : self.colorSelectID]
           AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: self) { (response, error) in
               SVProgressHUD.dismiss()
               if let error = error{
                   Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
               }else{
                   if let response = response{
                       if response["responseCode"] as! Int == 1{
                        Utils.showAlertWithCallbackOneAction(alert: "", message: response["responseText"] as! String, vc: self, completion: {
                            let cartListVC = STORYBOARD.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
                            self.navigationController?.pushViewController(cartListVC, animated: true)
                        })
                       }else{
                           Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
                       }
                   }
               }
           }
       }
    func releatedProductAddToCart(productID : String,quantity: Int,actionType: Int){
           SVProgressHUD.show()
           let apiName = DEV_BASE_URL+"cart/add_to_cart"
        let param :[String:Any] = ["usreId":Utils.getUserID(),"productid" :productID,"quantity":quantity,"action_type" : actionType,"product_option_value_id" : "0"]
           AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: self) { (response, error) in
               SVProgressHUD.dismiss()
               if let error = error{
                   Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
               }else{
                   if let response = response{
                       if response["responseCode"] as! Int == 1{
                        Utils.showAlertWithCallbackOneAction(alert: "", message: response["responseText"] as! String, vc: self, completion: {
                            let cartListVC = STORYBOARD.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
                            self.navigationController?.pushViewController(cartListVC, animated: true)

                        })
                       }else{
                           Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
                       }
                   }
               }
           }
       }
}
