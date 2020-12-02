//
//  ModelEntityExtension.swift
//  AR-Furnishing
//
//  Created by Coffee Bean on 12/2/20.
//

import Foundation
import RealityKit

extension ModelEntity {
    
    func fixScale(for filename: String) {
        switch(filename) {
        case "simple_table": transform.scale /= 2
        case "nightstand": transform.scale /= 3
        case "armchair", "rustic_stand": transform.scale /= 4
        default: break
        }
    }
}
