//
//  CountryCell.swift
//  NirmanPro
//
//  Created by Joy Mondal on 13/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {
    @IBOutlet weak var countryName : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
