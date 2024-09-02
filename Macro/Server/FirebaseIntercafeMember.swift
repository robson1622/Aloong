//
//  FirebaseIntercafeMember.swift
//  Macro
//
//  Created by Robson Borges on 26/08/24.
//

import Foundation


extension FirebaseInterface{
    
    // criar usuário
    func createDocument(model : MemberModel) -> String?{
        do {
            let document = try  db.collection(memberColectionName).addDocument(from: model)
            return document.documentID
        } catch {
            print("Erro ao adicionar o documento: \(error)")
        }
        return nil
    }
    // atualizar usuário
    func updateDocument(model : MemberModel?) async -> Bool?{
        if(model != nil && model?.id != nil){
            do{
                try db.collection(memberColectionName).document(model!.id!).setData(from: model, merge: true)
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
    // deletar usuário
    func deleteDocument(model : MemberModel?) async{
        if(model != nil && model?.id != nil){
            do {
                try await db.collection(memberColectionName).document(model!.id!).delete()
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
    func readDocuments(userId: String) async -> [MemberModel] {
        do {
            let querySnapshot = try await db.collection(memberColectionName).whereField("userId", isEqualTo: userId).getDocuments()
            var retorno : [MemberModel] = []
            print(querySnapshot.documents)
            for doc in querySnapshot.documents {
                retorno.append(try doc.data(as: MemberModel.self))
            }
            return retorno
            
        }
        catch {
            print(error)
            return []
        }
    }
    
}
