//
//  SelectorOfImages.swift
//  Macro
//
//  Created by Robson Borges on 26/09/24.
//

import SwiftUI
import PhotosUI

struct SelectorOfImages: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var listOfImages : [UIImage]
    @Binding var showTab : Bool
    
    let limitOfImages = 5
    
    @State var newListOfImages : [UIImage] = []
    @State var newImageOfgalery : [UIImage] = []
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @StateObject var pickerPhoto = PhotoSelectorViewModel()
    let saveText : String = NSLocalizedString("Save", comment: "")
    let cancelText : String = NSLocalizedString("Cancel", comment: "")
    let addPlusImageText : String = NSLocalizedString("Add plus image", comment: "")
    var body: some View {
        ScrollView {
            HStack{
                Button(action:{
                    showTab = false
                }){
                    Text(cancelText)
                        .font(.headline)
                        .foregroundColor(Color.preto)
                        .padding()
                }
                Spacer()
                Button(action:{
                    self.saveChanges()
                }){
                    Text(saveText)
                        .font(.headline)
                        .foregroundColor(Color.azul4)
                        .padding()
                }
            }
            VStack{
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(newListOfImages.indices, id: \.self) { index in
                        ZStack(alignment: .center) {
                            Image(uiImage: newListOfImages[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipped()
                                .cornerRadius(4)
                            
                            Button(action: {
                                deleteImage(at: index)
                            }) {
                                ZStack{
                                    Circle()
                                        .foregroundStyle(Color.azul4)
                                        .frame(width: 25)
                                    Image(systemName:"x.circle.fill")
                                        .foregroundStyle( colorScheme == .dark ? Color.black : Color.white)
                                        .frame(width: 35, height: 35)
                                }
                                .padding(.leading,100)
                                .padding(.bottom,100)
                            }
                        }
//                        .padding(.leading,-32)
                    }
                }
            }
            .padding()
            if newListOfImages.count < limitOfImages {
                VStack {
                    PhotosPicker(
                        selection: $pickerPhoto.selectedPhotos, // holds the selected photos from the picker
                        maxSelectionCount: limitOfImages - newListOfImages.count, // sets the max number of photos the user can select
                        selectionBehavior: .ordered, // ensures we get the photos in the same order that the user selected them
                        matching: .images // filter the photos library to only show images
                    ) {
                        Text(addPlusImageText)
                            .font(.headline)
                            .foregroundColor(newListOfImages.count <= limitOfImages ? Color.azul4 : Color.gray)
                        
                    }
                }
                .padding(.horizontal,16)
                .padding(.vertical,8)
                .onChange(of: pickerPhoto.selectedPhotos) { _ in
                    Task{
                        await pickerPhoto.convertDataToImage()
                        if !pickerPhoto.images.isEmpty {
                            newListOfImages.append(contentsOf: pickerPhoto.images)
                        }
                    }
                }
            }
            
            
            
        }
        .background(Color.branco)
        .onAppear{
            newListOfImages = listOfImages
        }
    }

   func deleteImage(at index: Int) {
       newListOfImages.remove(at: index)
   }
    
    func saveChanges(){
        listOfImages.removeAll()
        listOfImages = newListOfImages
        newListOfImages.removeAll()
        showTab = false
    }
       
}

#Preview {
    SelectorOfImages(listOfImages: .constant([]),showTab: .constant(false))
}
