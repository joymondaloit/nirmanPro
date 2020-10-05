//
//  MyOrdersCell.swift
//  NirmanPro
//
//  Created by Joy Mondal on 17/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit

class MyOrdersCell: UITableViewCell {
    @IBOutlet weak var productName : UILabel!
    @IBOutlet weak var productImg : UIImageView!
    @IBOutlet weak var productOrderDate : UILabel!
    @IBOutlet weak var status : UILabel!
    @IBOutlet weak var totalItem : UILabel!
    @IBOutlet weak var totalPrice : UILabel!
    @IBOutlet weak var imgCountLbl : UILabel!
    var orderData : OrdersResponseData?{
        didSet{
            self.showData()
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
        if let productImage = orderData?.productImage{
            Utils.loadImage(imageView: self.productImg, imageURL: productImage, placeHolderImage: PlaceHolderImg) { (img, error, catcheType, url) in
                
            }
        }
        if let status = orderData?.statusName{
            self.status.text = status
        }
        if let orderDate = orderData?.orderDate{
            self.productOrderDate.text = orderDate
        }
        if let productName = orderData?.productName{
            self.productName.text! = productName
        }
        if let totalItem = orderData?.totalItem{
            let count = Int(totalItem)
            if count! > 1{
                self.imgCountLbl.isHidden = false
                self.imgCountLbl.text = "+\(count!-1) more"
            }else{
                self.imgCountLbl.isHidden = true
            }
            self.totalItem.text = totalItem
        }
        if let totalPrice = orderData?.ordTotal{
            self.totalPrice.text = "₹ \(totalPrice)"
        }
        
    }
}
