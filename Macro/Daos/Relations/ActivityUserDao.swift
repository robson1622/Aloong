//
//  UserActivityModel.swift
//  Macro
//
//  Created by Robson Borges on 04/09/24.
//

import Foundation


class ActivityUserDao: ObservableObject{
    static var shared : ActivityUserDao = ActivityUserDao()
    let collectionName : String = "activityuser"
    
    func create(model : ActivityUserModel) async -> Bool?{
        if let idModel = FirebaseInterface.shared.createDocument(model: model, collection: collectionName){
            var modelWithId = model
            modelWithId.id = idModel
            return await self.update(model: modelWithId)
        }
        return nil
    }
    func delete(model : ActivityUserModel)async -> Bool?{
        if(model.id != nil){
            if let sucess = await FirebaseInterface.shared.deleteDocument(id: model.id!, collection: collectionName){
                return sucess
            }
        }
        else{
            print("ERRO AO TENTAR APAGAR, id DO MODEL NULO UserActivity/deletes")
        }
        return nil
    }
    
    func read(idUserActivity : String) async -> ActivityUserModel?{
        if let sucess : ActivityUserModel = await FirebaseInterface.shared.readDocument(id: idUserActivity, collection: collectionName){
            return sucess
        }
        return nil
    }
    
    func update(model : ActivityUserModel) async -> Bool?{
        if(model.id != nil){
            if let sucess = await FirebaseInterface.shared.updateDocument(model: model, id: model.id!, collection: collectionName){
                return sucess
            }
        }
        else{
            print("ERRO AO TENTAR ATUALIZAR, id NULO UserActivityDao/update")
        }
        return nil
    }
    
    func readAllActivitiesOfUser(idUser: String) async -> [ActivityUserModel]{
        return await FirebaseInterface.shared.readDocuments(id: idUser, collection: collectionName, field: "idUser")
    }
}
