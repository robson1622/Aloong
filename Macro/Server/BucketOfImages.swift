//
//  BucketOfImages.swift
//  Macro
//
//  Created by Robson Borges on 15/09/24.
//

import Foundation
import PhotosUI
import FirebaseAuth
import FirebaseStorage
import UIKit

/* este balde está dividido da seguinte forma:
ImageCash sao as imagens que estão na memoria RAM
 
ImageSaved registra onde está salva a imagem localmente(offline) na ROM
 

 */
class BucketOfImages: ObservableObject{
    static var shared : BucketOfImages = BucketOfImages()
    private var storage = Storage.storage()
    private var ongoingDownloads: [String: [(UIImage?) -> Void]] = [:]
    private struct ImageCash {
        var id : String
        var image : UIImage
        var date : Date
    }
    
    private struct ImagesSaved: Codable {
        var url: String
        var date: Date
    }

    
    enum localImage{
        case profile
        case activity
    }
    
    private var images : [ImageCash] = []
    
    private let profileImageReference : String = "/profileimage/"
    private let activityImageReference : String = "/activityimages/"
    private let localStorageImages : String = "gs://aloong-40645.appspot.com/"

    init() {
        let calendar = Calendar.current
        var list = readImageDocument()
        var elementsToRemove : [Int] = []
        for index in 0..<list.count{
            if let diference = calendar.dateComponents([.day], from: list[index].date, to: Date()).day{
                if diference > 10{
                    elementsToRemove.append(index)
                }
            }
        }
        for index in elementsToRemove.reversed(){
            self.deleteImage(fileName: list[index].url)
            if let exist = images.firstIndex(where: {$0.id == list[index].url}){
                images.remove(at: exist)
            }
            list.remove(at: index)
        }
        self.saveImageDocument(list)
        for element in list{
            if let image = self.loadImageLocally(fileName: element.url){
                let imageCash = ImageCash(id: element.url,image: image, date: element.date)
                self.images.append(imageCash)
            }
        }
        
        
    }

    func removeImageOfRAM(url : String){
        if let index = images.firstIndex(where: {$0.id == url}){
            images.remove(at: index)
        }
    }
    
    func upload(image: UIImage,type: localImage,url: String? = nil, completion: @escaping(String?) -> Void) {
        let imageResized = type == .profile ? self.resizeImage(image: image, targetSize: CGSize(width: 260, height: 260)) : image
        guard let imageData = imageResized.jpegData(compressionQuality: type == .profile ? 1.0 : 0.55) else {return}
        var fileName = NSUUID().uuidString
        if let url = url{
            fileName = url
        }
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
                self.deleteImage(fileName: url)
                if let savedImage = self.images.firstIndex(where: { $0.id == url}){
                    self.images.remove(at: savedImage)
                }
            } else {
                completion(nil)
            }
        }
    }
    func download(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        // Verifica se o usuário está autenticado
        guard let currentUser = Auth.auth().currentUser else {
            print("User not authenticated.")
            completion(nil)
            return
        }
        
        // Verifica se o usuário foi autenticado via Apple SignIn
        guard currentUser.providerData.first?.providerID == "apple.com" else {
            print("User is not authenticated with Apple SignIn.")
            completion(nil)
            return
        }
        
        // Verifica se a imagem já foi carregada em cache ou localmente
        if let savedImage = self.images.first(where: { $0.id == urlString}) {
            completion(savedImage.image)
        } else if let imageLocal = self.loadImageLocally(fileName: urlString) {
            let newImageCash = ImageCash(id: urlString, image: imageLocal, date: Date())
            self.images.append(newImageCash)
            completion(imageLocal)
            return
        }
        // Verifica se já existe um download em andamento para a mesma URL
//        if ongoingDownloads[urlString] != nil {
//            ongoingDownloads[urlString]?.append(completion)
//            return
//        } else {
//            ongoingDownloads[urlString] = [completion]
//        }

        // Obtém referência ao arquivo no Firebase Storage
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
                let newImageCash = ImageCash(id: urlString, image: image, date: Date())
                self.images.append(newImageCash)
                
                // Salva a imagem baixada localmente
                let imageSaved = ImagesSaved(url: urlString, date: Date())
                var list = self.readImageDocument()
                list.append(imageSaved)
                self.saveImageDocument(list)
                
                completion(image)
            } else {
                completion(nil)
            }
        }
        
    }
//
//    func download(from urlString: String, completion: @escaping (UIImage?) -> Void) {
//        if let savedImage = self.images.first(where: { $0.id == urlString}){
//            completion(savedImage.image)
//        }
//        else if let imageLocal = self.loadImageLocally(fileName: urlString){
//            let newImageCash = ImageCash(id: urlString, image: imageLocal,date: Date())
//            self.images.append(newImageCash)
//            completion(imageLocal)
//            return
//        }
//        else{
//            let ref = storage.reference(forURL: localStorageImages + urlString)
//            // Faz o download dos dados da imagem
//            ref.getData(maxSize: 5 * 1024 * 1024) { data, error in
//                if let error = error {
//                    print("Error downloading image: \(error.localizedDescription)")
//                    completion(nil)
//                    return
//                }
//                
//                // Converte os dados baixados em uma UIImage
//                if let data = data, let image = UIImage(data: data) {
//                    let newImageCash = ImageCash(id: urlString, image: image,date: Date())
//                    self.images.append(newImageCash)
//                    let imageSaved = ImagesSaved(url: urlString, date: Date())
//                    var list = self.readImageDocument()
//                    list.append(imageSaved)
//                    self.saveImageDocument(list)
//                    
//                    _ = self.saveImageLocally(image: image, fileName: urlString)
//                    completion(image)
//                } else {
//                    completion(nil)
//                }
//            }
//        }
//    }
//    
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
    
    ///
    ///
    ///     FUNÇÕES QUE SALVAM OFILINE
    ///
    ///
    
    private func loadImageLocally(fileName: String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        if let fileURL = documentsDirectory?.appendingPathComponent(fileName),
           FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path) // Carrega a imagem a partir do caminho
        }
        return nil
    }
    
    private func deleteImage(fileName: String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        if let fileURL = documentsDirectory?.appendingPathComponent(fileName) {
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("Erro ao excluir a imagem: \(error)")
            }
        }
    }
    
    private func saveImageDocument(_ list : [ImagesSaved]){
        let key = "imagedocuments"
        do {
            let data = try JSONEncoder().encode(list)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Erro ao salvar o usuário: \(error)")
        }
    }
    
    private func readImageDocument() -> [ImagesSaved]{
        let key = "imagedocuments"
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        
        do {
            let list = try JSONDecoder().decode([ImagesSaved].self, from: data)
            return list
        } catch {
            print("Erro ao carregar o usuário: \(error)")
            return []
        }
    }
    
    private func deleteImageDocument(){
        let key = "imagedocuments"
        UserDefaults.standard.removeObject(forKey: key)
    }
}
