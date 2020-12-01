//
//  FurnishingARView.swift
//  AR-Furnishing
//
//  Created by Coffee Bean on 12/1/20.
//

import Foundation

import RealityKit
import Combine
import ARKit
import UIKit

class FurnishingARView: ARView {
    
    //  var focusEntity: FocusEntity?
    
    let itemsArray: [String] = ["cup", "vase", "boxing", "table"]
    
    let config = ARWorldTrackingConfiguration()
    
    var selectedItem: String?
    
    var lastPanTouchPosition: CGPoint?
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        self.setupConfig()
    //    self.focusEntity = FocusEntity(on: self, focus: .classic)
    //    self.focusEntity = FocusEntity(on: self, style: .colored(onColor: .red, offColor: .blue, nonTrackingColor: .orange))
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConfig() {
        config.planeDetection = .horizontal
        session.run(config, options: [])
    }
    
    func registerGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(rotate))
        longPressGestureRecognizer.minimumPressDuration = 0.1
        let panGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(move))
        
        self.addGestureRecognizer(longPressGestureRecognizer)
        self.addGestureRecognizer(pinchGestureRecognizer)
        self.addGestureRecognizer(tapGestureRecognizer)
        self.addGestureRecognizer(panGestureRecogniser)
    }
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let tapLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        if !hitTest.isEmpty {
            self.addItem(hitTestResult: hitTest.first!)
        }
    }
    
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let pinchLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(pinchLocation)
        
        if !hitTest.isEmpty {
            let results = hitTest.first!
            let node = results.node
            let pinchAction = SCNAction.scale(by: sender.scale, duration: 0)
            print(sender.scale)
            node.runAction(pinchAction)
            sender.scale = 1.0
        }
    }
    
    @objc func rotate(sender: UILongPressGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let holdLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(holdLocation)
        
        if !hitTest.isEmpty {
            let result = hitTest.first!
            if sender.state == .began {
                let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 1.5)
                let forever = SCNAction.repeatForever(rotation)
                result.node.runAction(forever)
                
            } else if sender.state == .ended {
                result.node.removeAllActions()
            }
        }
    }
    
    @objc func move(sender: UIPanGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let panLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(panLocation)
        
        if !hitTest.isEmpty {
            let results = hitTest.first!
            let node = results.node
            
            switch sender.state {
            case .changed:
                let translation = sender.translation(in: sceneView)
                
                let previousPosition = lastPanTouchPosition ?? CGPoint(sceneView.projectPoint(node.position))
                // Calculate the new touch position
                let currentPosition = CGPoint(x: previousPosition.x + translation.x, y: previousPosition.y + translation.y)
                if let hitTestResult = sceneView.smartHitTest(currentPosition) {
                    node.simdPosition = hitTestResult.worldTransform.translation
                }
                lastPanTouchPosition = currentPosition
                // reset the gesture's translation
                sender.setTranslation(.zero, in: sceneView)
            default:
                // Clear the current position tracking.
                lastPanTouchPosition = nil
            }
        }
    }
    
    func addItem(hitTestResult: ARHitTestResult) {
        if let selectedItem = self.selectedItem {
          let scene = SCNScene(named: "Models.scnassets/\(selectedItem).scn")
            let node = (scene?.rootNode.childNode(withName: selectedItem, recursively: false))!
            let transform = hitTestResult.worldTransform
            let thirdColumn = transform.columns.3
            node.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
            
            self.scene.rootNode.addChildNode(node)
        }
        
    }
}

//extension FocusARView: FocusEntityDelegate {
//  func toTrackingState() {
//    print("tracking")
//  }
//  func toInitializingState() {
//    print("initializing")
//  }
//}
