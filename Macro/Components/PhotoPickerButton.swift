//
//  PhotoPickerButton.swift
//  Macro
//
//  Created by Robson Borges on 10/09/24.
//

import SwiftUI
import PhotosUI

class PhotoSelectorViewModel: ObservableObject {
    @Published var images = [UIImage]()
    @Published var selectedPhotos = [PhotosPickerItem]()
    
    @MainActor
    func convertDataToImage() async {
        // reset the images array before adding more/new photos
        images.removeAll()
        
        if !selectedPhotos.isEmpty {
            for eachItem in selectedPhotos {
                if let imageData = try? await eachItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: imageData) {
                        images.append(image)
                    }
                }
                
            }
        }
        
        // uncheck the images in the system photo picker
        selectedPhotos.removeAll()
    }
}

struct PhotoPickerButton: View {
    @StateObject var vm = PhotoSelectorViewModel()
    var maxPhotosToSelect : Int = 1
    
    var body: some View {
        VStack {
            PhotosPicker(
                selection: $vm.selectedPhotos, // holds the selected photos from the picker
                maxSelectionCount: maxPhotosToSelect, // sets the max number of photos the user can select
                selectionBehavior: .ordered, // ensures we get the photos in the same order that the user selected them
                matching: .images // filter the photos library to only show images
            ) {
                ZStack(alignment:.center){
                    Circle()
                        .frame(width: 38, height: 38) // Define o tamanho do círculo
                        .foregroundColor(.branco) // Define a cor de preenchimento do círculo
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 8) // Ajustes na sombra
                    Image(systemName: "square.and.pencil")
                        .font(.title2)
                        .foregroundColor(.roxo3)
                        .bold()
                }
                .frame(width: 38, height: 38)
                .padding(0)
            }
        }
        .padding()
        .onChange(of: vm.selectedPhotos) { _ in
            Task{
                await vm.convertDataToImage()
            }
        }
    }
}

#Preview {
    PhotoPickerButton(maxPhotosToSelect: 1)
}
