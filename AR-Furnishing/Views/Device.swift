//
//  ContentModel.swift
//  AR-Furnishing
//
//  Created by Coffee Bean on 12/2/20.
//

import Foundation
import UIKit
import SwiftUI

class Device: ObservableObject {
    
    @Published var orientation: UIDeviceOrientation = UIDevice.current.orientation
    
    private var _observer: NSObjectProtocol?

    init() {
        _observer = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { _ in
            self.orientation = UIDevice.current.orientation
        }
    }
    
    deinit {
        if let observer = _observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    func getImageOrientationAngle() -> Angle {
        switch orientation {
        case .landscapeLeft:
            return Angle(degrees: 90)
        case .landscapeRight:
            return Angle(degrees: -90)
        default:
            return Angle(degrees: 0)
        }
    }
}
