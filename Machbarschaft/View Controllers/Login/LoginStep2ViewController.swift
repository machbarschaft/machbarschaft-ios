//
//  LoginStep2ViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import PromiseKit

class LoginStep2ViewController: SuperViewController {
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var codeErrorLabel: UILabel!
    
    let accountService = AccountService()
    
    var phoneNumber: String?
    var verificationId: String?
    
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LoginStep3ViewController {
            destination.phoneNumber = phoneNumber
            destination.userId = userId
        }
    }
    
    @IBAction func requestNewCode(_ sender: Any) {
        guard let phone = phoneNumber else {
            debugPrint("Phone number not set")
            return
        }
        accountService.requestCode(phoneNumber: phone)
            .done(on: .main, {_ in debugPrint("New code requested succeed")})
            .recover(on: .main, {debugPrint("Error requesting new code: \($0.localizedDescription)")})
            .catch(on: .main, {debugPrint("Error requesting new code: \($0.localizedDescription)")})
    }
    
    @IBAction func confirm(_ sender: Any) {
        guard let verificationId = self.verificationId,
            let code = codeTextField.text else {
                debugPrint("verificationId or codeTextField text is nil")
                return
        }
        if code.count == 6 {
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationId,
                verificationCode: code)
            accountService.signIn(with: credential)
                .then(handleSignInResult)
                .then(handleUser)
                .done(on: .main, handleSuccess)
                .recover(on: .main, handleFailure)
                .catch(on: . main, handleFailure)
        } else {
            handleCodeCountError()
        }
    }
    
    // MARK: - Private functions
    
    private func handleRequestNewCodeSuccess(_ verificationId: String) {
        self.verificationId = verificationId
        codeErrorLabel.text = NSLocalizedString("RequestNewCodeSuccess", comment: "Message that is shown, when the request was successful")
    }
    
    private func handleRequestNewCodeFilure(_ error: Error) {
        codeErrorLabel.text = NSLocalizedString("RequestNewCodeFailure", comment: "Message that is shown, when the request failed")
    }
    
    private func handleSignInResult(_ result: AuthDataResult) -> Promise<(Bool, AuthDataResult)> {
        return Promise<(Bool, AuthDataResult)> { resolver in
            
            // User is signed in
            debugPrint("Phone number authentication successful!")
            
            // Get user id and save it to UserDefaults
            self.userId = result.user.uid
            resolver.fulfill((result.additionalUserInfo?.isNewUser ?? true, result))
        }
    }
    
    private func handleUser(_ tuple: (Bool, AuthDataResult)) -> Promise<String> {
        if tuple.0 {
            return Promise<String> { $0.fulfill("")}
        }
        return self.accountService.getDocumentID(for: tuple.1.user.uid)
    }
    
    private func handleSuccess(for documentId: String) {
        self.codeErrorLabel.text = ""
        if documentId.isEmpty {
            self.performSegue(withIdentifier: "LoginStep2_to_LoginStep3", sender: nil)
        } else {
            
            // Complete Account exists
            // TODO: - UserDefaults where do we need it again?
            UserDefaults.standard.set(documentId, forKey: "docID")
            performSegue(withIdentifier: "LoginStep2_to_Map", sender: nil)
        }
    }
    
    private func handleFailure(_ error: Error) {
        debugPrint(error.localizedDescription)
        switch error {
        case is AuthenticationError:
            self.codeErrorLabel.text = NSLocalizedString("CodeError", comment: "")
        case is DatabaseError:
            
            //Proceed to Step3 Viewcontroller as phone number exists, but is associated to no account
            self.performSegue(withIdentifier: "LoginStep2_to_LoginStep3", sender: nil)
        default:
            debugPrint("Unknown error occured, error description: \(error.localizedDescription), error code: \(error._code)")
        }
    }
    
    private func handleCodeCountError() {
        codeErrorLabel.text = NSLocalizedString("CodeLengthError", comment: "")
    }
}
