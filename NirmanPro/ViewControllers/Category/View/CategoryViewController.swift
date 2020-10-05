//
//  CategoryViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 13/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
class CategoryViewController: UIViewController {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    var categoryArr = [HomeCategoryResponseData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCategoryList()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }


}

extension CategoryViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.categoryImg.layer.cornerRadius = cell.categoryImg.frame.height/2
        if let img = categoryArr[indexPath.row].image{
            Utils.loadImage(imageView: cell.categoryImg, imageURL: img, placeHolderImage: PlaceHolderImg) { (image, error, catheType, url) in}
            
        }
        if let name = categoryArr[indexPath.row].name{
            cell.categoryLbl.text = name
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: CGFloat((collectionView.frame.size.width / 2)), height: CGFloat(165))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let isSubcategory = categoryArr[indexPath.row].isSubcategory{
            if isSubcategory == 1{
                let subCategoryVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
                subCategoryVC.categoryID = categoryArr[indexPath.row].id
                self.navigationController?.pushViewController(subCategoryVC, animated: true)
            }else{
                let categoryVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryWiseProductViewController") as! CategoryWiseProductViewController
                categoryVC.categoryID = categoryArr[indexPath.row].id
                categoryVC.categoryName = categoryArr[indexPath.row].name!
                self.navigationController?.pushViewController(categoryVC, animated: true)
            }
        }else{
            let categoryVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryWiseProductViewController") as! CategoryWiseProductViewController
            categoryVC.categoryID = categoryArr[indexPath.row].id
            categoryVC.categoryName = categoryArr[indexPath.row].name!
            self.navigationController?.pushViewController(categoryVC, animated: true)
        }
     
    }
}

//MARK:- API Call
extension CategoryViewController{
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
                            self.categoryArr.removeAll()
                            self.categoryArr = response.responseData!
                            self.categoryCollectionView.reloadData()
                           
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
}
