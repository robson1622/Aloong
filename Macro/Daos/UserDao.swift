//
//  UserDao.swift
//  Macro Challenge
//
//  Created by Robson Borges on 30/07/24.
//

import Foundation
import UIKit

class UserDao : ObservableObject{
    static var shared : UserDao = UserDao()
    let collectionName : String = "users"
    
    func create(model : UserModel?)async  -> Bool? {
        if (model == nil && model?.id != nil){
            print("NÃO FOI POSSIVEL SALVAR USUÁRIO NO BANCO DE DADOS, PONTEIRO NULO")
            return nil
        }
        UserLocalSave().saveUser(user: model!)
        if let response = await FirebaseInterface.shared.updateDocument(model: model, id: (model?.id!)!, collection: collectionName){
            return true
        }
        else{
            return nil
        }
        
    }
    
    func delete(model : UserModel?){
        UserLocalSave().deleteUser()
        Task{
            await FirebaseInterface.shared.deleteDocument(id: model!.id!, collection: collectionName)
        }
    }
    
    func update(model : UserModel?)async -> Bool?{
        if(model != nil){
            UserLocalSave().saveUser(user: model!)
        }
        return await FirebaseInterface.shared.updateDocument(model: model!, id: model!.id!, collection: collectionName)
    }
    
    
    
    func read(userId : String) async -> UserModel?{
        if let model : UserModel = await FirebaseInterface.shared.readDocument(id: userId, collection: collectionName){
            UserLocalSave().saveUser(user: model)
            return model
        }
        return nil
    }
}
