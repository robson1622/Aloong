//
//  HomeController.swift
//  Macro
//
//  Created by Robson Borges on 22/08/24.
//

import Foundation


class GeneralController: ObservableObject{
    @Published var user : UserController = UserController()
    @Published var group : GroupController = GroupController()
    @Published var satistic : StatisticController = StatisticController()
    @Published var activities : ActivitiesController = ActivitiesController()
    
    @Published var mainListActivities : [ActivityCompleteModel] = []
    
    init(){
        
    }
    
    func updateAll() async{
        await user.load()
        if(user.user?.id != nil){
            await group.load(idUser: (user.user?.id!)!)
//            activities.load()
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
    

    
    func createUser(){
        
    }
    func updateUser(){
        
    }
    func deleteUser(){
        
    }
    
}
