//
//  FirebaseInterfaceUser.swift
//  Macro
//
//  Created by Robson Borges on 26/08/24.
//

import Foundation


extension FirebaseInterface{
    
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
    // atualizar usuário
    func updateDocument(model : UserModel?) -> Bool{
        if(model != nil && model?.id != nil){
            do{
                try db.collection(userColectionName).document(model!.id!).setData(from: model, merge: true)
                return true
            }
            catch{
                print(error.localizedDescription)
                return false
            }
        }
        else{
            print("ERRO AO TENTAR ATUALIZAR USUÁRIO NO FIREBASE")
        }
        return false
    }
    // deletar usuário
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
    
    // ler usuário
    func readDocument(userId: String) async -> UserModel? {
        do {
            let user = try await db.document("\(userColectionName)/\(userId)").getDocument(as: UserModel.self)
            return user
        }
        catch {
            print(error)
            return nil
        }
    }
    
}
