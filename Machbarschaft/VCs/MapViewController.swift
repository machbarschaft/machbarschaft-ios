//
//  MapViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit
import MapKit
import OverlayContainer

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let containerController = OverlayContainerViewController(style: .flexibleHeight)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let menuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapOverlayViewController") as? MapOverlayViewController else { return }
        containerController.delegate = self
        containerController.viewControllers = [menuVC]
    }
}

extension MapViewController: MKMapViewDelegate {
    
}

extension MapViewController: OverlayContainerViewControllerDelegate {
    enum OverlayNotch: Int, CaseIterable {
        case minimum, medium, maximum
    }
    
    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController, heightForNotchAt index: Int, availableSpace: CGFloat) -> CGFloat {
        switch OverlayNotch.allCases[index] {
        case .maximum:
            return availableSpace * 3 / 4
        case .medium:
            return availableSpace / 2
        case .minimum:
            return availableSpace * 1 / 4
        }
    }
    
    func numberOfNotches(in containerViewController: OverlayContainerViewController) -> Int {
        OverlayNotch.allCases.count
    }
}
