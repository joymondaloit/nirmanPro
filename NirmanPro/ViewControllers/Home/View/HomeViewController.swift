//
//  ViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 08/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import DropDown
var staticPageName = String()
class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var specialBannerLbl3: UILabel!
    @IBOutlet weak var specialBannerLbl2: UILabel!
    @IBOutlet weak var specialBannerLbl1: UILabel!
    @IBOutlet weak var specialBannerImg3: UIImageViewX!
    @IBOutlet weak var specialBannerImg2: UIImageViewX!
    @IBOutlet weak var specialBannerImg1: UIImageViewX!
    @IBOutlet weak var categoryDropdownView: UIViewX!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var notificationCountLbl: UILabelX!
    @IBOutlet weak var cartCountLbl: UILabelX!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    @IBOutlet weak var carouselPageControl: UIPageControl!
    @IBOutlet weak var newProducCollectionView: UICollectionView!
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    @IBOutlet weak var featuredProductCollectionView: UICollectionView!
    var carouselCollectionArr = [BannerResponseData]()
    var categoryListArr = [HomeCategoryResponseData]()
    var featuredProductList = [HomeFeaturedProductResponseData]()
    var brandListArr = [BrandsResponseData]()
    var newProductListArr = [NewProductResponseData]()
    var specialBannerListArr = [SpecialBannerResponseData]()
    var cartLisrArr = [CartItemsResponseData]()
    var categoryNameArr = [String]()
    var timer : Timer!
    var isCarouselLabelAnim = true
    var commingFromFeatureList : Bool?
    var customerID : String?
    var categoryID = ""
    var categoryName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.notificationCountLbl.layer.cornerRadius = 10.0
        self.cartCountLbl.layer.cornerRadius = 9.0
        if Utils.getUserID() == ""{
            customerID = "0"
        }else{
            customerID = Utils.getUserID()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(goToSelectedVC), name: Notification.Name(GoToVCNotificationKey), object: nil)
        if commingFromNotification {
            goToOrderDetails()
        }
        
      
        //Go to Selected Vc from Side Menu:-
        
        // Do any additional setup after loading the view.
    }
    
    func goToOrderDetails(){
        commingFromNotification = false
        let ordersVC = STORYBOARD.instantiateViewController(withIdentifier: "MyOrdersViewController") as! MyOrdersViewController
        self.navigationController?.pushViewController(ordersVC, animated: false)
        let orderDetailsVC = STORYBOARD.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
        orderDetailsVC.orderID = ORDER_ID
        self.navigationController?.pushViewController(orderDetailsVC, animated: false)
    }
    @objc func goToSelectedVC(notification : Notification){
        if let controller = notification.userInfo?["controller"] as? UIViewController{
            if self.isViewLoaded && (self.view.window != nil)
            {
                if controller.isKind(of: StaticPageViewController.self){
                    let con = controller as! StaticPageViewController
                    if staticPageName == "terms"{
                        con.headerTitle = "Terms And Condition"
                        con.pageID = 5
                    }
                    else if staticPageName == "aboutUs"{
                        con.headerTitle = "About Us"
                        con.pageID = 4
                    }
                    else if staticPageName == "privacyPolicy"{
                        con.headerTitle = "Privacy Policy"
                        con.pageID = 3
                    }
                    else if staticPageName == "contactUs"{
                        con.headerTitle = "Contact Us"
                        con.pageID = 7
                    }
                     self.navigationController?.pushViewController(con, animated: true)
                }else{
                  self.navigationController?.pushViewController(controller, animated: true)
                }
                
                // NotificationCenter.default.removeObserver(self, name: Notification.Name(GoToVCNotificationKey), object: nil)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getBannerList()
        self.getCategoryList()
        self.getFeaturedProductList()
        self.getBrandList()
        self.getNewProducts()
        self.getSpecialBannerList()
        self.getCartItems()
    }
    override func viewDidAppear(_ animated: Bool)
    {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(slideInNextImg), userInfo: nil, repeats: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    @objc func slideInNextImg() {
        let pageWidth:CGFloat = self.carouselCollectionView.frame.width
        let maxWidth:CGFloat = pageWidth * CGFloat(carouselCollectionArr.count)
        let contentOffset:CGFloat = self.carouselCollectionView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        if  contentOffset + pageWidth == maxWidth {
            slideToX = 0
            isCarouselLabelAnim = false
        }
        else
        {
            isCarouselLabelAnim = true
        }
        self.carouselCollectionView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.carouselCollectionView.frame.height), animated: true)
    }
    //MARK:- IBAction:->
    @IBAction func menuBtnAction(_ sender: Any) {
        drawerController.setDrawerState(.opened,animated: true)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let trimmedTF = searchTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedTF.count > 0{
            let searchVC = STORYBOARD.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
            searchVC.categoryID = self.categoryID
            searchVC.searchText = self.searchTF.text!
            searchVC.categoryName = self.categoryName
            self.navigationController?.pushViewController(searchVC, animated: true)
        }else{
            Utils.showAlert(alert: "", message: "Please enter some character for search", vc: self)
        }
        
    }
    @IBAction func goToCartAction(_ sender: Any) {
        let cartVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
    @IBAction func goToNotificationAction(_ sender: Any) {
        let notificationVC = STORYBOARD.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    @IBAction func categoryDropdown(_ sender: Any) {
        self.showDropDownWithCallback(itemArr: self.categoryNameArr, anchorView: self.categoryDropdownView) { (item,index)  in
            self.categoryLbl.text! = self.categoryListArr[index!].name!
            self.categoryID = self.categoryListArr[index!].id!
            self.categoryName = self.categoryListArr[index!].name!
        }
    }
    /***
     Add To Cart Action
     */
    @objc func addToCartAction(sender : UIButton){
        if Utils.getUserID() != ""{
            Utils.showAlertWithCallback(alert: "", message: "Are you sure want to cart this item?", vc: self) {
                guard let productID = self.featuredProductList[sender.tag].productId else {return}
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
            self.commingFromFeatureList = true
            var message = ""
            if featuredProductList[sender.tag].productWishlist! == 1{
                message = "Remove from your wishlist?"
            }else{
                message = "Are you sure want to wishlist this item?"
            }
            Utils.showAlertWithCallback(alert: "", message: message, vc: self) {
                guard let productID = self.featuredProductList[sender.tag].productId else {return}
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
     Add To Cart Action for new Product
     */
    @objc func newProductAddToCartAction(sender : UIButton){
        if Utils.getUserID() != ""{
            Utils.showAlertWithCallback(alert: "", message: "Are you sure want to cart this item?", vc: self) {
                guard let productID = self.newProductListArr[sender.tag].productId else {return}
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
    @objc func newProductAddToWishlistAction(sender : UIButton){
        if Utils.getUserID() != ""{
            self.commingFromFeatureList = false
            var message = ""
            if newProductListArr[sender.tag].productWishlist! == 1{
                message = "Remove from your wishlist?"
            }else{
                message = "Are you sure want to wishlist this item?"
            }
            Utils.showAlertWithCallback(alert: "", message: message, vc: self) {
                guard let productID = self.newProductListArr[sender.tag].productId else {return}
                self.addToWishlist(productID: productID)
            }
        }else{
            Utils.showAlertWithCallbackOneAction(alert: "", message: "Please Login to continue", vc: self) {
                let loginVC = STORYBOARD.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(loginVC, animated: true)
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
    
    @IBAction func shopNow1Action(_ sender: Any) {
//        let productVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
//        productVC.productID = specialBannerListArr[0].id
//        self.navigationController?.pushViewController(productVC, animated: true)
    }
    
    @IBAction func shopNow2Action(_ sender: Any) {
//        let productVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
//        productVC.productID = specialBannerListArr[1].id
//        self.navigationController?.pushViewController(productVC, animated: true)
    }
    @IBAction func shopNow3Action(_ sender: Any) {
//        let productVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
//        productVC.productID = specialBannerListArr[2].id
//        self.navigationController?.pushViewController(productVC, animated: true)
    }
    
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == carouselCollectionView
        {
            return carouselCollectionArr.count
        }
        else if collectionView == categoryCollectionView{
            return self.categoryListArr.count
        }
        else if collectionView == featuredProductCollectionView{
            return self.featuredProductList.count
        }
        else if collectionView == newProducCollectionView{
            return newProductListArr.count
        }
        else if collectionView == brandsCollectionView{
            return brandListArr.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if collectionView == carouselCollectionView
        {
            let caraoselCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! CarouselCell
            if carouselCollectionArr.count > 0{
                carouselPageControl.currentPage = indexPath.row
                caraoselCell.textLbl.text! = carouselCollectionArr[indexPath.row].title!
                caraoselCell.textLbl1.text! = carouselCollectionArr[indexPath.row].descriptionField!
                if let imgUrl = carouselCollectionArr[indexPath.row].image{
                    caraoselCell.image.sd_setImage(with: URL(string: imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: PlaceHolderImg), options: .refreshCached) { (image, error, catcheType, imgURL) in
                        
                    }
                }
                
                
            }
            cell = caraoselCell
        }
        else if collectionView == categoryCollectionView{
            let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategaoryCell", for: indexPath) as! HomeCategaoryCell
            if indexPath.row % 2 != 0{
                categoryCell.containerView.backgroundColor = .red
                categoryCell.categoryLbl.textColor = .white
            }else{
                categoryCell.containerView.backgroundColor = .white
                categoryCell.categoryLbl.textColor = .black
            }
            if let img = categoryListArr[indexPath.row].image{
                Utils.loadImage(imageView: categoryCell.categoryImg, imageURL: img, placeHolderImage: PlaceHolderImg) { (image, error, catheType, url) in}
                
            }
            if let name = categoryListArr[indexPath.row].name{
                categoryCell.categoryLbl.text = name
            }
            cell = categoryCell
        }
        else if collectionView == featuredProductCollectionView{
            let data = featuredProductList[indexPath.row]
            let featuredCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFeaturedProductCell", for: indexPath) as! HomeFeaturedProductCell
            if let imgUrl = featuredProductList[indexPath.row].productImage{
                featuredCell.productImg.sd_setImage(with: URL(string: imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: PlaceHolderImg), options: .refreshCached) { (image, error, catcheType, imgURL) in
                    
                }
            }
            if let name = data.productName{
                featuredCell.productName.text! = name
                
            }
            if let rating = data.productRating{
                featuredCell.rating.rating = Double(rating)!
            }
            if let specialPrice = data.productSpecialPrice{
                if specialPrice != ""{
                    featuredCell.actualPriceLbl.isHidden = false
                    if let actualPrice = data.productPrice{
                        featuredCell.actualPriceLbl.attributedText = actualPrice.strikeThrough()
                    }
                    featuredCell.specialPriceLbl.text = specialPrice
                }else{
                    if let actualPrice = data.productPrice{
                        featuredCell.specialPriceLbl.text = "₹\(actualPrice)"
                    }
                    featuredCell.actualPriceLbl.isHidden = true
                    featuredCell.actualPriceLbl.text = ""
                }
            }
            if let isProductWishlisted = data.productWishlist{
                if isProductWishlisted == 1{
                    featuredCell.wishListImg.image = UIImage.init(named: "heartFull")
                }else{
                    featuredCell.wishListImg.image = UIImage.init(named: "heart-pop")
                    
                }
            }
            featuredCell.addToCartBtn.tag = indexPath.row
            featuredCell.wislistBtn.tag = indexPath.row
            featuredCell.wislistBtn.addTarget(self, action: #selector(addToWishlistAction), for: .touchUpInside)
            featuredCell.addToCartBtn.addTarget(self, action: #selector(addToCartAction), for: .touchUpInside)
            cell = featuredCell
        }
        else if collectionView == newProducCollectionView{
            let data = newProductListArr[indexPath.row]
            
            let newProductsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeNewProductCell", for: indexPath) as! HomeNewProductCell
            if let imgUrl = data.productImage{
                newProductsCell.productImg.sd_setImage(with: URL(string: imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: PlaceHolderImg), options: .refreshCached) { (image, error, catcheType, imgURL) in
                    
                }
            }
            if let name = data.productName{
                newProductsCell.productName.text! = name
                
            }
            if let rating = data.productRating{
                newProductsCell.rating.rating = Double(rating)!
            }
            if let specialPrice = data.productSpecialPrice{
                if specialPrice != ""{
                    newProductsCell.actualPriceLbl.isHidden = false
                    if let actualPrice = data.productPrice{
                        newProductsCell.actualPriceLbl.attributedText = actualPrice.strikeThrough()
                    }
                    newProductsCell.specialPriceLbl.text = specialPrice
                }else{
                    if let actualPrice = data.productPrice{
                        newProductsCell.specialPriceLbl.text = "₹\(actualPrice)"
                    }
                     newProductsCell.actualPriceLbl.isHidden = true
                    newProductsCell.actualPriceLbl.text = ""
                }
            }
            if let isProductWishlisted = data.productWishlist{
                if isProductWishlisted == 1{
                    newProductsCell.wishListImg.image = UIImage.init(named: "heartFull")
                }else{
                    newProductsCell.wishListImg.image = UIImage.init(named: "heart-pop")
                    
                }
            }
            newProductsCell.addToCartBtn.tag = indexPath.row
            newProductsCell.wislistBtn.tag = indexPath.row
            newProductsCell.wislistBtn.addTarget(self, action: #selector(newProductAddToWishlistAction), for: .touchUpInside)
            newProductsCell.addToCartBtn.addTarget(self, action: #selector(newProductAddToCartAction), for: .touchUpInside)
            cell = newProductsCell
        }
        else if collectionView == brandsCollectionView{
            let brandsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBrandCell", for: indexPath) as! HomeBrandCell
            
            if let imgUrl = brandListArr[indexPath.row].image{
                brandsCell.brandImg.sd_setImage(with: URL(string: imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: PlaceHolderImg), options: .refreshCached) { (image, error, catcheType, imgURL) in
                    
                }
            }
            cell = brandsCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == self.carouselCollectionView
        {
            let height = self.carouselCollectionView.frame.size.height
            let width = self.carouselCollectionView.frame.size.width
            // in case you you want the cell to be 100% of your Collection view
            return CGSize(width: width, height: height)
        }
        else if collectionView == self.categoryCollectionView{
            let height = self.categoryCollectionView.frame.size.height - 10
            let width = self.categoryCollectionView.frame.size.width / 3
            return CGSize(width: width, height: height)
            
        }
        else if collectionView == self.featuredProductCollectionView{
            let height = self.featuredProductCollectionView.frame.size.height
            let width = self.featuredProductCollectionView.frame.size.width / 2
            return CGSize(width: width, height: height)
            
        }
        else if collectionView == self.newProducCollectionView{
            let height = self.newProducCollectionView.frame.size.height
            let width = self.newProducCollectionView.frame.size.width / 2
            return CGSize(width: width, height: height)
            
        }
        else if collectionView == self.brandsCollectionView{
            let height = self.brandsCollectionView.frame.size.height
            let width = self.brandsCollectionView.frame.size.width / 3
            return CGSize(width: width, height: height)
            
        }
        
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView{
            let categoryVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryWiseProductViewController") as! CategoryWiseProductViewController
            categoryVC.categoryID = categoryListArr[indexPath.row].id
            categoryVC.categoryName = categoryListArr[indexPath.row].name!
            self.navigationController?.pushViewController(categoryVC, animated: true)
        }
        else if collectionView == featuredProductCollectionView{
            let productVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            productVC.productID = featuredProductList[indexPath.row].productId
            self.navigationController?.pushViewController(productVC, animated: true)
        }
        else if collectionView == newProducCollectionView{
            let productVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            productVC.productID = newProductListArr[indexPath.row].productId
            self.navigationController?.pushViewController(productVC, animated: true)
        }
    }
}

//MARK:- API call:-
extension HomeViewController {
    func getBannerList(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"customer/fetch_banner"
        HomeViewModel.shared.getBannerList(apiName: apiName, param:[:], vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
                self.getBannerList()
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        if response.responseData!.count > 0{
                            self.carouselCollectionArr = response.responseData!
                            self.carouselPageControl.numberOfPages = self.carouselCollectionArr.count
                            self.carouselCollectionView.reloadData()
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
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
                            self.categoryCollectionView.reloadData()
                            for item in self.categoryListArr{
                                self.categoryNameArr.append(item.name!)
                            }
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
    func getFeaturedProductList(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"product/featured_product"
        let param : [String:Any] = ["customer_id" : self.customerID!]
        HomeViewModel.shared.getFeatureProducts(apiName: apiName, param: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
                self.getFeaturedProductList()
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        if let notiCount = response.notificationCount{
                            self.notificationCountLbl.text = notiCount
                        }
                        if response.responseData!.count > 0{
                            self.featuredProductList = response.responseData!
                            self.featuredProductCollectionView.reloadData()
                            
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
    
    func getBrandList(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"product/brand_list"
        HomeViewModel.shared.getBrandsList(apiName: apiName, param: [:], vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
                self.getBrandList()
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        if response.responseData!.count > 0{
                            self.brandListArr = response.responseData!
                            self.brandsCollectionView.reloadData()
                            
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
    
    func getNewProducts(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"product/new_product"
        let param : [String:Any] = ["customer_id" : self.customerID!]
        HomeViewModel.shared.getNewProductList(apiName: apiName, param: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
                self.getNewProducts()
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        if response.responseData!.count > 0{
                            self.newProductListArr = response.responseData!
                            self.newProducCollectionView.reloadData()
                            
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
    func getSpecialBannerList(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"product/special_banner"
        HomeViewModel.shared.getSpecialBannerList(apiName: apiName, param: [:], vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
                self.getSpecialBannerList()
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        if response.responseData!.count >= 3{
                            self.specialBannerListArr = response.responseData!
                            self.showSpecialBannerData(data: self.specialBannerListArr)
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
    func showSpecialBannerData(data : [SpecialBannerResponseData]){
        if let bannerImg1 = data[0].image{
            self.specialBannerImg1.sd_setImage(with: URL(string: bannerImg1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: PlaceHolderImg), options: .refreshCached) { (image, error, catcheType, imgURL) in
                
            }
            
        }
        if let bannerImg2 = data[1].image{
            self.specialBannerImg2.sd_setImage(with: URL(string: bannerImg2.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: PlaceHolderImg), options: .refreshCached) { (image, error, catcheType, imgURL) in
                
            }
            
        }
        if let bannerImg3 = data[2].image{
            self.specialBannerImg3.sd_setImage(with: URL(string: bannerImg3.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: PlaceHolderImg), options: .refreshCached) { (image, error, catcheType, imgURL) in
                
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
                            if self.commingFromFeatureList!{
                                self.getFeaturedProductList()
                            }else{
                                self.getNewProducts()
                            }
                            
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
                            self.getCartItems()
                            
                        })
                    }else{
                        Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
                    }
                }
            }
        }
    }
    
    func getCartItems(){
        var userID = ""
        if Utils.getUserID() == ""{
            userID = "0"
        }else{
            userID = Utils.getUserID()
        }
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"cart/cart_list"
        let param : [String:Any] = ["usreId" : userID]
        MyCartViewModel.shared.getCartList(apiName: apiName, param: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        if let cartItems = response.responseData{
                            if cartItems.count != 0{
                                self.cartCountLbl.isHidden = false
                                self.cartCountLbl.text = "\(cartItems.count)"
                            }else{
                                self.cartCountLbl.isHidden = true
                            }
                        }
                    }else{
                       // Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
}
