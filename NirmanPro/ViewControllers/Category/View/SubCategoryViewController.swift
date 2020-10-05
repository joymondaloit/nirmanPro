//
//  SubCategoryViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 18/09/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
class SubCategoryViewController: UIViewController {
    @IBOutlet weak var subCategoryCollectionView: UICollectionView!
    var subCategoryArr = [HomeCategoryResponseData]()
    var categoryID : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        getSubCategoryList()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension SubCategoryViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subCategoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCell", for: indexPath) as! SubCategoryCell
        cell.subCategoryImg.layer.cornerRadius = cell.subCategoryImg.frame.height/2
        if let img = subCategoryArr[indexPath.row].image{
            Utils.loadImage(imageView: cell.subCategoryImg, imageURL: img, placeHolderImage: PlaceHolderImg) { (image, error, catheType, url) in}
            
        }
        if let name = subCategoryArr[indexPath.row].name{
            cell.subCategoryLbl.text = name
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: CGFloat((collectionView.frame.size.width / 2)), height: CGFloat(165))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryWiseProductViewController") as! CategoryWiseProductViewController
        categoryVC.categoryID = subCategoryArr[indexPath.row].id
        categoryVC.categoryName = subCategoryArr[indexPath.row].name!
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
}
//MARK:- API Call
extension SubCategoryViewController{
    func getSubCategoryList(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"product/sub_category"
        let param:[String:Any] = ["category_id" : self.categoryID!]
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
                            self.subCategoryCollectionView.reloadData()
                           
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
}
