//
//  FirebaseElements.swift
//  Macro
//
//  Created by Robson Borges on 19/08/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class FirebaseInterface{
    static var shared : FirebaseInterface = FirebaseInterface()
    var db = Firestore.firestore()
    
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
}
