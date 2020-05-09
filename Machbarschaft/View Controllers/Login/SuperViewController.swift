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
        configureNavigationBar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func showLoadingIndicator() {
        let loadingView = LoadingView(frame: self.view.frame)
        self.view.addSubview(loadingView)
    }
    
    func hideLoadingIndicator() {
        self.view.subviews.forEach {
            if $0.isKind(of: LoadingView.self) {
                $0.removeFromSuperview()
            }
        }
    }
    
    // MARK: NavigtaionBar setup
    
    private func configureNavigationBar() {
        makeNavigtaionBarTrasparent()
        changeBackButton()
    }
    
    private func makeNavigtaionBarTrasparent() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    private func changeBackButton() {
        guard let customBackButton = UIImage(systemName: "arrow.left") else {
            debugPrint("SuperViewController changeBackButton customBackButton systemImage not found")
            return
        }
        guard let customRepositionedBackButton = changeImagePosition(image: customBackButton, origin: CGPoint(x: 0, y: -1)) else {
            debugPrint("SuperViewController changeBackButton custom button cant be repositioned")
            return
        }
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.backIndicatorImage = customRepositionedBackButton
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = customRepositionedBackButton
        self.navigationItem.leftItemsSupplementBackButton = true
    }
    
    private func changeImagePosition(image: UIImage, origin: CGPoint) -> UIImage? {
        let size = image.size
        UIGraphicsBeginImageContextWithOptions(size, false, 2)
        image.draw(in: CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // MARK: TextField setup
    
    private func setupTextFields() {
        view.allSubviews.compactMap { $0 as? UITextField }.forEach {
            $0.delegate = self
        }
    }
    
    // MARK: Keyboard setup
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
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
        
        // move view up when keyboard shows up
        self.view.frame.origin.y = -keyboardHeight
    }
    
    @objc
    private func keyboardWillHide() {
        
        // move view back down when keyboard hides
        self.view.frame.origin.y = 0
    }
}

// MARK: - UITextFieldDelegate extension

extension SuperViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
