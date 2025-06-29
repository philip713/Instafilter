//
//  ContentView.swift
//  Instafilter
//
//  Created by Philip Janzel Paradeza on 2025-06-24.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var pickerItem: PhotosPickerItem?
    @State private var pickerItems = [PhotosPickerItem]()
    @State private var selectedImage: Image?
    var body: some View {
        VStack {
            PhotosPicker("Select a picture", selection: $pickerItem, matching: .images)
            selectedImage?
                .resizable()
                .scaledToFit()
        }
//        .onAppear(perform: loadImage)
        .onChange(of: pickerItem){
            Task {
                selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
            }
        }
        .padding()
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
