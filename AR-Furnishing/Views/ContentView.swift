//
//  ContentView.swift
//  AR-Furnishing
//
//  Created by Coffee Bean on 1/12/20.
//

import SwiftUI

struct ContentView: View {
    
    @State private var modelPlacementEnabled: Bool = false
    @State private var selectedModel: Model?
    @State private var modelConfirmedForPlacement: Model?
    
    private var models: [Model] = {
        let filemanager = FileManager.default
        
        guard let path = Bundle.main.resourcePath, let files = try? filemanager.contentsOfDirectory(atPath: path)
        else { return [] }
        
        var availableModels: [Model] = []
        for filename in files where filename.hasSuffix("usdz") {
            let modelName = filename.replacingOccurrences(of: ".usdz", with: "")
            let model = Model(name: modelName)
            
            availableModels.append(model)
        }
        
        return availableModels
    }()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ARViewContainer(selectedModel: $selectedModel, modelConfirmedForPlacement: $modelConfirmedForPlacement).edgesIgnoringSafeArea(.all)
                
                if modelPlacementEnabled {
                    PlacementButtonsView(modelPlacementEnabled: $modelPlacementEnabled, selectedModel: $selectedModel, modelConfirmedForPlacement: $modelConfirmedForPlacement)
                } else {
                    ModelPickerView(modelPlacementEnabled: $modelPlacementEnabled, selectedModel: $selectedModel, models: models)
                }
            }
        }
    }
}

struct ModelPickerView: View {
    @Binding var modelPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    
    var models: [Model]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                NavigationLink(destination: ExportView()) {
                    Text("Export")
                        .font(.body)
                        .foregroundColor(Color.white)
                        .padding(6)
                }
                .background(Color.black.opacity(0.5))
                .cornerRadius(12)
                .padding(6)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(0 ..< models.count) { index in
                        Button(action: {
                            selectedModel = models[index]
                            
                            modelPlacementEnabled = true
                        }) {
                            Image(uiImage: models[index].thumbnail)
                                .resizable()
                                .frame(height: 64)
                                .aspectRatio(1/1, contentMode: .fit)
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(12)
            }
            .background(Color.black.opacity(0.5))
        }
    }
}

struct PlacementButtonsView: View {
    @Binding var modelPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    @Binding var modelConfirmedForPlacement: Model?
    
    var body: some View {
        HStack {
            Button(action: {
                resetPlacementState()
            }) {
                Image(systemName: "xmark")
                    .frame(width: 64, height: 64)
                    .font(.title)
                    .foregroundColor(Color.red)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(32)
                    .padding(12)
            }
            
            Button(action: {
                modelConfirmedForPlacement = selectedModel
                
                resetPlacementState()
            }) {
                Image(systemName: "checkmark")
                    .frame(width: 64, height: 64)
                    .font(.title)
                    .foregroundColor(Color.white)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(32)
                    .padding(12)
            }
        }
    }
    
    func resetPlacementState() {
        selectedModel = nil
        modelPlacementEnabled = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
