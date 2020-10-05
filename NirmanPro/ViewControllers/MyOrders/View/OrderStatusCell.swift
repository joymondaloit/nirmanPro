//
//  OrderStatusCell.swift
//  NirmanPro
//
//  Created by Joy Mondal on 17/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit

class OrderStatusCell: UITableViewCell {
    
    @IBOutlet weak var upperLbl : UILabel!
    @IBOutlet weak var lowerLbl : UILabel!
    @IBOutlet weak var statusName : UILabel!
    @IBOutlet weak var orderDate : UILabel!
    @IBOutlet weak var statusView : UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.statusView.layer.cornerRadius = self.statusView.frame.size.height/2
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
