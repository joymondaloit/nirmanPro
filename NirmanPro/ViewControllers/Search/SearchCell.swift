//
//  SearchCell.swift
//  NirmanPro
//
//  Created by Joy Mondal on 21/09/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import Cosmos
class SearchCell: UICollectionViewCell {
    @IBOutlet weak var productImg : UIImageView!
    @IBOutlet weak var rating : CosmosView!
    @IBOutlet weak var productName : UILabel!
    @IBOutlet weak var actualPriceLbl : UILabel!
    @IBOutlet weak var specialPriceLbl : UILabel!
    @IBOutlet weak var addToCartBtn : UIButton!
    @IBOutlet weak var wislistBtn : UIButton!
    @IBOutlet weak var wishListImg : UIImageView!
    var searchData : CategoryResponseData?{
              didSet{
                 showData()
              }
          }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    func showData(){
           if let name = searchData?.productName{
               self.productName.text! = name
           }
          
           if let img = searchData!.productImage{
               Utils.loadImage(imageView: self.productImg, imageURL: img, placeHolderImage: "smallImgPlaceholder") { (image, error, catchetype, url) in
                   
               }
           }
           if let specialPrice = searchData?.productSpecialPrice{
               if specialPrice != ""{
                 self.actualPriceLbl.isHidden = false
                   if let actualPrice = searchData?.productPrice{
                       self.actualPriceLbl.attributedText = actualPrice.strikeThrough()
                   }
                   self.specialPriceLbl.text = specialPrice
               }else{
                   if let actualPrice = searchData?.productPrice{
                       self.specialPriceLbl.text = "₹\(actualPrice)"
                   }
                   self.actualPriceLbl.text = ""
                self.actualPriceLbl.isHidden = true
               }
           }
           if let rating = searchData?.productRating{
            self.rating.rating = Double(rating)!
           }
        if let isProductWishlisted = searchData!.isWishList{
            if isProductWishlisted == 1{
                self.wishListImg.image = UIImage.init(named: "heartFull")
            }else{
                self.wishListImg.image = UIImage.init(named: "heart-pop")
                
            }
        }
       }
}
