//
//  WishlistCell.swift
//  NirmanPro
//
//  Created by Joy Mondal on 20/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import Cosmos
class WishlistCell: UICollectionViewCell {
    @IBOutlet weak var productImg : UIImageView!
    @IBOutlet weak var productName : UILabel!
    @IBOutlet weak var productDescription : UILabel!
    @IBOutlet weak var ratingView : CosmosView!
    @IBOutlet weak var mrpPrice : UILabel!
    @IBOutlet weak var offerPrice : UILabel!
    @IBOutlet weak var addToCartBtn : UIButton!
    @IBOutlet weak var removeBtn : UIButton!
    var wishlistData : Wishlist?{
        didSet{
           showData()
        }
    }

    func showData(){
        if let name = wishlistData?.productName{
            self.productName.text! = name
        }
        if let description = wishlistData!.productDescription{
            self.productDescription.text! = description
        }
        if let img = wishlistData!.productImage{
            Utils.loadImage(imageView: self.productImg, imageURL: img, placeHolderImage: "smallImgPlaceholder") { (image, error, catchetype, url) in
                
            }
        }
        if let specialPrice = wishlistData?.productSpecialPrice{
            if specialPrice != ""{
                self.mrpPrice.isHidden = false
                if let actualPrice = wishlistData?.productPrice{
                    self.mrpPrice.attributedText = actualPrice.strikeThrough()
                }
                self.offerPrice.text = specialPrice
            }else{
                if let actualPrice = wishlistData?.productPrice{
                    self.offerPrice.text = "₹\(actualPrice)"
                }
                self.mrpPrice.isHidden = true
                self.mrpPrice.text = ""
            }
        }
        if let rating = wishlistData?.productRating{
            self.ratingView.rating = Double(rating)!
        }
        
    }
}
