//
//  ActivitiesController.swift
//  Macro
//
//  Created by Robson Borges on 03/09/24.
//

import Foundation
import PhotosUI

class ActivitiesController: ObservableObject{
    static var shared : ActivitiesController = ActivitiesController()
    @Published var activityGroupController = ActivityGroupController.shared
    @Published var activityUserController = ActivityUserController.shared
    @Published var activities : [ActivityModel] = []
    @Published var imagesForNewActivity : [UIImage] = []
    
    private struct ActivitiesOfGroups {
        var idGroup : String
        var activities : [ActivityModel]
    }
    
    @Published private var activitiesOfGroups : [ActivitiesOfGroups] = []
    //retorna todas as atividades do grupo
    func readActivitiesOfGroup(idGroup : String) async -> [ActivityModel]{
        if let index = activitiesOfGroups.firstIndex(where: { $0.idGroup == idGroup }){
            //primeiro pegamos todas as relacoes de atividades com grupos
            let relations = await activityGroupController.readAllActivityGroupsOfGroup(idGroup: idGroup)
            for relation in relations{
                if let activity : ActivityModel = await DatabaseInterface.shared.read(id: relation.idActivity, table: .activity){
                    if let indexInActivity = activitiesOfGroups[index].activities.firstIndex(where: {$0.id == activity.id}){
                        DispatchQueue.main.sync {
                            self.activitiesOfGroups[index].activities[indexInActivity] = activity
                        }
                    }
                    else{
                        DispatchQueue.main.sync {
                            self.activitiesOfGroups[index].activities.append(activity)
                        }
                    }
                }
            }
            return activitiesOfGroups[index].activities
            
        }
        else{
            var newGroupActivities : ActivitiesOfGroups = ActivitiesOfGroups(idGroup: idGroup, activities: [])
            let relations = await activityGroupController.readAllActivityGroupsOfGroup(idGroup: idGroup)
            for relation in relations{
                if let activity : ActivityModel = await DatabaseInterface.shared.read(id: relation.idActivity, table: .activity){
                    newGroupActivities.activities.append(activity)
                }
            }
            activitiesOfGroups.append(newGroupActivities)
            return newGroupActivities.activities
        }
    }
    //atividades de um usuário especifico
    func readActivitiesOfUser(idUser : String) async -> [ActivityModel]{
        var result : [ActivityModel] = []
        //primeiro pegamos todas as relacoes de atividades com user
        let relations = await activityUserController.readAllActivityUserOfUser(idUser: idUser)
        for relation in relations{
            if let activity : ActivityModel = await DatabaseInterface.shared.read(id: relation.idActivity, table: .activity){
                result.append(activity)
            }
        }
        return result
    }
    //delete todas
    func deleteAllActivitiesOfUser(idUser : String) async{
        print("Não está pronto em ActivitiesController/deleteAllActivitiesOfUser")
    }
}
