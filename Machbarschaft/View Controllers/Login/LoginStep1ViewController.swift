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
    
    var validatedPhone: String?
    var verificationId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LoginStep2ViewController {
            destination.phoneNumber = validatedPhone
            destination.verificationId = verificationId
        }
    }
    
    @IBAction func selectAreaCode(_ button: UIButton) {
        //Initilize prefix picker
        guard let areaCodes = [AreaCode].parse(jsonFile: "area-codes")?.removingDuplicates() else { return }
        var picker = SimplePicker(data: areaCodes.compactMap { $0.dialCode }.sorted(), presenter: self)
        picker.options.initialItem = button.titleLabel?.text ?? "+49"
        
        //Show picker
        picker.show(anchor: button) {
            button.setTitle($1, for: .normal)
        }
    }
    
    @IBAction func login(_ sender: Any) {
        
        // TODO: - validations here
        // TODO: - what should be validated? The phone number?
        performSegue(withIdentifier: "LoginStep1_to_Map", sender: nil)
    }
    
    @IBAction func register(_ sender: Any) {
        performSegue(withIdentifier: "LoginStep1_to_LoginStep2", sender: nil)
        // TODO: - remove comments after done
//        guard var phone = phoneNumberTextField.text else {
//            debugPrint("phoneNumberTextField text is nil")
//            return
//        }
//        if phone.hasPrefix("0") {
//            phone = String(phone.dropFirst())
//        }
//        phone = (areaCodeButton.titleLabel?.text?.nonEmpty ?? "+49") + phone
//        if PhoneNumberUtils.validatePhone(phone: phone) {
//            validatedPhone = phone
//            accountService.requestCode(phoneNumber: phone)
//                .done(on: .main, handleRequestCodeSuccess)
//                .recover(on: .main, handleRequestCodeFailure)
//        } else {
//            validatedPhone = nil
//            phoneNumberErrorLabel.text = NSLocalizedString("PhoneNumberError", comment: "")
//        }
    }
    
    // MARK: - Private functions
    
    private func handleRequestCodeSuccess(_ verificationId: String) {
        self.verificationId = verificationId
        phoneNumberErrorLabel.text = ""
        performSegue(withIdentifier: "LoginStep1_to_LoginStep2", sender: nil)
    }
    
    private func handleRequestCodeFailure(_ error: Error) {
        validatedPhone = nil
        verificationId = nil
        debugPrint(error.localizedDescription)
        phoneNumberErrorLabel.text = NSLocalizedString("RequestCodeError", comment: "Something went wrong while requesting the code.")
    }
}
