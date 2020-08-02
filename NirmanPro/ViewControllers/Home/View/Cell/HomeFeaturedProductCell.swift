//
//  HomeFeaturedProductCell.swift
//  NirmanPro
//
//  Created by Joy Mondal on 09/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import Cosmos
class HomeFeaturedProductCell: UICollectionViewCell {
    @IBOutlet weak var productImg : UIImageView!
    @IBOutlet weak var rating : CosmosView!
    @IBOutlet weak var productName : UILabel!
    @IBOutlet weak var actualPriceLbl : UILabel!
    @IBOutlet weak var specialPriceLbl : UILabel!
    @IBOutlet weak var addToCartBtn : UIButton!
    @IBOutlet weak var wislistBtn : UIButton!
    @IBOutlet weak var wishListImg : UIImageView!
}
