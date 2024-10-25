//
//  DatabaseInterface.swift
//  Macro
//
//  Created by Robson Borges on 15/09/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class DatabaseInterface: ObservableObject{
    static var shared : DatabaseInterface = DatabaseInterface()
    
    private var db = Firestore.firestore()
    
    struct CollectionsNames {
        static let userCollectionName : String = "users"
        static let groupCollectionName : String = "groups"
        static let memberCollectionName : String = "member"
        static let reactionCollectionName : String = "reactions"
        static let activityCollectionName : String = "activities"
        static let activityUserCollectionName : String = "activityusers"
        static let activityGroupCollectionName : String = "activitygroups"
        static let activityImageCollectionName : String = "activityimages"
        static let commentCollectionName : String = "commments"
    }
    
    enum DatabaseTable {
        case user
        case group
        case member
        case reaction
        case activity
        case activityGroup
        case activityUser
        case activityImage
        case comment
    }
    
    
    // criar
    func create<T: Encodable>(model: T,table: DatabaseTable) -> String? {
        do {
            let document = try db.collection(self.getTableName(type: table)).addDocument(from: model)
            return document.documentID
        } catch {
            print("Erro ao adicionar o documento: \(error)")
        }
        return nil
    }
    
    // atualizar
    func update<T : Encodable>(model : T, id: String, table: DatabaseTable) async -> Bool?{
        do{
            try db.collection(self.getTableName(type: table)).document(id).setData(from: model, merge: true)
            return true
        }
        catch{
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    // ler
    func read<T : Decodable>(id: String,table: DatabaseTable) async -> T? {
        do {
            let document = try await db.collection(self.getTableName(type: table)).document(id).getDocument(as: T.self)
            return document
        }
        catch {
            print(error)
            return nil
        }
    }
    // apagar
    func delete(id : String, table: DatabaseTable) async -> Bool?{
        
        do {
            try await db.collection(self.getTableName(type: table)).document(id).delete()
            print("Document successfully removed!")
            return true
        } catch {
            print("Error removing document: \(error)")
        }
        return nil
    }
    // query por id
    func readDocuments<T : Decodable>(isEqualValue: String, table: DatabaseTable, field : String) async -> [T]{
        do {
            let querySnapshot = try await db.collection(self.getTableName(type: table)).whereField(field, isEqualTo: isEqualValue).getDocuments()
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
    
    func loadMoreDocuments<T: Decodable>(isEqualValue: String,table: DatabaseTable, lastDocumentId: String?, field: String) async throws -> [T] {
        var query = db.collection(getTableName(type: table))
            .order(by: field, descending: true)
            .whereField(field, isEqualTo: isEqualValue)

        if let lastDocumentId = lastDocumentId {
            let lastVisible = try await db.collection(getTableName(type: table))
                .document(lastDocumentId)
                .getDocument()
            
            query = query.start(afterDocument: lastVisible)
        }

        query = query.limit(to: 10)

        let querySnapshot = try await query.getDocuments()
        var results: [T] = []
        for document in querySnapshot.documents {
            results.append(try document.data(as: T.self))
        }
        return results
    }


    //
    func deleteDocuments(listOfIds : [String],table: DatabaseTable) async -> Bool?{
        var sucess : Bool? = nil
        for element in listOfIds{
            if let _ = await self.delete(id: element, table: table){
            }
            else{
                print("ERRO AO TENTAR APAGAR LISTA DE DOCUMENTOS EM DatabaseInterface/deleteDocuments")
                sucess = false
            }
        }
        return sucess
    }
    
    private func getTableName(type : DatabaseTable) -> String{
        switch type {
        case .user:
            return CollectionsNames.userCollectionName
        case .group:
            return CollectionsNames.groupCollectionName
        case .member:
            return CollectionsNames.memberCollectionName
        case .reaction:
            return CollectionsNames.reactionCollectionName
        case .activity:
            return CollectionsNames.activityCollectionName
        case .activityGroup:
            return CollectionsNames.activityGroupCollectionName
        case .activityUser:
            return CollectionsNames.activityUserCollectionName
        case .activityImage:
            return CollectionsNames.activityImageCollectionName
        case .comment:
            return CollectionsNames.commentCollectionName
        }
    }
}
