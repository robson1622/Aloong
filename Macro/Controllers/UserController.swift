//
//  UserController.swift
//  Macro Challenge
//
//  Created by Robson Borges on 01/08/24.
//

import Foundation


class UserController: ObservableObject{
    
    //usuário atual
    @Published var user : UserModel?
    @Published var usersOfGroups : [UserModel] = []
    var dao : UserDao = UserDao()
    
    init(){
        user = UserLocalSave().loadUser()
    }
    
    func load() async {
        let id = UserLocalSave().loadUser()?.id
        if(id != nil){
            user = await UserDao().read(userId: id!)
        }
    }
    
    func updateUser()async{
        // atualiza localmente
        UserLocalSave().saveUser(user: user!)
        // atualiza na nuvem
        _ = await dao.update(model: user)
    }
    
    func deleteUser(){
        UserLocalSave().deleteUser()
        dao.delete(model: user)
    }
    
    func createUser(){
        // cria localmente
        UserLocalSave().saveUser(user: user!)
        // e em seguina na nuvem
        dao.create(model: user)
    }
    
    func readAllUsersOfGroup(idGroup : String) async -> [UserModel]{
        let members : [MemberModel] = await MemberDao.shared.readAllMembersOfGroup(idGroup: idGroup)
        var usersOfGroup : [UserModel] = []
        for member in members{
            if(member.userId != nil){
                if let user : UserModel = await UserDao.shared.read(userId: member.userId!){
                    usersOfGroup.append(user)
                }
            }
            else{
                print("ERRO AO TENTAR CARREGAR USUÁRIOS DE UM GRUPO, member.userId nulo UserDao/readAllUsersOfGroup")
            }
        }
        return usersOfGroup
    }
}

