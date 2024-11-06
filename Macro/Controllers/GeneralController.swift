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
    
    @Published var activityCompleteList : [ActivityCompleteModel] = []
    private var serverList : [ActivityCompleteModel] = []
    @Published var loadComplete : Bool = false
    
    func calculateMetrics(idGroup: String, idUser: String) async{
        let listOfUsers = await self.userController.readAllUsersOfGroup(idGroup: idGroup, reset: false)
        statisticController.calculate(idGroup: idGroup, idMyUser: idUser, activitiesCompleteList: self.activityCompleteList, listOfUsers: listOfUsers)
    }
    
    func loadAllLists(idGroup : String) async{
        DispatchQueue.main.async{
            self.loadComplete = false
        }
        _ = self.userController.loadUser()
        let listOfActivities = await activityController.readPlusTenActivities(idGroup: idGroup)
        Task{
            if let group = groupController.readMainGroupOfUser() {
                if let idGroup = group.id{
                    _ = await self.userController.readAllUsersOfGroup(idGroup: idGroup, reset: true)
                    for activity in listOfActivities{
                        if let completeAcitivity = await getActivityCompleteOfActivity(activity: activity, group: group){
                            if let index = activityCompleteList.firstIndex(where: {$0.activity?.id == completeAcitivity.activity?.id}){
                                DispatchQueue.main.sync{
                                    self.activityCompleteList[index] = completeAcitivity
                                }
                            }
                            else{
                                DispatchQueue.main.sync{
                                    self.activityCompleteList.append(completeAcitivity)
                                }
                            }
                        }
                    }
                    if let idUser = userController.myUser?.id{
                        await self.calculateMetrics(idGroup: idGroup, idUser: idUser)
                    }
                }
                DispatchQueue.main.async{
                    self.loadComplete = true
                }
            }
        }
    }
    
    func loadComments(idGroup: String) async {
        let comments = await commentController.readAllCommitsOfGroup(idGroup: idGroup)
        
        for index in 0..<activityCompleteList.count {
            // Verifica se o id da atividade está presente
            if let idActivity = activityCompleteList[index].activity?.id {
                // Filtra comentários que possuem o mesmo idActivity e idGroup
                let commentsOfActivity = comments.filter { comment in
                    comment.idActivity == idActivity //&& comment.idGroup == idGroup <- já foi verificado antes
                }
                // Adiciona os comentários filtrados à lista de comentários da atividade
                DispatchQueue.main.async{
                    self.activityCompleteList[index].comments = commentsOfActivity
                }
            }
        }
    }
    
    func loadReactions(idGroup: String) async {
        _ = await reactionController.readAllReactionsOfAGroup(idGroup: idGroup)
    }

    
    func updateActivitiesComplete(group : GroupModel) async{
        if let idGroup = group.id{
            let activities = await activityController.readActivitiesOfGroup(idGroup: idGroup)
            for activity in activities{
                //se já houver a atividade a gente só subistitui
                if let activityIndex = activityCompleteList.firstIndex(where: {$0.activity?.id == activity.id}){
                    if let activitycomplete = await self.getActivityCompleteOfActivity(activity: activity, group: group){
                        activityCompleteList[activityIndex] = activitycomplete
                    }
                }
                else{
                    if let activitycomplete = await self.getActivityCompleteOfActivity(activity: activity, group: group){
                        activityCompleteList.append(activitycomplete)
                    }
                }
            }
        }
        
    }
    
    private func getActivityCompleteOfActivity(activity : ActivityModel, group : GroupModel) async -> ActivityCompleteModel?{
        var result : ActivityCompleteModel? = nil
        let activityUsersRelations = await activityUserController.readAllActivityUserOfActivity(idActivity: activity.id!)
        var users : [UserModel] = []
        let groups : [GroupModel] = [group]
        for activityUserRelation in activityUsersRelations{
            if let user : UserModel = await DatabaseInterface.shared.read(id: activityUserRelation.idUser, table: .user){
                users.append(user)
            }
        }
        // está comentado por que não vai ter vários grupos ainda
//        let activityGroupRelations = await activityGroupController.readAllActivityGroupsOfActivity(idActivity: activity.id!)
//        for activityGroupRelation in activityGroupRelations{
//            if let group : GroupModel = await DatabaseInterface.shared.read(id: activityGroupRelation.idGroup, table: .group){
//                groups.append(group)
//            }
//        }
        
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
        if let owner = activityUserController.findOwnerOfActivity(idActivity: activity.id!){
            if let userOwner = userController.findUserInGroupById(idGroup: group.id!, userId: owner.idUser){
                result = ActivityCompleteModel(owner: userOwner, usersOfthisActivity: users, groupsOfthisActivity: groups,images: images, activity: activity)
            }
        }
        
        let reactions = reactionController.listOfReactions.filter{ $0.idActivity == activity.id}
        result?.reactions = reactions
        result?.numberOfReactions = reactions.count
        if reactions.contains(where: {$0.idUser == userController.myUser?.id}){
            result?.thisUserReacted = true
        }
        return result
    }
}
