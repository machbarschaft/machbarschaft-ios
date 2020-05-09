//
//  LoadingView.swift
//  Machbarschaft
//
//  Created by Manuel Donaubauer on 09.05.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "NoConnectionBackground")
        let loadingView = createLoadingView()
        let activityIndicatorView = createActivityIndicatorView(for: loadingView)
        loadingView.addSubview(activityIndicatorView)
        self.addSubview(loadingView)
        activityIndicatorView.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func createLoadingView() -> UIView {
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 250, height: 130)
        loadingView.center = self.center
        loadingView.backgroundColor = .white
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        return loadingView
    }
    
    private func createActivityIndicatorView(for view: UIView) -> UIActivityIndicatorView {
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicatorView.style = .large
        activityIndicatorView.center = CGPoint(x: view.frame.size.width / 2,
                                               y: view.frame.size.height / 2)
        activityIndicatorView.color = .black
        return activityIndicatorView
    }
}
