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
    
    let containerController = OverlayContainerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let menuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "") as? 
        containerController.delegate = self
        containerController.viewControllers = []
    }
}

extension MapViewController: MKMapViewDelegate {
    
}

extension MapViewController: OverlayContainerViewControllerDelegate {
    
}
