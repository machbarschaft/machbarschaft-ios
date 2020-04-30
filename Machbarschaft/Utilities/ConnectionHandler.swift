//
//  ConnectionHandler.swift
//  Machbarschaft
//
//  Created by Manuel Donaubauer on 30.04.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import Network
import UIKit

/// This class encapsulates the monitoring of the network connection.
class ConnectionHandler {
    
    static let shared: ConnectionHandler = ConnectionHandler()
    
    private let monitor = NWPathMonitor()
    private var isNoConnectionViewShown: Bool = false
    
    private init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.removeNoConnectionView()
                    self.isNoConnectionViewShown = false
                } else if !self.isNoConnectionViewShown {
                    self.addNoConnectionView()
                    self.isNoConnectionViewShown = true
                }
            }
        }
    }
    
    /// This function will start monitoring the network connection. If the connection is lost, an overlay is shown, which will disappear if the connection is back.
    func startMonitoring() {
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    // MARK: - Private functions
    
    private func addNoConnectionView() {
        if let window = UIApplication.shared.windows.last {
            let noConnectionView = NoConnectionView(frame: window.frame)
            window.addSubview(noConnectionView)
        }
    }
    
    private func removeNoConnectionView() {
        UIApplication.shared.windows.forEach {
            $0.subviews.forEach {
                if $0.isKind(of: NoConnectionView.self) {
                    $0.removeFromSuperview()
                }
            }
        }
    }
}
