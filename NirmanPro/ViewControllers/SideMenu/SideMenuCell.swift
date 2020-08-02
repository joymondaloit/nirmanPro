//
//  SideMenuCell.swift
//  NirmanPro
//
//  Created by Joy Mondal on 12/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {
    @IBOutlet weak var nameLbl : UILabel!
    @IBOutlet weak var img : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
