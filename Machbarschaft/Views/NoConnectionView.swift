//
//  NoConnectionView.swift
//  Machbarschaft
//
//  Created by Manuel Donaubauer on 30.04.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit

class NoConnectionView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "NoConnectionBackground")
        let label = createLabel()
        self.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func createLabel() -> UILabel {
        let label: UILabel = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 250, height: 130)
        label.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        label.backgroundColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = NSLocalizedString("NoConnectionError", comment: "Message text for the no connection view")
        return label
    }
}
