//
//  LoginStep1ViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit

class LoginStep1ViewController: SuperViewController {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var phoneNumberErrorLabel: UILabel!
    @IBOutlet weak var areaCodeButton: UIButton!
    
    let accountService = AccountService()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func selectAreaCode(_ button: UIButton) {
        //Initilize prefix picker
        guard let areaCodes = [AreaCode].parse(jsonFile: "area-codes")?.removingDuplicates() else { return }
        var picker = SimplePicker(data: areaCodes.compactMap { $0.dialCode }.sorted(), presenter: self)
        picker.options.initialItem = button.titleLabel?.text ?? "+49"
            
        //Show picker
        picker.show(anchor: button) { (index, value) in
            button.setTitle(value, for: .normal)
        }
    }
    
    @IBAction func login(_ sender: Any) {
        // TODO: validations here
        
        performSegue(withIdentifier: "LoginStep1_to_Map", sender: nil)
    }
    
    @IBAction func register(_ sender: Any) {
        
        var phone = phoneNumberTextField.text!
        // Remove 0 prefix of phone number if necessary
        if phone.hasPrefix("0") {
            phone = String(phone.dropFirst())
        }
        phone = (areaCodeButton.titleLabel?.text?.nonEmpty ?? "+49") + phone
        
        //Phone number validation
        if accountService.validatePhone(phone: phone){
            
            //Request verification code
            accountService.requestCode(phoneNumber: phone)
            
            //Remove any error messages from error label
            phoneNumberErrorLabel.text = ""
            
            //Save phone number to user defaults
            UserDefaults.standard.set(phone, forKey: "phone")
            
            performSegue(withIdentifier: "LoginStep1_to_LoginStep2", sender: nil)
            
        }else{
            
            //Show error message
            phoneNumberErrorLabel.text = NSLocalizedString("PhoneNumberError", comment: "")
            
        }
        
    }
}

class LoginStep1PageViewController: UIPageViewController {
    fileprivate lazy var pages: [UIViewController] = {
        return [
            viewController(withID: "Page1", from: "Login"),
            viewController(withID: "Page2", from: "Login"),
            viewController(withID: "Page3", from: "Login")
        ]
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension LoginStep1PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0          else { return pages.last }
        guard pages.count > previousIndex else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return pages.first }
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        0
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        pages.count
    }
}

fileprivate class PageViewController: UIViewController {
    
}
