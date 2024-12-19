//
//  ContentView.swift
//  PhotoSimulationAppMVVM
//
//  Created by user260588 on 10/23/24.
//
import SwiftUI
import PhotosUI

struct ContentView: View {
    @StateObject private var viewModel = PhotoPickerViewModel()
    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
        VStack {
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(10)
            } else {
                Text("Select a Photo")
                    .font(.headline)
                    .padding()
            }

            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    Text("Select a Photo")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let newItem = newItem {
                            let data = try? await newItem.loadTransferable(type: Data.self)
                            if let data = data, let image = UIImage(data: data) {
                                viewModel.selectedImage = image
                                viewModel.extractText(from: image)
                                //viewModel.extractTextResult(from: image)
                            }
                        }
                    }
                }

            if let extractedData = viewModel.extractedData {
                VStack {
                    Text("Name: \(extractedData.name ?? "Not found")")
                        .padding()
                    Text("Amount: \(extractedData.amount ?? "Not found")")
                        .padding()
                    Text("Date: \(extractedData.date ?? "Not found")")
                        .padding()
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

