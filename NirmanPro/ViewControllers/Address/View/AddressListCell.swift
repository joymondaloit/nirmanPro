//
//  AddressListCell.swift
//  NirmanPro
//
//  Created by Joy Mondal on 10/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit

class AddressListCell: UITableViewCell {

    @IBOutlet weak var nameLbl : UILabel!
    @IBOutlet weak var addressLbl : UILabel!
    @IBOutlet weak var companyLbl : UILabel!
    @IBOutlet weak var cityLbl : UILabel!
    @IBOutlet weak var stateLbl : UILabel!
    @IBOutlet weak var countryLbl : UILabel!
    @IBOutlet weak var postalCodeLbl : UILabel!
    @IBOutlet weak var defaultAddressBtn : UIButton!
    @IBOutlet weak var deleteAddressBtn : UIButton!
    @IBOutlet weak var editAddressBtn : UIButton!
    var addressData : AddressListResponseData!{
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
        if let firstName = addressData.firstname ,let lastName = addressData.lastname{
            self.nameLbl.text = firstName+" "+lastName
        }
        if let address = addressData.address1{
            if let address2 = addressData.address2{
                if address2 != ""{
                    self.addressLbl.text = address+" "+address2

                }else{
                    self.addressLbl.text = address
                }
            }else{
                self.addressLbl.text = address
            }
        }
        if let companyName = addressData.company{
            self.companyLbl.text = companyName
        }
        if let city = addressData.city{
            self.cityLbl.text = city
        }
        if let state = addressData.zone{
            self.stateLbl.text = state
        }
        if let country = addressData.country{
            self.countryLbl.text = country
        }
        if let postalCode = addressData.postcode{
            self.postalCodeLbl.text = postalCode
        }
        if let defaultAddress = addressData.defaultAddress{
            if defaultAddress == 0{
                self.defaultAddressBtn.isSelected = false
            }else{
                self.defaultAddressBtn.isSelected = true
            }
        }
    }
}
