//
//  FirebaseInterfaceGroup.swift
//  Macro
//
//  Created by Robson Borges on 26/08/24.
//

import Foundation


extension FirebaseInterface{
    // criar grupo
    func createDocument(model : GroupModel) -> String?{
        do {
            let document = try  db.collection(groupColectionName).addDocument(from: model)
            return document.documentID
        } catch {
            print("Erro ao adicionar o documento: \(error)")
        }
        return nil
    }
    // atualizar
    func updateDocument(model : GroupModel?) async -> Bool?{
        if(model != nil && model?.id != nil){
            do{
                try db.collection(groupColectionName).document(model!.id!).setData(from: model, merge: true)
                return true
            }
            catch{
                print(error.localizedDescription)
            }
        }
        else{
            print("ERRO AO TENTAR ATUALIZAR USUÁRIO NO FIREBASE")
        }
        return nil
    }
    // ler
    func readDocument(groupId: String) async -> GroupModel? {
        do {
            let group = try await db.collection(groupColectionName).document(groupId).getDocument(as: GroupModel.self)
            return group
        }
        catch {
            print(error)
            return nil
        }
    }
    // apagar
    func deleteDocument(model : GroupModel?) async -> Bool?{
        if(model != nil && model?.id != nil){
            do {
                try await db.collection(groupColectionName).document(model!.id!).delete()
                print("Document successfully removed!")
                return true
            } catch {
                print("Error removing document: \(error)")
            }
        }
        else{
            print("ERRO AO TENTAR DELETAR GRUPO NO FIREBASE, ID OU GRUPO INVÁLIDO")
        }
        return nil
    }
}
