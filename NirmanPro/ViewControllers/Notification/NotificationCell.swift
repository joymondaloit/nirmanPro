//
//  NotificationCell.swift
//  NirmanPro
//
//  Created by Joy Mondal on 30/09/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet weak var messageTypeLbl : UILabel!
    @IBOutlet weak var messageLbl : UILabel!
    @IBOutlet weak var dateLbl : UILabel!
    
    var data : NotificationResponseData!{
        didSet{
            showData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showData(){
        if let messageType = data.messageType{
            self.messageTypeLbl.text = messageType
        }
        if let message = data.message{
            self.messageLbl.text = message
        }
        if let date = data.createdAt{
            self.dateLbl.text = date
        }
    }
}
