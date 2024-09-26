//
//  Camera3View.swift
//  Macro
//
//  Created by Robson Borges on 23/09/24.
//

import SwiftUI
import AVFoundation
import SwiftUI
import PhotosUI

struct CustomCameraView: View {
    @State private var isPresentingImagePicker = false
    @State private var selectedImages: [UIImage] = []
    @StateObject private var cameraManager = CameraManager()

    var body: some View {
        ZStack {
            // Exibe o preview da câmera
            CameraPreview(cameraManager: cameraManager)
                .ignoresSafeArea()

            VStack {
                
                HStack{
                    Header()
                }
                .padding()
                .background(Color.black.opacity(0.5))
                
                Spacer()

                HStack {
                    // Botão para abrir a galeria
                    Button(action: {
                        isPresentingImagePicker = true
                    }) {
                        Image(systemName: "photo.on.rectangle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.verde2)
                            .padding()
                    }
                    .sheet(isPresented: $isPresentingImagePicker) {
                        MultipleImagePicker(selectedImages: $selectedImages)
                    }

                    Spacer()

                    // Botão para capturar a foto
                    Button(action: {
                        cameraManager.capturePhoto()
                    }) {
                        Circle()
                            .strokeBorder(.verde, lineWidth: 5)
                            .frame(width: 60, height: 60)
                    }

                    Spacer()
                    
                    Rectangle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.clear)
                        .padding()
                }
                .padding()
                .background(Color.black.opacity(0.5))
            }
        }
    }
}


import Foundation
import AVFoundation
import SwiftUI
import Foundation
import AVFoundation
import SwiftUI

class CameraManager: NSObject, ObservableObject {
    private var session: AVCaptureSession?
    private var output = AVCapturePhotoOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    @Published var capturedImage: UIImage?

    override init() {
        super.init()
        setupCamera()
    }

    func setupCamera() {
        session = AVCaptureSession()
        session?.beginConfiguration()

        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)

        guard let camera = device, let input = try? AVCaptureDeviceInput(device: camera) else {
            return
        }

        if session?.canAddInput(input) == true {
            session?.addInput(input)
        }

        if session?.canAddOutput(output) == true {
            session?.addOutput(output)
        }

        session?.commitConfiguration()

        // Cria o preview da câmera
        previewLayer = AVCaptureVideoPreviewLayer(session: session!)
        previewLayer?.videoGravity = .resizeAspectFill

        session?.startRunning()
    }

    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }

    func getPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        return previewLayer
    }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else {
            return
        }
        DispatchQueue.main.async {
            self.capturedImage = image
        }
    }
}

import SwiftUI
import AVFoundation
import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var cameraManager: CameraManager

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        if let previewLayer = cameraManager.getPreviewLayer() {
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = cameraManager.getPreviewLayer() {
            previewLayer.frame = uiView.bounds
        }
    }
}


struct MultipleImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0 // 0 significa seleção ilimitada
        config.filter = .images // Apenas imagens

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: MultipleImagePicker

        init(_ parent: MultipleImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.selectedImages.removeAll() // Limpa as imagens selecionadas previamente

            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                        if let uiImage = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.selectedImages.append(uiImage)
                            }
                        }
                    }
                }
            }

            picker.dismiss(animated: true)
        }
    }
}
/*
 import UIKit
 import CoreImage
 import CoreFoundation
 import AVKit
 import AVFoundation

 let view = UIView()
 var str = "Hello, playground"
 import PlaygroundSupport
 var captureSession: AVCaptureSession?
 var stillImageOutput: AVCapturePhotoOutput?
 var previewLayer: AVCaptureVideoPreviewLayer?







 captureSession = AVCaptureSession()
 captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
 var backCamera = AVCaptureDevice.defaultDevice(withMediaType:     AVMediaTypeVideo)
  var error: NSError?
  //var lol = AVCaptureInput();
  // var input = AVCaptureDeviceInput(device: backCamera, error: &error)

  var input = try AVCaptureDeviceInput(device: backCamera)

 //error

 if error == nil && captureSession!.canAddInput(input) {
     captureSession!.addInput(input)
     stillImageOutput = AVCapturePhotoOutput()
 //    stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
     captureSession!.addOutput(stillImageOutput)

 }

  previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
  view.layer.addSublayer(previewLayer!)
  previewLayer!.frame = view.bounds
  PlaygroundPage.current.liveView = view
  //PlaygroundPage.currentPage.liveView = view
 */
