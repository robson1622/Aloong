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
    @Published var update : Bool = false
    
    
    func loadAllLists(idGroup : String) async{
        print("\n loadAllLists - GeneralController \n")
        _ = self.userController.loadUser()
        await self.loadGroup(idGroup: idGroup)
        let listOfActivities = await activityController.readPlusTenActivities(idGroup: idGroup)
        for activity in listOfActivities{
            if let completeAcitivity = await getActivityCompleteOfActivity(activity: activity, idGroup: idGroup){
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
            await statisticController.calculate(idGroup: idGroup, idMyUser: idUser, activitiesCompleteList: activityCompleteList, listOfUsers: userController.readAllUsersOfGroup(idGroup: idGroup, reset: false))
        }
        
        
    }
    
    func loadGroup(idGroup: String) async {
        _ = await commentController.readAllCommitsOfGroup(idGroup: idGroup)
        _ = await reactionController.readAllReactionsOfAGroup(idGroup: idGroup)
    }
    
    func readPlusTenActivities(idGroup: String) async -> [ActivityCompleteModel]{
        if activityCompleteList.isEmpty{
            
        }
        else{
            
        }
        return activityCompleteList
    }
    
    func updateActivitiesComplete(idGroup: String) async{
        let activities = await activityController.readActivitiesOfGroup(idGroup: idGroup)
        for activity in activities{
            //se já houver a atividade a gente só subistitui
            if let activityIndex = activityCompleteList.firstIndex(where: {$0.activity?.id == activity.id}){
                if let activitycomplete = await self.getActivityCompleteOfActivity(activity: activity, idGroup: idGroup){
                    activityCompleteList[activityIndex] = activitycomplete
                }
            }
            else{
                if let activitycomplete = await self.getActivityCompleteOfActivity(activity: activity, idGroup: idGroup){
                    activityCompleteList.append(activitycomplete)
                }
            }
        }
    }
    
    private func getActivityCompleteOfActivity(activity : ActivityModel, idGroup : String) async -> ActivityCompleteModel?{
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
        let reactions = reactionController.listOfReactions.filter{ $0.idActivity == activity.id}
        result?.reactions = reactions
        result?.numberOfReactions = reactions.count
        if reactions.contains(where: {$0.idUser == userController.myUser?.id}){
            result?.thisUserReacted = true
        }
        return result
    }
}
