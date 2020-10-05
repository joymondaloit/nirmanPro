//
//  ColorCell.swift
//  NirmanPro
//
//  Created by Joy Mondal on 03/10/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell {
    @IBOutlet weak var colorView : UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.colorView.layer.cornerRadius = self.colorView.frame.height/2
    }
}
