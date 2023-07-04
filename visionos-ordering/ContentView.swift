//
//  ContentView.swift
//  visionos-ordering
//
//  Created by David Seeler on 7/1/23.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Vision
import AVFoundation

struct MenuItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let imageName: String
    let category: String
}

let menuItems: [MenuItem] = [
    MenuItem(name: "Burger", price: 10.99, imageName: "burger", category: "Category A"),
    MenuItem(name: "Item 2", price: 8.99, imageName: "item2", category: "Category B"),
    MenuItem(name: "Item 3", price: 12.99, imageName: "item3", category: "Category A"),
    MenuItem(name: "Item 4", price: 9.99, imageName: "item4", category: "Category C"),
    MenuItem(name: "Item 5", price: 11.99, imageName: "item5", category: "Category B"),
    MenuItem(name: "Item 6", price: 7.99, imageName: "item6", category: "Category C")
]

struct ContentView: View {
    
    @State private var selectedMenuItem: MenuItem? = nil
    @State private var flipped: Bool = false
    @State private var rotationAngle: Double = 0

    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(getCategories(), id: \.self) { category in
                    Section(header: Text(category)) {
                        ForEach(getItems(for: category)) { item in
                            MenuItemCell(item: item).onTapGesture {
                                selectedMenuItem = item
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Menu")
        } detail: {
            GeometryReader { geometry in
                VStack {
                    Model3D(named: "pie_lemon_meringue")
                        .scaleEffect(2)
                }
                .rotation3DEffect(
                    Angle(degrees: rotationAngle),
                    axis: (x: 0, y: 1, z: 0)
                )
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .onAppear {
                    startRotationAnimation()
                }
            }
            .navigationTitle("Content")
            .padding()
        }
    }
    
    func startRotationAnimation() {
        withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: false)) {
            rotationAngle = 360 // Set rotation angle
        }
    }
}



private func getCategories() -> [String] {
    let categories = Set(menuItems.map { $0.category })
    return Array(categories)
}

private func getItems(for category: String) -> [MenuItem] {
    return menuItems.filter { $0.category == category }
}

struct MenuItemCell: View {
    let item: MenuItem

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text("$\(item.price, specifier: "%.2f")")
                    .foregroundColor(.gray)
                    .italic()
            }
            Spacer()
            Image(item.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
        }
    }
}

#Preview {
    ContentView()
}
