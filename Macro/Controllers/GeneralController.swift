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
    
    init(){
    }
    
    func updateAll() async{
        await user.load()
        if(user.user?.id != nil){
            group.groupsOfThisUser = await self.getGroupsOfUser(userId: (user.user?.id)!)
            
        }
    }
    
    
    func createGroup(model : GroupModel) async -> GroupModel? {
        
        if(model.id != nil || user.user?.id != nil){
            if let result = await GroupDao().create(group: model){
                if let _ = await self.aloongAnGroup(groupId: result.id!, userId: (user.user?.id)!){
                    print("SUCESSO AO CRIAR GRUPO E MEMBRO!")
                }
                return result
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
    
    
    func aloongAnGroup(groupId : String, userId : String) async -> Bool?{
        // pesquisa se já existe uma relação do usuário com o grupo
        // se não houver, crie a relção (entra no grupo)
        // se houver:
            // ele pode estar bloqueado do grupo, então não pode entrar
            // ele pode ser o dono ou membro, também não pode entrar pois já está
        
        // teste
        let newMember = MemberModel(groupId: groupId, userId: userId, state: statesOfMembers.member)
        if let _ = await MemberDao().create(model: newMember){
            return true
        }
        return nil
        
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
