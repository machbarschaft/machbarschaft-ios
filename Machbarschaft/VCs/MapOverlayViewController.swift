//
//  MapOverlayViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit

class MapOverlayViewController: UIViewController {
    
    @IBOutlet weak var urgencyButton: UIButton!
    @IBOutlet weak var urgencyButtonIcon: UIImageView!
    
    @IBOutlet weak var closenessButton: UIButton!
    @IBOutlet weak var closenessButtonIcon: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let highlightedColor = UIColor(named: "Link")
    let defaultColor = UIColor(named: "Text")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func setSorting(_ button: UIButton) {
        let isSortingByUrgency = button == urgencyButton
        
        urgencyButton.isHighlighted = isSortingByUrgency
        urgencyButtonIcon.tintColor = isSortingByUrgency ? highlightedColor : defaultColor
        closenessButton.isHighlighted = !isSortingByUrgency
        closenessButtonIcon.tintColor = isSortingByUrgency ? defaultColor : highlightedColor
    }
}
