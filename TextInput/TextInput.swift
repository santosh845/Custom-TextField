//
//  TextInput.swift
//  TextFieldDemo
//
//  Created by Santosh Maurya on 11/29/19.
//  Copyright © 2019 Santosh Maurya. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
 

@objc protocol TextInputDelegate {
    
     @objc optional func textShouldReturn(textInput: TextInput)
     @objc optional func textInputDidBeginEditing(textInput: TextInput)
     @objc optional func textInputDidEndEditing(textInput: TextInput)
     @objc optional func textInputDidChange(textInput: TextInput, text: String)
 @objc optional func textinput(_ textInput: TextInput, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
   @objc optional func buttonRightImageClicked(forInput Input: TextInput)
    
}

class TextInput: UIView {
    
    public var rightBtn: UIButton!
    @IBOutlet weak var txtFld: SkyFloatingLabelTextField!
    public var delegate : TextInputDelegate?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        
        guard let nib = Bundle.main.loadNibNamed("TextInput", owner: self, options: nil)?.first as? UIView else {
            fatalError("Couldn't find the xib for TextInputView")
        }
        
        addSubview(nib)
        nib.frame = bounds
        nib.autoresizingMask = [.flexibleWidth, .flexibleHeight ]
        configTextField()
        
    }
    
    var text:String? {
        return txtFld.text
    }
    
    public func configTextField(){
        
        txtFld.delegate = self
        
        
    }
    
    func addRightImageOnTextField(textField:UITextField) {
        
        if rightImage != nil{
            rightBtn = UIButton(type: .custom)
            let origImage = rightImage
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            rightBtn.setImage(tintedImage, for: .normal)
            rightBtn.tintColor = .lightGray
            rightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            rightBtn.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
            if(textField == txtFld){
         rightBtn.addTarget(self, action: #selector(buttonRightImageClicked(button:)), for: .touchUpInside)
            }
            textField.rightView = rightBtn
            textField.rightViewMode = .always
        }
        
    }
    
    @objc func buttonRightImageClicked(button : UIButton){
        delegate?.buttonRightImageClicked?(forInput: self)
    }
    
    // This will notify us when something has changed on the textfield
    public var shouldShowError: Bool = false {
        didSet{
            updateTintColor()
        }
    }
    
    private func updateTintColor(){
        if shouldShowError {
            txtFld.selectedTitleColor = .red
            rightBtn.tintColor = .red
        }
        else{
            txtFld.selectedTitleColor = .black
            rightBtn.tintColor = .lightGray
        }
    }

    
    private func animateShadow() {
        center = self.center
        backgroundColor = UIColor.white
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
        
    }
    
    private func removeShadow() {
        center = self.center
        backgroundColor = UIColor.white
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOpacity = 0.0
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 0.0
        
    }
        

    @IBInspectable public var isProtected: Bool = false {

            didSet{

                txtFld.isSecureTextEntry = isProtected

                if (isProtected) {

                    txtFld.keyboardType = .default

                }

            }

        }


    
    @IBInspectable public var rightImage: UIImage? {
        didSet{
           self.addRightImageOnTextField(textField: self.txtFld)
        }
    }
      
    
    @IBInspectable public var isEmailType:UIKeyboardType = .default {
        didSet{
                txtFld.keyboardType = isEmailType
            }
    }
    
    @IBInspectable public var placeHolderText: String?{
        didSet{
            if  (placeHolderText != nil){
                txtFld.placeholder = placeHolderText
            }
            
        }
    }
    
        
    
    @IBInspectable public var selectedTitle: String?{
        didSet{
            if selectedTitle != nil {
                txtFld.selectedTitle = selectedTitle
            }
            
        }
    }
    
    @IBInspectable public var selectedLineColor: UIColor?{
        didSet{
            if selectedLineColor != nil {
                txtFld.selectedLineColor = selectedLineColor ?? .black
                
              }
          }
    }
    
    @IBInspectable public var placeholderColor: UIColor?{
        didSet{
            if placeholderColor != nil {
                txtFld.placeholderColor = placeholderColor ?? .lightGray
              }
          }
    }
    
    @IBInspectable public var errorColor: UIColor?{
        didSet{
            if errorColor != nil {
                txtFld.errorColor = errorColor ?? .red
              }
          }
    }
    
}

extension TextInput:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.textShouldReturn!(textInput: self)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateShadow()
        delegate?.textInputDidBeginEditing!(textInput: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        removeShadow()
        delegate?.textInputDidEndEditing!(textInput: self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        if (string == "") {
//            return true
//        }
        
        if string.rangeOfCharacter(from: CharacterSet.whitespaces) != nil {
            return false
        }
        var finalString = string
        
        if let text = textField.text as NSString? {
            finalString = text.replacingCharacters(in: range, with: string)
        }
        //print(finalString)
        delegate?.textInputDidChange!(textInput: self, text: finalString)
        return true
    }
    
}
