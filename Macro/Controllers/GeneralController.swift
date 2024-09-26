//
//  HomeController.swift
//  Macro
//
//  Created by Robson Borges on 22/08/24.
//

import Foundation
import SwiftUI
import PhotosUI
// classe responsável somente por atualizar as outras e criar a lista principal myGroupsWithActivities
class GeneralController: ObservableObject{
    static var shared = GeneralController()
    @Published var userController = UserController.shared
    @Published var groupController = GroupController.shared
    @Published var activityController = ActivitiesController.shared
    @Published var commentController = CommentController.shared
    @Published var reactionController = ReactionController.shared
    @Published var activityGroupController = ActivityGroupController.shared
    @Published var activityUserController = ActivityUserController.shared
    @Published var activityImageController = ActivityImageController.shared
    @Published var memberController = MembersController.shared
    @Published var statisticController = StatisticController.shared
    
    @Published var myGrouspsWithActivities : [GroupsAndActivitiesModel] = []
    @Published var update : Bool = false
    
    func getActivitiesComplete(idGroup : String)async -> [ActivityCompleteModel]{
        if let index = myGrouspsWithActivities.firstIndex(where: { $0.idGroups == idGroup }){
            let listOfActivities = await activityController.readActivitiesOfGroup(idGroup: idGroup)
            for activity in listOfActivities{
                if let completeAcitivity = await getActivityCompleteOfActivity(activity: activity){
                    if let indexInActivities = myGrouspsWithActivities[index].activitiesComplete.firstIndex(where: { $0.activity?.id == activity.id }){
                        myGrouspsWithActivities[index].activitiesComplete[indexInActivities] = completeAcitivity
                    }
                    else{
                        myGrouspsWithActivities[index].activitiesComplete.append(completeAcitivity)
                    }
                }
            }
            
            return myGrouspsWithActivities[index].activitiesComplete
        }
        else{
            var newGroupsWithActivities = GroupsAndActivitiesModel(idGroups: idGroup, activitiesComplete: [])
            let listOfActivities = await activityController.readActivitiesOfGroup(idGroup: idGroup)
            for activity in listOfActivities{
                if let completeAcitivity = await getActivityCompleteOfActivity(activity: activity){
                    newGroupsWithActivities.activitiesComplete.append(completeAcitivity)
                }
            }
            myGrouspsWithActivities.append(newGroupsWithActivities)
            return newGroupsWithActivities.activitiesComplete
        }
    }
    
    func loadAllLists() async{
        _ = self.userController.loadUser()
        if let groupId = self.groupController.readMainGroupOfUser()?.id{
            await self.loadGroup(idGroup: groupId)
        }
        else{
            if let groupId = await self.groupController.readAllGroupsOfUser().first?.id{
                self.groupController.saveLocalMainGroup(group: await self.groupController.readAllGroupsOfUser().first!)
                await self.loadGroup(idGroup: groupId)
            }
        }
    }
    
    func loadGroup(idGroup: String) async {
        _ = await activityController.readActivitiesOfGroup(idGroup: idGroup)
        _ = await commentController.readAllCommitsOfGroup(idGroup: idGroup)
        _ = await reactionController.readAllReactionsOfAGroup(idGroup: idGroup)
        if let idUser = UserLocalSave().loadUser()?.id{
            let activiesCompleteOfThisGroup = await getActivitiesComplete(idGroup: idGroup)
            _ = await statisticController.calculate(idGroup: idGroup, idMyUser: idUser, activitiesCompleteList: activiesCompleteOfThisGroup, listOfUsers: userController.readAllUsersOfGroup(idGroup: idGroup, reset: false))
        }
        else{
            print("ERRO AOCARRREGAR USUÁRIO, ID NULO EM GeneralController/loadGroup")
        }
            
        
    }
    
    func readPlusTenActivities(idGroup: String) async -> [ActivityCompleteModel]{
        if let index = myGrouspsWithActivities.firstIndex(where: {$0.idGroups == idGroup}){
            print("FALTA CODAR A REQUISIÇÃO DE MAIS 10 ATIVIDADES EM GeneralController/readPlusTenActivities")
            return myGrouspsWithActivities[index].activitiesComplete
        }
        return []
    }
    
