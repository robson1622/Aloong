//
//  HomeController.swift
//  Macro
//
//  Created by Robson Borges on 22/08/24.
//

import Foundation
import SwiftUI
import PhotosUI

class GeneralController: ObservableObject{
    @Published var user : UserController = UserController()
    @Published var group : GroupController = GroupController()
    @Published var activities : ActivitiesController = ActivitiesController()
    @Published var statistic : StatisticController = StatisticController()
    
    @Published var mainListActivities : [ActivityCompleteModel] = []
    
    init(){
        
    }
    
    func updateAll() async{
        mainListActivities.removeAll()
        await user.load()
        if(user.user?.id != nil){
            await group.load(idUser: (user.user?.id!)!)
            if(group.groupsOfThisUser.first?.id != nil ){
                await activities.load(idGroup: (group.groupsOfThisUser.first?.id!)!)
                if(group.groupsOfThisUser.count > 0){
                    for activity in activities.activities{
                        // pegar o dono da atividade
                        await activities.activityUserRelation.load(idUser: (user.user?.id!)!)
                        if let userOwner = activities.activityUserRelation.listOfActivityUser.first(where : { $0.state == statesOfMembers.owner}){
                            //todos os usuários da atividade
                            let allUsers = await user.readAllUsersOfActivity(idActivity: activity.id!)
                            var newActivityComplete : ActivityCompleteModel = ActivityCompleteModel(owner: allUsers.first(where: { $0.id == userOwner.idUser})!)
                            // associamos a atividade
                            newActivityComplete.activity = activity
                            // sabemos que ela está neste grupo
                            newActivityComplete.groupsOfthisActivity.append(group.groupsOfThisUser.first!)
                            // pegamos todos os usuários com relação com esta atividade
                            newActivityComplete.usersOfthisActivity = allUsers
                            // pegando as imagens
                            let listOfImages = await ActivityImageDao.shared.readAllActivityImagesOfActivity(idActivity: activity.id!)
                            for element in listOfImages{
                                if let url = element.imageURL{
                                    print(" url :\(url)")
                                    newActivityComplete.images.append(url)
                                }
                            }
                            // adicionamos ele na lista
                            mainListActivities.append(newActivityComplete)
                        }
                    }
                    statistic.listOfUser = group.usersOfThisGroup
                    statistic.activitiesComplete = mainListActivities
                    statistic.calculate(idUser: (user.user?.id!)!)
                }
                else{
                    print("ERRO AO TENTAR INICIALIZAR, SEM GRUPOS PARA ESTE USUÁRIO, GeneralController/updateAll")
                }
            }
        }
    }
    
    
    func createGroup(model : GroupModel) async -> GroupModel? {
        if(model.id != nil || user.user?.id != nil){
            if let result = await GroupDao().create(group: model){
                if let _ = await group.members.create(idGroup: result.id!, idUser: (user.user?.id!)!,state: statesOfMembers.owner){
                    return result
                }
            }
        }
        else{
            print("\n Model id inválido ou user.id inválido. \n")
        }
        return nil
    }
    func updateGroup(model : GroupModel) async -> Bool?{
        if let result = await GroupDao().update(model: model){
            return result
        }
        return nil
    }
    func deleteGroup(model : GroupModel)async -> Bool?{
        if let result = await GroupDao().delete(model: model){
             return result
        }
        return nil
    }
    func getGroupsOfUser(userId : String) async -> [GroupModel]{
        let result = await GroupDao().read(userId: userId)
        return result
    }
    
    
    func aloongAnGroup(userId : String, invitationCode : String) async -> Bool?{
        // busca os grupos com o código
        let listOfGroups = await group.searchGroup(code: invitationCode)
        // se não houver retorna nulo
        if listOfGroups.isEmpty{
            return nil
        }
        // se houver, então buscamos se já existe uma relação de membro
        let members = await group.members.getMembersOfUser(idUser: userId)
        // se houver verificamos se ele não está bloqueado
        if let member = members.first(where: { $0.userId == userId }) {
            // ele pode estar bloqueado do grupo, então não pode entrar
            if(member.state == statesOfMembers.blocked){
                return false
            }
            if(member.state == statesOfMembers.owner){
                return true
            }
        }
        return await group.members.create(idGroup: listOfGroups[0].id!, idUser: userId, state: statesOfMembers.member)
    }
    func deleteMemberOfGroup(){
        
    }
    func blockMemberOfGroup(){
        
    }
    

    
    func createUser(model : UserModel){
        user.user = model
        user.createUser()
    }
    func updateUser(){
        
    }
    func deleteUser(){
        
    }
    
    func uploadImage(image: UIImage,type: localImage,url: String? = nil, completion: @escaping(String?) -> Void){
        FirebaseInterface.shared.uploadImage(image: image, type: type, url: url) { response in
            completion(response)
        }
    }
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if (!urlString.isEmpty){
            FirebaseInterface.shared.downloadImage(from: urlString){ response in
                completion(response)
            }
        }
        else{
            completion(nil)
        }
    }
}
