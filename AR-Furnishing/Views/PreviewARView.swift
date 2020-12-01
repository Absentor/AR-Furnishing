//
//  PreviewARView.swift
//  AR-Furnishing
//
//  Created by Coffee Bean on 12/1/20.
//

import Foundation
import RealityKit
import ARKit

class PreviewARView: ARView, ARSessionDelegate {
    
    var previewAnchor: AnchorEntity? = nil
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if previewAnchor != nil {
            if let raycastResult = self.raycast(from: self.center, allowing: .estimatedPlane, alignment: .horizontal).first {
                previewAnchor?.anchoring = AnchoringComponent(.world(transform: raycastResult.worldTransform))
            }
        }
    }
}
