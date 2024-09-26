////
////  Camera2View.swift
////  Macro
////
////  Created by Robson Borges on 23/09/24.
////
//
//import PhotosUI
//import SwiftUI
//import AVFoundation
//import UIKit
//
//struct CameraPreview: UIViewRepresentable {
//    @ObservedObject var cameraManager: CameraManager
//
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView(frame: UIScreen.main.bounds)
//
//        if let previewLayer = cameraManager.getPreviewLayer() {
//            previewLayer.frame = view.bounds
//            view.layer.addSublayer(previewLayer)
//        }
//
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//        if let previewLayer = cameraManager.getPreviewLayer() {
//            previewLayer.frame = uiView.bounds
//        }
//    }
//}
//
//
//class CameraManager: NSObject, ObservableObject {
//    private var session: AVCaptureSession
//    private var photoOutput: AVCapturePhotoOutput
//    @Published var capturedImage: UIImage? // Aqui a imagem capturada será armazenada
//    public var previewLayer: AVCaptureVideoPreviewLayer?
//    
//    override init() {
//        self.session = AVCaptureSession()
//        self.photoOutput = AVCapturePhotoOutput()
//        super.init()
//        
//        setupSession()
//    }
//    
//    func setupSession() {
//        session.beginConfiguration()
//        
//        // Configura a entrada da câmera
//        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
//              let cameraInput = try? AVCaptureDeviceInput(device: camera) else { return }
//        
//        if session.canAddInput(cameraInput) {
//            session.addInput(cameraInput)
//        }
//        
//        // Configura a saída de foto
//        if session.canAddOutput(photoOutput) {
//            session.addOutput(photoOutput)
//        }
//        
//        session.commitConfiguration()
//    }
//    
//    func startSession() {
//        if !session.isRunning {
//            DispatchQueue.global(qos: .background).async {
//                self.session.startRunning()
//            }
//        }
//    }
//    
//    func stopSession() {
//        if session.isRunning {
//            session.stopRunning()
//        }
//    }
//    
//    func capturePhoto() {
//        let settings = AVCapturePhotoSettings()
//        settings.flashMode = .auto
//        photoOutput.capturePhoto(with: settings, delegate: self)
//    }
//    func getPreviewLayer() -> AVCaptureVideoPreviewLayer? {
//            return previewLayer
//        }
//}
//
//extension CameraManager: AVCapturePhotoCaptureDelegate {
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        guard error == nil, let imageData = photo.fileDataRepresentation() else { return }
//
//        // Converte a foto em UIImage
//        if let image = UIImage(data: imageData) {
//            DispatchQueue.main.async {
//                self.capturedImage = image // Armazena a imagem capturada
//            }
//        }
//    }
//}
//
//
//
//struct MultipleImagePicker: UIViewControllerRepresentable {
//    @Binding var selectedImages: [UIImage]
//
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//        var config = PHPickerConfiguration()
//        config.selectionLimit = 0 // 0 significa seleção ilimitada
//        config.filter = .images // Apenas imagens
//
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, PHPickerViewControllerDelegate {
//        var parent: MultipleImagePicker
//
//        init(_ parent: MultipleImagePicker) {
//            self.parent = parent
//        }
//
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            parent.selectedImages.removeAll() // Limpa as imagens selecionadas previamente
//
//            for result in results {
//                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
//                    result.itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
//                        if let uiImage = image as? UIImage {
//                            DispatchQueue.main.async {
//                                self.parent.selectedImages.append(uiImage)
//                            }
//                        }
//                    }
//                }
//            }
//
//            picker.dismiss(animated: true)
//        }
//    }
//}
//
//
//struct CustomCameraView: View {
//    @State private var isPresentingImagePicker = false
//    @State private var selectedImages: [UIImage] = []
//    @StateObject private var cameraManager = CameraManager()
//
//    var body: some View {
//        ZStack {
//            // Exibe o preview da câmera
//            CameraPreview(cameraManager: cameraManager)
//                .ignoresSafeArea()
//
//            VStack {
//                Spacer()
//
//                HStack {
//                    // Botão para abrir a galeria com múltiplas seleções
//                    Button(action: {
//                        isPresentingImagePicker = true
//                    }) {
//                        Image(systemName: "photo.on.rectangle")
//                            .resizable()
//                            .frame(width: 30, height: 30)
//                            .foregroundColor(.verde2)
//                            .padding()
//                    }
//                    .sheet(isPresented: $isPresentingImagePicker) {
//                        MultipleImagePicker(selectedImages: $selectedImages)
//                    }
//
//                    Spacer()
//
//                    // Botão para capturar a foto
//                    Button(action: {
//                        cameraManager.capturePhoto()
//                    }) {
//                        Circle()
//                            .strokeBorder(.verde, lineWidth: 5)
//                            .frame(width: 55, height: 55)
//                    }
//
//                    Spacer()
//                }
//                .padding()
//                .background(Color.black.opacity(0.5))
//            }
//        }
//    }
//}
//
//
//struct CustomCameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomCameraView()
//    }
//}
