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
    let userColectionName : String = "users" // NOME NO BANCO NOSQL PARA SALVAR OS USUÁRIOS
    let groupColectionName : String = "groups"
    let memberColectionName : String = "member"
    
    // criar usuário
    func createDocument(model : UserModel){
        if model.id == nil{
            print("erro ao tentar criar usuário, id nulo! (FIrebaseInterface/createDocument{user})")
        }
        else{
            do {
                try db.document("\(userColectionName)/\(model.id!)").setData(from: model)
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }
    // criar grupo
    func createDocument(model : GroupModel){
        if model.id == nil || model.idUser == nil{
            print("erro ao tentar criar grupo, id's nulos! (FIrebaseInterface/createDocument{group})")
        }
        else{
            do {
                try db.document("\(userColectionName)/\(model.id!)").setData(from: model)
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }
    // criar associação de membro
    func createDocument(groupId : String,userId : String){
        
    }
    
    func updateDocument(model : UserModel?){
        if(model != nil && model?.id != nil){
            do{
                try db.collection(userColectionName).document(model!.id!).setData(from: model, merge: true)
            }
            catch{
                print(error.localizedDescription)
            }
        }
        else{
            print("ERRO AO TENTAR ATUALIZAR USUÁRIO NO FIREBASE")
        }
    }
    
    func deleteDocument(model : UserModel?) async{
        if(model != nil && model?.id != nil){
            do {
                try await db.collection(userColectionName).document(model!.id!).delete()
                print("Document successfully removed!")
            } catch {
                print("Error removing document: \(error)")
            }
        }
        else{
            print("ERRO AO TENTAR DELETAR CONTA NO FIREBASE, ID OU USUÁRIO INVÁLIDO")
        }
    }
    
    func readDocument(userId: String) async -> UserModel? {
        do {
            let document = try await db.collection(userColectionName).document(userId).getDocument()

            // Verifica se o documento existe
            if let documentData = document.data() {
                // Tenta mapear os dados do documento para UserModel manualmente
                if let userModel = try? JSONDecoder().decode(UserModel.self, from: JSONSerialization.data(withJSONObject: documentData)) {
                    return userModel
                } else {
                    print("Falha ao decodificar o documento em UserModel")
                    return nil
                }
            } else {
                print("O documento não existe")
                return nil
            }
        } catch {
            print("Erro ao obter o documento: \(error)")
            return nil
        }
    }
    
    private func dataBaseTypeForString(type : dataBaseType) -> String{
        switch type {
        case .user:
            return "user"
        case .group:
            return "group"
        case .member:
            return "member"
        }
    }
}
