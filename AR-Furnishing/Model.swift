//
//  Model.swift
//  AR-Furnishing
//
//  Created by Coffee Bean on 1/12/20.
//

import UIKit
import RealityKit
import Combine

class Model {
    var name: String
    var thumbnail: UIImage
    var entity: ModelEntity?
    
    private var cancellable: AnyCancellable? = nil
    
    init(name: String) {
        self.name = name
        self.thumbnail = UIImage(named: name)!
        
        let filename = name + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: { loadCompletion in
                print("Unable to load model entity for \(name)")
            }, receiveValue: { modelEntity in
                self.entity = modelEntity
                self.entity?.generateCollisionShapes(recursive: true)
            })
    }
}
