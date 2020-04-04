//
//  GeoFunctions.swift
//  Machbarschaft
//
//  Created by Florian on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import Foundation
import CoreLocation

struct GeoBounds {
    let center : CLLocationCoordinate2D
    let leftBound : CLLocationCoordinate2D
    let rightBound : CLLocationCoordinate2D
    let upperBound : CLLocationCoordinate2D
    let lowerBound : CLLocationCoordinate2D
}

// Distance in Kilometer
func getEdgeCoordinates(midCoordinate: CLLocationCoordinate2D, distance: Double) -> GeoBounds {
    let upper = calculateCoordinations(midCoordinate: midCoordinate, distance: distance / 2, heading: 0)
    let right = calculateCoordinations(midCoordinate: midCoordinate, distance: distance / 2, heading: 90)
    let lower = calculateCoordinations(midCoordinate: midCoordinate, distance: distance / 2, heading: 180)
    let left = calculateCoordinations(midCoordinate: midCoordinate, distance: distance / 2, heading: 270)
    return GeoBounds(center: midCoordinate, leftBound: left, rightBound: right, upperBound: upper, lowerBound: lower)
}

// In Metern
func getDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Int {
    print(from, to)
    let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
    let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
    let distance = Int(to.distance(from: from))
    return distance
}

fileprivate func calculateCoordinations(midCoordinate: CLLocationCoordinate2D, distance: Double, heading: Double) -> CLLocationCoordinate2D {
    let earthR = 6378.14
    // Degree to Radian
    let latitude1 = deg2rad(deg: Double(midCoordinate.latitude))
    let longitude1 = deg2rad(deg: Double(midCoordinate.longitude))
    let bearing = heading * Double.pi / 180
    
    let latitude2 = asin(sin(latitude1) * cos(distance/earthR) + cos(latitude1) * sin(distance/earthR) * cos(bearing))
    let longitude2 = longitude1 + atan2(sin(bearing) * sin(distance/earthR) * cos(latitude1) , cos(distance/earthR) - sin(latitude1) * sin(latitude2))
    return CLLocationCoordinate2D(latitude: ((180 / Double.pi) * latitude2), longitude: ((180 / Double.pi) * longitude2))
}


fileprivate func deg2rad(deg:Double) -> Double {
    return deg * Double.pi / 180
}

fileprivate func rad2deg(rad:Double) -> Double {
    return rad * 180.0 / Double.pi
}

