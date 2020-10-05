//
//  ReturnListCell.swift
//  NirmanPro
//
//  Created by Joy Mondal on 28/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit

class ReturnListCell: UITableViewCell {
    @IBOutlet weak var nameLbl : UILabel!
    @IBOutlet weak var dateLbl : UILabel!
    @IBOutlet weak var statusLbl : UILabel!
    @IBOutlet weak var orderIDLbl : UILabel!
    @IBOutlet weak var returnIDLbl : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
