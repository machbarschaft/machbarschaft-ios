//
//  JobMenuViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit
import CoreLocation

class JobMenuViewController: UIViewController {
    
    @IBOutlet weak var urgencyButton: UIButton!
    @IBOutlet weak var urgencyButtonIcon: UIImageView!
    
    @IBOutlet weak var closenessButton: UIButton!
    @IBOutlet weak var closenessButtonIcon: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var jobs = [
        Job(type: .medicine, urgency: .urgent, status: .open, clientName: "Frau Pohl", clientPhone: "017912345678", city: "Halle", zip: "06114", location: CLLocationCoordinate2D(latitude: 51.495696, longitude: 11.968022), street: "Brandenburger Str.", houseNumber: "3"),
        Job(type: .medicine, urgency: .urgent, status: .open, clientName: "Frau Pohl", clientPhone: "017912345678", city: "Halle", zip: "06114", location: CLLocationCoordinate2D(latitude: 51.495696, longitude: 11.968022), street: "Brandenburger Str.", houseNumber: "8")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func setSorting(_ button: UIButton) {
        let isSortingByUrgency = button == urgencyButton
        
        urgencyButton.setTitleColor(color(isHighlighted: isSortingByUrgency), for: .normal)
        urgencyButtonIcon.tintColor = color(isHighlighted: isSortingByUrgency)
        closenessButton.setTitleColor(color(isHighlighted: !isSortingByUrgency), for: .normal)
        closenessButtonIcon.tintColor = color(isHighlighted: !isSortingByUrgency)
    }
    
    func color(isHighlighted: Bool) -> UIColor {
        let highlightedColor = UIColor(named: "Link")!
        let defaultColor = UIColor(named: "Text")!
        return isHighlighted ? highlightedColor : defaultColor
    }
}
