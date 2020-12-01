//
//  ARViewExtension.swift
//  AR-Furnishing
//
//  Created by Coffee Bean on 1/12/20.
//

import Foundation
import RealityKit
import ARKit

extension ARView {
    func enableObjectRemoval() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        let location = recognizer.location(in: self)
        
        if let entity = self.entity(at: location) {
            if let anchorEntity = entity.anchor {
                anchorEntity.removeFromParent()
            }
        }
    }
}
