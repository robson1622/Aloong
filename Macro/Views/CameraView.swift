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
    @State private var isPresented = true
    @State private var selectedImage: UIImage?
    @State private var galeryImages : [UIImage] = []
    @State var image: UIImage?
    var body: some View {
        VStack {
            if let selectedImage{
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .onAppear{
                        if let idUser = controller.userController.myUser?.id,let group = controller.groupController.readMainGroupOfUser(){
                            if let idGroup = group.id{
                                controller.activityController.imagesForNewActivity.append(selectedImage)
                                ViewsController.shared.navigateTo(to: .createActivity(idUser,idGroup,nil))
                            }
                        }
                        else{
                            print("ERRO EM CamaeraView/.onAppear , id ou grupo nulo")
                        }
                    }
            }
            else if (isPresented){
                accessCameraView(selectedImage: self.$selectedImage)
                    .ignoresSafeArea()
            }
            
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity,maxHeight: .infinity)
//        .fullScreenCover(isPresented: self.$showCamera) {
//            
//        }
        .onChange(of: isPresented){ newValue in
            if(!isPresented){
                ViewsController.shared.back()
            }
        }
        .background(Color.black)
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
