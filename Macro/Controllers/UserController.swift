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
    
    var dao : UserDao = UserDao()
    
    init(){
        user = UserLocalSave().loadUser()
    }
    
    func load() async {
        let id = UserLocalSave().loadUser()?.id
        if(id != nil){
            user = await UserDao().read(id: id!)
        }
    }
    
    func updateUser(){
        // atualiza localmente
        UserLocalSave().saveUser(user: user!)
        // atualiza na nuvem
        _ = dao.update(model: user)
    }
    
    func deleteUser(){
        // deleta as coisas do usuário antes de deletar o mesmo
        
        // deleta o usuário
        UserLocalSave().deleteUser()
        dao.delete(model: user)
    }
    
    func createUser(){
        // cria localmente
        UserLocalSave().saveUser(user: user!)
        // e em seguina na nuvem
        dao.create(model: user)
    }
}

