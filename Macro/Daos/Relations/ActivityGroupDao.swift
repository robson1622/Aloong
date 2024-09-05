//
//  GroupActivityDao.swift
//  Macro
//
//  Created by Robson Borges on 03/09/24.
//

import Foundation

class ActivityGroupDao: ObservableObject{
    static var shared : ActivityGroupDao = ActivityGroupDao()
    let collectionName : String = "activitygroup"
    
    func create(model: ActivityGroupModel) async -> Bool?{
        if let idGroupActivity = FirebaseInterface.shared.createDocument(model: model, collection: collectionName){
            var modelWithId = model
            modelWithId.id = idGroupActivity
            return await self.update(model: modelWithId)
        }
        return nil
    }
    func delete(model : ActivityGroupModel)async -> Bool?{
        if(model.id != nil){
            if let sucess = await FirebaseInterface.shared.deleteDocument(id: model.id!, collection: collectionName){
                return sucess
            }
            else{
                print("OCORREU UM ERRO, NÃO FOI POSSÍVEL APAGAR GroupActivityDao/update/ActivityGroupModel")
            }
        }
        else{
            print("ERRO AO TENTAR APAGAR, id NULO GroupActivityDao/update/ActivityGroupModel")
        }
        return nil
    }
    
    func read(idGroupActivity : String) async -> ActivityGroupModel?{
        if let sucess : ActivityGroupModel = await FirebaseInterface.shared.readDocument(id: idGroupActivity, collection: collectionName){
            return sucess
        }
        return nil
    }
    
    func update(model : ActivityGroupModel) async -> Bool?{
        if (model.id != nil){
            if let sucess = await FirebaseInterface.shared.updateDocument(model: model, id: model.id!, collection: collectionName){
                return sucess
            }
            else{
                print("OCORREU UM ERRO, NÃO FOI POSSÍVEL ATUALIZAR GroupActivityDao/update/ActivityGroupModel")
            }
        }
        else{
            print("ERRO AO TENTAR ATUALIZAR, id NULO GroupActivityDao/update/ActivityGroupModel")
        }
        return nil
    }
    
    func readAllGroupActivitiesOfGroup(idGroup: String) async -> [ActivityGroupModel]{
        return await FirebaseInterface.shared.readDocuments(id: idGroup, collection: collectionName, field: "idGroup")
    }
}
