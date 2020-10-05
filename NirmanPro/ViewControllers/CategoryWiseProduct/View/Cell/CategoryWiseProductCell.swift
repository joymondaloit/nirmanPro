//
//  CategoryWiseProductCell.swift
//  NirmanPro
//
//  Created by Joy Mondal on 01/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage
class CategoryWiseProductCell: UICollectionViewCell {
    @IBOutlet weak var productImg : UIImageView!
    @IBOutlet weak var rating : CosmosView!
    @IBOutlet weak var productName : UILabel!
    @IBOutlet weak var actualPriceLbl : UILabel!
    @IBOutlet weak var specialPriceLbl : UILabel!
    @IBOutlet weak var addToCartBtn : UIButton!
    @IBOutlet weak var wislistBtn : UIButton!
    @IBOutlet weak var wishListImg : UIImageView!
    var categoryData : CategoryResponseData?{
           didSet{
              showData()
           }
       }
    func showData(){
           if let name = categoryData?.productName{
               self.productName.text! = name
           }
          
           if let img = categoryData!.productImage{
               Utils.loadImage(imageView: self.productImg, imageURL: img, placeHolderImage: "smallImgPlaceholder") { (image, error, catchetype, url) in
                   
               }
           }
           if let specialPrice = categoryData?.productSpecialPrice{
               if specialPrice != ""{
                 self.actualPriceLbl.isHidden = false
                   if let actualPrice = categoryData?.productPrice{
                       self.actualPriceLbl.attributedText = actualPrice.strikeThrough()
                   }
                   self.specialPriceLbl.text = specialPrice
               }else{
                   if let actualPrice = categoryData?.productPrice{
                       self.specialPriceLbl.text = "₹\(actualPrice)"
                   }
                   self.actualPriceLbl.text = ""
                self.actualPriceLbl.isHidden = true
               }
           }
           if let rating = categoryData?.productRating{
            self.rating.rating = Double(rating)!
           }
        if let isProductWishlisted = categoryData!.productWishlist{
            if isProductWishlisted == 1{
                self.wishListImg.image = UIImage.init(named: "heartFull")
            }else{
                self.wishListImg.image = UIImage.init(named: "heart-pop")
                
            }
        }
       }
}
