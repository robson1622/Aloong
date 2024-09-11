//
//  ActivityImageDao.swift
//  Macro
//
//  Created by Robson Borges on 11/09/24.
//

import Foundation


class ActivityImageDao : ObservableObject{
    static var shared : ActivityImageDao = ActivityImageDao()
    let collectionName = "activityimages"
    func create(model : ActivityImageModel) async -> Bool?{
        if let idModel = FirebaseInterface.shared.createDocument(model: model, collection: collectionName){
            var modelWithId = model
            modelWithId.id = idModel
            return await self.update(model: modelWithId)
        }
        return nil
    }
    func delete(model : ActivityImageModel)async -> Bool?{
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
    
    func read(idActivityImage : String) async -> ActivityImageModel?{
        if let sucess : ActivityImageModel = await FirebaseInterface.shared.readDocument(id: idActivityImage, collection: collectionName){
            return sucess
        }
        return nil
    }
    
    func update(model : ActivityImageModel) async -> Bool?{
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
    func readAllActivityImagesOfActivity(idActivity : String) async -> [ActivityImageModel]{
        let list : [ActivityImageModel] = await FirebaseInterface.shared.readDocuments(id: idActivity, collection: collectionName, field: "idActivity")
        print(list)
        return list
    }
}
