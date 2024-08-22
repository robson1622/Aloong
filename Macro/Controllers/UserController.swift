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
    
    func load(){
        user = UserLocalSave().loadUser()
    }
    
    func updateUser(){
        // atualiza localmente
        UserLocalSave().saveUser(user: user!)
        // atualiza na nuvem
        dao.update(model: user)
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

