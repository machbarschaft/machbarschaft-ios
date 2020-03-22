//
//  LoginStep2ViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit

class LoginStep2ViewController: SuperViewController {
    
    @IBOutlet weak var codeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func requestNewCode(_ sender: Any) {
        
    }
    
    @IBAction func confirm(_ sender: Any) {
        // TODO: validations here
        
        performSegue(withIdentifier: "LoginStep2_to_LoginStep3", sender: nil)
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
