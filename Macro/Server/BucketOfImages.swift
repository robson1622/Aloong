//
//  BucketOfImages.swift
//  Macro
//
//  Created by Robson Borges on 15/09/24.
//

import Foundation
import PhotosUI
import FirebaseStorage

class BucketOfImages: ObservableObject{
    static var shared : BucketOfImages = BucketOfImages()
    private var storage = Storage.storage()
    
    private struct ImageCash {
        var id : String
        var image : UIImage
    }
    
    enum localImage{
        case profile
        case activity
    }
    
    private var images : [ImageCash] = []
    
    private let profileImageReference : String = "/profileimage/"
    private let activityImageReference : String = "/activityimages/"
    private let localStorageImages : String = "gs://aloong-40645.appspot.com/"
    
    
    func upload(image: UIImage,type: localImage, completion: @escaping(String?) -> Void) {
        let imageResized = type == .profile ? self.resizeImage(image: image, targetSize: CGSize(width: 260, height: 260)) : image
        guard let imageData = imageResized.jpegData(compressionQuality: type == .profile ? 1.0 : 0.75) else {return}
        let fileName = NSUUID().uuidString
        var ref = storage.reference(withPath: profileImageReference + fileName)
        if(type == .activity){
            ref = storage.reference(withPath: activityImageReference + fileName)
        }
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Err: Failed to upload image \(error.localizedDescription)")
                return
            }
            completion(ref.fullPath)
        }
        
    }
    
    func deleteImage(url: String, completion: @escaping (Error?) -> Void) {
        let storageRef = Storage.storage().reference(forURL: localStorageImages + url)

        storageRef.delete { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func download(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let savedImage = self.images.first(where: { $0.id == urlString}){
            completion(savedImage.image)
        }
        else{
            let ref = storage.reference(forURL: localStorageImages + urlString)
            // Faz o download dos dados da imagem
            ref.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                // Converte os dados baixados em uma UIImage
                if let data = data, let image = UIImage(data: data) {
                    let newImageCash = ImageCash(id: urlString, image: image)
                    self.images.append(newImageCash)
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Define a escala de redimensionamento mantendo a proporção
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        // Redimensiona a imagem
        let rect = CGRect(origin: .zero, size: newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? image
    }
}
