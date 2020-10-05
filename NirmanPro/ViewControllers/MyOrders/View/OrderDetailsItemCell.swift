//
//  OrderDetailsItemCell.swift
//  NirmanPro
//
//  Created by Joy Mondal on 17/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit

class OrderDetailsItemCell: UITableViewCell {
    @IBOutlet weak var productImg : UIImageView!
    @IBOutlet weak var productPrice : UILabel!
    @IBOutlet weak var productDescription : UILabel!
    @IBOutlet weak var productName : UILabel!
    @IBOutlet weak var quantityLbl : UILabel!
    @IBOutlet weak var returnBtn : UIButton!
    @IBOutlet weak var returnBtnView : UIView!
    @IBOutlet weak var colorView : UIView!
    @IBOutlet weak var colorViewHeight : NSLayoutConstraint!
    @IBOutlet weak var colorLbl : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
