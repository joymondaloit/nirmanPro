//
//  SearchViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 19/09/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD
class SearchViewController: UIViewController {
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryView: UIViewX!
    @IBOutlet weak var subCategoryView: UIViewX!
    @IBOutlet weak var shortByView: UIViewX!
    @IBOutlet weak var categoryLbl: UILabel!
     @IBOutlet weak var subCategoryLbl: UILabel!
     @IBOutlet weak var filterLbl: UILabel!
    var searchText = ""
    var categoryName = ""
    var categoryID = ""
    var filterID = ""
    var searchItemArr = [CategoryResponseData]()
    var categoryListArr = [HomeCategoryResponseData]()
    var categoryNameArr = [String]()
     var subCategoryArr = [HomeCategoryResponseData]()
    var subCategoryNameArr = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTF.text! = self.searchText
        getSearchList(searchText: self.searchText)
        getCategoryList()
        if categoryID != ""{
            self.categoryLbl.text = self.categoryName
            self.getSubCategoryList()
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let trimmedText = searchTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedText.count > 0{
            self.getSearchList(searchText: trimmedText)
        }else{
            Utils.showAlert(alert: "", message: "Please enter some character for search", vc: self)
        }
    }
    
    @IBAction func categoryAction(_ sender: Any) {
        self.showDropDownWithCallback(itemArr: self.categoryNameArr, anchorView: self.categoryView) { (item,index)  in
            if item == "--None--"{
                self.categoryID  = ""
                self.categoryLbl.text = item
                self.subCategoryLbl.text = "SubCategory"
                self.getSearchList(searchText: self.searchTF.text!)
            }else{
                self.categoryLbl.text! = self.categoryListArr[index!].name!
                self.categoryID = self.categoryListArr[index!].id!
                self.getSearchList(searchText: self.searchTF.text!)
                self.subCategoryArr.removeAll()
                self.subCategoryNameArr.removeAll()
                self.getSubCategoryList()
            }
        }
    }
    @IBAction func subCategoryAction(_ sender: Any) {
        if self.categoryID != ""{
            self.showDropDownWithCallback(itemArr: self.subCategoryNameArr, anchorView: self.subCategoryView) { (item,index)  in
                if item == "--None--"{
                    self.subCategoryLbl.text! = "--None--"
                    self.categoryID = ""
                     self.getSearchList(searchText: self.searchTF.text!)
                }else{
                    self.subCategoryLbl.text! = self.subCategoryArr[index!].name!
                    self.categoryID = self.subCategoryArr[index!].id!
                    self.getSearchList(searchText: self.searchTF.text!)
                }
              
            }
        }else{
            Utils.showAlert(alert: "", message: "Please select some category first", vc: self)
        }
     
    }
    @IBAction func shortByAction(_ sender: Any) {
        let filterArr = ["A-Z","Z-A","Low-High","High-Low","Rating(High)","Rating(Low)","--None--"]
        self.showDropDownWithCallback(itemArr: filterArr, anchorView: self.shortByView) { (item, index) in
            switch item{
            case "A-Z":
                self.filterLbl.text = item
                self.filterID = "2"
                self.getSearchList(searchText: self.searchTF.text!)
                break
            case "Z-A":
                self.filterLbl.text = item
                self.filterID = "3"
                self.getSearchList(searchText: self.searchTF.text!)
                break
            case "Low-High":
                self.filterLbl.text = item
                self.filterID = "4"
                self.getSearchList(searchText: self.searchTF.text!)
                break
            case "High-Low":
                self.filterLbl.text = item
                self.filterID = "5"
                self.getSearchList(searchText: self.searchTF.text!)
                break
            case "Rating(High)":
                self.filterLbl.text = item
                self.filterID = "6"
                self.getSearchList(searchText: self.searchTF.text!)
                break
            case "Rating(Low)":
                self.filterLbl.text = item
                self.filterID = "7"
                self.getSearchList(searchText: self.searchTF.text!)
                break
            case "--None--":
                self.filterLbl.text = item
                self.filterID = "1"
                self.getSearchList(searchText: self.searchTF.text!)
                break
            default:
                self.filterID = "1"
                self.getSearchList(searchText: self.searchTF.text!)
                break
            }
        }
    }

       /**
        Method for DropDown Listing And selection:-
        */
       func showDropDownWithCallback(itemArr:[String],anchorView : UIView, completion :@escaping(String?,Int?)->()){
           let dropDown = DropDown()
           dropDown.backgroundColor = .darkGray
           dropDown.textColor = .white
           dropDown.direction = .bottom
           dropDown.anchorView = anchorView // UIView or UIBarButtonItem
           dropDown.dataSource = itemArr
           dropDown.show()
           dropDown.selectionAction = {(index: Int, item: String) in
               completion(item,index)
           }
       }
       /***
           Add To Cart Action
           */
          @objc func addToCartAction(sender : UIButton){
           if Utils.getUserID() != ""{
               Utils.showAlertWithCallback(alert: "", message: "Are you sure want to cart this item?", vc: self) {
                   guard let productID = self.searchItemArr[sender.tag].productId else {return}
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
                   if searchItemArr[sender.tag].isWishList! == 1{
                       message = "Remove from your wishlist?"
                   }else{
                       message = "Are you sure want to wishlist this item?"
                   }
                   Utils.showAlertWithCallback(alert: "", message: message, vc: self) {
                       guard let productID = self.searchItemArr[sender.tag].productId else {return}
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

//MARK:- TableView Delegates and data source
extension SearchViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchItemArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        cell.searchData = searchItemArr[indexPath.row]
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
        productVC.productID = searchItemArr[indexPath.row].productId
        self.navigationController?.pushViewController(productVC, animated: true)
    }
}
//MARK:- API Call
extension SearchViewController{
    func getSearchList(searchText : String){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"product/catgory_wise_product"
        let param :[String:Any] = ["category_id": self.categoryID,
                                   "text": searchText,
                                   "filter": filterID,
                                   "user_id": Utils.getUserID()]
        SearchViewModel.shared.getSearchItemList(apiName: apiName, param: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        if response.responseData!.count > 0{
                            self.searchItemArr = response.responseData!
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                                
                            }
                        }else{
                            self.searchItemArr = []
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                                
                            }
                        }
                    }else{
                        self.searchItemArr = []
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            
                        }
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
                            self.getSearchList(searchText: self.searchTF.text!)
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
           let param :[String:Any] = ["usreId":Utils.getUserID(),"productid" :productID,"quantity":1,"action_type" : 1,"product_option_value_id" : "0"]
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
    
    func getCategoryList(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"product/category"
        HomeViewModel.shared.getCategoryList(apiName: apiName, param: [:], vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
                self.getCategoryList()
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        if response.responseData!.count > 0{
                            self.categoryNameArr.removeAll()
                            self.categoryListArr = response.responseData!
                            for item in self.categoryListArr{
                                self.categoryNameArr.append(item.name!)
                            }
                            self.categoryNameArr.append("--None--")
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
    
    func getSubCategoryList(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"product/sub_category"
        let param:[String:Any] = ["category_id" : self.categoryID]
        HomeViewModel.shared.getCategoryList(apiName: apiName, param: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        if response.responseData!.count > 0{
                            self.subCategoryArr.removeAll()
                            self.subCategoryArr = response.responseData!
                            for item in self.subCategoryArr{
                                self.subCategoryNameArr.append(item.name!)
                            }
                            self.subCategoryNameArr.append("--None--")
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
}
