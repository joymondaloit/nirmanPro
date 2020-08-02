

import UIKit

@IBDesignable
@objc open class CustomizeableUITextField: UITextField {
    
    @IBInspectable var DynamicFontSize: CGFloat = 0 {
        didSet {
            overrideFontSize(FontSize: DynamicFontSize)
        }
    }
    
    func overrideFontSize(FontSize: CGFloat){
        let fontName = self.font!.fontName
        let screenWidth = UIScreen.main.bounds.size.width
        let calculatedFontSize = screenWidth / 375 * FontSize
        self.font = UIFont(name: fontName, size: calculatedFontSize)
    }
    
    fileprivate var bottomLineView : UIView?
    fileprivate var labelPlaceholder : UILabel?
    
    fileprivate var bottomLineViewHeight : NSLayoutConstraint?
    fileprivate var placeholderLabelHeight : NSLayoutConstraint?
    
    // Disable Floating Label when true.
    @IBInspectable open var disableFloatingLabel : Bool = false
    
    // Change Bottom Line Color.
    @IBInspectable open var lineColor : UIColor = UIColor.black {
        didSet{
            self.floatTheLabel()
        }
    }
    
    // Change line color when Editing in textfield
    @IBInspectable open var selectedLineColor : UIColor = UIColor(red: 19/256.0, green: 141/256.0, blue: 117/256.0, alpha: 1.0){
        didSet{
            self.floatTheLabel()
        }
    }
    
    // Change placeholder color.
    @IBInspectable open var placeHolderColor : UIColor = UIColor.lightGray {
        didSet{
            self.floatTheLabel()
        }
    }
    
    // Change placeholder color while editing.
    @IBInspectable open var selectedPlaceHolderColor : UIColor = UIColor(red: 19/256.0, green: 141/256.0, blue: 117/256.0, alpha: 1.0){
        didSet{
            self.floatTheLabel()
        }
    }
    
    //MARK:- Set Text
    override open var text:String?  {
        didSet {
            self.floatTheLabel()
        }
    }
    
    override open var placeholder: String? {
        willSet {
            if newValue != "" {
                self.labelPlaceholder?.text = newValue
            }
        }
    }
    
    // Set images in textfield
    @IBInspectable var leadingImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leadingPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rtl: Bool = false {
        didSet {
            updateView()
        }
    }
    
    // Provides left padding for images
    override open func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leadingPadding
        return textRect
    }
    
    // Provides right padding for images
    override open func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= leadingPadding
        return textRect
    }
    
    //MARK:- UITtextfield Draw Method Override
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        self.upadteTextField(frame: CGRect(x:self.frame.minX, y:self.frame.minY, width:rect.width, height:rect.height));
    }
    
    // MARK:- Loading From NIB
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    // MARK:- Intialization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initialize()
    }
    
    //MARK:- UITextfield Becomes First Responder
    override open func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        self.textFieldDidBeginEditing()
        return result
    }
    
    //MARK:- UITextfield Resigns Responder
    override open func resignFirstResponder() -> Bool {
        let result =  super.resignFirstResponder()
        self.textFieldDidEndEditing()
        return result
    }
}

