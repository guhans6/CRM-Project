//
//  FormTextField.swift
//  FormPractice
//
//  Created by guhan-pt6208 on 06/02/23.
//

import UIKit

class FormTextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 5))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 5))
    }
    
    private func getKeyboardLanguage() -> String? {
         return "en" // here you can choose keyboard any way you need
     }

     override var textInputMode: UITextInputMode? {
         if let language = getKeyboardLanguage() {
             for tim in UITextInputMode.activeInputModes {
                 if tim.primaryLanguage!.contains(language) {
                     return tim
                 }
             }
         }
         return super.textInputMode
     }

}
