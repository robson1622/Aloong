//
//  ActivitiesController.swift
//  Macro
//
//  Created by Robson Borges on 03/09/24.
//

import Foundation
import PhotosUI

class ActivitiesController: ObservableObject{
    @Published var activityGroupRelation : ActivityGroupController = ActivityGroupController()
    @Published var activityUserRelation : ActivityUserController = ActivityUserController()
    @Published var activities : [ActivityModel] = []
    @Published var imagesForNewActivity : UIImage = UIImage()
    
    func load(idGroup: String, idUser : String? = nil) async {
        activities = await self.getActivitiesOfGroup(idGroup: idGroup)
    }
    func load(idUser: String) async {
        await activityUserRelation.load(idUser: idUser)
    }
    func create(model: ActivityModel, idGroup: String, idUserOwner : String, listOfOtherUsersIds: [String] = [] )async -> Bool?{
        if let sucess = await ActivityDao.shared.create(model: model, idGroup: idGroup, idUserOwner: idUserOwner,listOfUsersIds: listOfOtherUsersIds){
            await self.load(idGroup: idGroup)
            return sucess
        }
        return nil
    }
    func update(model: ActivityModel,idGroup: String)async -> Bool?{
        if let sucess = await ActivityDao.shared.update(model: model){
            await self.load(idGroup: idGroup)
            return sucess
        }
        return nil
    }
    func delete(model: ActivityModel,idGroup : String) async -> Bool?{
        if let sucess = await ActivityDao.shared.delete(model: model){
            await self.load(idGroup: idGroup)
            return sucess
        }
        return nil
    }
    //retorna todas as atividades do grupo
    func getActivitiesOfGroup(idGroup : String) async -> [ActivityModel]{
        var result : [ActivityModel] = []
        //primeiro pegamos todas as relacoes de atividades com grupos
        await activityGroupRelation.load(idGroup: idGroup)
        let relations = activityGroupRelation.listOfActivityGroup
        for relation in relations{
            if let activity : ActivityModel = await ActivityDao.shared.read(id: relation.idActivity){
                result.append(activity)
            }
        }
        return result
    }
    //atividades de um usuário especifico
    func getActivitiesOfUser(idUser : String) async -> [ActivityModel]{
        var result : [ActivityModel] = []
        await activityUserRelation.load(idUser: idUser)
        let relations = activityUserRelation.listOfActivityUser
        for relation in relations{
            if let activity : ActivityModel = await ActivityDao.shared.read(id: relation.idUser){
                result.append(activity)
            }
        }
        return result
    }
}
