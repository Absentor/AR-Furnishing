//
//  ARViewContainer.swift
//  AR-Furnishing
//
//  Created by Coffee Bean on 12/1/20.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    @Binding var selectedModel: Model?
    @Binding var modelConfirmedForPlacement: Model?
    
    func makeUIView(context: Context) -> PreviewARView {
        let arView = PreviewARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        config.environmentTexturing = .automatic
        
        let previewAnchor = AnchorEntity(plane: .horizontal)
        previewAnchor.name = "PreviewAnchor"
        
        arView.scene.addAnchor(previewAnchor)
        arView.previewAnchor = previewAnchor
        
        arView.session.delegate = arView
        arView.session.run(config)
        
        arView.enableObjectRemoval()
        
        return arView
    }

    func updateUIView(_ uiView: PreviewARView, context: Context) {
        if let model = selectedModel, let modelEntity = model.entity?.clone(recursive: true) {
            uiView.previewAnchor?.addChild(modelEntity)
        } else {
            uiView.previewAnchor?.children.removeAll()
        }
        
        if let model = modelConfirmedForPlacement {
            if let modelEntity = model.entity?.clone(recursive: true) {
                DispatchQueue.main.async {
                    print("Adding model: \(model.name)")
                    
                    let anchorEntity = AnchorEntity(plane: .horizontal)
                    anchorEntity.addChild(modelEntity)
                    
                    uiView.installGestures([.translation, .rotation], for: modelEntity)
                    
                    uiView.scene.addAnchor(anchorEntity)
                }
            }
            
            DispatchQueue.main.async {
                modelConfirmedForPlacement = nil
            }
        }
    }
}
