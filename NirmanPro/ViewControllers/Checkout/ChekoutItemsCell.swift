//
//  ChekoutItemsCell.swift
//  NirmanPro
//
//  Created by Joy Mondal on 15/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit

class ChekoutItemsCell: UITableViewCell {
    @IBOutlet weak var productImg : UIImageView!
    @IBOutlet weak var actualPrice : UILabel!
    @IBOutlet weak var mrpPrice : UILabel!
    @IBOutlet weak var productDescription : UILabel!
    @IBOutlet weak var productName : UILabel!
    @IBOutlet weak var itemCountLbl : UILabel!
    @IBOutlet weak var deleteItemBtn : UIButton!
    @IBOutlet weak var minusItemBtn : UIButton!
    @IBOutlet weak var plusItemBtn : UIButton!
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
