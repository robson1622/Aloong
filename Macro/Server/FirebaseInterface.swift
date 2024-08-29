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
    
 
    // criar associação de membro
    func createDocument(groupId : String,userId : String){
        
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
