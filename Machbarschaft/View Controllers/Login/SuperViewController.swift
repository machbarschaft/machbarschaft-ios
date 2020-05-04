//
//  SuperViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit

class SuperViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
        setupTextFields()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func setupTextFields() {
        view.allSubviews.compactMap { $0 as? UITextField }.forEach {
            $0.delegate = self
        }
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        let screenHeight = UIScreen.main.bounds.height
        
        guard let textField = UIResponder().currentFirst as? UITextField,
            let maxY = view.getConvertedFrame(fromSubview: textField)?.maxY,
            maxY > (screenHeight - keyboardHeight) else {
                return
        }
        self.view.frame.origin.y = -keyboardHeight // move view up when keyboard shows up
    }
    
    @objc
    private func keyboardWillHide() {
        self.view.frame.origin.y = 0 // move view back down when keyboard hides
    }
}

// MARK: - UITextFieldDelegate extension

extension SuperViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
