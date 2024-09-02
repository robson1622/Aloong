//
//  UserDao.swift
//  Macro Challenge
//
//  Created by Robson Borges on 30/07/24.
//

import Foundation
import UIKit

class UserDao : ObservableObject{
    
    func create(model : UserModel?){
        if model == nil{
            print("NÃO FOI POSSIVEL SALVAR USUÁRIO NO BANCO DE DADOS, PONTEIRO NULO")
            return
        }
        UserLocalSave().saveUser(user: model!)
        FirebaseInterface.shared.createDocument(model: model!)
    }
    
    func delete(model : UserModel?){
        UserLocalSave().deleteUser()
        Task{
            await FirebaseInterface.shared.deleteDocument(model: model)
        }
    }
    
    func update(model : UserModel?) -> Bool?{
        if(model != nil){
            UserLocalSave().saveUser(user: model!)
        }
        return FirebaseInterface.shared.updateDocument(model: model)
    }
    
    func read(id : String) async -> UserModel?{
        if let model = await FirebaseInterface.shared.readDocument(userId: id){
            UserLocalSave().saveUser(user: model)
            return model
        }
        return nil
    }
}