fileprivate extension CustomizeableUITextField {
    
    //MARK:- FLoating Initialzation.
    func initialize() -> Void {
        self.clipsToBounds = false
        
        // Adding Bottom Line
        addBottomLine()
        
        // Placeholder Label Configuration.
        addFloatingLabel()
        
        updateView()
        
        // Checking Floatibility
        if self.text != nil && self.text != "" {
            self.floatTheLabel()
        }
    }
    
    func updateView() {
        rightViewMode = UITextField.ViewMode.never
        rightView = nil
        leftViewMode = UITextField.ViewMode.never
        leftView = nil
        
        if let image = leadingImage {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            
            let imageViewWrapper:UIView = {
                let view = UIView()
                view.frame = CGRect(x: 0, y: 0, width: 20, height: 10)
                
                return view
            }()
            imageViewWrapper.addSubview(imageView)
            
            if rtl {
                rightViewMode = UITextField.ViewMode.always
                rightView = imageViewWrapper
            } else {
                leftViewMode = UITextField.ViewMode.always
                leftView = imageViewWrapper
            }
        }
    }
    
    func addBottomLine(){
        if bottomLineView?.superview != nil {
            return
        }
        
        //Bottom Line UIView Configuration.
        bottomLineView = UIView()
        bottomLineView?.backgroundColor = lineColor
        bottomLineView?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomLineView!)
        
        let leadingConstraint = NSLayoutConstraint.init(item: bottomLineView!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint.init(item: bottomLineView!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint.init(item: bottomLineView!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        bottomLineViewHeight = NSLayoutConstraint.init(item: bottomLineView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
        
        self.addConstraints([leadingConstraint,trailingConstraint,bottomConstraint])
        bottomLineView?.addConstraint(bottomLineViewHeight!)
    }
    
    func floatTheLabel() -> Void {
        DispatchQueue.main.async {
            if self.text == "" && self.isFirstResponder {
                self.floatPlaceHolder(selected: true)
            }else if self.text == "" && !self.isFirstResponder {
                self.resignPlaceholder()
            }else if self.text != "" && !self.isFirstResponder  {
                self.floatPlaceHolder(selected: false)
            }else if self.text != "" && self.isFirstResponder {
                self.floatPlaceHolder(selected: true)
            }
        }
    }
    
    func upadteTextField(frame:CGRect) -> Void {
        self.frame = frame
        self.initialize()
    }
    
    //MARK:- ADD Floating Label
    func addFloatingLabel(){
        if labelPlaceholder?.superview != nil {
            return
        }
        
        var placeholderText : String? = labelPlaceholder?.text
        
        if self.placeholder != nil && self.placeholder != "" {
            placeholderText = self.placeholder!
        }
        
        labelPlaceholder = UILabel()
        labelPlaceholder?.text = placeholderText
        labelPlaceholder?.textAlignment = self.textAlignment
        labelPlaceholder?.textColor = placeHolderColor
        
        let fontName = self.font!.fontName
        let screenWidth = UIScreen.main.bounds.size.width
        let calculatedFontSize = screenWidth / 375 * 12
        
        //UIFont.init(name: (self.font?.fontName ?? "helvetica")!, size: 13)
        labelPlaceholder?.font = UIFont(name: fontName, size: calculatedFontSize)
        labelPlaceholder?.isHidden = true
        labelPlaceholder?.sizeToFit()
        labelPlaceholder?.layer.zPosition = 3
        labelPlaceholder?.translatesAutoresizingMaskIntoConstraints = false
        self.setValue(placeHolderColor, forKeyPath: "placeholderlabel.textcolor")
        
        if labelPlaceholder != nil {
            self.addSubview(labelPlaceholder!)
            self.bringSubviewToFront(labelPlaceholder!)
        }
        
        let leadingConstraint = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: -10)
        placeholderLabelHeight = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15)
        self.addConstraints([leadingConstraint,trailingConstraint,topConstraint])
        labelPlaceholder?.addConstraint(placeholderLabelHeight!)
    }
    
    //MARK:- Float UITextfield Placeholder Label
    func floatPlaceHolder(selected:Bool) -> Void {
        labelPlaceholder?.isHidden = false
        if selected {
            
            bottomLineView?.backgroundColor = self.selectedLineColor
            labelPlaceholder?.textColor = self.selectedPlaceHolderColor
            bottomLineViewHeight?.constant = 2
            self.setValue(self.selectedPlaceHolderColor, forKeyPath: "placeholderlabel.textcolor")
            
        } else {
            bottomLineView?.backgroundColor = self.lineColor
            bottomLineViewHeight?.constant = 1
            self.labelPlaceholder?.textColor = self.placeHolderColor
            self.setValue(placeHolderColor, forKeyPath: "placeholderlabel.textcolor")
        }
        
        if disableFloatingLabel == true {
            labelPlaceholder?.isHidden = true
            return
        }
        
        if placeholderLabelHeight?.constant == 15 {
            return
        }
        
        placeholderLabelHeight?.constant = 15;
        labelPlaceholder?.font = UIFont(name: (self.font?.fontName)!, size: 12)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        })
    }
    
    //MARK:- Resign the Placeholder
    func resignPlaceholder() -> Void {
        self.setValue(self.placeHolderColor, forKeyPath: "placeholderlabel.textcolor")
        
        bottomLineView?.backgroundColor = self.lineColor
        bottomLineViewHeight?.constant = 1
        
        if disableFloatingLabel {
            labelPlaceholder?.isHidden = true
            self.labelPlaceholder?.textColor = self.placeHolderColor;
            UIView.animate(withDuration: 0.2, animations: {
                self.layoutIfNeeded()
            })
            return
        }
        
        placeholderLabelHeight?.constant = self.frame.height
        
        UIView.animate(withDuration: 0.3, animations: {
            self.labelPlaceholder?.font = self.font
            self.labelPlaceholder?.textColor = self.placeHolderColor
            self.layoutIfNeeded()
        }) { (finished) in
            self.labelPlaceholder?.isHidden = true
            self.placeholder = self.labelPlaceholder?.text
        }
    }
    
    //MARK:- UITextField Begin Editing.
    func textFieldDidBeginEditing() -> Void {
        if !self.disableFloatingLabel {
            self.placeholder = ""
        }
        
        self.floatTheLabel()
        self.layoutSubviews()
    }
    
    //MARK:- UITextField Begin Editing.
    func textFieldDidEndEditing() -> Void {
        self.floatTheLabel()
    }
}
