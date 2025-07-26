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
    @State private var selectedItem: PhotosPickerItem?
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
                HStack{
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                }
                .padding(.vertical)
                HStack{
                    Button("Change Filter", action: changeFilter)
                    Spacer()
                    //share
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
        }
    }
    func changeFilter(){
        
    }
    func loadImage(){
        Task{
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else {return}
            guard let inputImage = UIImage(data: imageData) else {return}
            //erza's
        }
    }
}

#Preview {
    ContentView()
}
