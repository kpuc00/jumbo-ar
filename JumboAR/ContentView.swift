//
//  ContentView.swift
//  JumboAR
//
//  Created by Kristiyan Strahilov on 29.09.22.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @State private var selectedProduct = ""
    
    var body: some View {
        ZStack {
            ARViewContainer(selectedProduct: selectedProduct).edgesIgnoringSafeArea(.all)
            HStack {
                Spacer()
                VStack {
                    Menu {
                        Button("Milk"){ shoppingListBtnAction(str: "Milk")}
                        Button("Juice"){ shoppingListBtnAction(str: "Juice")}
                    } label: {
                        Label("Shopping list", systemImage: "cart").padding(10)
                    }.buttonStyle(.bordered)
                    Text(selectedProduct)
                    
                    Spacer()
                    
                    Button {
                        searchProductsBtnAction()
                    } label:{
                        Label("Search products", systemImage: "location.magnifyingglass").padding(10)
                    }.buttonStyle(.bordered)
                }
            }.padding(10)
        }
    }
    
    func shoppingListBtnAction(str: String) {
        selectedProduct = str
    }
    
    func searchProductsBtnAction() {
        print("Search products button clicked")
    }
}

let arView = ARView(frame: .zero)

struct ARViewContainer: UIViewRepresentable {
    var selectedProduct: String
    
    func makeUIView(context: Context) -> ARView {
        // Load the "Box" scene from the "Experience" Reality File
        let testAnchor = try! Experience.loadTestScene()
        let productDetailAnchor = try! Experience.loadProductDetail()
        // Add the box anchor to the scene
        arView.scene.anchors.append(testAnchor)
        arView.scene.anchors.append(productDetailAnchor)
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        print("selected product",selectedProduct)
        let milkAnchor = try! Experience.loadMilk()
        let juiceAnchor = try! Experience.loadJuice()
        if(selectedProduct=="Milk"){
            print("Showing milk")
            arView.scene.anchors.removeAll()
            arView.scene.anchors.append(milkAnchor)
        }
        if(selectedProduct=="Juice"){
            print("Showing juice")
            arView.scene.anchors.removeAll()
            arView.scene.anchors.append(juiceAnchor)
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
