//
//  ProductImgesCell.swift
//  NirmanPro
//
//  Created by Joy Mondal on 29/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit

class ProductImgesCell: UICollectionViewCell {
    @IBOutlet weak var productImg : UIImageView!
    override func awakeFromNib() {
          super.awakeFromNib()
          // Initialization code
          self.productImg.layer.cornerRadius = 10
      }
}