    func updateActivitiesOfGroup(idGroup: String) async{
        if let index = myGrouspsWithActivities.firstIndex(where: {$0.idGroups == idGroup}){
            // carregar todas as atividades desse grupo
            let activities = await activityController.readActivitiesOfGroup(idGroup: idGroup)
            for activity in activities{
                //se já houver a atividade a gente só subistitui
                if let activityIndex = myGrouspsWithActivities[index].activitiesComplete.firstIndex(where: {$0.activity?.id == activity.id}){
                    if let activitycomplete = await self.getActivityCompleteOfActivity(activity: activity){
                        myGrouspsWithActivities[index].activitiesComplete[activityIndex] = activitycomplete
                    }
                }
                else{
                    if let activitycomplete = await self.getActivityCompleteOfActivity(activity: activity){
                        myGrouspsWithActivities[index].activitiesComplete.append(activitycomplete)
                    }
                }
            }
        }
        else{
            let activities = await activityController.readActivitiesOfGroup(idGroup: idGroup)
            var newGroupAndActivities : GroupsAndActivitiesModel = GroupsAndActivitiesModel(idGroups: idGroup, activitiesComplete: [])
            for activity in activities{
                if let activitycomplete = await self.getActivityCompleteOfActivity(activity: activity){
                    newGroupAndActivities.activitiesComplete.append(activitycomplete)
                }
            }
        }
    }
    
    private func getActivityCompleteOfActivity(activity : ActivityModel) async -> ActivityCompleteModel?{
        var result : ActivityCompleteModel? = nil
        let activityUsersRelations = await activityUserController.readAllActivityUserOfActivity(idActivity: activity.id!)
        var users : [UserModel] = []
        for activityUserRelation in activityUsersRelations{
            if let user : UserModel = await DatabaseInterface.shared.read(id: activityUserRelation.idUser, table: .user){
                users.append(user)
            }
        }
        
        let activityGroupRelations = await activityGroupController.readAllActivityGroupsOfActivity(idActivity: activity.id!)
        var groups : [GroupModel] = []
        for activityGroupRelation in activityGroupRelations{
            if let group : GroupModel = await DatabaseInterface.shared.read(id: activityGroupRelation.idGroup, table: .group){
                groups.append(group)
            }
        }
        
        let activityImageRelations = await activityImageController.readAllActivityImagesOfActivity(idActivity: activity.id)
        var images : [String] = []
        for activityImageRelation in activityImageRelations{
            if(activityImageRelation.id != nil){
                if let image : ActivityImageModel = await DatabaseInterface.shared.read(id: activityImageRelation.id!, table: .activityImage){
                    if(image.imageURL != nil){
                        images.append(image.imageURL!)
                    }
                }
            }
        }
        
        if let actuserrelindex = activityUsersRelations.firstIndex(where: {$0.state == statesOfActivityRelation.owner}){
            if let userOwner : UserModel = await DatabaseInterface.shared.read(id: activityUsersRelations[actuserrelindex].idUser, table: .user){
                result = ActivityCompleteModel(owner: userOwner, usersOfthisActivity: users, groupsOfthisActivity: groups,images: images, activity: activity)
            }
        }
        return result
    }
    
    func readActivitiesOfUser(idUser: Int) async{
        
    }
    
//    func updateAll() async{
//        mainListActivities.removeAll()
//        await user.load()
//        if(user.user?.id != nil){
//            await group.load(idUser: (user.user?.id!)!)
//            if(group.groupsOfThisUser.first?.id != nil ){
//                await activities.load(idGroup: (group.groupsOfThisUser.first?.id!)!)
//                if(group.groupsOfThisUser.count > 0){
//                    for activity in activities.activities{
//                        // pegar o dono da atividade
//                        await activities.activityUserRelation.load(idUser: (user.user?.id!)!)
//                        if let userOwner = activities.activityUserRelation.listOfActivityUser.first(where : { $0.state == statesOfMembers.owner}){
//                            //todos os usuários da atividade
//                            let allUsers = await user.readAllUsersOfActivity(idActivity: activity.id!)
//                            if let owner = allUsers.first(where: { $0.id == userOwner.idUser}){
//                                var newActivityComplete : ActivityCompleteModel = ActivityCompleteModel(owner: owner)
//                                
//                                // associamos a atividade
//                                newActivityComplete.activity = activity
//                                // sabemos que ela está neste grupo
//                                newActivityComplete.groupsOfthisActivity.append(group.groupsOfThisUser.first!)
//                                // pegamos todos os usuários com relação com esta atividade
//                                newActivityComplete.usersOfthisActivity = allUsers
//                                // pegando as imagens
//                                let listOfImages = await ActivityImageDao.shared.readAllActivityImagesOfActivity(idActivity: activity.id!)
//                                for element in listOfImages{
//                                    if let url = element.imageURL{
//                                        print(" url :\(url)")
//                                        newActivityComplete.images.append(url)
//                                    }
//                                }
//                                
//                                // adicionamos ele na lista
//                                mainListActivities.append(newActivityComplete)
//                            }
//                        }
//                    }
//                    statistic.listOfUser = group.usersOfThisGroup
//                    statistic.activitiesComplete = mainListActivities
//                    statistic.calculate(idUser: (user.user?.id!)!)
//                }
//                else{
//                    print("ERRO AO TENTAR INICIALIZAR, SEM GRUPOS PARA ESTE USUÁRIO, GeneralController/updateAll")
//                }
//            }
//        }
//    }
    
}
