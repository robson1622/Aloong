//
//  CameraView.swift
//  Macro
//
//  Created by Robson Borges on 08/09/24.
//

import SwiftUI
import PhotosUI

struct CameraView: View {
    @EnvironmentObject var controller : GeneralController
    @State private var showCamera = true
    @State private var selectedImage: UIImage?
    @State var image: UIImage?
    var body: some View {
        VStack {
            if let selectedImage{
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .onAppear{
                        if(controller.user.user?.id != nil && controller.group.groupsOfThisUser.first != nil){
                            controller.activities.imagesForNewActivity = selectedImage
                            ViewsController.shared.navigateTo(to: .createActivity((controller.user.user?.id!)!, controller.group.groupsOfThisUser.first!.id!))
                        }
                        else{
                            print("ERRO EM CamaeraView/.onAppear , id ou grupo nulo")
                        }
                    }
            }
            
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .fullScreenCover(isPresented: self.$showCamera) {
            accessCameraView(selectedImage: self.$selectedImage)
        }
    }
}


struct accessCameraView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}

// Coordinator will help to preview the selected image in the View.
class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: accessCameraView
    
    init(picker: accessCameraView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.picker.selectedImage = selectedImage
        self.picker.isPresented.wrappedValue.dismiss()
    }
}


#Preview {
    CameraView()
}
