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
    
    let handler: RegisterHandler = RegisterHandler()
    
    var selectedPrefix:String = "+49"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func selectAreaCode(_ button: UIButton) {
        
        //Initilize prefix picker
        guard let areaCodes = [AreaCode].parse(jsonFile: "area-codes")?.removingDuplicates() else { return }
        var options = SimplePicker.Options()
        options.initialItem = button.titleLabel?.text ?? "+49"
        let picker = SimplePicker(options: options, data: areaCodes.compactMap { $0.dialCode }.sorted(), presenter: self)
            
        //Show picker
        picker.show(anchor: button) { (index, value) in
            button.setTitle(value, for: .normal)
            
            //Update selected prefix variable
            self.selectedPrefix = value
            
        }
    }
    
    @IBAction func login(_ sender: Any) {
        // TODO: validations here
        
        performSegue(withIdentifier: "LoginStep1_to_Map", sender: nil)
    }
    
    @IBAction func register(_ sender: Any) {
        // TODO: validations here
        
        var phone:String = phoneNumberTextField.text!
        
        //Remove 0 prefix of phone number if necessary
        if phone[0] == "0"{
            
            phone = String(phone.dropFirst())
            
        }
        
        phone = selectedPrefix + phone
        print(phone)
        handler.requestCode(phoneNumber: phone)
        
        //Save phone number to user defaults
        UserDefaults.standard.set(phone, forKey: "phone")
        
        performSegue(withIdentifier: "LoginStep1_to_LoginStep2", sender: nil)
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
