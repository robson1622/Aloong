//
//  FirebaseElements.swift
//  Macro
//
//  Created by Robson Borges on 19/08/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

enum localImage{
    case profile
    case activity
}

class FirebaseInterface{
    static var shared : FirebaseInterface = FirebaseInterface()
    var db = Firestore.firestore()
    var storage = Storage.storage()
    
    private struct ImageCash {
        var id : String
        var image : UIImage
    }
    
    private var images : [ImageCash] = []
    
    let profileImageReference : String = "profileimages"
    let activityImageReference : String = "activityimages"
    let localStorageImages : String = "gs://aloong-40645.appspot.com/"
    
    init() {
        self.images.removeAll()
    }
    // criar
    func createDocument<T: Encodable>(model: T,collection: String) -> String? {
        do {
            let document = try db.collection(collection).addDocument(from: model)
            return document.documentID
        } catch {
            print("Erro ao adicionar o documento: \(error)")
        }
        return nil
    }
    
    // atualizar
    func updateDocument<T : Encodable>(model : T, id: String, collection : String) async -> Bool?{
        do{
            try db.collection(collection).document(id).setData(from: model, merge: true)
            return true
        }
        catch{
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    // ler
    func readDocument<T : Decodable>(id: String,collection : String) async -> T? {
        do {
            let document = try await db.collection(collection).document(id).getDocument(as: T.self)
            return document
        }
        catch {
            print(error)
            return nil
        }
    }
    //
    func readDocumentWithField<T : Decodable>(isEqualValue: String,collection : String, field : String) async -> [T] {
        do {
            let querySnapshot = try await db.collection(collection).whereField(field, isEqualTo: isEqualValue).getDocuments()
            var retorno : [T] = []
            for doc in querySnapshot.documents {
                retorno.append(try doc.data(as: T.self))
            }
            return retorno
        }
        catch {
            print(error)
            return []
        }
    }
    // apagar
    func deleteDocument(id : String, collection : String) async -> Bool?{
        
        do {
            try await db.collection(collection).document(id).delete()
            print("Document successfully removed!")
            return true
        } catch {
            print("Error removing document: \(error)")
        }
        return nil
    }
    // query por id
    func readDocuments<T : Decodable>(id: String, collection : String, field : String) async -> [T]{
        do {
            let querySnapshot = try await db.collection(collection).whereField(field, isEqualTo: id).getDocuments()
            var retorno : [T] = []
            for doc in querySnapshot.documents {
                retorno.append(try doc.data(as: T.self))
            }
            return retorno
            
        }
        catch {
            print(error)
            return []
        }
    }
    
    func uploadImage(image: UIImage,type: localImage,url: String? = nil, completion: @escaping(String?) -> Void) {
        if (url != nil && ((url?.isEmpty) == nil)){
            self.replaceImage(image: image, path: url!,type: type) { newUrl in
                    completion(newUrl)
            }
        }
        else{
            let imageResized = type == .profile ? self.resizeImage(image: image, targetSize: CGSize(width: 260, height: 260)) : image
            guard let imageData = imageResized.jpegData(compressionQuality: type == .profile ? 1.0 : 0.75) else {return}
            let fileName = NSUUID().uuidString
            var ref = storage.reference(withPath: "/profileimage/\(fileName)")
            if(type == .activity){
                ref = storage.reference(withPath: "/activityimages/\(fileName)")
            }
            ref.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Err: Failed to upload image \(error.localizedDescription)")
                    return
                }
                completion(ref.fullPath)
            }
        }
    }
    
    private func replaceImage(image: UIImage, path: String,type : localImage, completion: @escaping (String) -> Void) {
        let imageResized = type == .profile ? self.resizeImage(image: image, targetSize: CGSize(width: 130, height: 130)) : image
        // Converte a imagem redimensionada para JPEG com qualidade de 0.75
        guard let imageData = imageResized.jpegData(compressionQuality: 1) else { return }
        
        // Usa o mesmo caminho fornecido para substituir a imagem existente
        let ref = storage.reference(withPath: path)
        
        // Faz o upload da imagem, substituindo a existente
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Erro ao substituir a imagem: \(error.localizedDescription)")
                return
            }
            
            // Obtém a URL de download da imagem substituída
            ref.downloadURL { url, error in
                guard let imageURL = url?.absoluteString else { return }
                completion(imageURL)
            }
        }
    }
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
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
