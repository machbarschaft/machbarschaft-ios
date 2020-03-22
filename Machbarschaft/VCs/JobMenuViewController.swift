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
        Job(id: 2, type: .medicine, urgency: .urgent, status: .open, clientName: "Frau Pohl", clientPhone: "017912345678", city: "Halle", zip: "06114", location: CLLocationCoordinate2D(latitude: 51.495696, longitude: 11.968022), street: "Brandenburger Str.", houseNumber: "7", description: "Ibuprofen und Asthmaspray"),
        Job(id: 1, type: .groceries, urgency: .today, status: .open, clientName: "Frau Pohl", clientPhone: "017912345678", city: "Halle", zip: "06114", location: CLLocationCoordinate2D(latitude: 51.495696, longitude: 11.968022), street: "Brandenburger Str.", houseNumber: "7", description: "Ich brauche Toastbrot, etwas Obst und Nudeln"),
        Job(id: 3, type: .misc, urgency: .tomorrow, status: .open, clientName: "Frau Pohl", clientPhone: "017912345678", city: "Halle", zip: "06114", location: CLLocationCoordinate2D(latitude: 51.495696, longitude: 11.968022), street: "Brandenburger Str.", houseNumber: "7", description: "Könnte mir jemand Sachen vom Baumarkt holen?")
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

extension JobMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? JobMenuCell,
            let job = jobs[safe: indexPath.row] else { return UITableViewCell() }
        cell.populate(for: job)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
    }
}

class JobMenuCell: UITableViewCell {
    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var flagIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var job: Job!
    
    func populate(for job: Job) {
        self.job = job
        
        indexLabel.text = "\(job.id)"
        flagIcon.tintColor = job.urgency.color
        titleLabel.text = job.type.title
        descriptionLabel.text = job.description
        distanceLabel.text = "\(Int.random(in: 100...750))m"
    }
}
