//
//  JobCompletedViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 23.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit

class JobCompletedViewController: UIViewController {

    @IBOutlet weak var checkmarkIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
}
