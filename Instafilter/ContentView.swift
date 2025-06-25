//
//  ContentView.swift
//  Instafilter
//
//  Created by Philip Janzel Paradeza on 2025-06-24.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
            ContentUnavailableView{
                Label("No snippets", systemImage: "swift")
            } description: {
                Text("You dont have any saved snippets yet.")
            } actions: {
                Button("Create Snippet"){
                    
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear(perform: loadImage)
        .padding()
    
        //fuck github
    }
    func loadImage() {
        let inputImage = UIImage(resource: .example)
        let beginImage = CIImage(image: inputImage)
        let context = CIContext()
        let currentFilter = CIFilter.twirlDistortion()
        currentFilter.inputImage = beginImage
        let amount = 1.0
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey){
            currentFilter.setValue(amount, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey){currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey)}
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey)}
        
        guard let outputImage = currentFilter.outputImage else { return}
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {return}
        let uiImage = UIImage(cgImage: cgImage)
        image = Image(uiImage: uiImage)
    }
}

#Preview {
    ContentView()
}
