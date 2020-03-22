//
//  Extensions.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit

extension UIView {
    var isShown: Bool {
        get { isHidden }
        set { isHidden = !newValue }
    }
    
    func mask(withRect rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}

extension Collection where Indices.Iterator.Element == Index {
    /// Returns the element at the specified index if it is within bounds, otherwise nil
    subscript (safe index: Index?) -> Iterator.Element? {
        guard let i = index else { return nil }
        return indices.contains(i) ? self[i] : nil
    }
}

extension Array {
    var nonEmpty: Array? {
        return self.count > 0 ? self : nil
    }
}

extension Array where Element: Equatable {
    /// Returns array without duplicate entries
    func removingDuplicates() -> [Element] {
        var result = [Element]()
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}

extension Date {
    func string(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension Decodable {
    static func parse(jsonFile: String) -> Self? {
        guard let url = Bundle.main.url(forResource: jsonFile, withExtension: "json"), let data = try? Data(contentsOf: url) else { return nil }
        var output: Self?
        do {
            output = try JSONDecoder().decode(self, from: data)
        } catch {
            print(error.localizedDescription)
        }
        return output
    }
}

extension CALayer {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let roundingSize = CGSize(width: radius, height: radius)
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: roundingSize)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.mask = mask
    }
}
