//
//  UserModel.swift
//  Macro Challenge
//
//  Created by Robson Borges on 01/08/24.
//

import Foundation


struct UserModel:  Codable, Hashable{
    var id : String
    var name : String
    var email : String?
    var userimage : String?
    
    func create()async -> Bool?{
        UserLocalSave().saveUser(user: self)
        return await DatabaseInterface.shared.update(model: self, id: self.id , table: .user)
    }
    
    func update() async -> Bool?{
        if(self.id == UserController.shared.myUser?.id){
            UserLocalSave().saveUser(user: self)
            return await DatabaseInterface.shared.update(model: self, id: self.id, table: .user)
        }
        return nil
    }
    
    func delete() async -> Bool?{
        if(self.id == UserController.shared.myUser?.id){
            // buscamos todas as relaçoes do usuário com atividade
            let activitiesRelations = await ActivityUserController.shared.readAllActivityUserOfUser(idUser: self.id)
            let groupsRelaction = await GroupController.shared.readAllGroupsOfUser()
            let comments = await CommentController.shared.readAllCommitsOfUser(idUser: self.id)
            // se le for dono em alguma, verifica se existem outros usuários referenciados nessa atividade
            // se houver, então passe o dono para um outro usuário
            // se não houver, apaga a atividade e em seguida a relação
            
            // apaga todos os comentários do usuário
            // apaga todas as reações do usuário
            // apaga as ligações com grupos
            //
            let deletedUser = UserModel(id: UUID().uuidString, name: "User deleted")
            
            if let _ = await DatabaseInterface.shared.update(model: deletedUser, id: self.id, table: .user){
                print("Deletado com sucesso em UserModel/delete")
            }
        }
        return nil
    }
    
    func read() async -> UserModel?{
        if let user : UserModel = await DatabaseInterface.shared.read(id: self.id, table: .user){
            UserLocalSave().saveUser(user: user)
            return user
        }
        return nil
    }
}
