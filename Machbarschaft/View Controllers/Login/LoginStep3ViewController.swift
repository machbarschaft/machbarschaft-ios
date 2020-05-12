//
//  LoginStep3ViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit
import M13Checkbox
import Firebase
import CoreLocation

class LoginStep3ViewController: SuperViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var lastNameErrorLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addressErrorLabel: UILabel!
    
    @IBOutlet weak var termsCheckbox: M13Checkbox!
    @IBOutlet weak var termsErrorLabel: UILabel!
    
    let accountService = AccountService()
    var locationHelper: LocationHelper?
    
    var userId: String?
    var phoneNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func toggleTermsCheckbox() {
        termsCheckbox.toggleCheckState(true)
    }
    
    @IBAction func getCurrentLocationAction(_ sender: Any) {
        locationHelper = LocationHelper()
        locationHelper?.getCurrentLocation()
            .done(on: .main, handleGetCurrentLocationSuccess)
            .recover(on: .main, handleGetCurrentLocationFailure)
            .catch(on: .main, handleGetCurrentLocationFailure)
    }
    
    @IBAction func signup(_ sender: Any) {
        guard let phoneNumber = phoneNumber, let userId = userId else {
            debugPrint("phoneNumber or userId is nil")
            return
        }
        firstNameErrorLabel.text = ""
        lastNameErrorLabel.text = ""
        termsErrorLabel.text = ""
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            firstNameErrorLabel.text = NSLocalizedString("FirstNameError", comment: "")
            return
        }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            lastNameErrorLabel.text = NSLocalizedString("LastNameError", comment: "")
            return
        }
        guard let address = addressTextField.text, !address.isEmpty else {
            addressErrorLabel.text = NSLocalizedString("AddressError", comment: "")
            return
        }
        if termsCheckbox.checkState == .unchecked {
            termsErrorLabel.text = NSLocalizedString("TermsError", comment: "")
            return
        }
        
        //Add textfield data to user struct
        let userInput = User(uid: userId,
                             credits: 0,
                             first_name: firstName,
                             last_name: lastName,
                             radius: 0,
                             phone: phoneNumber)
        
        // Create account
        showLoadingIndicator()
        accountService.createAccount(user: userInput)
            .done(on: .main, handleCreateAccountSuccess)
            .recover(on: .main, handleCreateAccountFailure)
            .catch(on: .main, handleCreateAccountFailure)
    }
    
    // MARK: - Private functions
    
    private func handleCreateAccountSuccess() {
        hideLoadingIndicator()
        UserDefaults.standard.set(true, forKey: "userLoggedIn")
        self.performSegue(withIdentifier: "LoginStep3_to_Map", sender: nil)
    }
    
    private func handleCreateAccountFailure(_ error: Error) {
        hideLoadingIndicator()
        self.termsErrorLabel.text = NSLocalizedString("TermsError", comment: "")
    }
    
    private func handleGetCurrentLocationSuccess(with location: CLPlacemark) {
        let street = location.name ?? ""
        let postalCode = location.postalCode ?? ""
        let city = location.locality ?? ""
        let country = location.country ?? ""
        
        addressTextField.text = "\(street) \(postalCode) \(city) \(country)"
        locationHelper = nil
    }
    
    private func handleGetCurrentLocationFailure(_ error: Error) {
        debugPrint("LoginStep3ViewController handleGetCurrentLocationFailure error: \(error.localizedDescription)")
        locationHelper = nil
    }
}
