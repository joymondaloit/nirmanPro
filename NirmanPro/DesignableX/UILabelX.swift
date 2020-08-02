
import UIKit

@IBDesignable
class UILabelX: UILabel {

        @IBInspectable var DynamicFontSize: CGFloat = 0 {
            didSet {
                overrideFontSize(FontSize: DynamicFontSize)
            }
        }
        
        func overrideFontSize(FontSize: CGFloat){
            let fontName = self.font.fontName
            let screenWidth = UIScreen.main.bounds.size.width
            let calculatedFontSize = screenWidth / 375 * FontSize
            self.font = UIFont(name: fontName, size: calculatedFontSize)
        }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius == -1 ? self.frame.height/2 : cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var rotationAngle: CGFloat = 0 {
        didSet {
            self.transform = CGAffineTransform(rotationAngle: rotationAngle * .pi / 180)
        }
    }
    
    // MARK: - Shadow Text Properties
    
    @IBInspectable public var shadowOpacity: CGFloat = 0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    @IBInspectable public var shadowColorLayer: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColorLayer.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOffsetLayer: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            layer.shadowOffset = shadowOffsetLayer
        }
    }
}
