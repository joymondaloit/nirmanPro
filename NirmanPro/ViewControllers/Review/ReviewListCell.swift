//
//  ReviewListCell.swift
//  NirmanPro
//
//  Created by Joy Mondal on 26/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import Cosmos
class ReviewListCell: UITableViewCell {
    @IBOutlet weak var authorName : UILabel!
    @IBOutlet weak var reviewDescription : UILabel!
    @IBOutlet weak var date : UILabel!
    @IBOutlet weak var rating : CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
