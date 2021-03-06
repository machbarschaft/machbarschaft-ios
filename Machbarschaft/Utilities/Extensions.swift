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
    
    func getConvertedFrame(fromSubview subview: UIView) -> CGRect? {
        guard subview.isDescendant(of: self) else { return nil }
        var frame = subview.frame
        if subview.superview == nil {
            return frame
        }
        
        var superview = subview.superview
        while superview != self {
            frame = superview!.convert(frame, to: superview!.superview)
            if superview!.superview == nil {
                break
            } else {
                superview = superview!.superview
            }
        }
        return superview!.convert(frame, to: self)
    }
    
    var allSubviews: [UIView] {
        var array = [self.subviews].flatMap { $0 }
        array.forEach { array.append(contentsOf: $0.allSubviews) }
        return array
    }
    
    func pinToSuperview(with insets: UIEdgeInsets = .zero, edges: UIRectEdge = .all) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        if edges.contains(.top) {
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = true
        }
        if edges.contains(.bottom) {
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom).isActive = true
        }
        if edges.contains(.left) {
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left).isActive = true
        }
        if edges.contains(.right) {
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right).isActive = true
        }
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

extension UIResponder {
    
    private struct Static {
        static weak var responder: UIResponder?
    }
    
    var currentFirst: UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }
    
    @objc private func _trap() {
        Static.responder = self
    }
}

extension UIViewController {
    func addChild(_ child: UIViewController, in containerView: UIView) {
        guard containerView.isDescendant(of: view) else { return }
        addChild(child)
        containerView.addSubview(child.view)
        child.view.pinToSuperview()
        child.didMove(toParent: self)
    }
    
    func removeChild(_ child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
    
    func showLoadingIndicator() {
        let loadingView = LoadingView(frame: self.view.frame)
        self.view.addSubview(loadingView)
    }
    
    func hideLoadingIndicator() {
        self.view.subviews.forEach {
            if $0.isKind(of: LoadingView.self) {
                $0.removeFromSuperview()
            }
        }
    }
}

public func viewController(withID id: String, from storyboardID: String = "Main") -> UIViewController {
    UIStoryboard(name: storyboardID, bundle: nil).instantiateViewController(withIdentifier: id)
}

//Extension to get individual chars from string
extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    var nonEmpty: String? {
        self == "" ? nil : self
    }
}

extension UIButton {
    func set(title: String?) {
        setTitle(title, for: .normal)
    }
    
    func set(titleColor: UIColor?) {
        setTitleColor(titleColor, for: .normal)
    }
}

extension UINavigationController {
    func popAllPreviousViewControllers() {
        guard let topMostViewController = self.viewControllers.last else {
            return
        }
        self.viewControllers.removeAll()
        self.viewControllers = [topMostViewController]
    }
}
