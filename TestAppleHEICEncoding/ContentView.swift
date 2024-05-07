//
//  ContentView.swift
//  TestAppleHEICEncoding
//
//  Created by lizhuoli on 2024/5/7.
//

import SwiftUI

class Model: ObservableObject {
    @Published var image: PlatformImage?
}

struct ContentView: View {
    @StateObject var model = Model()
    var body: some View {
        VStack {
            Image(platformImage: model.image ?? .empty)
            .resizable()
            .aspectRatio(contentMode: .fit)
            Text("Hello, world!")
        }
        .onAppear() {
            let name = "TestImage.heic"
            let image = loadImage(name)
            guard let image = image else {
                fatalError()
            }
            model.image = image
            DispatchQueue.global().async {
                let data = encodeImage(image)
                guard let data = data else {
                    fatalError()
                }
                print("Successfuly encode \(name) to HEIC with bytes: \(data.count)")
            }
        }
    }
}

#Preview {
    ContentView()
}
