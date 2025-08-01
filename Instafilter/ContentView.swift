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
import StoreKit

struct ContentView: View {
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5
    @State private var selectedItem: PhotosPickerItem?
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var showingFilters = false
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    let context = CIContext()
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                PhotosPicker(selection: $selectedItem){
                    if let processedImage{
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No pic", systemImage: "photo.badge.plus", description: Text("tap to import photo"))
                    }
                }
                .onChange(of: selectedItem, loadImage)

                Spacer()
                HStack(){
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity, applyProcessing)
                }
                HStack{
                    Text("Radius")
                    Slider(value: $filterRadius)
                        .onChange(of: filterRadius, applyProcessing)
                }
                HStack{
                    Text("Scale")
                    Slider(value: $filterScale)
                        .onChange(of: filterScale, applyProcessing)
                }
                HStack{
                    Button("Change Filter", action: changeFilter)
                    Spacer()
                    if let processedImage{
                        ShareLink(item: processedImage, preview: SharePreview("Unstafilter image", image: processedImage))
                    }
                    
                }
            }
            .padding([.horizontal, .bottom])
            .confirmationDialog("Select a filter", isPresented: $showingFilters){
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Morphology Gradient") { setFilter(CIFilter.morphologyGradient()) }
                Button("Kaleidoscope") { setFilter(CIFilter.kaleidoscope()) }
                Button("Spotlight") { setFilter(CIFilter.spotLight()) }
                Button("Cancel", role: .cancel) { }
            }
            .navigationTitle("Instafilter")
        }
    }
    func changeFilter(){
        showingFilters = true
    }
    func loadImage(){
        Task{
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else {return}
            guard let inputImage = UIImage(data: imageData) else {return}
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    func applyProcessing(){
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey){ currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)}
        if inputKeys.contains(kCIInputRadiusKey){ currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey)}
        if inputKeys.contains(kCIInputScaleKey){ currentFilter.setValue(filterScale*10, forKey: kCIInputScaleKey)}
        guard let outputImage = currentFilter.outputImage else {return}
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {return}
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    @MainActor func setFilter(_ filter: CIFilter){
        currentFilter = filter
        loadImage()
        filterCount += 1
        if filterCount >= 5 {
            requestReview()
        }
    }
    
}

#Preview {
    ContentView()
}
