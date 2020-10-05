//
//  ProductDescriptionCell.swift
//  NirmanPro
//
//  Created by Joy Mondal on 03/10/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit

class ProductDescriptionCell: UITableViewCell {
    @IBOutlet weak var descriptionName : UILabel!
    @IBOutlet weak var descriptionValue : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
